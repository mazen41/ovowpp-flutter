import 'package:get/get.dart';
import '../translations/en_US/en_us_translation.dart';
import '../translations/ar_AR/ar_ar_translation.dart';

class Messages extends Translations {
  @override
  Map<String, Map<String, String>> get keys {
    return {
      'en_US': enUs,
      'ar_SA': arAR,
    };
  }
}
