// ignore_for_file: constant_identifier_names

class AppStatus {
  static const String PENDING = "0";
  static const String APPROVE = "1";
  //attention: write all status here
  static const String success = "success";
  static const String ALL = "0";
  static const String PENDING_CONVERSATION = "2";
  static const String DONE_CONVERSATION = "1";
  static const String IMPORTANT_CONVERSATION = "3";
  static const String UNREAD_CONVERSATION = "4";
  static const String IMPORTANT = "3";
  //attention: write all status here

  static const String SENT = "1";
  static const String DELIVERED = "2";
  static const String READ = "3";
  static const String FAILED = "9";
  static const String SCHEDULED = "0";

  static const String TEXT_TYPE_MESSAGE = "1";
  static const String IMAGE_TYPE_MESSAGE = "2";
  static const String VIDEO_TYPE_MESSAGE = "3";
  static const String DOCUMENT_TYPE_MESSAGE = "4";
  static const String AUDIO_TYPE_MESSAGE = '5';
  static const String URL_TYPE_MESSAGE = '6';
  static const String BUTTON_TYPE_MESSAGE = '7';
  static const String LOCATION_TYPE_MESSAGE = '8';
  static const String LIST_TYPE_MESSAGE = '9';
  static const String REPLY_TYPE_MESSAGE = '0';
  static const String STICKER_TYPE_MESSAGE = '10';

  static const String ctaUrl = 'CTA Url';
  static const String location = 'Location';
  static const String listMessage = 'List message';
  static const String template = 'Template';
}
