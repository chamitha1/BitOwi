import 'package:flutter/material.dart';

class AppInputDecorations {
  static InputDecoration textField({
    String? hintText,
    Widget? suffixIcon,
    Widget? prefixIcon,
    String? suffixText,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: hintText == null
          ? null
          : const TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
              fontSize: 14,
              color: Color(0xFF717F9A),
            ),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: _border(),
      enabledBorder: _border(),
      focusedBorder: _focusedBorder(),
      suffixIcon: suffixIcon,
      prefixIcon: prefixIcon,
      suffixText: suffixText,
    );
  }

  static OutlineInputBorder _border() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
    );
  }

  static OutlineInputBorder _focusedBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFF929EB8)),
    );
  }
}
