import 'package:flutter/material.dart';
import 'package:ovowpp/app/components/card/my_custom_scaffold.dart';
import 'package:ovowpp/core/utils/my_color.dart';
import 'package:ovowpp/core/utils/util.dart';
import 'package:ovowpp/app/components/buttons/custom_elevated_button.dart';
import 'package:ovowpp/app/screens/auth/kyc/section/kyc_checkbox_section.dart';
import 'package:ovowpp/app/screens/auth/kyc/section/kyc_date_time_section.dart';
import 'package:ovowpp/app/screens/auth/kyc/section/kyc_radio_section.dart';
import 'package:ovowpp/app/screens/auth/kyc/section/kyc_select_section.dart';
import 'package:ovowpp/app/screens/auth/kyc/section/kyc_text_section.dart';
import 'package:get/get.dart';
import 'package:ovowpp/core/utils/dimensions.dart';
import 'package:ovowpp/core/utils/my_strings.dart';
import 'package:ovowpp/data/controller/kyc_controller/kyc_controller.dart';
import 'package:ovowpp/data/model/kyc/kyc_response_model.dart' as kyc;
import 'package:ovowpp/data/repo/kyc/kyc_repo.dart';
import 'package:ovowpp/app/components/custom_loader/custom_loader.dart';
import 'package:ovowpp/app/components/custom_no_data_found_class.dart';
import 'package:ovowpp/app/screens/auth/kyc/widget/already_verifed.dart';
import 'package:ovowpp/app/screens/auth/kyc/widget/widget/file_item.dart';
import '../../../components/text/label_text_with_instructions.dart';

class KycScreen extends StatefulWidget {
  const KycScreen({super.key});

  @override
  State<KycScreen> createState() => _KycScreenState();
}

class _KycScreenState extends State<KycScreen> {
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    Get.put(KycRepo());
    Get.put(KycController(repo: Get.find()));
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<KycController>().beforeInitLoadKycData();
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return GetBuilder<KycController>(
      builder: (controller) => GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: MyCustomScaffold(
          pageTitle: MyStrings.kycVerification.tr,
          body: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: controller.isLoading
                ? const Padding(padding: EdgeInsets.all(Dimensions.space15), child: CustomLoader())
                : controller.isAlreadyVerified
                ? const AlreadyVerifiedWidget()
                : controller.isAlreadyPending
                ? const AlreadyVerifiedWidget(isPending: true)
                : controller.isNoDataFound
                ? const NoDataOrInternetScreen()
                : SingleChildScrollView(
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            itemCount: controller.formList.length,
                            itemBuilder: (ctx, index) {
                              kyc.KycFormModel? model = controller.formList[index];
                              return Padding(
                                padding: const EdgeInsets.all(3),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (MyUtils.getTextInputType(model.type ?? 'text')) ...[
                                      KycTextAnEmailSection(
                                        onChanged: (value) {
                                          controller.changeSelectedValue(value, index);
                                        },
                                        model: model,
                                      ),
                                    ] else if (model.type == "select") ...[
                                      KycSelectSection(
                                        onChanged: (value) {
                                          controller.changeSelectedValue(value, index);
                                        },
                                        model: model,
                                      ),
                                    ] else if (model.type == 'radio') ...[
                                      KycRadioSection(
                                        model: model,
                                        onChanged: (selectedIndex) {
                                          controller.changeSelectedRadioBtnValue(index, selectedIndex);
                                        },
                                        selectedIndex:
                                            controller.formList[index].options?.indexOf(model.selectedValue ?? '') ?? 0,
                                      ),
                                    ] else if (model.type == "checkbox") ...[
                                      KycCheckBoxSection(
                                        model: model,
                                        onChanged: (value) {
                                          controller.changeSelectedCheckBoxValue(index, value);
                                        },
                                        selectedValue: controller.formList[index].cbSelected,
                                      ),
                                    ] else if (model.type == "datetime" ||
                                        model.type == "date" ||
                                        model.type == "time") ...[
                                      KycDateTimeSection(
                                        model: model,
                                        onChanged: (value) {
                                          controller.changeSelectedValue(value, index);
                                        },
                                        onTap: () {
                                          if (model.type == "time") {
                                            controller.changeSelectedTimeOnlyValue(index, context);
                                          } else if (model.type == "date") {
                                            controller.changeSelectedDateOnlyValue(index, context);
                                          } else {
                                            controller.changeSelectedDateTimeValue(index, context);
                                          }
                                        },
                                        controller: controller.formList[index].textEditingController!,
                                      ),
                                    ],
                                    if (model.type == "file") ...[
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          LabelTextInstruction(
                                            text: model.name ?? '',
                                            isRequired: model.isRequired == 'optional' ? false : true,
                                            instructions: model.instruction,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(vertical: Dimensions.textToTextSpace),
                                            child: ConfirmKycFileItem(index: index),
                                          ),
                                          const SizedBox(height: Dimensions.space2),
                                          Row(
                                            children: [
                                              Text(
                                                MyStrings.supportedFileType,
                                                style: theme.textTheme.bodySmall?.copyWith(
                                                  color: MyColor.getBodyTextColor(),
                                                ),
                                              ),
                                              Text(
                                                ' ${model.extensions}',
                                                style: theme.textTheme.bodySmall?.copyWith(
                                                  color: MyColor.getBodyTextColor(),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: Dimensions.space10),
                                        ],
                                      ),
                                    ],
                                  ],
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: Dimensions.space25),
                          Center(
                            child: CustomElevatedBtn(
                              isLoading: controller.submitLoading,
                              onTap: () {
                                if (formKey.currentState!.validate()) {
                                  controller.submitKycData();
                                } else {}
                              },
                              text: MyStrings.submit,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
