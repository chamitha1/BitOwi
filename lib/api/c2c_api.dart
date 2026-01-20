import 'package:BitOwi/config/api_client.dart';
import 'package:BitOwi/models/ads_home_res.dart';
import 'package:BitOwi/models/ads_my_page_res.dart';
import 'package:BitOwi/models/page_info.dart';
import 'package:flutter/material.dart';

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
  //         await HttpUtil.post('/core/v1/trade_order/my_page_front', data);
  //     return PageInfo.fromJson<TradeOrderPageRes>(
  //         res, TradeOrderPageRes.fromJson);
  //   } catch (e) {
  //     e.printError();
  //     rethrow;
  //   }
  // }

