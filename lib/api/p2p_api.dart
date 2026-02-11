import 'package:BitOwi/config/api_client.dart';
import 'package:BitOwi/models/ads_page_res.dart';
import 'package:BitOwi/models/trade_order_page_res.dart';
import 'package:BitOwi/models/trade_order_detail_res.dart';
import 'package:BitOwi/models/ads_detail_res.dart';
import 'package:BitOwi/utils/app_logger.dart';
import 'package:flutter/foundation.dart';

class P2PApi {
  /// params: {pageNum, pageSize, tradeCoin, tradeType, tradeCurrency, minPrice}
  static Future<AdsPageRes> getAdsPageList(Map<String, dynamic> data) async {
    try {
      final res = await ApiClient.dio.post(
        '/core/v1/ads/public/page_front',
        data: data,
      );

      AppLogger.d("getAdsPageList Raw Response: ${res.data}");
      final responseData = res.data['data'];
      return AdsPageRes.fromJson(responseData);
    } catch (e) {
      AppLogger.d("getAdsPageList Error: $e");
      rethrow;
    }
  }

  /// params: {pageNum, pageSize, ostatus
  static Future<TradeOrderPageRes> getTradeOrderPageList(
    Map<String, dynamic> data,
  ) async {
    try {
      final res = await ApiClient.dio.post(
        '/core/v1/trade_order/my_page_front',
        data: data,
      );

      AppLogger.d("getTradeOrderPageList Raw Response: ${res.data}");
      final responseData = res.data['data'];
      return TradeOrderPageRes.fromJson(responseData);
    } catch (e) {
      AppLogger.d("getTradeOrderPageList Error: $e");
      rethrow;
    }
  }

  /// Get Trade Order Detail
  static Future<TradeOrderDetailRes> getTradeOrderDetail(String id) async {
    try {
      final res = await ApiClient.dio.post(
        '/core/v1/trade_order/detail_front/$id',
      );
      AppLogger.d('getTradeOrderDetail Raw Response: ${res.data}');
      final responseData = res.data['data'];
      return TradeOrderDetailRes.fromJson(responseData);
    } catch (e) {
      AppLogger.d('getTradeOrderDetail Error: $e');
      rethrow;
    }
  }

  /// Cancel Order
  static Future<void> cancelOrder(String id) async {
    try {
      await ApiClient.dio.post(
        '/core/v1/trade_order/user_cancel',
        data: {"id": id},
      );
    } catch (e) {
      AppLogger.d('cancelOrder Error: $e');
      rethrow;
    }
  }

  /// Mark Order as Paid
  static Future<void> markOrderPay(String id) async {
    try {
      await ApiClient.dio.post(
        '/core/v1/trade_order/mark_pay',
        data: {"id": id},
      );
    } catch (e) {
      AppLogger.d('markOrderPay Error: $e');
      rethrow;
    }
  }

  /// Apply for Arbitration
  static Future<void> applyArbitration(String id) async {
    try {
      await ApiClient.dio.post(
        '/core/v1/trade_order/apply_arbitrate',
        data: {"id": id},
      );
    } catch (e) {
      AppLogger.d('applyArbitration Error: $e');
      rethrow;
    }
  }

  /// Release Order
  static Future<void> releaseOrder(String id, String tradePwd) async {
    try {
      await ApiClient.dio.post(
        '/core/v1/trade_order/release',
        data: {"id": id, "tradePwd": tradePwd},
      );
    } catch (e) {
      AppLogger.d('releaseOrder Error: $e');
      rethrow;
    }
  }

  /// params: {id, tradeAmount, count}
  static Future<AdsDetailRes> getAdsInfo(
    String id, {
    String? tradeAmount,
    String? count,
  }) async {
    try {
      final res = await ApiClient.dio.post(
        '/core/v1/ads/detail_front',
        data: {"id": id, "tradeAmount": tradeAmount, "count": count},
      );

      debugPrint(
        "getAdsInfo Request: id=$id, tradeAmount=$tradeAmount, count=$count",
      );
      debugPrint("getAdsInfo Response: ${res.data}");

      final responseData = res.data['data'];
      return AdsDetailRes.fromJson(responseData);
    } catch (e) {
      debugPrint("getAdsInfo Error: $e");
      rethrow;
    }
  }

  /// Create Buy Order
  /// params: {adsId, tradeAmount, count}
  static Future<String> buyOrder(Map<String, dynamic> data) async {
    try {
      debugPrint("buyOrder Request: $data");    
      final res = await ApiClient.dio.post(
        '/core/v1/trade_order/buy',
        data: data,
      );

      debugPrint("buyOrder Response: ${res.data}");

      return res.data['data']['id'].toString();
    } catch (e) {
      debugPrint("buyOrder Error: $e");
      rethrow;
    }
  }

  /// Create Sell Order
  /// params: {adsId, bankcardId, tradeAmount, count}
  static Future<String> sellOrder(Map<String, dynamic> data) async {
    try {
      debugPrint("sellOrder Request: $data");

      final res = await ApiClient.dio.post(
        '/core/v1/trade_order/sell',
        data: data,
      );

      debugPrint("sellOrder Response: ${res.data}");

      return res.data['data']['id'].toString();
    } catch (e) {
      debugPrint("sellOrder Error: $e");
      rethrow;
    }
  }

  /// Get merchant home/profile stats
  /// params: {master: userId}
  static Future<UserStatistics> getMerchantHome(String userId) async {
    try {
      debugPrint("getMerchantHome Request: userId=$userId");

      final res = await ApiClient.dio.post(
        '/core/v1/ads/public/home',
        data: {"master": userId},
      );

      debugPrint("getMerchantHome Response: ${res.data}");

      return UserStatistics.fromJson(res.data['data']);
    } catch (e) {
      debugPrint("getMerchantHome Error: $e");
      rethrow;
    }
  }

  /// Get merchant's ads list
  /// params: {pageNum, pageSize, userId}
  static Future<AdsPageRes> getMerchantAdsList(
    Map<String, dynamic> data,
  ) async {
    try {
      debugPrint("getMerchantAdsList Request: $data");

      final res = await ApiClient.dio.post(
        '/core/v1/ads/public/page_other',
        data: data,
      );

      debugPrint("getMerchantAdsList Response: ${res.data}");

      return AdsPageRes.fromJson(res.data['data']);
    } catch (e) {
      debugPrint("getMerchantAdsList Error: $e");
      rethrow;
    }
  }
}
