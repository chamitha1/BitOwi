import 'package:BitOwi/config/api_client.dart';
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
}
