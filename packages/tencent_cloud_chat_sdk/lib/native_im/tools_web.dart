import 'dart:async';

class Tools {
  static int _userDataSeq = 0;

  static String generateUserData(String apiName) {
    String userData = "";
    if (apiName.isNotEmpty) {
      ++_userDataSeq;
      userData = "$apiName-$_userDataSeq";
    } else {
      throw "get userData error";
    }
    return userData;
  }

  // FFI Stub methods are NOT included because they cannot be defined without dart:ffi types.
  // Models do not use FFI methods, so this is safe.

  static List<Map<String, dynamic>> map2JsonList(Map<String, dynamic> originalMap, String key, String value) {
    return originalMap.entries.map((entry) => {key: entry.key, value: entry.value}).toList();
  }

  static Map<String, T> jsonList2Map<T>(List<Map<String, dynamic>> jsonList, String key, String value) {
    Map<String, T> resultMap = {};
    for (var item in jsonList) {
      if (item[key] is String && item[value] != null) {
        resultMap[item[key] as String] = item[value] as T;
      }
    }
    return resultMap;
  }
}
