import 'package:flutter/foundation.dart';

class AppLogger {
  // Debug
  static void d(String message) {
    if (!kReleaseMode) {
      debugPrint(message);
    }
  }

  static void e(Object message) {
    if (!kReleaseMode) {
      debugPrint('[ERROR] ${message.toString()}');
    }
  }
}
