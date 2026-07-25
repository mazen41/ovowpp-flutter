import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:ovowpp/app/components/snack_bar/show_custom_snackbar.dart';
import 'package:ovowpp/core/translations/localization_controller.dart';
import 'package:ovowpp/core/utils/app_status.dart';
import 'package:ovowpp/core/translations/strings_enum.dart';
import 'package:ovowpp/core/utils/util.dart';
import 'package:ovowpp/data/model/chat/chat_data_response_model.dart';
import 'package:ovowpp/data/model/chat/message_model.dart';
import 'package:ovowpp/data/model/chat/send_message_response_model.dart';
import 'package:ovowpp/data/model/customer_details/customer_details_response_model.dart';
import 'package:ovowpp/data/model/global/response_model/response_model.dart';
import 'package:ovowpp/data/repo/chat/chat_repo.dart';
import 'package:ovowpp/data/controller/home/home_controller.dart';

import '../../../environment.dart';
import '../../model/chat/seen_message_response_model.dart';

class ChatController extends GetxController {
  ChatRepo repo;
  ChatController({required this.repo});
  int currentChatIndex = 0;
  final TextEditingController chatController = TextEditingController();
  LocalizationController localizationController = LocalizationController();
  bool isLoading = true;
  bool nextPageLoading = false;
  String image = "";
  String imagePath = "";
  String mediaPath = "";
  String mobile = "";
  String username = "";
  int page = 0;
  final ScrollController scrollController = ScrollController();
  List<String> more = ["Contact Details", "Send Templates"];

  String? _tempDirPath;

  // ─── Inbox metadata (templates / CTA URLs / interactive lists) ────────────
  List<Map<String, dynamic>> templates = [];
  List<Map<String, dynamic>> ctaUrls = [];
  List<Map<String, dynamic>> interactiveLists = [];
  bool loadingTemplates = false;

  // ─── Contact blocked state ────────────────────────────────────────────────
  bool isBlocked = false;

  // ─── Auto-retry queue ─────────────────────────────────────────────────────
  final List<Map<String, dynamic>> _retryQueue = [];
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  bool _isRetrying = false;

  @override
  void onInit() {
    super.onInit();
    _cacheTempDir();
    _setupConnectivityListener();
  }

  void _setupConnectivityListener() {
    _connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> results) {
      final hasConnection = results.any((r) => r != ConnectivityResult.none);
      if (hasConnection && _retryQueue.isNotEmpty) {
        _flushRetryQueue();
      }
    });
  }

  Future<void> _flushRetryQueue() async {
    if (_isRetrying || _retryQueue.isEmpty) return;
    _isRetrying = true;
    while (_retryQueue.isNotEmpty) {
      final item = _retryQueue.first;
      try {
        final model = MessageModel(
          chatId: conversationId,
          message: item['message'] as String? ?? '',
          file: item['file'] as File?,
          id: item['replyId'] as String?,
        );
        final response = await repo.sendMessageRepo(model, null);
        if (response.statusCode == 200) {
          _retryQueue.removeAt(0);
          final parsed = SentMessageResponseModel.fromJson(response.responseJson);
          if (parsed.status?.toLowerCase() == AppStatus.success) {
            final sentMsg = parsed.data?.message;
            if (sentMsg != null) insertMessageIfAbsent(sentMsg);
            update(['chat_screen_main', 'recording_area']);
          }
        } else {
          break; // still offline or error, stop flushing
        }
      } catch (_) {
        break;
      }
    }
    _isRetrying = false;
  }

  Future<void> _cacheTempDir() async {
    final dir = await getTemporaryDirectory();
    _tempDirPath = dir.path;
  }

  File? selectedFile;

  void pickFile(int type) async {
    FilePickerResult? result = await FilePicker.pickFiles(
      allowMultiple: false,
      type: type == 0
          ? FileType.image
          : type == 1
          ? FileType.video
          : FileType.custom,
    );

    if (result == null) return;

    selectedFile = File(result.files.single.path!);
    update(['chat_screen_main', 'recording_area']);
  }

  void pickDocs() async {
    FilePickerResult? result = await FilePicker.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['pdf', 'docs', 'xls'],
    );

    if (result == null) return;

    selectedFile = File(result.files.single.path!);
    update(['chat_screen_main', 'recording_area']);
  }

  void removeAttachmentFromList() {
    if (selectedFile != null) {
      try {
        selectedFile!.delete();
      } catch (e) {
        printE(e);
      }
      selectedFile = null;
      update(['chat_screen_main', 'recording_area']);
    }
  }

  String conversationId = "";
  String whatsappAccountId = "";
  String lastseen = "";
  Contact? contact;
  List<MessagesData> messages = [];
  MessageReplayTo? replyingTo;
  String? highlightedMessageId;
  String? activeReplyDragMessageId;
  double activeReplyDragOffset = 0;
  bool _isFetchingChats = false;

  // List<MessagesData> filteredMessages = [];
  Future<void> getChatsData({bool initPage = false}) async {
    if (_isFetchingChats) return;
    if (!initPage && page > 0 && !hasNext()) return;

    _isFetchingChats = true;
    final isInitialLoad = initPage || page == 0;
    if (initPage) {
      page = 0;
      nextPageUrl = '';
      messages.clear();
    }

    if (isInitialLoad) {
      isLoading = true;
    } else {
      nextPageLoading = true;
    }
    update(['chat_screen_main', 'recording_area']);

    final requestedPage = page + 1;
    try {
      final responseModal = await repo.getChatsDataRepo(conversationId, requestedPage.toString(), searchQuery);
      printX('Chat data response: ${responseModal.responseJson}');
      
      if (responseModal.statusCode == 200) {
        ChatDataResponseModel model = ChatDataResponseModel.fromJson(responseModal.responseJson);
        if (model.status?.toLowerCase() == Strings.success) {
          final loadedMessages = model.data?.messages?.data ?? <MessagesData>[];
          if (requestedPage == 1) {
            messages
              ..clear()
              ..addAll(loadedMessages);
          } else {
            final existingIds = messages.map((message) => message.id).whereType<String>().toSet();
            messages.addAll(loadedMessages.where((message) => message.id == null || existingIds.add(message.id!)));
          }
          page = requestedPage;
          contact = model.data?.contact;
          imagePath = model.data?.profilePath ?? "";
          mediaPath = model.data?.mediaBasePath ?? "";
          nextPageUrl = model.data?.messages?.nextPageUrl ?? "";
          whatsappAccountId = model.data?.whatsappAccountId ?? "";
        } else {
          CustomSnackBar.error(errorList: model.message ?? [Strings.somethingWentWrong]);
        }
      } else {
        CustomSnackBar.error(errorList: [responseModal.message]);
      }
    } catch (e) {
      printE('Get chats data error: $e');
    } finally {
      _isFetchingChats = false;
      isLoading = false;
      nextPageLoading = false;
      update(['chat_screen_main', 'recording_area']);
    }
  }

  String unseenMessageCount = "";
  bool _isMarkingMessagesAsSeen = false;

  Future<void> seenMessage() async {
    if (_isMarkingMessagesAsSeen || conversationId.trim().isEmpty) return;

    _isMarkingMessagesAsSeen = true;
    try {
      final responseModal = await repo.seenMessageRepo(conversationId);
      if (responseModal.statusCode == 200) {
        SeenMessageResponseModel model = SeenMessageResponseModel.fromJson(responseModal.responseJson);
        if (model.status?.toLowerCase() == Strings.success) {
          unseenMessageCount = model.data?.unseenMessageCount ?? "0";
          if (Get.isRegistered<HomeController>()) {
            Get.find<HomeController>().updateConversationUnseenCount(conversationId, unseenMessageCount);
          }
        } else {
          CustomSnackBar.error(errorList: model.message ?? [Strings.somethingWentWrong]);
        }
      } else {
        CustomSnackBar.error(errorList: [responseModal.message]);
      }
    } catch (e) {
      printE(e.toString());
    } finally {
      _isMarkingMessagesAsSeen = false;
    }
  }

  String searchQuery = '';

  void scrollListener() {
    if (!scrollController.hasClients || _isFetchingChats || isLoading || nextPageLoading || !hasNext()) return;

    final position = scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 200) {
      getChatsData();
    }
  }

  String nextPageUrl = "";

  bool hasNext() {
    return nextPageUrl.isNotEmpty && nextPageUrl != 'null' ? true : false;
  }

  bool get isNearLatestMessage {
    if (!scrollController.hasClients) return true;
    return scrollController.position.pixels <= 120;
  }

  void scrollToLatestMessage() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!scrollController.hasClients) return;
      scrollController.animateTo(
        scrollController.position.minScrollExtent,
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOut,
      );
    });
    // addPostFrameCallback alone does not request a new frame.
    WidgetsBinding.instance.ensureVisualUpdate();
  }

  bool sendingMessage = false;

  /// Inserts a new chat message only when neither its database ID nor its
  /// WhatsApp message ID is already present in the visible conversation.
  bool insertMessageIfAbsent(MessagesData message) {
    final messageId = message.id;
    final whatsappMessageId = message.whatsappMessageId;
    final existingIndex = messages.indexWhere(
      (existing) =>
          (messageId != null && messageId.isNotEmpty && existing.id == messageId) ||
          (whatsappMessageId != null &&
              whatsappMessageId.isNotEmpty &&
              existing.whatsappMessageId == whatsappMessageId),
    );

    if (existingIndex != -1) {
      // Video uploads are slow enough for the realtime event to arrive before
      // the send response. Preserve one item and merge missing reply data.
      messages[existingIndex].replayTo ??= message.replayTo;
      return false;
    }

    messages.insert(0, message);
    return true;
  }

  void sendMessage({String? id, String? chatId, int? index}) async {
    if (sendingMessage) return;
    if (chatId == null && chatController.text.trim().isEmpty && selectedFile == null) {
      return;
    }

    if (conversationId.isEmpty) {
      CustomSnackBar.error(errorList: ['Conversation ID is missing']);
      return;
    }

    sendingMessage = true;
    update(['chat_screen_main', 'recording_area']);
    final pendingReply = replyingTo == null ? null : MessageReplayTo.fromJson(replyingTo!.toJson());
    try {
      MessageModel messageModel = MessageModel(
        chatId: conversationId,
        id: pendingReply?.id ?? id,
        message: chatController.text,
        file: selectedFile,
      );
      ResponseModel model = await repo.sendMessageRepo(messageModel, chatId);
      printX('Send message response: ${model.responseJson}');
      
      if (model.statusCode == 200) {
        SentMessageResponseModel responseModel = SentMessageResponseModel.fromJson(model.responseJson);
        if (responseModel.status?.toLowerCase() == AppStatus.success) {
          final message = messages.firstWhereOrNull((msg) => msg.id == chatId);
          if (message != null) message.status = AppStatus.DELIVERED;
          final sentMessage = responseModel.data?.message;
          if (sentMessage != null) {
            sentMessage.replayTo ??= pendingReply;
            insertMessageIfAbsent(sentMessage);
            // Refresh chat data to ensure persistence
            await getChatsData(initPage: false);
          }
          chatController.clear();
          selectedFile = null;
          clearReply();
          recordedFilePath = null;
          isPreviewing = false;
          update(['chat_screen_main', 'recording_area']);
        } else {
          CustomSnackBar.error(errorList: responseModel.message ?? [Strings.requestFail.tr]);
          // Queue for retry on connectivity restored
          _queueFailedMessage(chatController.text, selectedFile, pendingReply?.id);
        }
        sendingMessage = false;
        update(['chat_screen_main', 'recording_area']);
      } else {
        sendingMessage = false;
        update(['chat_screen_main', 'recording_area']);
        CustomSnackBar.error(errorList: [model.message]);
        // Queue for retry
        _queueFailedMessage(chatController.text, selectedFile, pendingReply?.id);
      }
    } catch (e) {
      printE('Send message error: $e');
      sendingMessage = false;
      update(['chat_screen_main', 'recording_area']);
      // Queue for retry on network error
      _queueFailedMessage(chatController.text, selectedFile, pendingReply?.id);
    }
  }

  /// Add a failed message to the retry queue (auto-sends when connectivity restores).
  void _queueFailedMessage(String message, File? file, String? replyId) {
    if (message.isEmpty && file == null) return;
    _retryQueue.add({'message': message, 'file': file, 'replyId': replyId});
    CustomSnackBar.error(errorList: ['Message queued — will send when connection restores.']);
  }

  bool downloadingFile = false;
  Map<String, String> downloadedVideoPaths = {}; // Store local paths
  Map<String, double> downloadProgress = {}; // Track download progress

  Future<String?> downloadVideoToLocal(String videoUrl, String mediaId) async {
    try {
      // Request storage permission
      if (await Permission.storage.request().isGranted || await Permission.manageExternalStorage.request().isGranted) {
        // Get local directory
        Directory? directory;
        if (Platform.isAndroid) {
          directory = await getExternalStorageDirectory();
        } else {
          directory = await getApplicationDocumentsDirectory();
        }

        if (directory != null) {
          // Create videos folder if it doesn't exist
          final videosDir = Directory('${directory.path}/videos');
          if (!await videosDir.exists()) {
            await videosDir.create(recursive: true);
          }

          final filePath = '${videosDir.path}/video_$mediaId.mp4';

          // Check if file already exists
          if (await File(filePath).exists()) {
            return filePath;
          }

          // Download file using Dio
          Dio dio = Dio();
          await dio.download(
            videoUrl,
            filePath,
            onReceiveProgress: (received, total) {
              if (total != -1) {
                downloadProgress[mediaId] = received / total;
                update(['chat_screen_main', 'recording_area']);
              }
            },
          );

          return filePath;
        }
      } else {
        CustomSnackBar.error(errorList: ['Storage permission denied']);
      }
    } catch (e) {
      printE('Error downloading video: $e');
      CustomSnackBar.error(errorList: ['Failed to download video']);
    }
    return null;
  }

  Future<void> downloadAttachment(String mediaId, int index, String extension) async {
    try {
      downloadingFile = true;
      selectedIndex = index;
      update(['chat_screen_main', 'recording_area']);
      // Check and request storage permission
      bool isPermissionGranted = await MyUtils.checkAndRequestStoragePermission();
      if (!isPermissionGranted) {
        CustomSnackBar.error(errorList: [Strings.permissionDenied]);
        return;
      }
      // Get directory path based on platform
      Directory? targetDir;
      if (Platform.isAndroid) {
        targetDir = Directory('/storage/emulated/0/Download');
      } else if (Platform.isIOS) {
        targetDir = await getApplicationDocumentsDirectory(); // iOS sandboxed path
      }

      if (targetDir == null || !targetDir.existsSync()) {
        CustomSnackBar.error(errorList: ['Download directory not found.']);
        return;
      }
      final fileName = '${Environment.appName}_${DateTime.now().millisecondsSinceEpoch}.$extension';
      final downloadPath = '${targetDir.path}/$fileName';
      // Download file
      ResponseModel responseModel = await repo.downloadFileRepo(mediaId, downloadPath);
      CustomSnackBar.success(successList: [responseModel.message]);
      MyUtils().openFile(downloadPath, extension);
    } catch (e) {
      printE(e);
    } finally {
      selectedIndex = -1;
      downloadingFile = false;
      update(['chat_screen_main', 'recording_area']);
    }
  }

  Future<void> saveAndOpenFile(List<int> bytes, String fileName, String extension) async {
    Directory? downloadsDirectory;

    if (Platform.isAndroid) {
      var status = await Permission.storage.request();
      if (!status.isGranted) {
        CustomSnackBar.error(errorList: [Strings.permissionDenied]);
        return;
      }
      downloadsDirectory = Directory('/storage/emulated/0/Download');
    } else if (Platform.isIOS) {
      downloadsDirectory = await getApplicationDocumentsDirectory();
    }

    if (downloadsDirectory != null) {
      final downloadPath = '${downloadsDirectory.path}/$fileName';
      final file = File(downloadPath);
      await file.writeAsBytes(bytes);
      CustomSnackBar.success(successList: ['File saved at: $downloadPath']);
      await MyUtils().openFile(downloadPath, extension);
    } else {
      CustomSnackBar.error(errorList: [Strings.downloadDirNotFound]);
    }
  }

  bool isSearch = false;
  void changeSearchStatus() {
    isSearch = !isSearch;
    update(['chat_screen_main', 'recording_area']);
  }

  List<String> status = [Strings.selectTemplate, "avvv", "asdsad"];
  int selectedIndex = 0;
  void changeSelectedIndex(int index) {
    selectedIndex = index;
    update(['chat_screen_main', 'recording_area']);
  }

  void startReply(MessagesData message) {
    replyingTo = MessageReplayTo.fromJson(message.toJson());
    activeReplyDragMessageId = null;
    activeReplyDragOffset = 0;
    update(['chat_screen_main', 'recording_area']);
  }

  void clearReply() {
    replyingTo = null;
    activeReplyDragMessageId = null;
    activeReplyDragOffset = 0;
    update(['chat_screen_main', 'recording_area']);
  }

  void updateReplyDrag(String messageId, double offset) {
    activeReplyDragMessageId = messageId;
    activeReplyDragOffset = offset.clamp(0, 72);
    update(['chat_screen_main']);
  }

  void finishReplyDrag(MessagesData message) {
    final shouldReply = activeReplyDragOffset >= 44;
    activeReplyDragMessageId = null;
    activeReplyDragOffset = 0;
    if (shouldReply) {
      startReply(message);
    } else {
      update(['chat_screen_main']);
    }
  }

  int findRepliedMessageIndex(MessageReplayTo? replyTo) {
    if (replyTo == null) return -1;

    final repliedMessageId = replyTo.id?.trim();
    final repliedWhatsappMessageId = replyTo.whatsappMessageId?.trim();

    return messages.indexWhere((message) {
      final messageId = message.id?.trim();
      final whatsappMessageId = message.whatsappMessageId?.trim();

      return (repliedMessageId != null &&
              repliedMessageId.isNotEmpty &&
              messageId == repliedMessageId) ||
          (repliedWhatsappMessageId != null &&
              repliedWhatsappMessageId.isNotEmpty &&
              whatsappMessageId == repliedWhatsappMessageId);
    });
  }

  void highlightMessage(String? messageId) {
    if (messageId == null || messageId.isEmpty) return;
    highlightedMessageId = messageId;
    update(['chat_screen_main']);
    Future.delayed(const Duration(seconds: 2), () {
      if (highlightedMessageId == messageId) {
        highlightedMessageId = null;
        update(['chat_screen_main']);
      }
    });
  }

  // ─── Audio Recording ───────────────────────────────────────────────
  final AudioRecorder _audioRecorder = AudioRecorder();
  bool isRecording = false;
  bool isRecordingLocked = false;
  String recordingDuration = '00:00';
  Timer? _recordingTimer;
  int _recordingSeconds = 0;
  String? recordedFilePath;
  bool isPreviewing = false;

  bool get hasText => chatController.text.trim().isNotEmpty;

  void onTextChanged() {
    update(['chat_screen_main', 'recording_area']);
  }

  Future<void> startRecording() async {
    // Provide instant UI feedback
    isRecording = true;
    isRecordingLocked = false;
    _recordingSeconds = 0;
    recordingDuration = '00:00';
    update(['recording_area']);
    _startTimer(); // Start timer immediately

    try {
      final hasPermission = await _audioRecorder.hasPermission();
      if (!hasPermission) {
        isRecording = false;
        _recordingTimer?.cancel();
        update(['chat_screen_main', 'recording_area']);
        CustomSnackBar.error(errorList: [Strings.permissionDenied]);
        return;
      }

      if (_tempDirPath == null) {
        final dir = await getTemporaryDirectory();
        _tempDirPath = dir.path;
      }
      recordedFilePath = '$_tempDirPath/voice_${DateTime.now().millisecondsSinceEpoch}.ogg';

      await _audioRecorder.start(
        const RecordConfig(encoder: AudioEncoder.opus, bitRate: 64000, sampleRate: 16000, numChannels: 1),
        path: recordedFilePath!,
      );
    } catch (e) {
      isRecording = false;
      _recordingTimer?.cancel();
      update(['chat_screen_main', 'recording_area']);
      printE('Start recording error: $e');
      CustomSnackBar.error(errorList: ['Failed to start recording']);
    }
  }

  List<double> amplitudes = [];
  DateTime? _recordingStartTime;

  void _startTimer() {
    _recordingTimer?.cancel();
    amplitudes.clear();
    _recordingStartTime = DateTime.now();
    _recordingTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (!isRecording) {
        timer.cancel();
        return;
      }

      final now = DateTime.now();
      _recordingSeconds = now.difference(_recordingStartTime!).inSeconds;

      final minutes = (_recordingSeconds ~/ 60).toString().padLeft(2, '0');
      final seconds = (_recordingSeconds % 60).toString().padLeft(2, '0');
      recordingDuration = '$minutes:$seconds';

      // Auto stop at max limit
      if (_recordingSeconds >= Environment.maxAudioRecordingSeconds) {
        stopRecording();
        // CustomSnackBar.error(errorList: ['Maximum recording limit of ${Environment.maxAudioRecordingSeconds ~/ 60} minutes reached']);
      }

      _pollAmplitude();
      update(['recording_duration']);
    });
  }

  bool _isPollingAmplitude = false;
  Future<void> _pollAmplitude() async {
    if (_isPollingAmplitude || !isRecording) return;
    _isPollingAmplitude = true;
    try {
      final amplitude = await _audioRecorder.getAmplitude();
      double value = (amplitude.current + 160) / 160;
      if (value < 0.1) value = 0.1;

      amplitudes.add(value);
      if (amplitudes.length > 30) {
        amplitudes.removeAt(0);
      }
    } catch (_) {
      if (amplitudes.length < 30) amplitudes.add(0.1);
    } finally {
      _isPollingAmplitude = false;
    }
  }

  void lockRecording() {
    isRecordingLocked = true;
    update(['chat_screen_main', 'recording_area']);
  }

  Future<void> stopRecording() async {
    try {
      final path = await _audioRecorder.stop();
      _recordingTimer?.cancel();
      isRecording = false;
      isPreviewing = true;
      recordedFilePath = path;
      update(['recording_area']);
    } catch (e) {
      printE('Stop recording error: $e');
      isRecording = false;
      update(['recording_area']);
    }
  }

  Future<void> cancelRecording() async {
    try {
      await _audioRecorder.cancel();
    } catch (_) {}
    _recordingTimer?.cancel();
    isRecording = false;
    isPreviewing = false;
    isRecordingLocked = false;
    _recordingSeconds = 0;
    recordingDuration = '00:00';
    recordedFilePath = null;
    amplitudes.clear();
    update(['recording_area']);
  }

  Future<void> stopAndSendRecording() async {
    try {
      final path = await _audioRecorder.stop();
      _recordingTimer?.cancel();
      isRecording = false;
      isPreviewing = false;
      isRecordingLocked = false;
      _recordingSeconds = 0;
      recordingDuration = '00:00';
      amplitudes.clear();
      update(['chat_screen_main', 'recording_area']); // Keep both for sendMessage logic

      if (path != null && path.isNotEmpty) {
        selectedFile = File(path);
        sendMessage();
      }
    } catch (e) {
      printE('Stop recording error: $e');
      isRecording = false;
      isPreviewing = false;
      update(['chat_screen_main', 'recording_area']);
    }
  }

  void sendPreview() {
    if (recordedFilePath != null) {
      selectedFile = File(recordedFilePath!);
      sendMessage();
      isPreviewing = false;
      recordedFilePath = null;
      update(['recording_area']);
    }
  }

  // ─── Inbox data (templates, CTA URLs, interactive lists) ─────────────────

  Future<void> loadInboxData() async {
    loadingTemplates = true;
    update(['chat_screen_main']);
    try {
      final res = await repo.getInboxDataRepo();
      if (res.statusCode == 200) {
        final data = res.responseJson['data'] as Map<String, dynamic>? ?? {};
        final rawTemplates = data['templates'] as List<dynamic>? ?? [];
        final rawCtaUrls = data['ctaUrls'] as List<dynamic>? ?? [];
        final rawLists = data['interactiveLists'] as List<dynamic>? ?? [];
        templates = rawTemplates.map((e) => Map<String, dynamic>.from(e as Map)).toList();
        ctaUrls = rawCtaUrls.map((e) => Map<String, dynamic>.from(e as Map)).toList();
        interactiveLists = rawLists.map((e) => Map<String, dynamic>.from(e as Map)).toList();
      }
    } catch (e) {
      printE('loadInboxData error: $e');
    } finally {
      loadingTemplates = false;
      update(['chat_screen_main']);
    }
  }

  // ─── Send template ────────────────────────────────────────────────────────

  Future<void> sendTemplateMessage(String templateId) async {
    if (conversationId.isEmpty) {
      CustomSnackBar.error(errorList: ['Conversation ID is missing']);
      return;
    }
    if (templateId.isEmpty) {
      CustomSnackBar.error(errorList: ['Template ID is missing']);
      return;
    }

    final recipientMobileCode = contact?.mobileCode ?? '';
    final recipientMobile = contact?.mobile ?? '';
    if (recipientMobileCode.isEmpty || recipientMobile.isEmpty) {
      CustomSnackBar.error(errorList: ['Contact number is missing for this conversation']);
      return;
    }

    sendingMessage = true;
    update(['chat_screen_main', 'recording_area']);
    try {
      final res = await repo.sendTemplateMessageRepo(
        conversationId,
        templateId,
        mobileCode: recipientMobileCode,
        mobile: recipientMobile,
      );
      printX('Template response: ${res.responseJson}');
      
      if (res.statusCode == 200 &&
          (res.responseJson['status'] as String?)?.toLowerCase() == AppStatus.success) {
        final sentMessage = res.responseJson['data']?['message'];
        if (sentMessage != null) {
          final msg = MessagesData.fromJson(Map<String, dynamic>.from(sentMessage as Map));
          insertMessageIfAbsent(msg);
          // Refresh chat data to ensure persistence
          await getChatsData(initPage: false);
        }
        CustomSnackBar.success(successList: ['Template sent successfully']);
      } else {
        final errorMessage = (res.responseJson['message'] as List?)?.first?.toString() ?? 
                            res.responseJson['message']?.toString() ?? 
                            Strings.somethingWentWrong;
        CustomSnackBar.error(errorList: [errorMessage]);
      }
    } catch (e) {
      printE('Template send error: $e');
      CustomSnackBar.error(errorList: ['Failed to send template: ${e.toString()}']);
    } finally {
      sendingMessage = false;
      update(['chat_screen_main', 'recording_area']);
    }
  }

  // ─── Send CTA URL ─────────────────────────────────────────────────────────

  Future<void> sendCtaUrlMessage(String ctaUrlId) async {
    sendingMessage = true;
    update(['chat_screen_main', 'recording_area']);
    try {
      final res = await repo.sendCtaUrlMessageRepo(conversationId, ctaUrlId);
      if (res.statusCode == 200 &&
          (res.responseJson['status'] as String?)?.toLowerCase() == AppStatus.success) {
        final sentMessage = res.responseJson['data']?['message'];
        if (sentMessage != null) {
          final msg = MessagesData.fromJson(Map<String, dynamic>.from(sentMessage as Map));
          insertMessageIfAbsent(msg);
        }
        CustomSnackBar.success(successList: ['CTA URL sent successfully']);
      } else {
        CustomSnackBar.error(errorList: [(res.responseJson['message'] as List?)?.first?.toString() ?? Strings.somethingWentWrong]);
      }
    } catch (e) {
      CustomSnackBar.error(errorList: [Strings.somethingWentWrong]);
    } finally {
      sendingMessage = false;
      update(['chat_screen_main', 'recording_area']);
    }
  }

  // ─── Send interactive list ────────────────────────────────────────────────

  Future<void> sendInteractiveListMessage(String listId) async {
    sendingMessage = true;
    update(['chat_screen_main', 'recording_area']);
    try {
      final res = await repo.sendInteractiveListMessageRepo(conversationId, listId);
      if (res.statusCode == 200 &&
          (res.responseJson['status'] as String?)?.toLowerCase() == AppStatus.success) {
        final sentMessage = res.responseJson['data']?['message'];
        if (sentMessage != null) {
          final msg = MessagesData.fromJson(Map<String, dynamic>.from(sentMessage as Map));
          insertMessageIfAbsent(msg);
        }
        CustomSnackBar.success(successList: ['Interactive list sent']);
      } else {
        CustomSnackBar.error(errorList: [(res.responseJson['message'] as List?)?.first?.toString() ?? Strings.somethingWentWrong]);
      }
    } catch (e) {
      CustomSnackBar.error(errorList: [Strings.somethingWentWrong]);
    } finally {
      sendingMessage = false;
      update(['chat_screen_main', 'recording_area']);
    }
  }

  // ─── Send location ────────────────────────────────────────────────────────

  Future<void> sendCurrentLocation() async {
    try {
      final perm = await Geolocator.checkPermission();
      if (perm == LocationPermission.denied) {
        final req = await Geolocator.requestPermission();
        if (req == LocationPermission.denied || req == LocationPermission.deniedForever) {
          CustomSnackBar.error(errorList: ['Location permission denied']);
          return;
        }
      }
      CustomSnackBar.success(successList: ['Fetching location…']);
      final pos = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.medium);
      sendingMessage = true;
      update(['chat_screen_main', 'recording_area']);
      final res = await repo.sendLocationMessageRepo(conversationId, pos.latitude, pos.longitude);
      if (res.statusCode == 200 &&
          (res.responseJson['status'] as String?)?.toLowerCase() == AppStatus.success) {
        final sentMessage = res.responseJson['data']?['message'];
        if (sentMessage != null) {
          final msg = MessagesData.fromJson(Map<String, dynamic>.from(sentMessage as Map));
          insertMessageIfAbsent(msg);
        }
        CustomSnackBar.success(successList: ['Location sent']);
      } else {
        CustomSnackBar.error(errorList: [(res.responseJson['message'] as List?)?.first?.toString() ?? Strings.somethingWentWrong]);
      }
    } catch (e) {
      CustomSnackBar.error(errorList: ['Failed to get location']);
    } finally {
      sendingMessage = false;
      update(['chat_screen_main', 'recording_area']);
    }
  }

  // ─── Block / unblock contact ──────────────────────────────────────────────

  bool blockLoading = false;

  Future<void> toggleBlockContact(String contactId) async {
    blockLoading = true;
    update(['chat_screen_main']);
    try {
      final res = await repo.blockContactRepo(contactId, !isBlocked);
      if (res.statusCode == 200 &&
          (res.responseJson['status'] as String?)?.toLowerCase() == AppStatus.success) {
        isBlocked = !isBlocked;
        CustomSnackBar.success(
            successList: [isBlocked ? 'Contact blocked' : 'Contact unblocked']);
      } else {
        CustomSnackBar.error(errorList: [(res.responseJson['message'] as List?)?.first?.toString() ?? Strings.somethingWentWrong]);
      }
    } catch (e) {
      CustomSnackBar.error(errorList: [Strings.somethingWentWrong]);
    } finally {
      blockLoading = false;
      update(['chat_screen_main']);
    }
  }

  // ─── Clear chat ───────────────────────────────────────────────────────────

  bool clearingChat = false;

  Future<void> clearChat() async {
    clearingChat = true;
    update(['chat_screen_main']);
    try {
      final res = await repo.clearChatRepo(conversationId);
      if (res.statusCode == 200 &&
          (res.responseJson['remark'] as String?) == 'conversation_cleared') {
        messages.clear();
        CustomSnackBar.success(successList: ['Chat cleared']);
      } else {
        CustomSnackBar.error(errorList: [(res.responseJson['message'] as String?) ?? Strings.somethingWentWrong]);
      }
    } catch (e) {
      CustomSnackBar.error(errorList: [Strings.somethingWentWrong]);
    } finally {
      clearingChat = false;
      update(['chat_screen_main', 'recording_area']);
    }
  }

  // ─── Tag assignment ───────────────────────────────────────────────────────

  List<Map<String, dynamic>> availableTags = [];
  bool loadingTags = false;
  bool assigningTag = false;
  String assignedTagId = ''; // currently assigned tag id on this contact

  /// Load all available tags from the backend, then open the picker.
  Future<void> loadTagsForPicker() async {
    loadingTags = true;
    // Seed assignedTagId from the contact's current first tag (if any).
    final firstTag = contact?.tags?.firstOrNull;
    assignedTagId = firstTag?.toString() ?? '';
    update(['chat_screen_main']);
    try {
      final res = await repo.fetchTagsRepo();
      if (res.statusCode == 200) {
        final rawTags =
            res.responseJson['data']?['contact_tags']?['data'] as List<dynamic>? ?? [];
        availableTags =
            rawTags.map((e) => Map<String, dynamic>.from(e as Map)).toList();
      }
    } catch (e) {
      printE('loadTagsForPicker error: $e');
    } finally {
      loadingTags = false;
      update(['chat_screen_main']);
    }
  }

  /// Assign [tagId] to the current contact. Pass empty string to remove all tags.
  Future<void> assignTag(String tagId) async {
    final contactId = contact?.id?.toString() ?? '';
    if (contactId.isEmpty) {
      CustomSnackBar.error(errorList: ['Contact not found']);
      return;
    }
    assigningTag = true;
    update(['chat_screen_main']);
    try {
      final res = await repo.assignTagRepo(contactId, tagId);
      if (res.statusCode == 200 &&
          (res.responseJson['status'] as String?)?.toLowerCase() == 'success') {
        assignedTagId = tagId;
        CustomSnackBar.success(
            successList: [tagId.isEmpty ? 'Tag removed' : 'Tag assigned successfully']);
      } else {
        final msg = (res.responseJson['message'] as List?)?.first?.toString() ??
            res.responseJson['message']?.toString() ??
            'Failed to assign tag';
        CustomSnackBar.error(errorList: [msg]);
      }
    } catch (e) {
      printE('assignTag error: $e');
      CustomSnackBar.error(errorList: ['Failed to assign tag']);
    } finally {
      assigningTag = false;
      update(['chat_screen_main']);
    }
  }

  @override
  void onClose() {
    _connectivitySubscription?.cancel();
    _recordingTimer?.cancel();
    _audioRecorder.dispose();
    scrollController.dispose();
    super.onClose();
  }
}
