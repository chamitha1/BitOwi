import 'package:BitOwi/config/api_client.dart';
import 'package:BitOwi/models/ads_page_res.dart';

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
}
