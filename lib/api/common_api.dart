import 'package:BitOwi/config/api_client.dart';
import 'package:BitOwi/models/article_type.dart';
import 'package:BitOwi/models/config.dart';
import 'package:BitOwi/models/country_list_res.dart';
import 'package:BitOwi/models/dict.dart';

class CommonApi {
  /// Fetch dictionary list
  static Future<List<Dict>> getDictList({
    String? type,
    String? key,
    String? parentKey,
    List<String>? parentKeyList,
  }) async {
    try {
      final res = await ApiClient.dio.post(
        '/core/v1/dict/public/list',
        data: {
          "type": type,
          "key": key,
          "parentKey": parentKey,
          "parentKeyList": parentKeyList,
        },
      );

      final resData = res.data;
      print("getDictList Raw Response: $resData");
      if (resData is List) {
        return resData.map((item) => Dict.fromJson(item)).toList();
      } else if (resData is Map<String, dynamic> && resData['data'] is List) {
        return (resData['data'] as List)
            .map((item) => Dict.fromJson(item))
            .toList();
      }

      return [];
    } catch (e) {
      print("getDictList error: $e");
      rethrow;
    }
  }

  /// Get list of countries
  static Future<List<CountryListRes>> getCountryList() async {
    try {
      final res = await ApiClient.dio.post(
        '/core/v1/country/public/list_front',
        data: {},
      );

      final data = res.data['data'];
      if (data is! List) return [];
      final List<CountryListRes> countryList = data
          .map<CountryListRes>((e) => CountryListRes.fromJson(e))
          .toList();
      return countryList;
    } catch (e) {
      print("getCountryList Error: $e");
      rethrow;
    }
  }

  /// Get system parameters
  static Future<Config> getConfig({
    String? type,
    String? key,
    List<String>? typeList,
  }) async {
    try {
      final res = await ApiClient.dio.post(
        '/core/v1/config/public/list',
        data: {"type": type, "key": key, "typeList": typeList},
      );
      // extract inner data map
      final Map<String, dynamic> data = Map<String, dynamic>.from(
        res.data['data'],
      );
      return Config.fromJson(data);
    } catch (e) {
      print("getConfig Error: $e");
      rethrow;
    }
  }

  /// Get list of article types for help center
  static Future<List<ArticleType>> getArticleList(String location) async {
    try {
      final res = await ApiClient.dio.post(
        '/core/v1/article_type/public/list',
        data: {"status": '1', "location": location},
      );
      final data = res.data['data'];

      // Check if the response is null or not a list
      if (data is! List) {
        print("API returned null or invalid data: $res");
        return []; // Return an empty list in case of error
      }

      // Safely map the response to the ArticleType list
      // List<ArticleType> list = (res as List<dynamic>)
      List<ArticleType> list = data
          .map((item) => ArticleType.fromJson(item))
          .toList();
      return list;
    } catch (e) {
      // ToastUtil.showError('暂无数据'.tr); //No Records
      print("getCountryList Error: $e");
      // rethrow;
      return []; // Return an empty list in case of error
    }
  }

  /// Get SMS Page By Type
  static Future<Map<String, dynamic>> getSmsPageByType({
    required int pageNum,
    required int pageSize,
    required String type,
  }) async {
    try {
      final response = await ApiClient.dio.post(
        '/core/v1/mySms/public/my_sms_page_by_type',
        data: {
          'pageNum': pageNum,
          'pageSize': pageSize,
          'type': type,
        },
      );
      return response.data as Map<String, dynamic>;
    } catch (e) {
      print("Get SMS Page By Type error: $e");
      rethrow;
    }
  }
}
