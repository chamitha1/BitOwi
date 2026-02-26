import 'package:flutter/foundation.dart';

class AppLogger {
  // Debug
  static void d(String message) {
    if (!kReleaseMode) {
      debugPrint(message);
    }
  }

 // Error log
  static void e(
    Object error, {
    StackTrace? stackTrace,
  }) {
    if (!kReleaseMode) {
      debugPrint('[ERROR] $error');

      if (stackTrace != null) {
        debugPrint(' StackTrace:\n$stackTrace');
      }
    }
  }
}
