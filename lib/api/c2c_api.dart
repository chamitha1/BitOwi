import 'package:BitOwi/config/api_client.dart';
import 'package:BitOwi/models/ads_home_res.dart';

class C2CApi {
  static Future<AdsHomeRes> getOtherUserAdsHome(String master) async {
    try {
      final res = await ApiClient.dio.post(
        "/core/v1/ads/public/home",
        data: {"master": master},
      );

      final resData = res.data;
      print("----ads/public/home RAW RESPONSE----\n $resData");
      if (resData['code'] == 200 || resData['code'] == '200') {
        return AdsHomeRes.fromJson(resData['data']);
      } else {
        throw Exception(
          resData['errorMsg'] ?? resData['msg'] ?? 'Error fetching ads info',
        );
      }
    } catch (e) {
      print("getOtherUserAdsHome error: $e");
      rethrow;
    }
  }
}
