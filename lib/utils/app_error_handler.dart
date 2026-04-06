import 'package:dio/dio.dart';
import 'package:BitOwi/core/widgets/custom_snackbar.dart';
import 'package:BitOwi/utils/app_logger.dart';

class AppErrorHandler {
  static String getFriendlyMessage(dynamic error) {
    if (error is DioException) {
      final statusCode = error.response?.statusCode;

      if (statusCode == 400 || statusCode == 401) {
        return 'Invalid email or password. Please try again.';
      }

      if (statusCode == 403) {
        return 'Your account is not allowed to access this feature.';
      }

      if (statusCode == 404) {
        return 'Requested service was not found. Please try again later.';
      }

      if (statusCode == 429) {
        return 'Too many attempts. Please wait a moment and try again.';
      }

      if (statusCode != null && statusCode >= 500) {
        return 'Something went wrong on our side. Please try again in a moment.';
      }

      if (error.type == DioExceptionType.connectionTimeout ||
          error.type == DioExceptionType.sendTimeout ||
          error.type == DioExceptionType.receiveTimeout) {
        return 'Request timed out. Please check your connection and try again.';
      }

      if (error.type == DioExceptionType.connectionError) {
        return 'No internet connection. Please check your network and try again.';
      }

      return 'Something went wrong. Please try again.';
    }

    return 'Something went wrong. Please try again.';
  }

  static void handle(
    dynamic error, {
    String title = 'Error',
  }) {
    AppLogger.d('Raw error: $error');
    final friendlyMessage = getFriendlyMessage(error);

    CustomSnackbar.showError(
      title: title,
      message: friendlyMessage,
    );
  }
}