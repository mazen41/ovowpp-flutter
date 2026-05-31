import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ovowpp/core/helper/string_format_helper.dart';
import 'package:ovowpp/data/model/global/response_model/response_model.dart';
import 'package:get/get.dart';
import 'package:ovowpp/core/utils/my_strings.dart';
import 'package:ovowpp/core/utils/url_container.dart';
import 'package:ovowpp/data/repo/account/profile_repo.dart';
import 'package:ovowpp/data/services/shared_pref_service.dart';
import 'package:ovowpp/app/components/snack_bar/show_custom_snackbar.dart';
import '../../model/profile/profile_post_model.dart';
import '../../model/profile/profile_response_model.dart';
import '../menu/my_menu_controller.dart';

class ProfileController extends GetxController {
  ProfileRepo profileRepo;
  ProfileResponseModel profileModel = ProfileResponseModel();

  ProfileController({required this.profileRepo});

  String imageUrl = '';

  bool isLoading = false;
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileNoController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController zipCodeController = TextEditingController();
  TextEditingController cityController = TextEditingController();

  File? imageFile;

  String? country;
  String? address;

  Future<void> loadProfileInfo({bool forceLoad = true}) async {
    country = SharedPreferenceService.getString(SharedPreferenceService.country);
    address = SharedPreferenceService.getString(SharedPreferenceService.address);
    update();
    countryController.text = country ?? '';
    addressController.text = address ?? '';
    if (forceLoad) {
      isLoading = true;
      update();
    }

    ResponseModel responseModel = await profileRepo.loadProfileInfo();
    if (responseModel.statusCode == 200) {
      profileModel = ProfileResponseModel.fromJson(responseModel.responseJson);
      if (profileModel.data != null && profileModel.status?.toLowerCase() == MyStrings.success.toLowerCase()) {
        loadData(profileModel);
      } else {
        isLoading = false;
        update();
      }
    } else {
      CustomSnackBar.error(errorList: [responseModel.message]);
    }
  }

  bool isSubmitLoading = false;
  Future<void> updateProfile() async {
    isSubmitLoading = true;
    update();

    String firstName = firstNameController.text;
    String lastName = lastNameController.text.toString();
    String address = addressController.text.toString();
    String country = countryController.text.toString();
    String city = cityController.text.toString();
    String zip = zipCodeController.text.toString();
    String state = stateController.text.toString();

    if (firstName.isNotEmpty && lastName.isNotEmpty) {
      ProfilePostModel model = ProfilePostModel(
        address: address,
        country: country,
        state: state,
        zip: zip,
        city: city,
        firstname: firstName,
        lastName: lastName,
        image: imageFile,
      );

      ResponseModel responseModel = await profileRepo.updateProfile(model);

      if (responseModel.isSuccess) {
        List<String> messageList = (responseModel.responseJson['message'] as List<dynamic>).toStringList();
        CustomSnackBar.success(successList: messageList);
        await loadProfileInfo(forceLoad: false);

        await SharedPreferenceService.setString(
          SharedPreferenceService.firstName,
          profileModel.data?.user?.firstname ?? '',
        );
        await SharedPreferenceService.setString(
          SharedPreferenceService.lastName,
          profileModel.data?.user?.lastname ?? '',
        );
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
          final myMenuController = Get.find<MyMenuController>();
          myMenuController.loadData();
        });
      }
      Get.back();
    } else {
      if (firstName.isEmpty) {
        CustomSnackBar.error(errorList: [MyStrings.kFirstNameNullError.tr]);
      }
      if (lastName.isEmpty) {
        CustomSnackBar.error(errorList: [MyStrings.kLastNameNullError.tr]);
      }
    }

    isSubmitLoading = false;
    update();
  }

  bool user2faIsOne = false;
  String image = "";
  String imagePath = "";
  String firstName = "";
  String lastName = "";
  String email = "";
  String mobileNo = "";
  String addressStr = "";
  String countryStr = "";
  String stateStr = "";
  String zipCodeStr = "";
  String cityStr = "";

  void loadData(ProfileResponseModel? model) async {
    SharedPreferenceService.setUserName('${model?.data?.user?.username}');

    firstNameController.text = model?.data?.user?.firstname ?? '';
    lastNameController.text = model?.data?.user?.lastname ?? '';
    emailController.text = model?.data?.user?.email ?? '';
    mobileNoController.text = model?.data?.user?.mobile ?? '';
    addressController.text = model?.data?.user?.address ?? '';
    countryController.text = model?.data?.user?.countryName ?? '';
    stateController.text = model?.data?.user?.state ?? '';
    zipCodeController.text = model?.data?.user?.zip ?? '';
    cityController.text = model?.data?.user?.city ?? '';
    // update profile data
    firstName = model?.data?.user?.firstname ?? '';
    lastName = model?.data?.user?.lastname ?? '';
    email = model?.data?.user?.email ?? '';
    mobileNo = model?.data?.user?.mobile ?? '';
    addressStr = model?.data?.user?.address ?? '';
    countryStr = model?.data?.user?.countryName ?? '';
    stateStr = model?.data?.user?.state ?? '';
    zipCodeStr = model?.data?.user?.zip ?? '';
    cityStr = model?.data?.user?.city ?? '';

    final profileFullImage = "${UrlContainer.domainUrl}/assets/images/user/profile/${model?.data?.user?.image}";
    await SharedPreferenceService.setString(
      SharedPreferenceService.fullProfileImage, // KEY
      profileFullImage, // VALUE
    );
    imageUrl = profileFullImage;

    user2faIsOne = model?.data?.user?.ts == '1' ? true : false;

    isLoading = false;
    update();
  }
}
