import 'dart:async';

class CommonUtils {
  /// Get currency symbol
  static String getUnit(String currency) {
    if (currency == 'CNY') {
      return '¥';
    }
    if (currency == 'USD') {
      return '\$';
    }
    if (currency == 'NGN') {
      return '₦';
    }
    return '';
  }

  static Function debounce(Function func, int milliseconds) {
    Timer? timer;
    return () {
      timer?.cancel();
      timer = Timer(Duration(milliseconds: milliseconds), () {
        func();
      });
    };
  }
}
