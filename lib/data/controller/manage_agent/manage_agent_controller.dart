import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:ovowpp/app/components/snack_bar/show_custom_snackbar.dart';
import 'package:ovowpp/core/route/route.dart';
import 'package:ovowpp/core/utils/app_status.dart';
import 'package:ovowpp/core/utils/my_strings.dart';
import 'package:ovowpp/core/utils/util.dart';
import 'package:ovowpp/data/model/all_contact/create_contact_response_model.dart';
import 'package:ovowpp/data/model/all_contact/delete_contact_response_model.dart';
import 'package:ovowpp/data/model/customer_details/customer_details_response_model.dart';
import 'package:ovowpp/data/model/global/response_model/response_model.dart';
import 'package:ovowpp/data/model/manage_agent/agent_list_response_model.dart';

import '../../repo/manage_agent/manage_agent_repo.dart';

class ManageAgentController extends GetxController {
  ManageAgentRepo repo;
  bool isLoading = true;

  ManageAgentController({required this.repo});

  TextEditingController searchController = TextEditingController();

  String? nextPageUrl;
  String? imageUrl;
  String? imagePath;

  List<AgentData> agentList = [];

  int page = 0;
  String searchQuery = "";
  Future<void> initData({bool initPage = false}) async {
    try {
      if (initPage) {
        page = 0;
        isLoading = true;
        update();
      }
      if (page == 0) {
        agentList.clear();
      }

      page = page + 1;

      String pram = "";

      pram += "?page=$page";
      pram += "&search=${searchController.text}";

      ResponseModel response = await repo.loadAgentData(pram);

      if (response.statusCode == 200) {
        AgentListResponseModel responseModel = AgentListResponseModel.fromJson(response.responseJson);
        if (responseModel.status?.toLowerCase() == MyStrings.success.toLowerCase()) {
          List<AgentData>? tempList = responseModel.data?.agents?.data;
          imagePath = responseModel.data?.profilePath ?? "";
          nextPageUrl = responseModel.data?.agents?.nextPageUrl ?? "";
          if (tempList != null && tempList.isNotEmpty) {
            agentList.addAll(tempList);
          }
        }
      } else {
        CustomSnackBar.error(errorList: [response.message]);
      }
    } catch (e) {
      printE(e.toString());
    } finally {
      isLoading = false;
      update();
    }
  }

  Conversation? conversation;
  bool chatLoading = false;
  String contactId = "";
  Future<void> createConversation() async {
    try {
      chatLoading = true;
      update();
      page = page + 1;
      update();
      ResponseModel response = await repo.loadConversationRepo(contactId);
      if (response.statusCode == 200) {
        CreateContactResponseModel responseModel = CreateContactResponseModel.fromJson(response.responseJson);
        if (responseModel.status?.toLowerCase() == MyStrings.success.toLowerCase()) {
          conversation = responseModel.data?.conversation;
          Get.toNamed(RouteHelper.chatScreen, arguments: [conversation?.id.toString() ?? ""]);
        }
      } else {
        CustomSnackBar.error(errorList: [response.message]);
      }
    } catch (e) {
      printE(e.toString());
    } finally {
      chatLoading = false;
      update();
    }
  }

  bool hasNext() {
    return nextPageUrl != null && nextPageUrl!.isNotEmpty && nextPageUrl!.toLowerCase() != 'null' ? true : false;
  }

  bool isDeleteLoading = false;
  void deleteAgent(int index, {AgentData? agent}) async {
    isDeleteLoading = true;
    update();
    try {
      ResponseModel model = await repo.deleteAgent(agent?.id.toString() ?? "");
      if (model.statusCode == 200) {
        DeleleContactResponseModel responseModel = DeleleContactResponseModel.fromJson(model.responseJson);
        if (responseModel.status?.toLowerCase() == AppStatus.success) {
          agentList.removeAt(index);
          Get.back();
          CustomSnackBar.success(successList: [responseModel.message?.first ?? ""]);
        } else {
          CustomSnackBar.error(errorList: [responseModel.message?.first ?? ""]);
        }
        isDeleteLoading = false;
        update();
      } else {
        isDeleteLoading = false;
        update();
        CustomSnackBar.error(errorList: [model.message]);
      }
    } catch (e) {
      isDeleteLoading = false;
      update();
    }
  }

  Future<void> checkAndRedirect(String remark, String? tradeId) async {}
}
