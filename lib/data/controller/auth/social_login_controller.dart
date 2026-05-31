import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:ovowpp/app/packages/signin_with_linkdin/signin_with_linkedin.dart';
import 'package:ovowpp/core/route/route.dart';
import 'package:ovowpp/core/utils/my_strings.dart';
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

  //SIGN IN With Google
  final GoogleSignIn googleSignIn = GoogleSignIn.instance;
  bool isGoogleSignInLoading = false;

  Future<void> signInWithGoogle() async {
    try {
      isGoogleSignInLoading = true;
      update();
      const List<String> scopes = <String>['email', 'profile'];
      googleSignIn.signOut();
      await googleSignIn.initialize();
      var googleUser = await googleSignIn.attemptLightweightAuthentication();
      var googleAuth = googleUser?.authentication;
      if (googleAuth == null || googleAuth.idToken == null) {
        isGoogleSignInLoading = false;
        update();
        return;
      }
      final GoogleSignInClientAuthorization? authorization = await googleUser?.authorizationClient
          .authorizationForScopes(scopes);

      await socialLoginUser(provider: 'google', accessToken: authorization?.accessToken ?? '');
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      // CustomSnackBar.error(errorList: [e.toString()]);
    }

    isGoogleSignInLoading = false;
    update();
  }

  //SIGN IN With LinkeDin
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
          CustomSnackBar.error(errorList: [error.description ?? MyStrings.loginFailedTryAgain.tr]);
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
      ResponseModel responseModel = await repo.socialLoginUser(accessToken: accessToken, provider: provider);
      if (responseModel.statusCode == 200) {
        LoginResponseModel loginModel = LoginResponseModel.fromJson(responseModel.responseJson);
        if (loginModel.status.toString().toLowerCase() == MyStrings.success.toLowerCase()) {
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
          CustomSnackBar.error(errorList: loginModel.message ?? [MyStrings.loginFailedTryAgain.tr]);
        }
      } else {
        CustomSnackBar.error(errorList: [responseModel.message]);
      }
    } catch (e) {
      //printx(e.toString());
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
        return config.google?.status == '1' || config.linkedin?.status == '1' || config.facebook?.status == '1';
      default:
        return false;
    }
  }
}
