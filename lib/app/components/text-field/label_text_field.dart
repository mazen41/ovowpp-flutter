// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:ovowpp/app/components/text/label_text.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../core/utils/text_style.dart';
import '../../../core/utils/util_exporter.dart';
import 'field_shadow.dart';

class LabelTextField extends StatefulWidget {
  final bool needOutline;
  final String? labelText;
  final String? hintText;
  final Function? onChanged;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final FocusNode? nextFocus;
  final FormFieldValidator? validator;
  final TextInputType? textInputType;
  final bool isEnable;
  final bool isPassword;
  final TextInputAction inputAction;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final bool readOnly;
  final int maxLines;
  final bool isRequired;
  final bool isAttachment;
  final bool hideLabel;
  final double radius;
  final double suffixPadding;
  final EdgeInsetsGeometry contentPadding;
  final Color fillColor;
  final Color labelTextColor;
  final Color hintTextColor;
  final TextStyle? labelTextStyle;
  final TextStyle? hintStyle;
  final TextStyle? inputTextStyle;
  final VoidCallback? onTap;
  final bool isShadow;
  final BoxShadow? boxShadow;

  const LabelTextField({
    super.key,
    this.needOutline = true,
    this.labelText,
    this.readOnly = false,
    required this.onChanged,
    this.hintText,
    this.controller,
    this.focusNode,
    this.nextFocus,
    this.validator,
    this.textInputType,
    this.isEnable = true,
    this.isPassword = false,
    this.isAttachment = false,
    this.inputAction = TextInputAction.next,
    this.maxLines = 1,
    this.isRequired = false,
    this.hideLabel = false,
    this.radius = Dimensions.cardMargin,
    this.suffixPadding = Dimensions.space12,
    this.suffixIcon,
    this.prefixIcon,
    this.contentPadding = const EdgeInsets.only(top: 5, left: 15, right: 15, bottom: 5),
    this.fillColor = MyColor.white,
    this.hintTextColor = MyColor.lightBodyText,
    this.labelTextColor = MyColor.lightBodyText,
    this.labelTextStyle,
    this.inputTextStyle,
    this.onTap,
    this.hintStyle,
    this.isShadow = false,
    this.boxShadow = fieldShadow,
  });

  @override
  State<LabelTextField> createState() => _LabelTextFieldState();
}

class _LabelTextFieldState extends State<LabelTextField> {
  bool obscureText = true;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return widget.needOutline
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.hideLabel != true) ...[
                LabelText(
                  text: widget.labelText.toString(),
                  isRequired: widget.isRequired,
                  textStyle: MyTextStyle.subHeading15W500FieldTitleColor,
                ),
                const SizedBox(height: Dimensions.textToTextSpace),
              ],

              IntrinsicHeight(
                child: Container(
                  // height: 40.h,
                  decoration: BoxDecoration(
                    boxShadow: widget.isShadow == true ? [widget.boxShadow!] : null,
                    borderRadius: BorderRadius.circular(widget.radius),
                  ),
                  child: TextFormField(
                    maxLines: widget.maxLines,
                    readOnly: widget.readOnly,
                    style:
                        widget.inputTextStyle ??
                        MyTextStyle.subHeading14W400().copyWith(color: MyColor.getBodyTextColor()),
                    cursorColor: MyColor.getBodyTextColor(),
                    controller: widget.controller,
                    autofocus: false,
                    textInputAction: widget.inputAction,
                    enabled: widget.isEnable,
                    focusNode: widget.focusNode,
                    validator: widget.validator,
                    keyboardType: widget.textInputType,
                    obscureText: widget.isPassword ? obscureText : false,
                    decoration: InputDecoration(
                      contentPadding: widget.contentPadding,
                      hintText: widget.hintText?.tr ?? '',
                      hintStyle:
                          widget.hintStyle ??
                          MyTextStyle.subHeading15W500FieldTitleColor.copyWith(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                          ),
                      fillColor: widget.readOnly == true || widget.isEnable == false
                          ? MyColor.searchItemBgColor
                          : widget.fillColor,
                      filled: true,
                      border: OutlineInputBorder(
                        borderSide: BorderSide(width: 1, color: MyColor.socialContainerBorder),
                        borderRadius: BorderRadius.circular(widget.radius),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 1, color: MyColor.socialContainerBorder),
                        borderRadius: BorderRadius.circular(widget.radius),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 1, color: MyColor.socialContainerBorder),
                        borderRadius: BorderRadius.circular(widget.radius),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 1, color: MyColor.socialContainerBorder),
                        borderRadius: BorderRadius.circular(widget.radius),
                      ),
                      prefixIcon: widget.prefixIcon,
                      suffixIcon: widget.isPassword
                          ? Material(
                              color: Colors.transparent,
                              shape: const CircleBorder(),
                              child: InkWell(
                                focusColor: MyColor.socialContainerBorder.withValues(alpha: 0.01),
                                autofocus: false,
                                canRequestFocus: false,
                                onTap: _toggle,
                                child: Container(
                                  padding: EdgeInsets.all(widget.suffixPadding.r),
                                  decoration: const BoxDecoration(shape: BoxShape.circle),
                                  height: 25,
                                  width: 25,
                                  child: SvgPicture.asset(
                                    obscureText ? MyImages.eyeInvisibleIcon : MyImages.eyeVisibleIcon,
                                    color: MyColor.fieldTitleTextColor.withAlpha(127),
                                    height: 24.h,
                                    width: 24.h,
                                  ),
                                ),
                              ),
                            )
                          : widget.suffixIcon,
                    ),
                    onFieldSubmitted: (text) =>
                        widget.nextFocus != null ? FocusScope.of(context).requestFocus(widget.nextFocus) : null,
                    onChanged: (text) => widget.onChanged!(text),
                    onTap: widget.onTap,
                  ),
                ),
              ),
            ],
          )
        : widget.isAttachment
        ? TextFormField(
            maxLines: widget.maxLines,
            readOnly: widget.readOnly,
            style: widget.inputTextStyle ?? theme.textTheme.labelMedium?.copyWith(color: MyColor.getBodyTextColor()),
            cursorColor: MyColor.getBodyTextColor(),
            controller: widget.controller,
            autofocus: false,
            textInputAction: widget.inputAction,
            enabled: widget.isEnable,
            focusNode: widget.focusNode,
            validator: widget.validator,
            keyboardType: widget.textInputType,
            obscureText: widget.isPassword ? obscureText : false,
            decoration: InputDecoration(
              contentPadding: widget.contentPadding,
              hintText: widget.hintText?.tr ?? '',
              hintStyle: theme.textTheme.labelMedium?.copyWith(color: widget.hintTextColor),
              fillColor: widget.fillColor.withValues(alpha: .80),
              filled: true,
              border: OutlineInputBorder(
                borderSide: BorderSide(width: 1, color: MyColor.socialContainerBorder),
                borderRadius: BorderRadius.circular(widget.radius),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 1, color: MyColor.socialContainerBorder),
                borderRadius: BorderRadius.circular(widget.radius),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 1, color: MyColor.socialContainerBorder),
                borderRadius: BorderRadius.circular(widget.radius),
              ),
              prefixIcon: widget.prefixIcon,
              suffixIcon: widget.isPassword
                  ? UnconstrainedBox(
                      child: Material(
                        color: Colors.transparent,
                        shape: const CircleBorder(),
                        child: InkWell(
                          focusColor: MyColor.socialContainerBorder.withValues(alpha: 0.01),
                          autofocus: false,
                          canRequestFocus: false,
                          onTap: _toggle,
                          child: Container(
                            padding: const EdgeInsets.all(Dimensions.space5),
                            decoration: BoxDecoration(shape: BoxShape.circle, color: MyColor.getPrimaryColor()),
                            height: 25,
                            width: 25,
                          ),
                        ),
                      ),
                    )
                  : widget.suffixIcon,
            ),
            onFieldSubmitted: (text) =>
                widget.nextFocus != null ? FocusScope.of(context).requestFocus(widget.nextFocus) : null,
            onChanged: (text) => widget.onChanged!(text),
            onTap: widget.onTap,
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.hideLabel != true) ...[
                LabelText(
                  text: widget.labelText.toString(),
                  isRequired: widget.isRequired,
                  textStyle: widget.labelTextStyle ?? MyTextStyle.subHeading15W500FieldTitleColor,
                ),
                const SizedBox(height: Dimensions.textToTextSpace),
              ],
              TextFormField(
                maxLines: widget.maxLines,
                readOnly: widget.readOnly,
                style:
                    widget.inputTextStyle ?? theme.textTheme.labelMedium?.copyWith(color: MyColor.getBodyTextColor()),
                cursorColor: MyColor.getBodyTextColor(),
                controller: widget.controller,
                autofocus: false,
                textInputAction: widget.inputAction,
                enabled: widget.isEnable,
                focusNode: widget.focusNode,
                validator: widget.validator,
                keyboardType: widget.textInputType,
                obscureText: widget.isPassword ? obscureText : false,
                decoration: InputDecoration(
                  contentPadding: widget.contentPadding,
                  hintText: widget.hintText?.tr ?? '',
                  hintStyle: theme.textTheme.labelMedium?.copyWith(color: widget.hintTextColor),
                  fillColor: widget.fillColor.withValues(alpha: .80),
                  filled: true,
                  border: UnderlineInputBorder(borderSide: BorderSide(width: 1, color: MyColor.socialContainerBorder)),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(width: 1, color: MyColor.socialContainerBorder),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(width: 1, color: MyColor.socialContainerBorder),
                  ),
                  prefixIcon: widget.prefixIcon,
                  suffixIcon: widget.isPassword
                      ? UnconstrainedBox(
                          child: Material(
                            color: Colors.transparent,
                            shape: const CircleBorder(),
                            child: InkWell(
                              splashColor: MyColor.getPrimaryColor().withValues(alpha: 0.1),
                              onTap: _toggle,
                              child: Container(
                                padding: const EdgeInsets.all(Dimensions.space5),
                                decoration: const BoxDecoration(shape: BoxShape.circle),
                                height: 25,
                                width: 25,
                                child: SvgPicture.asset(
                                  obscureText ? MyImages.eyeInvisibleIcon : MyImages.eyeVisibleIcon,
                                  color: MyColor.getBodyTextColor(),
                                  height: 18,
                                  width: 18,
                                ),
                              ),
                            ),
                          ),
                        )
                      : widget.suffixIcon,
                ),
                onFieldSubmitted: (text) =>
                    widget.nextFocus != null ? FocusScope.of(context).requestFocus(widget.nextFocus) : null,
                onChanged: (text) => widget.onChanged!(text),
                onTap: widget.onTap,
              ),
            ],
          );
  }

  void _toggle() {
    setState(() {
      obscureText = !obscureText;
    });
  }
}
