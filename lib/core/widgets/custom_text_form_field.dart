import 'package:flutter/material.dart';
import 'package:yallabina/core/app_responsive.dart';

import '../../core/theming/text_styles.dart';
import '../constant/colors.dart';

class CustomTextFormField extends StatelessWidget {
  bool? obscureText = false;
  TextInputType? keyboardType;
  String? hintText;
  String? labelText;
  Widget? suffixIcon;
  Widget? prefixIcon;
  Color? fillColor;
  Color? labelColor;
  EdgeInsetsGeometry? contentPadding;
  TextEditingController? controller;
  String? Function(String?)? validator;
  String? Function(String?)? onChanged;
  int? maxLength;
  TextAlign? textAlign;
  FocusNode? focusNode;
  InputBorder? border;
  String? counterText;
  Color? focusBorder;
  final Function(String)? onSubmittedCallback;
  TextStyle? errorStyle;
  int? maxLines;
  int? minLines;
  String? initialValue;
  TextStyle? hintStyle;
  Color? enableBorderColor;
  TextDirection? textDirection;

  CustomTextFormField({
    super.key,
    this.enableBorderColor,
    this.hintStyle,
    this.initialValue,
    this.errorStyle,
    this.obscureText,
    this.keyboardType,
    this.hintText,
    this.labelText,
    this.suffixIcon,
    this.prefixIcon,
    this.fillColor,
    this.contentPadding,
    this.controller,
    this.validator,
    this.onChanged,
    this.maxLength,
    this.textAlign,
    this.focusNode,
    this.border,
    this.counterText,
    this.focusBorder,
    this.labelColor,
    this.onSubmittedCallback,
    this.maxLines,
    this.minLines,
    this.textDirection
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Theme(
      data: themeData.copyWith(
        inputDecorationTheme: themeData.inputDecorationTheme.copyWith(
          prefixIconColor: WidgetStateColor.resolveWith((
            Set<WidgetState> states,
          ) {
            if (states.contains(WidgetState.focused)) {
              return AppColors.darkestHeading;
            }
            if (states.contains(WidgetState.error)) {
              return AppColors.red;
            }
            return AppColors.shade_8;
          }),
        ),
      ),
      child: TextFormField(
        initialValue: initialValue,
        textAlignVertical: TextAlignVertical.top,
        focusNode: focusNode,
        textAlign: textAlign ?? TextAlign.start,
        maxLength: maxLength,
        validator: validator,
        controller: controller,
        obscureText: obscureText ?? false,
        keyboardType: keyboardType,
        onChanged: onChanged,
        maxLines: maxLines ?? 1,
        minLines: minLines ?? 1,
        style: TextStyles.font14Shade95Normal.copyWith(
          color: labelColor ?? AppColors.shade_95,
          fontSize: 14.s(), // Responsive font size
        ),
        textInputAction: TextInputAction.done,
        onFieldSubmitted: onSubmittedCallback,
        decoration: InputDecoration(
          hintText: hintText,
          hintTextDirection: TextDirection.rtl,
          hintStyle:
              hintStyle ??
                   TextStyles.font14GrayNormal,

          counterText: counterText,
          labelText: labelText,
          filled: true,
          fillColor: fillColor ?? AppColors.background,
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          labelStyle: TextStyles.font14GrayNormal,

          contentPadding:
              contentPadding ??
              EdgeInsets.symmetric(
                horizontal: 15.w(), // Responsive padding
                vertical: 10.h(), // Responsive padding
              ),
          suffixIcon: suffixIcon,
          prefixIcon: prefixIcon,
          errorStyle:
              errorStyle ??
              TextStyles.font10RedNormal.copyWith(
                fontSize: 12.s(), // Responsive error font size
              ),
          border: border,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.s()), // Responsive radius
            borderSide: BorderSide(
              color: enableBorderColor ?? AppColors.darkestHeading,
              width: 1.s(), // Responsive border width
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.s()), // Responsive radius
            borderSide: BorderSide(
              color: focusBorder ?? AppColors.primary,
              width: 1.s(), // Responsive border width
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.s()), // Responsive radius
            borderSide: BorderSide(
              color: AppColors.red,
              width: 1.s(), // Responsive border width
            ),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.s()), // Responsive radius
            borderSide: BorderSide(
              color: AppColors.darkestHeading,
              width: 1.s(), // Responsive border width
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.s()), // Responsive radius
            borderSide: BorderSide(
              color: AppColors.red,
              width: 1.s(), // Responsive border width
            ),
          ),
        ),
      ),
    );
  }
}
