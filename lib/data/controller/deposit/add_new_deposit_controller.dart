import 'package:flutter/material.dart';
import 'package:ovowpp/app/components/snack_bar/show_custom_snackbar.dart';
import 'package:ovowpp/core/helper/string_format_helper.dart';
import 'package:ovowpp/core/utils/url_container.dart';
import 'package:get/get.dart';
import 'package:ovowpp/data/services/shared_pref_service.dart';

import '../../../core/route/route.dart';
import '../../../core/utils/my_strings.dart';
import '../../model/deposit/deposit_insert_response_model.dart';
import '../../model/deposit/deposit_method_response_model.dart';
import '../../model/global/response_model/response_model.dart';
import '../../repo/deposit/deposit_repo.dart';

class AddNewDepositController extends GetxController {
  DepositRepo depositRepo;
  AddNewDepositController({required this.depositRepo});
  final TextEditingController selectedPaymentMethodController = TextEditingController();
  bool isLoading = true;

  String selectedValue = "";
  String depositLimit = "";
  String charge = "";
  String payable = "";
  String amount = "";
  String fixedCharge = "";
  String currency = '';
  String payableText = '';
  String conversionRate = '';
  String inLocal = '';

  List<Methods> methodList = [];
  List<Methods> methods = [];
  String imagePath = UrlContainer.domainUrl;
  Methods? paymentMethod = Methods(name: MyStrings.selectOne, id: -1);

  TextEditingController amountController = TextEditingController();

  double rate = 1;
  double mainAmount = 0;
  bool isSubscriptionDeposit = false;
  String subscriptionPlanId = '';
  String subscriptionPlanName = '';
  String subscriptionPlanDescription = '';
  String subscriptionRecurring = 'monthly';
  String subscriptionCouponCode = '';

  void configureFromArguments(dynamic args) {
    isSubscriptionDeposit = false;
    subscriptionPlanId = '';
    subscriptionPlanName = '';
    subscriptionPlanDescription = '';
    subscriptionRecurring = 'monthly';
    subscriptionCouponCode = '';
    amountController.clear();
    selectedPaymentMethodController.clear();
    paymentMethod = Methods(name: MyStrings.selectOne, id: -1);
    depositLimit = '';
    charge = '';
    payableText = '';
    conversionRate = '';
    inLocal = '';
    mainAmount = 0;

    if (args is Map &&
        args['source'] == 'subscription_plan_purchase' &&
        (args['plan_id']?.toString() ?? '').isNotEmpty &&
        (args['plan_recurring']?.toString() ?? '').isNotEmpty) {
      isSubscriptionDeposit = true;
      subscriptionPlanId = args['plan_id']?.toString() ?? '';
      subscriptionPlanName = args['plan_name']?.toString() ?? '';
      subscriptionPlanDescription = args['plan_description']?.toString() ?? '';
      subscriptionRecurring = args['plan_recurring']?.toString() ?? '1';
      subscriptionCouponCode = args['coupon_code']?.toString() ?? '';
      amountController.text = AppConverter.formatNumber(args['amount']?.toString() ?? '0', precision: 2);
    }
  }

  void setPaymentMethod(Methods? method) {
    String amt = amountController.text.toString();
    mainAmount = amt.isEmpty ? 0 : double.tryParse(amt) ?? 0;
    paymentMethod = method;

    depositLimit =
        '${AppConverter.formatNumber(method?.minAmount?.toString() ?? '-1')} - ${AppConverter.formatNumber(method?.maxAmount?.toString() ?? '-1')} $currency';
    changeInfoWidgetValue(mainAmount);
    update();
  }

  Future<void> getDepositMethod() async {
    methodList.clear();
    methodList.add(paymentMethod!);
    currency = SharedPreferenceService.getCurrencyText();
    selectedPaymentMethodController.text = paymentMethod?.name ?? '';
    ResponseModel responseModel = await depositRepo.getDepositMethods();

    if (responseModel.statusCode == 200) {
      DepositMethodResponseModel methodsModel = DepositMethodResponseModel.fromJson(responseModel.responseJson);

      if (methodsModel.message != null && methodsModel.message != null) {
        List<Methods>? tempList = methodsModel.data?.methods;
        if (tempList != null && tempList.isNotEmpty) {
          methodList.addAll(tempList);
        }
      }
      imagePath = '${UrlContainer.domainUrl}/${methodsModel.data?.imagePath}';
    } else {
      CustomSnackBar.error(errorList: [responseModel.message]);
      return;
    }

    isLoading = false;
    update();
  }

  bool submitLoading = false;
  Future<void> submitDeposit() async {
    if (paymentMethod?.id.toString() == '-1') {
      CustomSnackBar.error(errorList: [MyStrings.selectPaymentMethod]);
      return;
    }

    String amount = amountController.text.toString();
    if (amount.isEmpty) {
      CustomSnackBar.error(errorList: [MyStrings.enterAmount]);
      return;
    }

    submitLoading = true;
    update();

    final Map<String, String> extraData = {};
    if (isSubscriptionDeposit && subscriptionPlanId.isNotEmpty) {
      extraData['plan_id'] = subscriptionPlanId;
      extraData['plan_recurring'] = subscriptionRecurring;
      extraData['plan_recurring_type'] = subscriptionRecurring;
      if (subscriptionCouponCode.isNotEmpty) {
        extraData['coupon_code'] = subscriptionCouponCode;
      }
    }

    ResponseModel responseModel = await depositRepo.insertDeposit(
      amount: amount,
      methodCode: paymentMethod?.methodCode ?? "",
      currency: paymentMethod?.currency ?? "",
      extraData: extraData.isEmpty ? null : extraData,
    );

    if (responseModel.statusCode == 200) {
      DepositInsertResponseModel insertResponseModel = DepositInsertResponseModel.fromJson(responseModel.responseJson);

      if (insertResponseModel.status.toString().toLowerCase() == "success") {
        showWebView(insertResponseModel.data?.redirectUrl ?? "");
      } else {
        CustomSnackBar.error(errorList: insertResponseModel.message ?? [MyStrings.somethingWentWrong]);
      }
    } else {
      CustomSnackBar.error(errorList: [responseModel.message]);
    }

    submitLoading = false;
    update();
  }

  void changeInfoWidgetValue(double amount) {
    if (paymentMethod?.id.toString() == '-1') {
      return;
    }

    mainAmount = amount;
    double percent = double.tryParse(paymentMethod?.percentCharge ?? '0') ?? 0;
    double percentCharge = (amount * percent) / 100;
    double temCharge = double.tryParse(paymentMethod?.fixedCharge ?? '0') ?? 0;
    double totalCharge = percentCharge + temCharge;
    charge = '${AppConverter.formatNumber('$totalCharge')} $currency';
    double payable = totalCharge + amount;
    payableText = '${AppConverter.formatNumber('$payable')} $currency';

    rate = double.tryParse(paymentMethod?.rate ?? '0') ?? 0;
    conversionRate = '1 $currency = $rate ${paymentMethod?.currency ?? ''}';
    inLocal = AppConverter.formatNumber('${payable * rate}');

    update();
    return;
  }

  void clearData() {
    depositLimit = '';
    charge = '';
    amountController.text = '';
    isLoading = false;
    methodList.clear();
    selectedPaymentMethodController.clear();
    paymentMethod = Methods(name: MyStrings.selectOne, id: -1);
    isSubscriptionDeposit = false;
    subscriptionPlanId = '';
    subscriptionPlanName = '';
    subscriptionPlanDescription = '';
    subscriptionRecurring = 'monthly';
    subscriptionCouponCode = '';
  }

  bool isShowRate() {
    if (rate > 1 && currency.toLowerCase() != paymentMethod?.currency?.toLowerCase()) {
      return true;
    } else {
      return false;
    }
  }

  void showWebView(String redirectUrl) {
    Get.offAndToNamed(RouteHelper.depositWebViewScreen, arguments: redirectUrl);
  }

  String get recurringLabel => subscriptionRecurring == '2' ? MyStrings.yearly : MyStrings.monthly;
}
