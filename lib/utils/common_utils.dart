import 'dart:async';

class CommonUtils {
  /// Hide bank card number
  static String maskBankno(String text, {int remainLength = 4}) {
    if (text.isEmpty) return '';

    final cleaned = text.replaceAll(' ', '');
    if (cleaned.length <= remainLength) return cleaned;

    final starLength = cleaned.length - remainLength;
    final stars = '*' * starLength;
    final visible = cleaned.substring(cleaned.length - remainLength);

    return '${stars.replaceAllMapped(RegExp('.{4}'), (m) => '${m.group(0)} ').trim()} $visible';
  }

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

  /// Remove keys with null values from a map
  static Map<String, dynamic> removeNullKeys(Map<String, dynamic> map) {
    Map<String, dynamic> newMap = {};
    map.forEach((key, value) {
      if (value != null) {
        if (value is Map<String, dynamic>) {
          newMap[key] = removeNullKeys(value);
        } else {
          newMap[key] = value;
        }
      }
    });
    return newMap;
  }
}
