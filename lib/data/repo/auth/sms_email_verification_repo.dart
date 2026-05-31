import 'package:ovowpp/core/utils/my_strings.dart';
import 'package:ovowpp/core/utils/url_container.dart';
import 'package:ovowpp/data/model/authorization/authorization_response_model.dart';
import 'package:ovowpp/data/model/global/response_model/response_model.dart';
import 'package:ovowpp/data/services/api_service.dart';
import 'package:ovowpp/app/components/snack_bar/show_custom_snackbar.dart';

class SmsEmailVerificationRepo {
  Future<ResponseModel> verify(String code, {bool isEmail = true}) async {
    final map = {'code': code};
    String url =
        '${UrlContainer.baseUrl}${isEmail ? UrlContainer.verifyEmailEndPoint : UrlContainer.verifySmsEndPoint}';

    ResponseModel responseModel = await ApiService.postRequest(url, map);
    return responseModel;
  }

  Future<ResponseModel> sendAuthorizationRequest() async {
    String url = '${UrlContainer.baseUrl}${UrlContainer.authorizationCodeEndPoint}';
    ResponseModel responseModel = await ApiService.getRequest(url);
    return responseModel;
  }

  Future<bool> resendVerifyCode({required bool isEmail}) async {
    final url = '${UrlContainer.baseUrl}${UrlContainer.resendVerifyCodeEndPoint}${isEmail ? 'email' : 'mobile'}';
    ResponseModel response = await ApiService.getRequest(url);

    if (response.statusCode == 200) {
      AuthorizationResponseModel model = AuthorizationResponseModel.fromJson(response.responseJson);

      if (model.status == 'error') {
        CustomSnackBar.error(errorList: model.message ?? [MyStrings.resendCodeFail]);
        return false;
      } else {
        CustomSnackBar.success(successList: model.message ?? [MyStrings.successfullyCodeResend]);
        return true;
      }
    } else {
      return false;
    }
  }
}
