import 'package:BitOwi/config/api_client.dart';
import 'package:BitOwi/models/ads_detail_res.dart';
import 'package:BitOwi/models/ads_home_res.dart';
import 'package:BitOwi/models/ads_my_page_res.dart';
import 'package:BitOwi/models/page_info.dart';
import 'package:flutter/material.dart';

class C2CApi {
  //  /// Add new ad
  // static Future<void> createAds(Map<String, dynamic> data) async {
  //   try {
  //     await ApiClient.dio.post('/core/v1/ads/create', data);
  //   } catch (e) {
  //     e.printError();
  //     rethrow;
  //   }
  // }

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
      print("getPrice error: $e");
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
      print("getAdsInfo error: $e");
      rethrow;
    }
  }

  // /// Edit ad
  // static Future<void> editAds(Map<String, dynamic> data) async {
  //   try {
  //     await ApiClient.dio.post('/core/v1/ads/edit_ads', data);
  //   } catch (e) {
  //     e.printError();
  //     rethrow;
  //   }
  // }

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

  /// Query my ads by page
  static Future<PageInfo<AdsMyPageRes>> getMyAdsPageList(
    Map<String, dynamic> data,
  ) async {
    try {
      final res = await ApiClient.dio.post('/core/v1/ads/page_my', data: data);
      final resData = res.data;

      return PageInfo<AdsMyPageRes>.fromJson(resData, AdsMyPageRes.fromJson);
    } catch (e) {
      print("getMyAdsPageList error: $e");
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
      print("upDownAds error: $e");
      rethrow;
    }
  }
}

  // static Future<PageInfo<TradeOrderPageRes>> getTradeOrderPageList(
  //     Map<String, dynamic> data) async {
  //   try {
  //     final res =
  //         await ApiClient.dio.post('/core/v1/trade_order/my_page_front', data);
  //     return PageInfo.fromJson<TradeOrderPageRes>(
  //         res, TradeOrderPageRes.fromJson);
  //   } catch (e) {
  //     e.printError();
  //     rethrow;
  //   }
  // }

