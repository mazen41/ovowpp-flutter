import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ovowpp/core/utils/my_strings.dart';
import 'package:ovowpp/app/screens/auth/kyc/widget/widget/choose_file_list_item.dart';

import '../../../../../data/controller/withdraw/withdraw_confirm_controller.dart';
import '../../../../../data/model/withdraw/withdraw_request_response_model.dart';

class ConfirmWithdrawFileItem extends StatefulWidget {
  final int index;

  const ConfirmWithdrawFileItem({super.key, required this.index});

  @override
  State<ConfirmWithdrawFileItem> createState() => _ConfirmWithdrawFileItemState();
}

class _ConfirmWithdrawFileItemState extends State<ConfirmWithdrawFileItem> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<WithdrawConfirmController>(
      builder: (controller) {
        FormModel? model = controller.formList[widget.index];
        return InkWell(
          onTap: () {
            controller.pickFile(widget.index);
          },
          child: ChooseFileItem(fileName: model.selectedValue ?? MyStrings.chooseFile),
        );
      },
    );
  }
}
