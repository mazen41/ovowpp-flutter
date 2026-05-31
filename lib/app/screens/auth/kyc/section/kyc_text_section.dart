import 'package:flutter/material.dart';
import 'package:ovowpp/core/utils/dimensions.dart';
import 'package:ovowpp/core/utils/my_strings.dart';
import 'package:ovowpp/core/utils/util.dart';
import 'package:ovowpp/data/model/kyc/kyc_response_model.dart' as kyc;
import 'package:ovowpp/app/components/text-field/custom_text_field.dart';
import 'package:get/get.dart';

class KycTextAnEmailSection extends StatelessWidget {
  final kyc.KycFormModel model;
  final Function onChanged;

  const KycTextAnEmailSection({super.key, required this.onChanged, required this.model});

  @override
  Widget build(BuildContext context) {
    bool isRequired = model.isRequired == 'optional' ? false : true;
    printX(isRequired);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextField(
          isRequired: model.isRequired == 'optional' ? false : true,
          instructions: model.instruction,
          hintText: '',
          needOutlineBorder: true,
          labelText: (model.name ?? '').tr.capitalize,
          textInputType: MyUtils.getInputTextFieldType(model.type ?? 'text'),
          validator: (value) {
            if (isRequired && value.toString().isEmpty) {
              return '${model.name.toString().capitalizeFirst} ${MyStrings.isRequired}';
            } else {
              return null;
            }
          },
          onChanged: (value) => onChanged(value),
          maxLines: model.type == "textarea" ? 5 : 1,
        ),
        const SizedBox(height: Dimensions.space10),
      ],
    );
  }
}
