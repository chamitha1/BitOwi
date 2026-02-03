import 'package:BitOwi/config/api_client.dart';
import 'package:BitOwi/models/ads_detail_res.dart';
import 'package:BitOwi/models/ads_home_res.dart';
import 'package:BitOwi/models/ads_my_page_res.dart';
import 'package:BitOwi/models/api_result.dart';
import 'package:BitOwi/models/page_info.dart';
import 'package:BitOwi/utils/app_logger.dart';
import 'package:dio/dio.dart';

class C2CApi {
  /// Add new ad
  // static Future<Map<String, dynamic>> createAds(
  //   Map<String, dynamic> data,
  // ) async {
  //   try {
  //     final response = await ApiClient.dio.post(
  //       '/core/v1/ads/create',
  //       data: data,
  //     );
  //     // assuming backend returns JSON
  //     return response.data as Map<String, dynamic>;
  //   } catch (e) {
  //     AppLogger.d("createAds error: $e");
  //     rethrow;
  //   }
  // }
  static Future<ApiResult> createAds(Map<String, dynamic> data) async {
    try {
      final response = await ApiClient.dio.post(
        '/core/v1/ads/create',
        data: data,
      );

      if (response.data is Map<String, dynamic>) {
        final data = response.data as Map<String, dynamic>;

        if (data['code'] == 200 ||
            data['code'] == '200' ||
            data['errorCode'] == 'Success' ||
            data['errorCode'] == 'SUCCESS') {
          return ApiResult(success: true);
        }

        // ❗ Backend logical error (like AUTH00006)
        return ApiResult(
          success: false,
          message: data['errorMsg'] ?? 'Something went wrong',
        );
      }
      return ApiResult(success: false, message: 'Invalid server response');
    } on DioException catch (e) {
      final data = e.response?.data;
      return ApiResult(
        success: false,
        message: data is Map ? data['errorMsg'] : e.message,
      );
    } catch (e) {
      return ApiResult(success: false, message: 'Unexpected error occurred');
    }
  }

  /// get price
  static Future<String> getPrice(Map<String, dynamic> data) async {
    try {
      final res = await ApiClient.dio.post(
        '/core/v1/ads/get_price',
        data: data,
      );

      final responseData = res.data['data'];
      return responseData["truePrice"];
    } catch (e) {
      AppLogger.d("getPrice error: $e");
      rethrow;
    }
  }

  /// Get ad details
  static Future<AdsDetailRes> getAdsInfo(
    String id, {
    String? tradeAmount,
    String? count,
  }) async {
    try {
      final res = await ApiClient.dio.post(
        "/core/v1/ads/detail_front",
        data: {"id": id, "tradeAmount": tradeAmount, "count": count},
      );
      final resData = res.data;
      return AdsDetailRes.fromJson(resData['data']);
    } catch (e) {
      AppLogger.d("getAdsInfo error: $e");
      rethrow;
    }
  }

  /// Edit ad
  static Future<ApiResult> editAds(Map<String, dynamic> data) async {
    try {
      final response = await ApiClient.dio.post(
        '/core/v1/ads/edit_ads',
        data: data,
      );

      if (response.data is Map<String, dynamic>) {
        final data = response.data as Map<String, dynamic>;

        if (data['code'] == 200 ||
            data['code'] == '200' ||
            data['errorCode'] == 'Success' ||
            data['errorCode'] == 'SUCCESS') {
          return ApiResult(success: true);
        }

        // ❗ Backend logical error (like AUTH00006)
        return ApiResult(
          success: false,
          message: data['errorMsg'] ?? 'Something went wrong',
        );
      }
      return ApiResult(success: false, message: 'Invalid server response');
    } on DioException catch (e) {
      final data = e.response?.data;
      return ApiResult(
        success: false,
        message: data is Map ? data['errorMsg'] : e.message,
      );
    } catch (e) {
      return ApiResult(success: false, message: 'Unexpected error occurred');
    }
  }

  static Future<AdsHomeRes> getOtherUserAdsHome(String master) async {
    try {
      final res = await ApiClient.dio.post(
        "/core/v1/ads/public/home",
        data: {"master": master},
      );

      final resData = res.data;
      AppLogger.d("----ads/public/home RAW RESPONSE----\n $resData");
      if (resData['code'] == 200 || resData['code'] == '200') {
        return AdsHomeRes.fromJson(resData['data']);
      } else {
        throw Exception(
          resData['errorMsg'] ?? resData['msg'] ?? 'Error fetching ads info',
        );
      }
    } catch (e) {
      AppLogger.d("getOtherUserAdsHome error: $e");
      rethrow;
    }
  }

  /// Query my ads by page
  static Future<PageInfo<AdsMyPageRes>> getMyAdsPageList(
    Map<String, dynamic> data,
  ) async {
    try {
      final res = await ApiClient.dio.post('/core/v1/ads/page_my', data: data);
      final resData = res.data;

      return PageInfo<AdsMyPageRes>.fromJson(resData, AdsMyPageRes.fromJson);
    } catch (e) {
      AppLogger.d("getMyAdsPageList error: $e");
      rethrow;
    }
  }

  /// Add and remove ads
  /// type 0: off the shelf 1: on the shelf
  static Future<void> upDownAds(String id, String type) async {
    try {
      await ApiClient.dio.post(
        '/core/v1/ads/updown_ads',
        data: {"id": id, "type": type},
      );
    } catch (e) {
      AppLogger.d("upDownAds error: $e");
      rethrow;
    }
  }
}
