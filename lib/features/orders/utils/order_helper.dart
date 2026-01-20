import 'package:BitOwi/features/orders/presentation/widgets/order_card.dart';

class OrderHelper {
  /// API statuses: {-1: Order pending, 0: Buyer pending payment, 1: Paid and pending release,
  /// 2: Released and pending evaluation, 3: Completed, 4: Cancelled, 5: Under arbitration}
  static OrderStatus mapApiStatusToOrderStatus(String? status) {
    switch (status) {
      case '-1':
        return OrderStatus.pending;
      case '0':
        return OrderStatus.pendingPayment;
      case '1':
        return OrderStatus.pendingReleased;
      case '2':
        return OrderStatus.cryptoReleased;
      case '3':
        return OrderStatus.completed;
      case '4':
        return OrderStatus.cancelled;
      case '5':
        return OrderStatus.arbitration;
      default:
        return OrderStatus.pending;
    }
  }

  /// Formats datetime
  static String formatDateTime(String? datetime) {
    if (datetime == null || datetime.isEmpty) return '';
    try {
      final dt = DateTime.parse(datetime);
      return '${dt.month.toString().padLeft(2, '0')}/${dt.day.toString().padLeft(2, '0')}, ${dt.hour.toString().padLeft(2, '0')}.${dt.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return datetime;
    }
  }
}
