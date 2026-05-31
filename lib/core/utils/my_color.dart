import 'package:flutter/material.dart';

class MyColor {
  // ========================== Splash Screens Colors ===========================
  static const Color splashScreenBackground = Color(0xFFF5F2EB); //#F5F2EB
  static const Color loginScreenBackground = Color(0xFFF6F3EC);
  static const Color transparent = Colors.transparent;
  static const Color regularHederColor = Color(0xFF1D1E25); //######################0A0A0A
  static const Color usdTextColor = Color(0xFF0A0A0A); //####0A0A0A
  static const Color splashTextColor = Color(0xFF606576); //#606576
  static const Color appBarSmallText = Color(0xFF666666);
  static const Color ovoTextColor = Color(0xFF101828);
  static const Color btnArrowColor = Color(0xFF030712);
  static final Color socialContainerBorder = Color(0xFFC1C9D0).withAlpha(76);
  static const Color orLineColor = Color(0xFFD1D5DC); //#D1D5DC
  static const Color error = Color(0xFFEB4E3D); //###F0FDF4
  static const Color dark = Color(0xFF1F2937);
  static const Color headingText = Color(0xFF1E293B);
  static const Color fieldTitleTextColor = Color(0xFF6A7282); //#767779
  static const Color forgotPasswordColor = Color(0xFFEF4444);
  static const Color appBarTitleColor = Color(0xFF1A1A1A);
  static const Color notificationBorder = Color(0xFFF0F0F0);
  static const Color notificationToggle = Color(0xFFEF4444);
  static Color dashboardCardBorder = Color(0XFF000000).withAlpha(20); //######6A7282
  static const Color messageSentBgColor = Color(0xFF3C82F6);
  static const Color totalContactBgColor = Color(0xFFA855F7);
  static const Color totalCampaignsBgColor = Color(0xFFF97315);

  static Color planStatusColor = Color(0XFF0BC9F4);
  static Color planStatusTextColor = Color(0XFF767779); //#####767779
  static Color recentActivityIconBgColor = Color(0XFFE8F8F0);
  static Color recentActivityCardValue = Color(0XFF888888);
  static Color searchFieldColor = Color(0XFFF8F8F8);
  static Color searchItemBgColor = Color(0XFFF4F4F4);
  static Color selectedSearchItemBgColor = Color(0XFFD0FECF);
  static Color selectedSearchItemTextColor = Color(0XFF15603E);
  static Color campaignsRunning = Color(0XFF28A745);
  static Color campaignsScheduled = Color(0XFF00A8E5);
  static Color updatedTextColor = Color(0XFF99A1AF);
  static Color errorColor = Color(0XFFFF4C4C);
  static Color campaignFieldFillColor = Color(0XFFF9FAFB);
  static Color switchOffColor = Color(0XFFCBCED4);
  static Color cancelElevatedBtnBgColor = Color(0XFFEFEFF3);
  static Color customerText = Color(0XFF008236);
  static Color leadText = Color(0XFF1447E6);
  static Color agentText = Color(0XFF8200DB);
  static Color contactDetailsICon = Color(0XFF969EB6);
  static Color recentlyActivityIconColor = Color(0XFF4A5565);
  static Color recentActivityTextColor = Color(0XFF364153); //##99A1AF
  static Color logoutColor = Color(0XFFE7000B);
  static Color notificationLineColor = Color(0XFFE2E8F0);
  static Color helpCenterItemBgColor = Color(0XFFF0FDF4);
  static Color chatBoxHintColor = Color(0XFF717182);
  static Color chatMessageSendBgColor = Color(0XFF00A884);
  static Color chatPersonItemArrow = Color(0XFFCCCCCC);
  static Color ratingStar = Color(0XFFFFB938);
  static Color sendMessage = Color(0XFFD0FECF);

  // ===================== Neutral Colors =====================
  static const Color black = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);

  // ===================== Light Theme Colors =====================
  // Primary & Secondary
  static const Color lightPrimary = Color(0xFF25D366);
  static const Color dashboardIconBg = Color(0xFFC7F4D8);
  static const Color lightSecondary = Color(0xFF43D2FF);

  // Text Colors
  static const Color lightHeadingText = Color(0xFF1D1E25);
  static const Color lightBodyText = Color(0xFF606576);
  static const Color lightSplashBodyText = Color(0xFFDCF8E7);

  // Accent Colors
  static const Color lightAccent1 = Color(0xFF77AAFF);

  // Section & Background
  static const Color lightBackground = Color(0xFFEFEFF3); // Light Background
  static const Color lightCardBackground = Color(0xFFFFFFFF); // Card Background
  static const Color lightSectionBackground = Color(0xFFF8FAFC); // Section Background#F8FAFC
  static const Color lightScaffoldBackground = Color(0xFFF8FAFC); // Scaffold Background
  static const Color lightAppBarBackground = Color(0xFFF8FAFC); // Dark AppBar background
  static const Color lightSplashBgBackground = Color(0xFF0B411F); // Dark AppBar background
  // Borders
  static const Color lightBorder = Color(0xFFDBDEE3);
  static const Color lightButtonBorderBorder = Color(0xFF378F5B);
  //textfield fill color
  static const Color lightTextFieldFillColor = Color(0xFFEFEFF3);

  // Feedback Colors
  static const Color lightInformation = Color(0xFF00A8E5);
  static const Color lightWarning = Color(0xFFFFCC00);
  static const Color lightSuccess = Color(0xFF35C75A);
  static const Color lightError = Color(0xFFEB4E3D);

  // Button Colors
  static const Color lightButtonBackground = lightPrimary;
  static const Color lightButtonText = white;

  static const Color pendingColor = Colors.orange;
  static const Color openColor = Color(0XFF00A8E5); //##FF4C4C

  // ===================== Dark Theme Colors =====================
  // Primary & Secondary
  static const Color darkPrimary = Color(0xFFFF5722); // A slightly muted orange for dark mode
  static const Color darkSecondary = Color(0xFF1E88E5); // A deeper blue for contrast

  // Text Colors
  static const Color darkHeadingText = Color(0xFFFFFFFF); // Almost white for headings
  static const Color darkBodyText = Color(0xFFFFFFFF); // Light gray for body text

  // Accent Colors
  static const Color darkAccent1 = Color(0xFF64B5F6); // Soft blue accent

  // Section & Background
  static const Color darkBackground = Color(0xFF121212); // Dark mode background
  static const Color darkCardBackground = Color(0xFF1E1E1E); // Slightly lighter card background
  static const Color darkSectionBackground = Color(0xFF232323); // For sections
  static const Color darkScaffoldBackground = Color(0xFF121212); // Dark scaffold background
  static const Color darkAppBarBackground = Color(0xFF232323); // Dark AppBar background

  // Borders
  static const Color darkBorder = Color(0xFF37474F); // Subtle dark border

  // Feedback Colors
  static const Color darkInformation = Color(0xFF007AFF); // Lighter green for better visibility
  static const Color darkWarning = Color(0xFFFFCA28); // A vibrant amber for warnings
  static const Color darkSuccess = Color(0xFF43A047); // Slightly darker green for success
  static const Color darkError = Color(0xFFEF5350); // Vibrant red for errors

  // Button Colors
  static const Color darkButtonBackground = darkPrimary;
  static const Color darkButtonText = white; // Black text for better visibility on buttons

  //All Colors getters
  // ===================== Getters for Colors =====================
  static Color getTransparentColor({bool isLightTheme = true}) => transparent;
  static Color getPrimaryColor({bool isLightTheme = true}) => isLightTheme ? lightPrimary : darkPrimary;
  static Color getSecondaryColor({bool isLightTheme = true}) => isLightTheme ? lightSecondary : darkSecondary;
  static Color getHeadingTextColor({bool isLightTheme = true}) => isLightTheme ? lightHeadingText : darkHeadingText;
  static Color getBodyTextColor({bool isLightTheme = true}) => isLightTheme ? lightBodyText : darkBodyText;
  static Color getAccent1Color({bool isLightTheme = true}) => isLightTheme ? lightAccent1 : darkAccent1;
  static Color getBackgroundColor({bool isLightTheme = true}) => isLightTheme ? lightBackground : darkBackground;
  static Color getCardBackgroundColor({bool isLightTheme = true}) =>
      isLightTheme ? lightCardBackground : darkCardBackground;
  static Color getSectionBackgroundColor({bool isLightTheme = true}) =>
      isLightTheme ? lightSectionBackground : darkSectionBackground;
  static Color getScaffoldBackgroundColor({bool isLightTheme = true}) =>
      isLightTheme ? lightScaffoldBackground : darkScaffoldBackground;
  static Color getBorderColor({bool isLightTheme = true}) => isLightTheme ? lightBorder : darkBorder;
  static Color getInformationColor({bool isLightTheme = true}) => isLightTheme ? lightInformation : darkInformation;
  static Color getWarningColor({bool isLightTheme = true}) => isLightTheme ? lightWarning : darkWarning;
  static Color getSuccessColor({bool isLightTheme = true}) => isLightTheme ? lightSuccess : darkSuccess;
  static Color getErrorColor({bool isLightTheme = true}) => isLightTheme ? lightError : darkError;
  static Color getButtonBackgroundColor({bool isLightTheme = true}) =>
      isLightTheme ? lightButtonBackground : darkButtonBackground;
  static Color getButtonTextColor({bool isLightTheme = true}) => isLightTheme ? lightButtonText : darkButtonText;

  static Color getDarkColor() {
    return dark;
  }

  static Color getHeaderTextColor() {
    return headingText;
  }

  static int getAlpha(int opacity) {
    return (255 * opacity / 100).round();
  }
}
