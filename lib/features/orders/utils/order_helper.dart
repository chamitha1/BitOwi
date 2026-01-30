import 'package:BitOwi/features/orders/presentation/widgets/order_card.dart';

class OrderHelper {
  /// Maps API status int to OrderStatus enum
  /// API statuses: {-1: Order pending, 0: Buyer pending payment, 1: Paid and pending release,
  /// 2: Released and pending evaluation, 3: Completed, 4: Cancelled, 5: Under arbitration}
  static OrderStatus mapApiStatusToOrderStatus(int? status) {
    switch (status) {
      case -1:
        return OrderStatus.pending;
      case 0:
        return OrderStatus.pendingPayment;
      case 1:
        return OrderStatus.pendingReleased;
      case 2:
        return OrderStatus.cryptoReleased;
      case 3:
        return OrderStatus.completed;
      case 4:
        return OrderStatus.cancelled;
      case 5:
        return OrderStatus.arbitration;
      default:
        return OrderStatus.pending;
    }
  }

  /// Formats timestamp (milliseconds) to display format
  static String formatDateTime(int? timestamp) {
    if (timestamp == null) return '';
    try {
      final dt = DateTime.fromMillisecondsSinceEpoch(timestamp);
      return '${dt.month.toString().padLeft(2, '0')}/${dt.day.toString().padLeft(2, '0')}, ${dt.hour.toString().padLeft(2, '0')}.${dt.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return '';
    }
  }

  /// Formats timestamp (milliseconds) to full display format: YYYY-MM-DD HH:mm:ss
  static String formatDateTimeFull(int? timestamp) {
    if (timestamp == null) return '';
    try {
      final dt = DateTime.fromMillisecondsSinceEpoch(timestamp);
      return '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}:${dt.second.toString().padLeft(2, '0')}';
    } catch (e) {
      return '';
    }
  }

  /// Formats double amount to string
  static String formatAmount(double? amount) {
    if (amount == null) return '0';
    return amount.toString();
  }
}
