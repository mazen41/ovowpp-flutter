import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ovowpp/app/components/snack_bar/show_custom_snackbar.dart';
import 'package:ovowpp/core/route/route.dart';
import 'package:ovowpp/core/utils/my_strings.dart';
import 'package:ovowpp/core/utils/util.dart';
import 'package:ovowpp/data/controller/dashboard/dashboard_controller.dart';
import 'package:ovowpp/data/model/authorization/authorization_response_model.dart';
import 'package:ovowpp/data/model/global/response_model/response_model.dart';
import 'package:ovowpp/data/model/subscription/pricing_plan_response_model.dart';
import 'package:ovowpp/data/model/subscription/purchase_history_response_model.dart';
import 'package:ovowpp/data/model/user/user.dart';
import 'package:ovowpp/data/repo/subscription/subscription_repo.dart';
import 'package:ovowpp/data/services/shared_pref_service.dart';
import 'package:path_provider/path_provider.dart';

import '../../../environment.dart';

class SubscriptionController extends GetxController {
  SubscriptionRepo subscriptionRepo;
  SubscriptionController({required this.subscriptionRepo});

  bool isLoading = true;
  bool isHistoryLoading = true;
  int purchaseHistoryPage = 0;
  String purchaseHistoryNextPageUrl = "";
  List<PricingPlan> pricingPlanList = [];
  List<PurchaseHistoryData> purchaseHistoryList = [];
  User? user;
  ActivePlan? activePlan;
  PurchaseData? purchaseData;
  bool downloadingInvoice = false;
  String downloadingInvoiceId = '';

  final TextEditingController couponController = TextEditingController();
  PricingPlan? selectedPurchasePlan;
  String selectedPlanRecurring = 'monthly';
  String selectedPurchasePaymentOption = 'wallet_payment';
  String appliedCouponCode = '';
  bool purchaseSubmitting = false;

  Future<void> loadPricingPlans() async {
    isLoading = true;
    update();

    ResponseModel responseModel = await subscriptionRepo.getPricingPlans();
    if (responseModel.statusCode == 200) {
      PricingPlanResponseModel model = PricingPlanResponseModel.fromJson(responseModel.responseJson);
      pricingPlanList = model.data?.pricingPlans ?? [];
      user = model.data?.user;
      activePlan = model.data?.activePlan;
      purchaseData = model.data?.purchaseData;

      if ((model.status ?? '').toLowerCase() != MyStrings.success.toLowerCase() && pricingPlanList.isEmpty) {
        CustomSnackBar.error(errorList: model.message ?? [MyStrings.somethingWentWrong]);
      }
    } else {
      CustomSnackBar.error(errorList: [responseModel.message]);
    }

    isLoading = false;
    update();
  }

  Future<void> initPurchaseHistory() async {
    purchaseHistoryPage = 0;
    purchaseHistoryNextPageUrl = "";
    purchaseHistoryList.clear();

    isHistoryLoading = true;
    update();

    await loadPurchaseHistory();

    isHistoryLoading = false;
    update();
  }

  Future<void> loadPaginationData() async {
    await loadPurchaseHistory();
    update();
  }

  Future<void> loadPurchaseHistory() async {
    purchaseHistoryPage = purchaseHistoryPage + 1;

    if (purchaseHistoryPage == 1) {
      purchaseHistoryList.clear();
    }

    ResponseModel responseModel = await subscriptionRepo.getPurchaseHistory(purchaseHistoryPage);
    if (responseModel.statusCode == 200) {
      PurchaseHistoryResponseModel model = PurchaseHistoryResponseModel.fromJson(responseModel.responseJson);
      purchaseHistoryNextPageUrl = model.data?.purchaseHistories?.nextPageUrl ?? "";

      if (model.status.toString().toLowerCase() == MyStrings.success.toLowerCase()) {
        List<PurchaseHistoryData>? tempHistoryList = model.data?.purchaseHistories?.data;
        if (tempHistoryList != null && tempHistoryList.isNotEmpty) {
          purchaseHistoryList.addAll(tempHistoryList);
        }
      } else {
        CustomSnackBar.error(errorList: model.message ?? [MyStrings.somethingWentWrong]);
      }
    } else {
      CustomSnackBar.error(errorList: [responseModel.message]);
    }
  }

  bool hasNext() {
    return purchaseHistoryNextPageUrl.isNotEmpty && purchaseHistoryNextPageUrl != 'null' ? true : false;
  }

  bool isStarterPlan(PricingPlan? plan) {
    final String normalizedName = (plan?.name ?? '').trim().toLowerCase();
    return normalizedName.contains(MyStrings.starter.toLowerCase());
  }

  bool hasPurchasedPlan(PricingPlan? plan) {
    final String planId = (plan?.id ?? '').trim();
    if (planId.isEmpty) return false;

    if ((user?.planId ?? '').trim() == planId) {
      return true;
    }

    final dynamic currentPurchasePlanId = purchaseData?.rawData['plan_id'];
    if ((currentPurchasePlanId?.toString().trim() ?? '') == planId) {
      return true;
    }

    return purchaseHistoryList.any((item) => (item.planId ?? '').trim() == planId);
  }

  bool isStarterPlanRepurchaseBlocked(PricingPlan? plan) {
    return isStarterPlan(plan) && hasPurchasedPlan(plan);
  }

  bool isCurrentPlan(String? planId) {
    return (user?.planId ?? '') == (planId ?? '');
  }

  PricingPlan? get currentPricingPlan {
    try {
      return pricingPlanList.firstWhere((element) => element.id == user?.planId);
    } catch (_) {
      return null;
    }
  }

  void preparePlanPurchase(PricingPlan plan, {required bool isYearly}) {
    selectedPurchasePlan = plan;
    final preferredRecurring = isYearly ? 'yearly' : 'monthly';
    selectedPlanRecurring = isRecurringAvailable(plan, preferredRecurring)
        ? preferredRecurring
        : defaultRecurringForPlan(plan);
    selectedPurchasePaymentOption = 'wallet_payment';
    appliedCouponCode = '';
    couponController.clear();
    update();
  }

  void changeSelectedRecurring(String? value) {
    if ((value ?? '').isEmpty) return;
    final plan = selectedPurchasePlan;
    if (plan == null) return;
    if (!isRecurringAvailable(plan, value!)) {
      CustomSnackBar.error(errorList: [MyStrings.invalidBillingCycle]);
      return;
    }
    selectedPlanRecurring = value;
    update();
  }

  void changeSelectedPurchasePaymentOption(String value) {
    selectedPurchasePaymentOption = value;
    update();
  }

  void applyCouponCode() {
    appliedCouponCode = couponController.text.trim();
    if (appliedCouponCode.isEmpty) {
      CustomSnackBar.error(errorList: [MyStrings.enterCouponCode]);
      return;
    }
    CustomSnackBar.success(successList: [MyStrings.couponWillApply]);
    update();
  }

  String get selectedPlanPrice {
    final plan = selectedPurchasePlan;
    if (plan == null) return '0';
    return selectedPlanRecurring == 'yearly' ? (plan.yearlyPrice ?? '0') : (plan.monthlyPrice ?? '0');
  }

  String get selectedPlanRecurringValue {
    return selectedPlanRecurring == 'yearly' ? '2' : '1';
  }

  List<String> availableRecurringOptions(PricingPlan plan) {
    final options = <String>[];
    if (isRecurringAvailable(plan, 'monthly')) {
      options.add('monthly');
    }
    if (isRecurringAvailable(plan, 'yearly')) {
      options.add('yearly');
    }
    return options;
  }

  String defaultRecurringForPlan(PricingPlan plan) {
    final options = availableRecurringOptions(plan);
    if (options.contains('monthly')) return 'monthly';
    if (options.contains('yearly')) return 'yearly';
    return 'monthly';
  }

  bool isRecurringAvailable(PricingPlan plan, String recurring) {
    final rawPrice = recurring == 'yearly' ? plan.yearlyPrice : plan.monthlyPrice;
    if ((rawPrice ?? '').trim().isEmpty) return false;
    final parsedPrice = double.tryParse(rawPrice!.trim());
    if (parsedPrice == null) return false;
    if (parsedPrice > 0) return true;
    return parsedPrice == 0 && isStarterPlan(plan);
  }

  String get currencySymbol {
    return SharedPreferenceService.getCurrencySymbol().isEmpty ? r'$' : SharedPreferenceService.getCurrencySymbol();
  }

  String get currencyCode {
    return SharedPreferenceService.getCurrencyText().isEmpty
        ? MyStrings.usd
        : SharedPreferenceService.getCurrencyText();
  }

  String get walletBalance {
    if (Get.isRegistered<DashboardController>()) {
      return Get.find<DashboardController>().dashboardData?.walletBalance?.toString() ?? '0';
    }
    return '0';
  }

  double get walletBalanceValue => double.tryParse(walletBalance) ?? 0;
  double get selectedPlanPriceValue => double.tryParse(selectedPlanPrice) ?? 0;

  Future<void> submitSelectedPlanPurchase() async {
    await submitPlanPurchase(
      plan: selectedPurchasePlan,
      selectedRecurring: selectedPlanRecurring,
      paymentOption: selectedPurchasePaymentOption,
      couponCode: appliedCouponCode,
    );
  }

  Future<void> submitPlanPurchase({
    required PricingPlan? plan,
    required String selectedRecurring,
    required String paymentOption,
    String couponCode = '',
  }) async {
    if (plan == null || (plan.id ?? '').isEmpty) {
      CustomSnackBar.error(errorList: [MyStrings.requestFail]);
      return;
    }

    if (isStarterPlanRepurchaseBlocked(plan)) {
      CustomSnackBar.error(errorList: [MyStrings.starterPlanAlreadyPurchased]);
      return;
    }

    if (!isRecurringAvailable(plan, selectedRecurring)) {
      CustomSnackBar.error(errorList: [MyStrings.invalidBillingCycle]);
      return;
    }

    final String selectedPrice = selectedRecurring == 'yearly' ? (plan.yearlyPrice ?? '0') : (plan.monthlyPrice ?? '0');
    final double selectedPriceValue = double.tryParse(selectedPrice) ?? 0;

    if (paymentOption == 'wallet_payment' && walletBalanceValue < selectedPriceValue) {
      CustomSnackBar.error(errorList: [MyStrings.insufficientWalletBalance]);
      return;
    }

    selectedPurchasePlan = plan;
    selectedPlanRecurring = selectedRecurring;
    selectedPurchasePaymentOption = paymentOption;
    appliedCouponCode = couponCode;
    purchaseSubmitting = true;
    update();

    try {
      if (paymentOption == 'gateway_payment') {
        purchaseSubmitting = false;
        update();

        if (Get.isBottomSheetOpen ?? false) {
          Get.back();
        }

        Get.toNamed(
          RouteHelper.newDepositScreenScreen,
          arguments: {
            'source': 'subscription_plan_purchase',
            'plan_id': plan.id ?? '',
            'plan_name': plan.name ?? '',
            'plan_description': plan.description ?? '',
            'plan_recurring': selectedPlanRecurringValue,
            'amount': selectedPrice,
            'currency': currencyCode,
            'coupon_code': couponCode,
          },
        );
        return;
      }

      final Map<String, dynamic> data = {
        'plan_recurring': selectedPlanRecurringValue,
        'purchase_payment_option': paymentOption == "wallet_payment" ? "1" : "2",
      };

      if (couponCode.isNotEmpty) {
        data['coupon_code'] = couponCode;
      }

      ResponseModel responseModel = await subscriptionRepo.purchasePlan(planId: plan.id ?? '', data: data);

      if (responseModel.statusCode == 200) {
        AuthorizationResponseModel model = AuthorizationResponseModel.fromJson(responseModel.responseJson);
        if ((model.status ?? '').toLowerCase() == MyStrings.success.toLowerCase()) {
          purchaseSubmitting = false;
          selectedPurchasePlan = null;
          selectedPlanRecurring = 'monthly';
          selectedPurchasePaymentOption = 'wallet_payment';
          appliedCouponCode = '';
          couponController.clear();
          update();

          if (Get.isBottomSheetOpen ?? false) {
            Get.back();
            await Future.delayed(const Duration(milliseconds: 150));
          }
          CustomSnackBar.success(successList: model.message ?? [MyStrings.requestSuccess]);
          await loadPricingPlans();
          await initPurchaseHistory();
          if (Get.isRegistered<DashboardController>()) {
            await Get.find<DashboardController>().loadData();
          }
        } else {
          CustomSnackBar.error(errorList: model.message ?? [MyStrings.requestFail]);
        }
      } else {
        CustomSnackBar.error(errorList: [responseModel.message]);
      }
    } catch (e) {
      printE(e);
      CustomSnackBar.error(errorList: [MyStrings.requestFail]);
    } finally {
      purchaseSubmitting = false;
      update();
    }
  }

  Future<void> downloadInvoice(String invoiceId) async {
    if (invoiceId.isEmpty) {
      CustomSnackBar.error(errorList: [MyStrings.requestFail]);
      return;
    }

    try {
      downloadingInvoice = true;
      downloadingInvoiceId = invoiceId;
      update();

      bool isPermissionGranted = await MyUtils.checkAndRequestStoragePermission();
      if (!isPermissionGranted) {
        CustomSnackBar.error(errorList: [MyStrings.permissionDenied]);
        return;
      }

      Directory? targetDir;
      if (Platform.isAndroid) {
        targetDir = Directory('/storage/emulated/0/Download');
      } else if (Platform.isIOS) {
        targetDir = await getApplicationDocumentsDirectory();
      }

      if (targetDir == null || !targetDir.existsSync()) {
        CustomSnackBar.error(errorList: [MyStrings.downloadDirNotFound]);
        return;
      }

      final fileName = '${Environment.appName}_invoice_$invoiceId.pdf';
      final downloadPath = '${targetDir.path}/$fileName';
      ResponseModel responseModel = await subscriptionRepo.downloadInvoiceRepo(invoiceId, downloadPath);

      if (responseModel.isSuccess) {
        CustomSnackBar.success(successList: [responseModel.message]);
        await MyUtils().openFile(downloadPath, 'pdf');
      } else {
        CustomSnackBar.error(errorList: [responseModel.message]);
      }
    } catch (e) {
      printE(e);
      CustomSnackBar.error(errorList: [MyStrings.errorDownloadingFile]);
    } finally {
      downloadingInvoice = false;
      downloadingInvoiceId = '';
      update();
    }
  }
}
