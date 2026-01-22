import 'package:flutter/material.dart';
import '../theme/app_text_styles.dart';

class AppText extends StatelessWidget {
  final String text;
  final TextStyle style;
  final Color? color;
  final TextAlign? align;
  final int? maxLines;
  final TextOverflow? overflow;

  const AppText(
    this.text, {
    super.key,
    required this.style,
    this.color,
    this.align,
    this.maxLines,
    this.overflow,
  });

  // ---- Named constructors (Figma friendly) ----

  // Paragraph / P1
  factory AppText.p1SemiBold(String text, {Color? color}) {
    return AppText(text, style: AppTextStyles.p1SemiBold, color: color);
  }

  factory AppText.p1Medium(String text, {Color? color}) {
    return AppText(text, style: AppTextStyles.p1Medium, color: color);
  }

  // Paragraph / P2
  factory AppText.p2Bold(String text, {Color? color}) {
    return AppText(text, style: AppTextStyles.p2Bold, color: color);
  }

  factory AppText.p2SemiBold(String text, {Color? color}) {
    return AppText(text, style: AppTextStyles.p2SemiBold, color: color);
  }

  factory AppText.p2Medium(String text, {Color? color}) {
    return AppText(text, style: AppTextStyles.p2Medium, color: color);
  }

  factory AppText.p2Regular(String text, {Color? color}) {
    return AppText(text, style: AppTextStyles.p2Regular, color: color);
  }

  // Paragraph / P3
  factory AppText.p3SemiBold(String text, {Color? color}) {
    return AppText(text, style: AppTextStyles.p3SemiBold, color: color);
  }

  factory AppText.p3Regular(String text, {Color? color}) {
    return AppText(text, style: AppTextStyles.p3Regular, color: color);
  }

  factory AppText.p3Medium(String text, {Color? color}) {
    return AppText(text, style: AppTextStyles.p3Medium, color: color);
  }

  // Paragraph / P4
  factory AppText.p4SemiBold(String text, {Color? color}) {
    return AppText(text, style: AppTextStyles.p4SemiBold, color: color);
  }

  factory AppText.p4Medium(String text, {Color? color}) {
    return AppText(text, style: AppTextStyles.p4Medium, color: color);
  }

  factory AppText.p4Regular(String text, {Color? color}) {
    return AppText(text, style: AppTextStyles.p4Regular, color: color);
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: color != null ? style.copyWith(color: color) : style,
      textAlign: align,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}
