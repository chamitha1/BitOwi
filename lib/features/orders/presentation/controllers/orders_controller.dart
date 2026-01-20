import 'package:get/get.dart';
import 'package:BitOwi/api/p2p_api.dart';
import 'package:BitOwi/models/trade_order_page_res.dart';

class OrdersController extends GetxController {
  final RxInt currentTabIndex = 0.obs;
  final RxList<TradeOrderItem> ordersList = <TradeOrderItem>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isEnd = false.obs;
  final RxInt pageNum = 1.obs;
  final int pageSize = 10;

  @override
  void onInit() {
    super.onInit();
    fetchOrders(isRefresh: true);
  }

  void changeTab(int index) {
    if (currentTabIndex.value != index) {
      currentTabIndex.value = index;
      fetchOrders(isRefresh: true);
    }
  }

  String get statusFilter {
    switch (currentTabIndex.value) {
      case 0: // Processing
        return '-1,0,1,2,5';
      case 1: // Completed
        return '3';
      case 2: // Cancelled
        return '4';
      default:
        return '';
    }
  }

  Future<void> fetchOrders({bool isRefresh = false}) async {
    if (isLoading.value) return;

    try {
      if (isRefresh) {
        pageNum.value = 1;
        isEnd.value = false;
      } else if (isEnd.value) {
        return;
      }

      isLoading.value = true;

      final res = await P2PApi.getTradeOrderPageList({
        'pageNum': pageNum.value,
        'pageSize': pageSize,
        'ostatus': statusFilter,
      });

      if (isRefresh) {
        ordersList.value = res.list;
      } else {
        ordersList.addAll(res.list);
      }

      isEnd.value = res.isEnd;
      pageNum.value++;
    } catch (e) {
      print('Error fetching orders: $e');
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
