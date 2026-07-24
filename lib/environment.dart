class Environment {
  static const appName = "OvoWpp";
  static const appVersion = "1.0.0";

  static String defaultLangCode = "en";
  static String defaultLanguageName = "English";

  static String defaultPhoneCode = "1"; //don't put + here
  static String defaultCountryCode = "us";
  static String defaultCountry = "United States";

  static const int animationDuration = 375;

  //DEV MODE ==> false if production
  static const bool DEV_MODE = true;

  // API END POINT URL
  static const MAIN_API_URL = DEV_MODE ? TEST_API_URL : LIVE_API_URL; // Don't touch here

  static const LIVE_API_URL = 'https://preview.ovosolution.com/ovowpp/demo'; //Live end Point URL
  static const TEST_API_URL = 'https://preview.ovosolution.com/ovowpp/demo'; //Local or demo or test URL

  static const int maxAudioRecordingSeconds = 20; // 3 minutes
}
