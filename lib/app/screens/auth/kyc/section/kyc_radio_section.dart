import 'package:flutter/material.dart';
import 'package:ovowpp/core/utils/dimensions.dart';
import 'package:ovowpp/data/model/kyc/kyc_response_model.dart' as kyc;
import 'package:ovowpp/app/components/custom_radio_button.dart';
import 'package:ovowpp/app/components/text/label_text_with_instructions.dart';
import 'package:get/get.dart';

class KycRadioSection extends StatelessWidget {
  final kyc.KycFormModel model;
  final Function onChanged;
  final int selectedIndex;
  const KycRadioSection({super.key, required this.model, required this.onChanged, required this.selectedIndex});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LabelTextInstruction(
          text: (model.name ?? '').tr.capitalize!,
          isRequired: model.isRequired == 'optional' ? false : true,
          instructions: model.instruction,
        ),
        CustomRadioButton(
          title: model.name,
          selectedIndex: selectedIndex,
          list: model.options ?? [],
          onChanged: (index) => onChanged(index),
        ),
        const SizedBox(height: Dimensions.space10),
      ],
    );
  }
}
