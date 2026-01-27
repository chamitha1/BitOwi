import 'package:BitOwi/utils/app_logger.dart';

class PageInfo<T> {
  final List<T> list;
  final int total;
  final int pageNum;
  final int pageSize;
  final bool isEnd;

  PageInfo({
    required this.list,
    this.total = 0,
    this.pageNum = 1,
    this.pageSize = 10,
    this.isEnd = false,
  });

  factory PageInfo.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    final data = json['data'] != null
        ? json['data'] as Map<String, dynamic>
        : json;

    final rawList = data['list'] as List<dynamic>? ?? [];
    List<T> list = [];
    try {
      list = rawList
          .map((item) => fromJsonT(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      AppLogger.d("PageInfo list parsing error: $e");

      rethrow;
    }

    final total = _parseInt(data['total']);
    final pages = _parseInt(data['pages']);
    final pageNum = _parseInt(data['pageNum'], defaultValue: 1);
    final pageSize = _parseInt(data['pageSize'], defaultValue: 10);
    final isEnd = pageNum >= pages;

    return PageInfo(
      list: list,
      total: total,
      pageNum: pageNum,
      pageSize: pageSize,
      isEnd: isEnd,
    );
  }

  static int _parseInt(dynamic value, {int defaultValue = 0}) {
    if (value == null) return defaultValue;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) {
      return int.tryParse(value) ?? defaultValue;
    }
    return defaultValue;
  }
}
