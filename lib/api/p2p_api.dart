import 'package:BitOwi/config/api_client.dart';
import 'package:BitOwi/models/ads_page_res.dart';
import 'package:BitOwi/models/trade_order_page_res.dart';

class P2PApi {
  /// params: {pageNum, pageSize, tradeCoin, tradeType, tradeCurrency, minPrice}
  static Future<AdsPageRes> getAdsPageList(Map<String, dynamic> data) async {
    try {
      final res = await ApiClient.dio.post(
        '/core/v1/ads/public/page_front',
        data: data,
      );

      print("getAdsPageList Raw Response: ${res.data}");
      final responseData = res.data['data'];
      return AdsPageRes.fromJson(responseData);
    } catch (e) {
      print("getAdsPageList Error: $e");
      rethrow;
    }
  }

  /// params: {pageNum, pageSize, ostatus (optional)}
  static Future<TradeOrderPageRes> getTradeOrderPageList(
      Map<String, dynamic> data) async {
    try {
      final res = await ApiClient.dio.post(
        '/core/v1/trade_order/my_page_front',
        data: data,
      );

      print("getTradeOrderPageList Raw Response: ${res.data}");
      final responseData = res.data['data'];
      return TradeOrderPageRes.fromJson(responseData);
    } catch (e) {
      print("getTradeOrderPageList Error: $e");
      rethrow;
    }
  }
}
