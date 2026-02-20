import 'package:BitOwi/utils/app_logger.dart';
import 'package:BitOwi/utils/im_util.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:BitOwi/api/p2p_api.dart';
import 'package:BitOwi/models/trade_order_page_res.dart';
//! Platform-specific Tencent IM imports.
// - Mobile: real Tencent Cloud Chat SDK
// - Web: stub implementations from im_util_web.dart
// import 'package:tencent_cloud_chat_sdk/enum/V2TimAdvancedMsgListener.dart';
// import 'package:tencent_cloud_chat_sdk/enum/V2TimConversationListener.dart';
// import 'package:tencent_cloud_chat_sdk/models/v2_tim_conversation.dart';
import 'package:tencent_cloud_chat_sdk/enum/V2TimAdvancedMsgListener.dart'
    if (dart.library.html) 'package:BitOwi/utils/im_util_web.dart';
import 'package:tencent_cloud_chat_sdk/enum/V2TimConversationListener.dart'
    if (dart.library.html) 'package:BitOwi/utils/im_util_web.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_conversation.dart'
    if (dart.library.html) 'package:BitOwi/utils/im_util_web.dart';

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

  // order chat
  List<V2TimConversation?> conversationList = [];

  Future<void> orderItemUnreadConvoLoad() async {
    try {
      final res = await IMUtil.sdkInstance
          .getConversationManager()
          .getConversationList(nextSeq: '0', count: 100);
      conversationList = res.data?.conversationList ?? [];
      setUnreadCount();
    } catch (e) {}

    IMUtil.sdkInstance.getConversationManager().addConversationListener(
      listener: V2TimConversationListener(
        onConversationChanged: (_conversationList) {
          conversationList = _conversationList;
          setUnreadCount();
        },
      ),
    );
    IMUtil.sdkInstance.getMessageManager().addAdvancedMsgListener(
      listener: V2TimAdvancedMsgListener(
        onRecvNewMessage: (msg) async {
          try {
            final res = await IMUtil.sdkInstance
                .getConversationManager()
                .getConversationList(nextSeq: '0', count: 100);
            conversationList = res.data?.conversationList ?? [];
            setUnreadCount();
          } catch (e) {}
        },
      ),
    );
  }

  void setUnreadCount() {
    if (ordersList.isEmpty || conversationList.isEmpty) return;

    // bool flag = false;
    for (int i = 0; i < ordersList.length; i++) {
      final orderId = ordersList[i].id;
      final index = conversationList.indexWhere(
        (element) => element?.groupID == orderId.toString(),
      );
      if (index > -1) {
        ordersList[i].unReadCount = conversationList[index]?.unreadCount ?? 0;
        debugPrint("unReadCount🚀 ${ordersList[i].unReadCount}");
        // flag = true;
      }
    }
    // if (flag && mounted) {
    //   setState(() {});
    // }
  }
}
