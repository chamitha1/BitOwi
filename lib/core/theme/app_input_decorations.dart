import 'package:BitOwi/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

class AppInputDecorations {
  static InputDecoration textField({
    String? hintText,
    bool enabled = true,
    // Widget? suffixIcon,
    // Widget? prefixIcon,
    // String? suffixText,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: hintText == null
          ? null
          : AppTextStyles.p2Regular.copyWith(color: const Color(0xFF717F9A)),
      filled: true,
      fillColor: enabled ? Colors.white : const Color(0xFFECEFF5),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: _border(enabled),
      enabledBorder: _border(enabled),
      disabledBorder: _border(false),
      focusedBorder: _focusedBorder(),
    );
  }

  static OutlineInputBorder _border(bool enabled) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(
        color: enabled
            ? const Color(0xFFE2E8F0)
            : const Color(0xFFDAE0EE), // disabled border
      ),
    );
  }

  static OutlineInputBorder _focusedBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFF929EB8)),
    );
  }
}
