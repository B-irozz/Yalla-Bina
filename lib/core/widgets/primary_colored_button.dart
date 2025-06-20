
import 'package:flutter/material.dart';
import 'package:yallabina/core/app_responsive.dart';

import '../constant/colors.dart';
import '../theming/text_styles.dart';


class PrimaryColoredButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback? onPressed;
  final double? height;
  final double? width;
  final bool isOutlined;
  final Color? color;
  final Color? fontColor;
  final double? fontSize;

  const PrimaryColoredButton({
    super.key,
    required this.buttonText,
    required this.onPressed,
    this.height,
    this.width,
    this.isOutlined = false, this.color, this.fontSize, this.fontColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width ?? double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isOutlined ? Colors.white : color ??AppColors.primary,
          side: isOutlined ? const BorderSide(color: AppColors.darkestHeading, width: 1) : null,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.s()),
          ),
        ),
        child: Padding(
          padding:  EdgeInsets.symmetric(vertical: 2.s()),
          child: Text(
            buttonText,
            style: TextStyles.font16WhiteBold.copyWith(
              fontSize: fontSize ?? 16.s(),
              color: isOutlined ? AppColors.darkestHeading : Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
