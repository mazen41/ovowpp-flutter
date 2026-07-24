import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:ovowpp/app/components/snack_bar/show_custom_snackbar.dart';
import 'package:ovowpp/core/translations/localization_controller.dart';
import 'package:ovowpp/core/utils/app_status.dart';
import 'package:ovowpp/core/utils/my_strings.dart';
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

  @override
  void onInit() {
    super.onInit();
    _cacheTempDir();
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
      if (responseModal.statusCode == 200) {
        ChatDataResponseModel model = ChatDataResponseModel.fromJson(responseModal.responseJson);
        if (model.status?.toLowerCase() == MyStrings.success) {
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
          CustomSnackBar.error(errorList: model.message ?? [MyStrings.somethingWentWrong]);
        }
      } else {
        CustomSnackBar.error(errorList: [responseModal.message]);
      }
    } catch (e) {
      printE(e.toString());
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
        if (model.status?.toLowerCase() == MyStrings.success) {
          unseenMessageCount = model.data?.unseenMessageCount ?? "0";
          if (Get.isRegistered<HomeController>()) {
            Get.find<HomeController>().updateConversationUnseenCount(conversationId, unseenMessageCount);
          }
        } else {
          CustomSnackBar.error(errorList: model.message ?? [MyStrings.somethingWentWrong]);
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

    sendingMessage = true;
    update(['chat_screen_main', 'recording_area']);
    // Keep the selected reply until the request finishes. The API response for a
    // newly sent message may not contain `reply_to`, even though it is returned
    // after the conversation is loaded again.
    final pendingReply = replyingTo == null ? null : MessageReplayTo.fromJson(replyingTo!.toJson());
    try {
      MessageModel messageModel = MessageModel(
        chatId: conversationId,
        // The backend expects the replied message's main database ID in
        // `wa_message_id` (see ChatRepo.sendMessageRepo).
        id: pendingReply?.id ?? id,
        message: chatController.text,
        file: selectedFile,
      );
      ResponseModel model = await repo.sendMessageRepo(messageModel, chatId);
      if (model.statusCode == 200) {
        SentMessageResponseModel responseModel = SentMessageResponseModel.fromJson(model.responseJson);
        if (responseModel.status?.toLowerCase() == AppStatus.success) {
          final message = messages.firstWhereOrNull((msg) => msg.id == chatId);

          if (message != null) {
            message.status = AppStatus.DELIVERED;
          }

          final sentMessage = responseModel.data?.message;
          if (sentMessage != null) {
            sentMessage.replayTo ??= pendingReply;
            insertMessageIfAbsent(sentMessage);
          }
          chatController.clear();
          selectedFile = null;
          clearReply();
          recordedFilePath = null; // Clear this too
          isPreviewing = false;
          update(['chat_screen_main', 'recording_area']);
        } else {
          CustomSnackBar.error(errorList: responseModel.message ?? [MyStrings.requestFail.tr]);
        }
        sendingMessage = false;
        update(['chat_screen_main', 'recording_area']);
      } else {
        sendingMessage = false;
        update(['chat_screen_main', 'recording_area']);
        CustomSnackBar.error(errorList: [model.message]);
      }
    } catch (e) {
      sendingMessage = false;
      update(['chat_screen_main', 'recording_area']);
    }
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
        CustomSnackBar.error(errorList: [MyStrings.permissionDenied]);
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
        CustomSnackBar.error(errorList: [MyStrings.permissionDenied]);
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
      CustomSnackBar.error(errorList: [MyStrings.downloadDirNotFound]);
    }
  }

  bool isSearch = false;
  void changeSearchStatus() {
    isSearch = !isSearch;
    update(['chat_screen_main', 'recording_area']);
  }

  List<String> status = [MyStrings.selectTemplate, "avvv", "asdsad"];
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
        CustomSnackBar.error(errorList: [MyStrings.permissionDenied]);
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

  @override
  void onClose() {
    _recordingTimer?.cancel();
    _audioRecorder.dispose();
    scrollController.dispose();
    super.onClose();
  }
}
