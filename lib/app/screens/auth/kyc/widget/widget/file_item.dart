import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ovowpp/core/utils/my_strings.dart';
import 'package:ovowpp/data/controller/kyc_controller/kyc_controller.dart';
import 'package:ovowpp/data/model/kyc/kyc_response_model.dart';
import 'package:ovowpp/app/screens/auth/kyc/widget/widget/choose_file_list_item.dart';

class ConfirmKycFileItem extends StatefulWidget {
  final int index;

  const ConfirmKycFileItem({super.key, required this.index});

  @override
  State<ConfirmKycFileItem> createState() => _ConfirmKycFileItemState();
}

class _ConfirmKycFileItemState extends State<ConfirmKycFileItem> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<KycController>(
      builder: (controller) {
        KycFormModel? model = controller.formList[widget.index];
        return InkWell(
          onTap: () {
            controller.pickFile(widget.index, extention: model.extensions?.split(','));
          },
          child: ChooseFileItem(fileName: model.selectedValue ?? MyStrings.chooseFile),
        );
      },
    );
  }
}
