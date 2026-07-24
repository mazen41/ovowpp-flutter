import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ovowpp/app/components/snack_bar/show_custom_snackbar.dart';
import 'package:ovowpp/data/controller/home/pusher_home_service_controller.dart';
import 'package:ovowpp/data/model/general_setting/general_setting_response_model.dart';
import 'package:ovowpp/data/model/home/all_numbers_model.dart';
import 'package:ovowpp/data/model/home/chat_list_response_model.dart';
import 'package:ovowpp/data/model/home/home_response_model.dart';
import 'package:ovowpp/data/model/home/switch_number_model.dart';
import 'package:ovowpp/data/repo/home/home_repo.dart';
import 'package:ovowpp/data/services/shared_pref_service.dart';
import '../../../core/utils/util_exporter.dart';
import '../../model/global/response_model/response_model.dart';
import '../../model/profile/profile_response_model.dart';
import '../../model/user/user.dart';

class HomeController extends GetxController {
  HomeRepo homeRepo;

  HomeController({required this.homeRepo});

  String isKycVerified = '1';
  String email = "";
  bool isHomeDataLoading = true;
  bool numShowed = false;
  String username = "";
  String siteName = "";
  String imagePath = "";
  String chatListImagePath = "";
  late TabController tabController;
  String defaultCurrencySymbol = "";
  String selectedWpAccountNumber = "";
  String webId = "";
  String selectedNumber = "";
  bool isSwitch = false;
  GeneralSettingResponseModel generalSettingResponseModel = GeneralSettingResponseModel();
  final ScrollController scrollController = ScrollController();
  final ScrollController pendingScrollController = ScrollController();
  final ScrollController openScrollController = ScrollController();
  final ScrollController solvedScrollController = ScrollController();
  final TextEditingController searchController = TextEditingController();
  List<String> tabsList = ['All', 'Pending', 'Done', 'Important'];

  String image = "";
  String imagePaths = "";
  String mobile = "";
  int currentChatIndex = 0;

  void changeStatus() {
    numShowed = !numShowed;
    update();
  }

  List<ConnectivityResult> _connectionStatus = [ConnectivityResult.none];
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> connectivitySubscription;

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initConnectivity() async {
    connectivitySubscription = _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);

    late List<ConnectivityResult> result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      printE('Couldn\'t check connectivity status $e');
      return;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(List<ConnectivityResult> result) async {
    _connectionStatus = result;
    update();
    // ignore: avoid_print
    print('Connectivity changed: $_connectionStatus');
  }

  Future<void> initialData({bool shouldLoad = true}) async {
    isHomeDataLoading = shouldLoad ? true : false;
    update();

    await loadInitialData();
    isHomeDataLoading = false;
    update();
  }

  Future<void> loadInitialData() async {
    username = SharedPreferenceService.getUserName();
    email = SharedPreferenceService.getUserEmail();
    generalSettingResponseModel = SharedPreferenceService.getGeneralSettingData();
    defaultCurrencySymbol = SharedPreferenceService.getCurrencySymbol();
    siteName = generalSettingResponseModel.data?.generalSetting?.siteName ?? "";
    await loadUserProfileData();

    update();

    isHomeDataLoading = false;
    update();
  }

  Future<void> refreshGeneralSettings() async {
    try {
      ResponseModel response = await homeRepo.getGeneralSetting();
      if (response.statusCode == 200) {
        GeneralSettingResponseModel model = GeneralSettingResponseModel.fromJson(response.responseJson);
        if (model.status?.toLowerCase() == 'success') {
          await SharedPreferenceService.setGeneralSettingData(model);
          generalSettingResponseModel = model;
          defaultCurrencySymbol = SharedPreferenceService.getCurrencySymbol();
          siteName = generalSettingResponseModel.data?.generalSetting?.siteName ?? "";
          update();
        }
      }
    } catch (e) {
      printE(e.toString());
    }
  }

  User? user;

  bool isHomeDataError = false;
  String homeDataErrorMessage = '';
  Future<void> homeData({bool shouldShowLoader = true}) async {
    try {
      if (shouldShowLoader) {
        isHomeDataLoading = true;
        update();
      }
      isHomeDataError = false;
      update();

      ResponseModel model = await homeRepo.getData();

      if (model.statusCode == 200) {
        HomeResponseModel responseModel = HomeResponseModel.fromJson(model.responseJson);

        if (responseModel.status?.toLowerCase() == MyStrings.success.toLowerCase()) {
          imagePath = responseModel.data?.profilePath ?? "";
          user = responseModel.data?.user;

          SharedPreferenceService.setString(
            SharedPreferenceService.userNameKey,
            responseModel.data?.user?.username ?? "",
          );

          final profileFullImage = "${UrlContainer.domainUrl}/${responseModel.data?.profilePath}/${user?.image}";
          await SharedPreferenceService.setString(
            SharedPreferenceService.fullProfileImage, // KEY
            profileFullImage, // VALUE
          );
          SharedPreferenceService.setString(SharedPreferenceService.mobile, "${user?.dialCode}${user?.mobile}");

          await allNumbers();
          selectStatus(tabController.index, shouldShowLoader: shouldShowLoader);
          isKycVerified = responseModel.data?.user?.kv ?? "";
        } else {
          isHomeDataError = true;
          homeDataErrorMessage = model.message;
        }
      } else {
        isHomeDataError = true;
        homeDataErrorMessage = model.message;
      }
    } catch (e) {
      isHomeDataError = true;
      homeDataErrorMessage = e.toString();
      printE(e);
    } finally {
      isHomeDataLoading = false;
      update();
    }
  }

  List<WhatsappAccount> whatsappNumbers = [];
  List<ConversationData> allChatsData = [];
  List<ConversationData> newChatData = [];
  List<ConversationData> pendingChatsData = [];
  List<ConversationData> openChatsData = [];
  List<ConversationData> solvedChatsData = [];
  String searchQuery = '';
  List<ConversationData> filteredAllChats = [];
  List<ConversationData> filteredPendingChats = [];
  List<ConversationData> filteredOpenChats = [];
  List<ConversationData> filteredSolvedChats = [];

  void updateConversationUnseenCount(String conversationId, String unseenMessageCount) {
    if (conversationId.trim().isEmpty) return;

    var hasUpdatedConversation = false;
    final conversationLists = <List<ConversationData>>[
      newChatData,
      allChatsData,
      pendingChatsData,
      openChatsData,
      solvedChatsData,
      filteredAllChats,
      filteredPendingChats,
      filteredOpenChats,
      filteredSolvedChats,
    ];

    for (final conversations in conversationLists) {
      final index = conversations.indexWhere(
        (conversation) =>
            conversation.id == conversationId || conversation.lastMessage?.conversationId == conversationId,
      );
      if (index < 0) continue;

      conversations[index] = conversations[index].copyWith(unseenMessages: unseenMessageCount);
      hasUpdatedConversation = true;
    }

    if (hasUpdatedConversation) update();
  }

  int allChatsPage = 0;
  int pendingChatsPage = 0;
  int openChatsPage = 0;
  int solvedChatsPage = 0;
  bool allNumberLoading = false;

  Future<void> allNumbers() async {
    try {
      allNumberLoading = true;
      update();
      ResponseModel model = await homeRepo.getNumbersRepo();
      if (model.statusCode == 200) {
        AllNumbersResponseModel responseModel = AllNumbersResponseModel.fromJson(model.responseJson);

        if (responseModel.status?.toLowerCase() == MyStrings.success.toLowerCase()) {
          whatsappNumbers = responseModel.data?.whatsappAccounts ?? [];

          selectedNumber =
              whatsappNumbers.firstWhereOrNull((e) => e.isDefault == '1')?.phoneNumber ?? MyStrings.connectAccount.tr;
          selectedWpAccountNumber = whatsappNumbers.firstWhereOrNull((e) => e.isDefault == '1')?.id ?? "";
        }
      } else {
        CustomSnackBar.error(errorList: [model.message]);
      }
    } catch (e) {
      printE(e);
    } finally {
      allNumberLoading = false;
      update();
    }
  }

  Conversations? conversations;
  String tab = "";
  bool allChatsLoading = true;
  bool pendingChatsLoading = true;
  bool openChatsLoading = true;
  bool solvedChatsLoading = true;
  String nextPageUrl = "";
  String? newNextPageUrl = '';

  bool hasNext() {
    return newNextPageUrl != null && newNextPageUrl!.isNotEmpty && newNextPageUrl != 'null' ? true : false;
  }

  void filterChats() {
    if (searchQuery.isEmpty) {
      filteredAllChats = List.from(allChatsData);
      filteredPendingChats = List.from(pendingChatsData);
      filteredOpenChats = List.from(openChatsData);
      filteredSolvedChats = List.from(solvedChatsData);
    } else {
      filteredAllChats = allChatsData
          .where(
            (chat) =>
                "${chat.contact?.firstname ?? ''}${chat.contact?.lastname ?? ''}".toLowerCase().contains(searchQuery),
          )
          .toList();
      filteredPendingChats = pendingChatsData
          .where(
            (chat) =>
                "${chat.contact?.firstname ?? ''}${chat.contact?.lastname ?? ''}".toLowerCase().contains(searchQuery),
          )
          .toList();
      filteredOpenChats = openChatsData
          .where((chat) => "${chat.contact?.firstname ?? ''}${chat.contact?.lastname ?? ''}".contains(searchQuery))
          .toList();
      filteredSolvedChats = solvedChatsData
          .where((chat) => "${chat.contact?.firstname ?? ''}${chat.contact?.lastname ?? ''}".contains(searchQuery))
          .toList();
    }
    update();
  }

  int page = 0;

  int? status;

  Future<void> selectStatus(int tabBarStatus, {bool shouldShowLoader = true}) async {
    switch (tabBarStatus) {
      case 0:
        status = null;
        break;
      case 1:
        status = int.tryParse(AppStatus.PENDING_CONVERSATION);

        break;
      case 2:
        status = int.tryParse(AppStatus.DONE_CONVERSATION);
        break;
      case 3:
        status = int.tryParse(AppStatus.IMPORTANT_CONVERSATION);

        break;
      default:
        status = null;
    }

    if (shouldShowLoader) {
      newChatLoader = true;
      newChatData.clear();
    }

    // 🔥 Reset pagination on tab change
    page = 1;
    newNextPageUrl = null;

    // 🔥 Call API with new status
    await newChatMethod(status: status, shouldShowLoader: shouldShowLoader);

    update();
  }

  bool newChatLoader = false;
  bool isLoadingMore = false;

  Future<void> newChatMethod({
    bool loadMore = false,
    String? searchQuery,
    int? status,
    bool shouldShowLoader = true,
  }) async {
    try {
      if (loadMore) {
        isLoadingMore = true;
        page++;
      } else {
        page = 1;
        if (shouldShowLoader) {
          newChatLoader = true;
          newChatData.clear();
        }
      }

      update();
      ResponseModel model = await homeRepo.newNewChat(page, searchQuery: searchQuery, status: status);
      if (model.statusCode == 200) {
        final responseModel = ChatListResponseModel.fromJson(model.responseJson);
        if (responseModel.status?.toLowerCase() == MyStrings.success.toLowerCase()) {
          if (responseModel.data?.conversations?.nextPageUrl != null) {
            newNextPageUrl = responseModel.data?.conversations?.nextPageUrl ?? '';
          }
          final tempList = responseModel.data?.conversations?.data;

          if (!loadMore && !shouldShowLoader) {
            newChatData.clear();
          }

          if (tempList != null && tempList.isNotEmpty) {
            newChatData.addAll(tempList);
          }
        }
      }
    } catch (e) {
      printE(e.toString());
    } finally {
      newChatLoader = false;
      isLoadingMore = false;
      update();
    }
  }

  //For all chat
  void allChatList({bool initPage = false}) async {
    try {
      if (initPage) {
        page = 0;
        allChatsLoading = true;
        update();
      }
      if (page == 0) {
        allChatsData.clear();
      }

      page = page + 1;
      update();
      ResponseModel model = await homeRepo.getchatListRepo("0", page.toString(), searchQuery);

      if (model.statusCode == 200) {
        ChatListResponseModel responseModel = ChatListResponseModel.fromJson(model.responseJson);
        if (responseModel.status?.toLowerCase() == MyStrings.success.toLowerCase()) {
          conversations = responseModel.data?.conversations;
          if (conversations?.data != null) {
            nextPageUrl = conversations?.nextPageUrl ?? "";
            chatListImagePath = responseModel.data?.profilePath ?? "";
            allChatsData.clear();
            allChatsData.addAll(conversations?.data ?? []);
            filterChats();
          }
        }
      } else {
        CustomSnackBar.error(errorList: [model.message]);
      }
    } catch (e) {
      printE(e.toString());
    } finally {
      allChatsLoading = false;
      update();
    }
  }

  void pendingChatList({bool initPage = false}) async {
    pendingChatsData.clear();
    try {
      if (initPage) {
        page = 0;
        pendingChatsLoading = true;
        update();
      }
      if (page == 0) {
        pendingChatsData.clear();
      }

      page = page + 1;
      update();
      ResponseModel model = await homeRepo.getchatListRepo("1", page.toString(), searchQuery);

      if (model.statusCode == 200) {
        ChatListResponseModel responseModel = ChatListResponseModel.fromJson(model.responseJson);
        if (responseModel.status?.toLowerCase() == MyStrings.success.toLowerCase()) {
          conversations = responseModel.data?.conversations;
          if (conversations?.data != null) {
            nextPageUrl = conversations?.nextPageUrl ?? "";
            chatListImagePath = responseModel.data?.profilePath ?? "";
            pendingChatsData.clear();

            pendingChatsData.addAll(conversations?.data ?? []);
            filterChats();
          }
        }
      } else {
        CustomSnackBar.error(errorList: [model.message]);
      }
    } catch (e) {
      printE(e.toString());
    } finally {
      pendingChatsLoading = false;
      update();
    }
  }

  void openChatList({bool initPage = false}) async {
    try {
      if (initPage) {
        page = 0;
        openChatsLoading = true;
        update();
      }
      if (page == 0) {
        openChatsData.clear();
      }

      page = page + 1;
      update();
      ResponseModel model = await homeRepo.getchatListRepo("2", page.toString(), searchQuery);

      if (model.statusCode == 200) {
        ChatListResponseModel responseModel = ChatListResponseModel.fromJson(model.responseJson);
        if (responseModel.status?.toLowerCase() == MyStrings.success.toLowerCase()) {
          conversations = responseModel.data?.conversations;
          if (conversations?.data != null) {
            nextPageUrl = conversations?.nextPageUrl ?? "";
            chatListImagePath = responseModel.data?.profilePath ?? "";
            openChatsData.clear();
            openChatsData.addAll(conversations?.data ?? []);
            filterChats();
          }
        }
      } else {
        CustomSnackBar.error(errorList: [model.message]);
      }
    } catch (e) {
      printE(e.toString());
    } finally {
      openChatsLoading = false;
      update();
    }
  }

  void solvedChatList({bool initPage = false}) async {
    try {
      if (initPage) {
        page = 0;
        solvedChatsLoading = true;
        update();
      }
      if (page == 0) {
        solvedChatsData.clear();
      }

      page = page + 1;
      update();
      ResponseModel model = await homeRepo.getchatListRepo("3", page.toString(), searchQuery);

      if (model.statusCode == 200) {
        ChatListResponseModel responseModel = ChatListResponseModel.fromJson(model.responseJson);
        if (responseModel.status?.toLowerCase() == MyStrings.success.toLowerCase()) {
          conversations = responseModel.data?.conversations;
          if (conversations?.data != null) {
            nextPageUrl = conversations?.nextPageUrl ?? "";
            chatListImagePath = responseModel.data?.profilePath ?? "";
            solvedChatsData.clear();
            solvedChatsData.addAll(conversations?.data ?? []);
            filterChats();
          }
        }
      } else {
        CustomSnackBar.error(errorList: [model.message]);
      }
    } catch (e) {
      printE(e.toString());
    } finally {
      solvedChatsLoading = false;
      update();
    }
  }

  void switchNumber() async {
    try {
      isSwitch = true;
      update();
      ResponseModel model = await homeRepo.switchNumberRepo(webId);
      if (model.statusCode == 200) {
        SwitchNumbersResponseModel responseModel = SwitchNumbersResponseModel.fromJson(model.responseJson);
        if (responseModel.status?.toLowerCase() == MyStrings.success.toLowerCase()) {
          CustomSnackBar.success(successList: responseModel.message ?? [MyStrings.requestSuccess.tr]);
          await homeData().then((v) {
            Get.find<PusherHomeServiceController>().ensureConnection(
              "private-receive-message-$selectedWpAccountNumber",
            );
          });
        } else {
          CustomSnackBar.error(errorList: responseModel.message ?? [MyStrings.requestFail.tr]);
        }
      } else {
        CustomSnackBar.error(errorList: [model.message]);
      }
      isSwitch = false;
      update();
    } catch (e) {
      isSwitch = false;
      update();
    }
  }

  int tabIndex = 0;

  int currentIndex = 0;

  //Balance animation
  RxBool isAnimation = false.obs;
  RxBool isBalanceShown = false.obs;
  RxBool isBalance = true.obs;
  RxBool isClickable = true.obs;

  bool showMoreWidget = false;

  Future<void> changeShowMoreWidgetState() async {
    showMoreWidget = !showMoreWidget;
    update();
  }

  Future<void> loadUserProfileData() async {
    try {
      ResponseModel responseModel = await homeRepo.getUserInfoData();

      if (responseModel.statusCode == 200) {
        ProfileResponseModel model = ProfileResponseModel.fromJson(responseModel.responseJson);
        if (model.status == 'success') {
          await SharedPreferenceService.setString(
            SharedPreferenceService.userPhoneNumberKey,
            model.data?.user?.mobile ?? '',
          );
          await SharedPreferenceService.setString(
            SharedPreferenceService.userNameKey,
            model.data?.user?.username ?? '',
          );
          await SharedPreferenceService.setString(SharedPreferenceService.userEmailKey, model.data?.user?.email ?? '');
          isKycVerified = model.data?.user?.kv ?? '1';
        } else {}
      } else {}
    } catch (e) {
      printX(e.toString());
    }
  }
}
