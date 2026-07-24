import 'package:ovowpp/app/screens/all_contact/all_contact_screen.dart';
import 'package:ovowpp/app/screens/all_contact_list/all_contact_list_screen.dart';
import 'package:ovowpp/app/screens/campaigns/create_campaign/create_campaign_screen.dart';
import 'package:ovowpp/app/screens/chat/chat_person_details/chat_person_details_screen.dart';
import 'package:ovowpp/app/screens/chat/chat_screen.dart';
import 'package:ovowpp/app/screens/chat/widget/documnet_preview_screen.dart';
import 'package:ovowpp/app/screens/contact/contact_details_screen.dart';
import 'package:ovowpp/app/screens/contact_tag/contact_tag_list_screen.dart';
import 'package:ovowpp/app/screens/customer_details/customer_details_screen.dart';
import 'package:ovowpp/app/screens/dashboard/dashboard_screen.dart';
import 'package:ovowpp/app/screens/edit_profile/widget/profile_edit_from.dart';
import 'package:ovowpp/app/screens/help_center/help_center_screen.dart';
import 'package:ovowpp/app/screens/manage_contact/manage_contact_screen.dart';
import 'package:ovowpp/app/screens/menu/contact_support/contact_support_screen.dart';
import 'package:ovowpp/app/screens/menu/menu_screen.dart';
import 'package:ovowpp/app/screens/subscriptions/subscriptions_screen.dart';
import 'package:ovowpp/app/screens/customer_account/customer_account_screen.dart';
import 'package:ovowpp/app/screens/menu/widgets/edit_personal_information_screen.dart';
import 'package:ovowpp/app/screens/onboard/onboard_screen.dart';
import 'package:ovowpp/app/screens/view_contact/add_new_contact_group_screen.dart';
import 'package:ovowpp/app/screens/view_contact/view_contact_screen.dart';
import 'package:ovowpp/data/model/user/user.dart';
import 'package:ovowpp/data/services/shared_pref_service.dart';
import 'package:ovowpp/app/components/preview_image.dart';
import 'package:ovowpp/app/screens/account/change-password/change_password_screen.dart';
import 'package:ovowpp/app/screens/auth/email_verification_page/email_verification_screen.dart';
import 'package:ovowpp/app/screens/auth/forget_password/forget_password/forget_password.dart';
import 'package:ovowpp/app/screens/auth/forget_password/reset_password/reset_password_screen.dart';
import 'package:ovowpp/app/screens/auth/forget_password/verify_forget_password/verify_forget_password_screen.dart';
import 'package:ovowpp/app/screens/auth/kyc/kyc.dart';
import 'package:ovowpp/app/screens/auth/login/login_screen.dart';
import 'package:ovowpp/app/screens/auth/profile_complete/profile_complete_screen.dart';
import 'package:ovowpp/app/screens/auth/registration/registration_screen.dart';
import 'package:ovowpp/app/screens/auth/sms_verification_page/sms_verification_screen.dart';
import 'package:ovowpp/app/screens/edit_profile/edit_profile_screen.dart';
import 'package:ovowpp/app/screens/faq/faq_screen.dart';
import 'package:ovowpp/app/screens/language/language_screen.dart';
import 'package:ovowpp/app/screens/notification/notification_screen.dart';
import 'package:ovowpp/app/screens/privacy_policy/privacy_policy_screen.dart';
import 'package:ovowpp/app/screens/splash/splash_screen.dart';
import 'package:ovowpp/app/screens/ticket/new_ticket_screen/new_ticket_screen.dart';
import 'package:ovowpp/app/screens/ticket/all_ticket_screen/all_ticket_screen.dart';
import 'package:ovowpp/app/screens/transaction/transactions_screen.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../app/screens/auth/two_factor/two_factor_setup_screen/two_factor_setup_screen.dart';
import '../../app/screens/auth/two_factor/two_factor_verification_screen/two_factor_verification_screen.dart';
import '../../app/screens/bottom_nav_bar/bottom_nav_bar.dart';
import '../../app/screens/contact/add_new_contact_screen.dart';
import '../../app/screens/contact/contact_screen.dart';
import '../../app/screens/deposits/deposit_webview/my_webview_screen.dart';
import '../../app/screens/deposits/deposits_history_screen.dart';
import '../../app/screens/deposits/new_deposit/new_deposit_screen.dart';
import '../../app/screens/manage_agent/add_new_agent_screen.dart';
import '../../app/screens/manage_agent/agent_permission_screen.dart';
import '../../app/screens/manage_agent/edit_agent_screen.dart';
import '../../app/screens/manage_agent/manage_agent_screen.dart';
import '../../app/screens/menu/help_center/new_help_center_screen.dart';
import '../../app/screens/menu/notification_setting/notification_setting_screen.dart';
import '../../app/screens/ticket/ticket_details_screen/ticket_details_screen.dart';
import '../../app/screens/withdraw/add_withdraw_screen/add_withdraw_method_screen.dart';
import '../../app/screens/withdraw/confirm_withdraw_screen/withdraw_confirm_screen.dart';
import '../../app/screens/withdraw/withdraw_history/withdraw_screen.dart';

import 'package:ovowpp/app/screens/clients/clients_screen.dart';
import 'package:ovowpp/app/screens/clients/client_tags_screen.dart';

class RouteHelper {
  //use screen in screen name and route name
  static const String splashScreen = "/splash_screen";
  static const String onboardScreen = "/onboard_screen";
  static const String loginScreen = "/login_screen";
  static const String forgotPasswordScreen = "/forgot_password_screen";
  static const String changePasswordScreen = "/change_password_screen";
  static const String registrationScreen = "/registration_screen";
  static const String chatScreen = "/chat_screen";

  static const String myWalletScreen = "/my_wallet_screen";
  static const String addMoneyHistoryScreen = "/add_money_history_screen";
  static const String profileCompleteScreen = "/profile_complete_screen";
  static const String emailVerificationScreen = "/verify_email_screen";
  static const String smsVerificationScreen = "/verify_sms_screen";
  static const String verifyPassCodeScreen = "/verify_pass_code_screen";
  static const String twoFactorScreen = "/two-factor-screen";
  static const String resetPasswordScreen = "/reset_pass_screen";
  static const String transactionHistoryScreen = "/transaction_history_screen";
  static const String notificationScreen = "/notification_screen";
  static const String profileScreen = "/profile_screen";
  static const String editProfileScreen = "/edit_profile_screen";
  static const String kycScreen = "/kyc_screen";
  static const String privacyScreen = "/privacy-screen";

  static const String withdrawScreen = "/withdraw-screen";
  static const String addWithdrawMethodScreen = "/withdraw-method";
  static const String withdrawConfirmScreenScreen = "/withdraw-preview-screen";
  static const String supportTicketMethodsList = '/all_ticket_methods';
  static const String allTicketScreen = '/all_ticket_screen';

  static const String ticketDetailsScreen = '/ticket_details_screen';

  static const String newTicketScreen = '/new_ticket_screen';

  static const String depositsHistoryScreen = "/deposits";
  static const String newDepositScreenScreen = "/deposits_money";
  static const String depositWebViewScreen = '/deposit_webView';
  static const String languageScreen = "/languages_screen";
  static const String twoFactorSetupScreen = "/two-factor-setup-screen";
  static const String previewImageScreen = "/preview-image-screen";
  static const String faqScreen = "/faq-screen";
  static const String notification = "/notifications-screen";
  static const String homeScreen = "/home-screen";
  static const String menuScreen = "/menu-screen";
  static const String customerDetailsScreen = "/customer-details-screen";
  static const String chatPersonDetailsScreen = "/chat-person-details-screen";
  static const String customerAccountScreen = "/my-account-screen";
  static const String helpCenterScreen = "/help-center-screen";
  static const String manageContactScreen = "/manage-contact-screen";
  static const String allContactScreen = "/all-contact-screen";
  static const String allContactListScreen = "/all-contact-list-screen";
  static const String manageAgentScreen = "/manage-agent-screen";
  static const String editAgentScreen = "/edit-agent-screen";
  static const String addNewAgentScreen = "/add-new-agent-screen";
  static const String viewContactListScreen = "/view-contact-list-screen";
  static const String addNewContactGroupListScreen = "/add-new-contact-list-screen";
  static const String contactTagListScreen = "/contact-tag-list-screen";
  static const String agentPermissionScreen = "/agent-permission-screen";

  static const String dashboardScreen = "/dashboard-screen";
  static const String subscriptionScreen = "/subscription-screen";
  static const String bottomNavScreen = "/bottom-nav-screen";
  static const String documentPreviewScreen = '/document-preview';
  static const String createCampaignScreen = '/create_campaign_screen';
  static const String addNewContact = '/add_new_contact';
  static const String contactDetails = '/contact_details';

  static const String editPersonalInformationScreen = '/edit_personal_information_screen';
  static const String notificationSettingScreen = '/notification_settings_screen';
  static const String newHelpCenterScreen = '/new_help_center_screen';
  static const String contactSupportScreen = '/contact_support_screen';
  static const String profileEditForm = '/edit_profile_form';
  static const String contactScreen = '/contact_screen';
  static const String clientsScreen = '/clients_screen';
  static const String clientTagsScreen = '/client_tags_screen';

  List<GetPage> routes = [
    GetPage(
      name: splashScreen,
      page: () => const SplashScreen(),
      transitionDuration: const Duration(milliseconds: 400),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: onboardScreen,
      page: () => const OnboardScreen(),
      transitionDuration: const Duration(milliseconds: 400),
      transition: Transition.fadeIn,
    ),

    GetPage(
      name: loginScreen,
      page: () => const LoginScreen(),
      transition: Transition.downToUp,
      fullscreenDialog: true,
      popGesture: false,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: forgotPasswordScreen,
      page: () => const ForgetPasswordScreen(),
      transitionDuration: const Duration(milliseconds: 400),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: changePasswordScreen,
      page: () => const ChangePasswordScreen(),
      transitionDuration: const Duration(milliseconds: 400),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: registrationScreen,
      page: () => const RegistrationScreen(),
      transitionDuration: const Duration(milliseconds: 400),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: profileCompleteScreen,
      page: () => const ProfileCompleteScreen(),
      transitionDuration: const Duration(milliseconds: 400),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: withdrawScreen,
      page: () => const WithdrawScreen(),
      transitionDuration: const Duration(milliseconds: 400),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: addWithdrawMethodScreen,
      page: () => const AddWithdrawMethod(),
      transitionDuration: const Duration(milliseconds: 400),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: withdrawConfirmScreenScreen,
      page: () => const WithdrawConfirmScreen(),
      transitionDuration: const Duration(milliseconds: 400),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: profileScreen,
      page: () => ProfileScreen(),
      transitionDuration: const Duration(milliseconds: 400),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: transactionHistoryScreen,
      page: () => const TransactionsScreen(),
      transitionDuration: const Duration(milliseconds: 400),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: kycScreen,
      page: () => const KycScreen(),
      transitionDuration: const Duration(milliseconds: 400),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: depositWebViewScreen,
      page: () => MyWebViewScreen(redirectUrl: Get.arguments),
    ),
    GetPage(
      name: depositsHistoryScreen,
      page: () => const DepositsHistoryScreen(),
      transitionDuration: const Duration(milliseconds: 400),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: newDepositScreenScreen,
      page: () => const NewDepositScreen(),
      transitionDuration: const Duration(milliseconds: 400),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: emailVerificationScreen,
      page: () => const EmailVerificationScreen(),
      transitionDuration: const Duration(milliseconds: 400),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: smsVerificationScreen,
      page: () => const SmsVerificationScreen(),
      transitionDuration: const Duration(milliseconds: 400),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: verifyPassCodeScreen,
      page: () => const VerifyForgetPassScreen(),
      transitionDuration: const Duration(milliseconds: 400),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: resetPasswordScreen,
      page: () => const ResetPasswordScreen(),
      transitionDuration: const Duration(milliseconds: 400),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: twoFactorScreen,
      page: () => const TwoFactorVerificationScreen(),
      transitionDuration: const Duration(milliseconds: 400),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: kycScreen,
      page: () => const KycScreen(),
      transition: Transition.fadeIn,
      fullscreenDialog: true,
      popGesture: false,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: privacyScreen,
      page: () => const PrivacyPolicyScreen(),
      transitionDuration: const Duration(milliseconds: 400),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: twoFactorSetupScreen,
      page: () => const TwoFactorSetupScreen(),
      transitionDuration: const Duration(milliseconds: 400),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: languageScreen,
      page: () => const LanguageScreen(),
      transitionDuration: const Duration(milliseconds: 400),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: allTicketScreen,
      page: () => const AllTicketScreen(),
      transitionDuration: const Duration(milliseconds: 400),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: ticketDetailsScreen,
      page: () => const TicketDetailsScreen(),
      transitionDuration: const Duration(milliseconds: 400),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: newTicketScreen,
      page: () => const NewTicketScreen(),
      transitionDuration: const Duration(milliseconds: 400),
      transition: Transition.fadeIn,
    ),
    GetPage(name: previewImageScreen, page: () => PreviewImage()),
    GetPage(
      name: allContactScreen,
      page: () => const AllContactScreen(),
      transitionDuration: const Duration(milliseconds: 400),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: faqScreen,
      page: () => const FaqScreen(),
      transitionDuration: const Duration(milliseconds: 400),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: chatScreen,
      page: () => const ChatScreen(),
      transitionDuration: const Duration(milliseconds: 400),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: menuScreen,
      page: () => const MenuScreen(),
      transitionDuration: const Duration(milliseconds: 400),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: manageContactScreen,
      page: () => const ManageContactScreen(),
      transitionDuration: const Duration(milliseconds: 400),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: contactTagListScreen,
      page: () => const ContactTagListScreen(),
      transitionDuration: const Duration(milliseconds: 400),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: addNewContactGroupListScreen,
      page: () => const AddNewContactGroupScreen(),
      transitionDuration: const Duration(milliseconds: 400),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: viewContactListScreen,
      page: () => const ViewContactScreen(),
      transitionDuration: const Duration(milliseconds: 400),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: allContactListScreen,
      page: () => const AllContactListScreen(),
      transitionDuration: const Duration(milliseconds: 400),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: customerAccountScreen,
      page: () => const CustomerAccountScreen(),
      transitionDuration: const Duration(milliseconds: 400),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: helpCenterScreen,
      page: () => const HelpCenterScreen(),
      transitionDuration: const Duration(milliseconds: 400),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: newHelpCenterScreen,
      page: () => const NewHelpCenterScreen(),
      transitionDuration: const Duration(milliseconds: 400),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: customerDetailsScreen,
      page: () => const CustomerDetailsScreen(),
      transitionDuration: const Duration(milliseconds: 400),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: notificationScreen,
      page: () => const NotificationScreen(),
      transitionDuration: const Duration(milliseconds: 400),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: manageAgentScreen,
      page: () => const ManageAgentScreen(),
      transitionDuration: const Duration(milliseconds: 400),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: editAgentScreen,
      page: () => const EditAgentScreen(),
      transitionDuration: const Duration(milliseconds: 400),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: addNewAgentScreen,
      page: () => const AddNewAgentScreen(),
      transitionDuration: const Duration(milliseconds: 400),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: agentPermissionScreen,
      page: () => const AgentPermissionScreen(),
      transitionDuration: const Duration(milliseconds: 400),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: bottomNavScreen,
      page: () => const BottomNavBar(),
      transitionDuration: const Duration(milliseconds: 400),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: documentPreviewScreen,
      page: () => DocumentPreviewScreen(pdfUrl: Get.arguments),
      transitionDuration: const Duration(milliseconds: 400),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: dashboardScreen,
      page: () => const DashboardScreen(),
      transitionDuration: const Duration(milliseconds: 400),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: subscriptionScreen,
      page: () => const SubscriptionsScreen(),
      transitionDuration: const Duration(milliseconds: 400),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: createCampaignScreen,
      page: () => CreateCampaignScreen(),
      transitionDuration: const Duration(milliseconds: 400),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: addNewContact,
      page: () => const AddNewContact(),
      transitionDuration: const Duration(milliseconds: 400),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: contactDetails,
      page: () => const ContactDetailsScreen(),
      transitionDuration: const Duration(milliseconds: 400),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: editPersonalInformationScreen,
      page: () => const EditPersonalInformationScreen(),
      transitionDuration: const Duration(milliseconds: 400),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: notificationSettingScreen,
      page: () => NotificationSettingScreen(),
      transitionDuration: const Duration(milliseconds: 400),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: contactSupportScreen,
      page: () => ContactSupportScreen(),
      transitionDuration: const Duration(milliseconds: 400),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: profileEditForm,
      page: () => ProfileEditForm(),
      transitionDuration: const Duration(milliseconds: 400),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: chatPersonDetailsScreen,
      page: () => ChatPersonDetailsScreen(),
      transitionDuration: const Duration(milliseconds: 400),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: contactScreen,
      page: () => ContactScreen(),
      transitionDuration: const Duration(milliseconds: 400),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: clientsScreen,
      page: () => const ClientsScreen(),
      transitionDuration: const Duration(milliseconds: 400),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: clientTagsScreen,
      page: () => const ClientTagsScreen(),
      transitionDuration: const Duration(milliseconds: 400),
      transition: Transition.fadeIn,
    ),
  ];

  static Future<void> checkUserStatusAndGoToNextStep(
    User? user, {
    bool isRemember = false,
    String accessToken = "",
    String tokenType = "",
  }) async {
    bool needEmailVerification = user?.ev == "1" ? false : true;
    bool needSmsVerification = user?.sv == '1' ? false : true;
    bool isTwoFactorEnable = user?.tv == '1' ? false : true;

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    if (isRemember) {
      await sharedPreferences.setBool(SharedPreferenceService.rememberMeKey, true);
    } else {
      await sharedPreferences.setBool(SharedPreferenceService.rememberMeKey, false);
    }

    await sharedPreferences.setString(SharedPreferenceService.firstName, user?.firstname.toString() ?? '-1');
    await sharedPreferences.setString(SharedPreferenceService.lastName, user?.lastname.toString() ?? '-1');
    await sharedPreferences.setString(SharedPreferenceService.userIdKey, user?.id.toString() ?? '-1');
    await sharedPreferences.setString(SharedPreferenceService.userEmailKey, user?.email ?? '');
    await sharedPreferences.setString(SharedPreferenceService.userPhoneNumberKey, user?.mobile ?? '');
    await sharedPreferences.setString(SharedPreferenceService.userNameKey, user?.username ?? '');

    if (accessToken.isNotEmpty) {
      await SharedPreferenceService.setAccessToken(accessToken);
      await SharedPreferenceService.setAccessTokenType(tokenType);
    }

    bool isProfileCompleteEnable = user?.profileComplete == '0' ? true : false;

    if (isProfileCompleteEnable) {
      Get.toNamed(RouteHelper.profileCompleteScreen);
    } else if (needEmailVerification) {
      Get.offAndToNamed(RouteHelper.emailVerificationScreen);
    } else if (needSmsVerification) {
      Get.offAndToNamed(RouteHelper.smsVerificationScreen);
    } else if (isTwoFactorEnable) {
      Get.offAndToNamed(RouteHelper.twoFactorScreen);
    } else {
      Get.offAndToNamed(RouteHelper.bottomNavScreen, arguments: [true]);
    }
  }
}
