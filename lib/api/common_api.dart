import 'package:BitOwi/config/api_client.dart';
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
}
