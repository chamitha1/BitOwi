import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomSnackbar {
  static void showSuccess({required String title, required String message}) {
    Get.snackbar(
      title,
      message,
      backgroundColor: const Color(0xFFEAF9F0),
      borderColor: const Color(0xFFABEAC6),
      borderWidth: 1,
      colorText: const Color(0xFF40A372),
      titleText: Text(
        title,
        style: const TextStyle(
          color: Color(0xFF40A372),
          fontFamily: 'Inter',
          fontWeight: FontWeight.w500,
          fontSize: 18,
        ),
      ),
      messageText: Text(
        message,
        style: const TextStyle(
          color: Color(0xFF40A372),
          fontFamily: 'Inter',
          fontWeight: FontWeight.w400,
          fontSize: 14,
        ),
      ),
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );
  }

  static void showError({required String title, required String message}) {
    Get.snackbar(
      title,
      message,
      backgroundColor: const Color(0xFFFDF4F5),
      borderColor: const Color(0xFFF5B7B1),
      borderWidth: 1,
      colorText: const Color(0xFFCF4436),
      titleText: Text(
        title,
        style: const TextStyle(
          color: Color(0xFFCF4436),
          fontFamily: 'Inter',
          fontWeight: FontWeight.w500,
          fontSize: 18,
        ),
      ),
      messageText: Text(
        message,
        style: const TextStyle(
          color: Color(0xFFCF4436),
          fontFamily: 'Inter',
          fontWeight: FontWeight.w400,
          fontSize: 14,
        ),
      ),
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );
  }

  static void showWarning({required String title, required String message}) {
    Get.snackbar(
      title,
      message,
      backgroundColor: const Color(0xFFFFFBF6),
      borderColor: const Color(0xFFFFE2C1),
      borderWidth: 1,
      colorText: const Color(0xFFC9710D),
      titleText: Text(
        title,
        style: const TextStyle(
          color: Color(0xFFC9710D),
          fontFamily: 'Inter',
          fontWeight: FontWeight.w500,
          fontSize: 18,
        ),
      ),
      messageText: Text(
        message,
        style: const TextStyle(
          color: Color(0xFFC9710D),
          fontFamily: 'Inter',
          fontWeight: FontWeight.w400,
          fontSize: 14,
        ),
      ),
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );
  }

  static void showSimpleValidation({required String message}) {
    Get.rawSnackbar(
      messageText: Text(
        message,
        style: const TextStyle(
          color: Color(0xFFC9710D),
          fontFamily: 'Inter',
          fontWeight: FontWeight.w400,
          fontSize: 13,
        ),
      ),
      backgroundColor: const Color(0xFFFFFBF6),
      borderColor: const Color(0xFFFFE2C1),
      borderWidth: 1,
      borderRadius: 10,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 2),
      isDismissible: true,
    );
  }
}
