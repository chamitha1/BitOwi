import 'package:BitOwi/utils/app_logger.dart';
import 'package:get/get.dart';
import 'package:BitOwi/api/p2p_api.dart';
import 'package:BitOwi/models/trade_order_page_res.dart';

class OrdersController extends GetxController {
  final RxInt currentTabIndex = 0.obs;
  final RxList<TradeOrderItem> allOrders = <TradeOrderItem>[].obs;
  final RxList<TradeOrderItem> ordersList = <TradeOrderItem>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isEnd = false.obs;
  final RxInt pageNum = 1.obs;
  final int pageSize = 100;
  bool hasInitialized = false;

  void changeTab(int index) {
    if (currentTabIndex.value != index) {
      currentTabIndex.value = index;
      filterOrders();
    }
  }

  // Filter orders based on current tab
  void filterOrders() {
    List<int> allowedStatuses;

    switch (currentTabIndex.value) {
      case 0: // Processing
        allowedStatuses = [-1, 0, 1, 2, 5];
        break;
      case 1: // Completed
        allowedStatuses = [3];
        break;
      case 2: // Cancelled
        allowedStatuses = [4];
        break;
      default:
        allowedStatuses = [];
    }

    ordersList.value = allOrders.where((order) {
      return allowedStatuses.contains(order.status);
    }).toList();
  }

  Future<void> fetchOrders({bool isRefresh = false}) async {
    if (isLoading.value) return;
    if (!hasInitialized) {
      hasInitialized = true;
    }

    try {
      if (isRefresh) {
        pageNum.value = 1;
        isEnd.value = false;
      } else if (isEnd.value) {
        return;
      }

      isLoading.value = true;

      // Fetch both in-progress (0) and completed/cancelled (1) orders
      // ostatus: 0 = in progress (statuses -1,0,1,2,5)
      // ostatus: 1 = finished (statuses 3,4 - completed and cancelled)
      final futures = await Future.wait([
        P2PApi.getTradeOrderPageList({
          'pageNum': pageNum.value,
          'pageSize': pageSize,
          'ostatus': '0',
        }),
        P2PApi.getTradeOrderPageList({
          'pageNum': pageNum.value,
          'pageSize': pageSize,
          'ostatus': '1',
        }),
      ]);

      final inProgressOrders = futures[0].list;
      final finishedOrders = futures[1].list;
      final combinedOrders = [...inProgressOrders, ...finishedOrders];

      if (isRefresh) {
        allOrders.value = combinedOrders;
      } else {
        allOrders.addAll(combinedOrders);
      }

      isEnd.value = futures[0].isEnd && futures[1].isEnd;
      pageNum.value++;

      // Filter for current tab
      filterOrders();
    } catch (e) {
      AppLogger.d('Error fetching orders: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMore() async {
    await fetchOrders();
  }

  Future<void> refresh() async {
    await fetchOrders(isRefresh: true);
  }
}
