import 'package:flutter/material.dart';
import 'package:ovowpp/core/utils/dimensions.dart';
import 'package:ovowpp/data/model/kyc/kyc_response_model.dart' as kyc;
import 'package:ovowpp/app/components/custom_drop_down_button_with_text_field.dart';
import 'package:ovowpp/app/components/text/label_text_with_instructions.dart';
import 'package:get/get.dart';

class KycSelectSection extends StatefulWidget {
  final kyc.KycFormModel model;
  final Function onChanged;
  const KycSelectSection({super.key, required this.model, required this.onChanged});

  @override
  State<KycSelectSection> createState() => _KycSelectSectionState();
}

class _KycSelectSectionState extends State<KycSelectSection> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LabelTextInstruction(
          text: (widget.model.name ?? '').tr.capitalize!,
          isRequired: widget.model.isRequired == 'optional' ? false : true,
          instructions: widget.model.instruction,
        ),
        const SizedBox(height: Dimensions.textToTextSpace),
        CustomDropDownWithTextField(
          borderWidth: .5,
          list: widget.model.options ?? [],
          onChanged: (value) => widget.onChanged(value),
          selectedValue: widget.model.selectedValue,
        ),
        const SizedBox(height: Dimensions.space10),
      ],
    );
  }
}
