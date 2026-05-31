import 'package:ovowpp/core/utils/my_strings.dart';
import 'package:ovowpp/core/utils/url_container.dart';
import 'package:ovowpp/data/model/global/response_model/response_model.dart';
import 'package:ovowpp/data/services/api_service.dart';

class GeneralSettingRepo {
  Future<dynamic> getGeneralSetting() async {
    String url = UrlContainer.generalSettingEndPoint;
    ResponseModel response = await ApiService.getRequest(url);
    return response;
  }

  Future<dynamic> getLanguage(String languageCode) async {
    try {
      String url = '${UrlContainer.languageUrl}$languageCode';
      ResponseModel response = await ApiService.getRequest(url);
      return response;
    } catch (e) {
      return ResponseModel(isSuccess: false, message: MyStrings.somethingWentWrong, statusCode: 300, responseJson: "");
    }
  }

  Future<dynamic> getCountryList() async {
    String url = '${UrlContainer.baseUrl}${UrlContainer.countryEndPoint}';
    ResponseModel model = await ApiService.getRequest(url);
    return model;
  }
}
