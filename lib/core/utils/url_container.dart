import 'package:ovowpp/environment.dart';

class UrlContainer {
  static const String domainUrl = Environment.MAIN_API_URL;
  static const String baseUrl = '$domainUrl/api/';

  static const String socialLoginEndPoint = 'social-login';
  static const String dashBoardEndPoint = 'dashboard';
  static const String depositHistoryUrl = 'deposit/history';
  static const String depositMethodUrl = 'deposit/methods';
  static const String depositInsertUrl = 'deposit/insert';
  static const String saveCustomerContactUrl = 'contact/save';
  static const String updateCustomerContactUrl = 'contact/update';

  static const String accountDisable = "delete-account";
  static const String notificationEndPoint = 'push-notifications';

  static const String registrationEndPoint = 'register';
  static const String loginEndPoint = 'login';
  static const String logoutUrl = 'logout';
  static const String forgetPasswordEndPoint = 'password/email';
  static const String passwordVerifyEndPoint = 'password/verify-code';
  static const String resetPasswordEndPoint = 'password/reset';
  static const String verify2FAUrl = 'verify-g2fa';
  static const String deviceTokenUrl = 'add-device-token';

  static const String otpVerify = 'otp-verify';
  static const String otpResend = 'otp-resend';

  static const String verifyEmailEndPoint = 'verify-email';
  static const String verifySmsEndPoint = 'verify-mobile';
  static const String resendVerifyCodeEndPoint = 'resend-verify/';
  static const String authorizationCodeEndPoint = 'authorization';

  static const String dashBoardUrl = 'dashboard';
  static const String allNumbersUrl = 'whatsapp-account';
  static const String chatListUrl = 'inbox/conversation-list';
  static const String switchNumberUrl = 'whatsapp-account/connect';
  static const String customerDetailsUrl = 'inbox/conversation/details/';
  static const String customerDetailsStatusUrl = 'inbox/conversation/status/';
  static const String customerDetailsNoteUrl = 'inbox/note/store';
  static const String sendMessageUrl = 'inbox/chat/message/send';
  static const String seenMessageUrl = 'inbox/chat/message/status';
  static const String updateContactUrl = 'contact-list/update/';
  static const String updateContactTagUrl = 'contact-tag/update/';
  static const String createContactUrl = 'contact-list/save';
  static const String createContactTagUrl = 'contact-tag/save';
  static const String addNewGroupContactUrl = 'contact-list/contact-add';
  static const String deleteMessageUrl = 'contact/delete/';
  static const String deleteContactUrl = 'contact-list/delete/';
  static const String deleteContactTagUrl = 'contact-tag/delete/';
  static const String deleteContacListtUrl = 'contact-list/contact-remove/';
  static const String deleteNoteUrl = 'inbox/note/delete/';
  static const String transactionEndpoint = 'transactions';

  static const String addWithdrawRequestUrl = 'withdraw-request';
  static const String withdrawMethodUrl = 'withdraw-method';
  static const String withdrawRequestConfirm = 'withdraw-request/confirm';
  static const String withdrawHistoryUrl = 'withdraw/history';
  static const String withdrawStoreUrl = 'withdraw/store/';
  static const String withdrawConfirmScreenUrl = 'withdraw/preview/';

  static const String kycFormUrl = 'kyc-form';
  static const String kycSubmitUrl = 'kyc-submit';

  static const String generalSettingEndPoint = 'general-setting';

  static const String privacyPolicyEndPoint = 'policies';
  static const String getProfileEndPoint = 'user-info';
  static const String updateProfileEndPoint = 'profile-setting';
  static const String profileCompleteEndPoint = 'user-data-submit';
  static const String chatsDataEndPoint = 'inbox/conversation-message/';
  static const String downloadMediaDataEndPoint = 'inbox/media/download/';
  static const String tagsDataEndPoint = 'contact-tag/list';
  static const String allTagsandCOntactDataEndPoint = 'contact/create';
  static const String contactListDataEndPoint = 'contact/list/';
  static const String allContactListDataEndPoint = 'contact-list/list';
  static const String allContactTagListDataEndPoint = 'contact-tag/list';
  static const String viewContactListDataEndPoint = 'contact-list/view/';
  static const String viewContactUnlistedDataEndPoint = 'contact/search?search=';
  static const String createConversationDataEndPoint = 'inbox?contact_id=';
  static const String importCsvEndPoint = 'contact/import';

  static const String agentListEndPoint = 'agent/list';
  static const String updateAgentListEndPoint = 'agent/update';
  static const String addAgentListEndPoint = 'agent/save';
  static const String agentPermissionEndPoint = 'agent/permissions';
  static const String updatePermissionEndPoint = 'agent/permissions/save';
  static const String deleteAgentEndPoint = 'agent/delete';

  static const String changePasswordEndPoint = 'change-password';
  static const String countryEndPoint = 'get-countries';

  static const String deviceTokenEndPoint = 'add-device-token';
  static const String languageUrl = 'language/';

  static const String twoFactor = "twofactor";
  static const String twoFactorEnable = "twofactor/enable";
  static const String twoFactorDisable = "twofactor/disable";
  static const String communityGroupsEndPoint = 'community-groups';

  static const String supportMethodsEndPoint = 'support/method';
  static const String supportListEndPoint = 'ticket';
  static const String storeSupportEndPoint = 'ticket/create';
  static const String supportViewEndPoint = 'ticket/view';
  static const String supportReplyEndPoint = 'ticket/reply';
  static const String supportCloseEndPoint = 'ticket/close';
  static const String supportDownloadEndPoint = 'ticket/download';
  static const String countryFlagImageLink = 'https://flagpedia.net/data/flags/h24/{countryCode}.webp';
  static const String faqEndPoint = 'faq';
  static const String subscriptionIndexEndPoint = 'subscription/index';
  static const String subscriptionPurchaseHistoryEndPoint = 'subscription/purchase-history';
  static const String subscriptionInvoiceDownloadEndPoint = 'subscription/invoice-download/';
  static const String subscriptionPlanPurchaseEndPoint = 'subscription/purchase/';

  static const String supportImagePath = '$domainUrl/assets/support/';

  static const String withDrawImagePath = '$domainUrl/assets/images/withdraw_method/';

  static const String seenMessageEndPoint = 'inbox/chat/message/status/';
  static const String resendMessageUrl = 'inbox/chat/message/resend';
  static const String pusherAuthApiURl = "pusher/auth";
  static const String getCampaign = 'campaign/index';
  static const String createCampaign = 'campaign/create';
  static const String saveCampaign = "campaign/save";
}
