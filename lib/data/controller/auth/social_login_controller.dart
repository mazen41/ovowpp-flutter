import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:ovowpp/app/packages/signin_with_linkdin/signin_with_linkedin.dart';
import 'package:ovowpp/core/route/route.dart';
import 'package:ovowpp/core/translations/strings_enum.dart';
import 'package:ovowpp/core/utils/util.dart';
import 'package:ovowpp/data/model/general_setting/general_setting_response_model.dart';
import 'package:ovowpp/data/model/user/user.dart';
import 'package:ovowpp/app/components/snack_bar/show_custom_snackbar.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ovowpp/data/services/shared_pref_service.dart';

import '../../model/auth/login/login_response_model.dart';
import '../../model/global/response_model/response_model.dart';
import '../../repo/auth/social_login_repo.dart';

class SocialLoginController extends GetxController {
  SocialLoginRepo repo;
  SocialLoginController({required this.repo});

  // google_sign_in v7.x â€” use the singleton, never the constructor
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  bool _initialized = false;
  StreamSubscription<GoogleSignInAuthenticationEvent>? _authSubscription;
  bool isGoogleSignInLoading = false;

  @override
  void onClose() {
    _authSubscription?.cancel();
    super.onClose();
  }

  // Web OAuth client ID - used as serverClientId so backend receives valid ID token
  static const String _serverClientId =
      '230160154555-01cq0m33tj7ekbjo99m9v9g2g0g8fd36.apps.googleusercontent.com';

  Future<void> _ensureInitialized() async {
    if (_initialized) return;
    await _googleSignIn.initialize(serverClientId: _serverClientId);
    _initialized = true;
  }

  Future<void> signInWithGoogle() async {
    try {
      isGoogleSignInLoading = true;
      update();

      await _ensureInitialized();

      if (!_googleSignIn.supportsAuthenticate()) {
        CustomSnackBar.error(errorList: ['Google Sign-In is not supported on this platform']);
        isGoogleSignInLoading = false;
        update();
        return;
      }

      // Set up a one-shot completer to capture the auth event result
      final completer = Completer<GoogleSignInAccount?>();

      _authSubscription?.cancel();
      _authSubscription = _googleSignIn.authenticationEvents.listen(
        (GoogleSignInAuthenticationEvent event) {
          if (completer.isCompleted) return;
          if (event is GoogleSignInAuthenticationEventSignIn) {
            _authSubscription?.cancel();
            completer.complete(event.user);
          } else if (event is GoogleSignInAuthenticationEventSignOut) {
            _authSubscription?.cancel();
            completer.complete(null);
          }
        },
        onError: (Object error) {
          if (!completer.isCompleted) {
            _authSubscription?.cancel();
            completer.completeError(error);
          }
        },
      );

      // Trigger the interactive sign-in UI
      await _googleSignIn.authenticate();

      final GoogleSignInAccount? googleUser = await completer.future;

      if (googleUser == null) {
        isGoogleSignInLoading = false;
        update();
        return;
      }

      // In v7, authentication is synchronous (no await needed)
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      if (googleAuth.idToken == null) {
        isGoogleSignInLoading = false;
        update();
        CustomSnackBar.error(errorList: [Strings.loginFailedTryAgain.tr]);
        return;
      }

      await socialLoginUser(provider: 'google', accessToken: googleAuth.idToken ?? '');
    } on GoogleSignInException catch (e) {
      if (e.code != GoogleSignInExceptionCode.canceled) {
        CustomSnackBar.error(errorList: [e.description ?? Strings.loginFailedTryAgain.tr]);
      }
    } catch (e) {
      if (kDebugMode) print(e.toString());
      CustomSnackBar.error(errorList: [e.toString()]);
    }

    isGoogleSignInLoading = false;
    update();
  }

  //SIGN IN With LinkedIn
  bool isLinkedinLoading = false;
  Future<void> signInWithLinkedin(BuildContext context) async {
    try {
      isLinkedinLoading = false;
      update();

      SocialiteCredentials linkedinCredential = SharedPreferenceService.getSocialCredentialsConfig();
      String linkedinCredentialRedirectUrl =
          "${SharedPreferenceService.getGeneralSettingData().data?.socialLoginRedirect}/linkedin";
      printX(linkedinCredentialRedirectUrl);
      printX(linkedinCredential.linkedin?.toJson());
      SignInWithLinkedIn.signIn(
        context,
        config: LinkedInConfig(
          clientId: linkedinCredential.linkedin?.clientId ?? '',
          clientSecret: linkedinCredential.linkedin?.clientSecret ?? '',
          scope: ['openid', 'profile', 'email'],
          redirectUrl: linkedinCredentialRedirectUrl,
        ),
        onGetAuthToken: (data) {
          printX('Auth token data: ${data.toJson()}');
        },
        onGetUserProfile: (token, user) async {
          printX('${token.idToken}-');
          printX('LinkedIn User: ${user.toJson()}');
          await socialLoginUser(provider: 'linkedin', accessToken: token.accessToken ?? '');
        },
        onSignInError: (error) {
          printX('Error on sign in: $error');
          CustomSnackBar.error(errorList: [error.description ?? Strings.loginFailedTryAgain.tr]);
          isLinkedinLoading = false;
          update();
        },
      );
    } catch (e) {
      printE(e.toString());
      CustomSnackBar.error(errorList: [e.toString()]);
    }
  }

  Future socialLoginUser({String accessToken = '', String? provider}) async {
    try {
      ResponseModel responseModel = await repo.socialLoginUser(
        accessToken: accessToken,
        provider: provider,
      );
      if (responseModel.statusCode == 200) {
        LoginResponseModel loginModel = LoginResponseModel.fromJson(responseModel.responseJson);
        if (loginModel.status.toString().toLowerCase() == Strings.success.toLowerCase()) {
          String accessToken = loginModel.data?.accessToken ?? "";
          String tokenType = loginModel.data?.tokenType ?? "";
          User? user = loginModel.data?.user;
          await RouteHelper.checkUserStatusAndGoToNextStep(
            user,
            accessToken: accessToken,
            tokenType: tokenType,
            isRemember: true,
          );
        } else {
          CustomSnackBar.error(errorList: loginModel.message ?? [Strings.loginFailedTryAgain.tr]);
        }
      } else {
        CustomSnackBar.error(errorList: [responseModel.message]);
      }
    } catch (e) {
      if (kDebugMode) print(e.toString());
    }
  }

  bool checkSocialAuthActiveOrNot({String provider = 'all'}) {
    final config = SharedPreferenceService.getSocialCredentialsConfig();
    switch (provider) {
      case 'google':
        return config.google?.status == '1';
      case 'linkedin':
        return config.linkedin?.status == '1';
      case 'facebook':
        return config.facebook?.status == '1';
      case 'all':
        return config.google?.status == '1' ||
            config.linkedin?.status == '1' ||
            config.facebook?.status == '1';
      default:
        return false;
    }
  }
}
