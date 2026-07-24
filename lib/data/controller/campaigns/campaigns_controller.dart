import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ovowpp/core/utils/my_strings.dart';
import 'package:ovowpp/data/model/authorization/authorization_response_model.dart';
import 'package:ovowpp/data/model/campaign/campaign_model.dart';
import 'package:ovowpp/data/model/campaign/create_campaign_model.dart';
import 'package:ovowpp/data/model/global/response_model/response_model.dart';
import 'package:ovowpp/data/repo/campaign/campaign_repo.dart';

import '../../../app/components/snack_bar/show_custom_snackbar.dart';
import '../../../core/utils/util.dart';

class CampaignsController extends GetxController {
  CampaignRepo repo;

  CampaignsController({required this.repo});

  late TabController tabController;
  int selectedSearchItemIndex = 1;

  void changeSearchItem(int index) {
    selectedSearchItemIndex = index;
    update();
  }

  List<Map<String, dynamic>> get campaignSearchItemList => [
    {'title': 'All', 'onTap': () => changeSearchItem(0), 'isSelected': selectedSearchItemIndex == 0},
    {'title': 'Schedule', 'onTap': () => changeSearchItem(1), 'isSelected': selectedSearchItemIndex == 1},
    {'title': 'Running', 'onTap': () => changeSearchItem(2), 'isSelected': selectedSearchItemIndex == 2},
    {'title': 'Complete', 'onTap': () => changeSearchItem(3), 'isSelected': selectedSearchItemIndex == 3},
  ];

  List resultList = [
    {'type': 'Running'},
    {'type': 'Scheduled'},
    {'type': 'Failed'},
  ];

  /// ============= CREATE CAMPAIGN =====================
  TextEditingController campaignNameController = TextEditingController();
  TextEditingController selectContactListController = TextEditingController();
  TextEditingController selectContactTagController = TextEditingController();
  TextEditingController selectTemplateController = TextEditingController();
  TextEditingController selectWhatsAppAccount = TextEditingController();
  TextEditingController messagePreviewController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController searchController = TextEditingController();

  bool startCampaignSwitch = false;
  bool enableTrackingSwitch = false;
  bool autoRetryFailedSwitch = false;

  void changeCampaignSwitch() {
    startCampaignSwitch = !startCampaignSwitch;
    update();
  }

  void changeTrackingSwitch() {
    enableTrackingSwitch = !enableTrackingSwitch;
    update();
  }

  void autoRetryFailed() {
    autoRetryFailedSwitch = !autoRetryFailedSwitch;
    update();
  }

  ///================= GET CAMPAIGN ====================

  bool isGetCampaignLoader = false;
  bool isLoadingMore = false;
  String? nextPageUrl;

  List<CampaignsDatum> campaignData = [];

  int page = 1;

  bool hasNext() {
    return nextPageUrl != null && nextPageUrl!.isNotEmpty && nextPageUrl != 'null' ? true : false;
  }

  int? status;
  void selectStatus(int tabBarStatus) {
    switch (tabBarStatus) {
      case 0:
        status = null;
        break;
      case 1:
        status = 3;
        break;
      case 2:
        status = 2;
        break;
      case 3:
        status = 1;
        break;
      default:
        status = null;
    }
    isGetCampaignLoader = true;
    // 🔥 Reset pagination on tab change
    page = 1;
    nextPageUrl = null;
    campaignData.clear();

    // 🔥 Call API with new status
    getCampaignData(status: status);

    update();
  }

  Future<void> getCampaignData({bool loadMore = false, String? searchQuery, int? status}) async {
    try {
      if (loadMore) {
        isLoadingMore = true;
        page++;
      } else {
        page = 1;
        isGetCampaignLoader = true;
        campaignData.clear();
      }

      update();

      final responseModel = await repo.loadCampaign(page, searchQuery: searchQuery, status: status);

      if (responseModel.statusCode == 200) {
        final campaignModel = CampaignModel.fromJson(responseModel.responseJson);

        if (campaignModel.status?.toLowerCase() == MyStrings.success.toLowerCase()) {
          final tempList = campaignModel.data?.campaigns?.data;
          nextPageUrl = campaignModel.data?.campaigns?.nextPageUrl;
          if (tempList != null && tempList.isNotEmpty) {
            campaignData.addAll(tempList);
          }
        }
      }
    } catch (e) {
      printE(e.toString());
    } finally {
      isGetCampaignLoader = false;
      isLoadingMore = false;
      update();
    }
  }

  /// ===================== CREATE CAMPAIGN ===================================
  String selectedTemplateId = '';

  String selectedWhatsAppAccountId = '';

  List<String> selectContactList = [];
  List<String> selectContactTag = [];

  void selectTags(String id) {
    if (selectContactTag.contains(id)) {
      selectContactTag.remove(id);
    } else {
      selectContactTag.add(id);
    }
    update();
  }

  void selectCountry(String id) {
    if (selectContactList.contains(id)) {
      selectContactList.remove(id);
    } else {
      selectContactList.add(id);
    }
    update();
  }

  bool createCampaignLoading = false;
  List<Template> templatesList = [];
  List<WhatsappAccount> whatsappAccountList = [];
  List<ContactList> contactList = [];
  List<ContactList> contactTag = [];

  Future<void> createCampaignData() async {
    try {
      createCampaignLoading = true;
      update();
      ResponseModel responseModel = await repo.createCampaign();

      if (responseModel.statusCode == 200) {
        CreateCampaignModel createCampaignModel = CreateCampaignModel.fromJson(responseModel.responseJson);
        if (createCampaignModel.status?.toLowerCase() == MyStrings.success.toLowerCase()) {
          templatesList = createCampaignModel.data?.templates ?? [];
          whatsappAccountList = createCampaignModel.data?.whatsappAccounts ?? [];
          contactList = createCampaignModel.data?.contactLists ?? [];
          contactTag = createCampaignModel.data?.contactTags ?? [];
        }
      } else {
        CustomSnackBar.error(errorList: [responseModel.message]);
      }
    } catch (e) {
      printE(e.toString());
    } finally {
      createCampaignLoading = false;
      update();
    }
  }

  /// ================= SELECT DATE ================
  DateTime selectedDateTime = DateTime.now();

  void initDateTime() {
    dateController.text = DateFormat('dd MMM yyyy').format(selectedDateTime);

    timeController.text = DateFormat('hh:mm a').format(selectedDateTime);
  }

  Future<void> selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDateTime,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      selectedDateTime = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        selectedDateTime.hour,
        selectedDateTime.minute,
      );

      dateController.text = DateFormat('dd MMM yyyy').format(selectedDateTime);

      update();
    }
  }

  /// ================ SELECT TIME ===================

  Future<void> selectTime(BuildContext context) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(selectedDateTime),
    );

    if (pickedTime != null) {
      selectedDateTime = DateTime(
        selectedDateTime.year,
        selectedDateTime.month,
        selectedDateTime.day,
        pickedTime.hour,
        pickedTime.minute,
      );

      timeController.text = DateFormat('hh:mm a').format(selectedDateTime);

      update();
    }
  }

  bool isSaveCampaignLoader = false;

  Future<void> saveCampaign() async {
    try {
      isSaveCampaignLoader = true;
      update();

      ResponseModel responseModel = await repo.saveCampaign(
        title: campaignNameController.text.trim(),
        contactLists: selectContactList,
        contactTags: selectContactTag,
        whatsAppAccountId: selectedWhatsAppAccountId,
        templateId: selectedTemplateId,
        schedule: DateFormat('dd MMM yyyy').format(selectedDateTime),
        scheduleAt: DateFormat('hh:mm a').format(selectedDateTime),
      );

      if (responseModel.statusCode == 200) {
        AuthorizationResponseModel response = AuthorizationResponseModel.fromJson(responseModel.responseJson);
        if (response.status?.toLowerCase() == MyStrings.success.toLowerCase()) {
          clearCampaignForm();

          CustomSnackBar.success(successList: response.message ?? [MyStrings.campaignCreateSuccessfully.tr]);
        } else {
          CustomSnackBar.error(errorList: response.message ?? [MyStrings.somethingWentWrong.tr]);
        }
      } else {
        CustomSnackBar.error(errorList: [responseModel.message]);
      }
    } catch (e) {
      CustomSnackBar.error(errorList: [e.toString()]);
    } finally {
      isSaveCampaignLoader = false;
      update();
    }
  }

  void clearCampaignForm() {
    campaignNameController.clear();
    selectContactList.clear();
    selectContactTag.clear();
    selectContactTagController.clear();
    selectContactListController.clear();
    selectedWhatsAppAccountId = '';
    selectWhatsAppAccount.clear();
    selectTemplateController.clear();
    selectedTemplateId = '';
    messagePreviewController.clear();
    dateController.clear();
    timeController.clear();
    initDateTime();
  }

  String searchQuery = '';
}
