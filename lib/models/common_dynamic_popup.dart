class CommonDynamicPopup {
  const CommonDynamicPopup({
    this.id,
    this.pic,
    this.url,
    this.action,
    this.type,
    this.totalAmount,
    this.newUserRewardAmount,
  });

  final int? id;
  final String? pic;
  final String? url;
  final int? action;
  final int? type;
  final num? totalAmount;
  final num? newUserRewardAmount;

  static const String imageHost = 'https://tsapi.mocard.store';

  String get imageUrl {
    final value = pic?.trim() ?? '';
    if (value.isEmpty) return '';
    if (value.startsWith('http://') || value.startsWith('https://')) {
      return value;
    }
    if (value.startsWith('/')) {
      return '$imageHost$value';
    }
    return '$imageHost/$value';
  }

  bool get hasImage => imageUrl.isNotEmpty;

  factory CommonDynamicPopup.fromJson(Map<String, dynamic> json) {
    return CommonDynamicPopup(
      id: json['id'] is int ? json['id'] as int : int.tryParse('${json['id'] ?? ''}'),
      pic: json['pic'] as String?,
      url: json['url'] as String?,
      action: json['action'] is int ? json['action'] as int : int.tryParse('${json['action'] ?? ''}'),
      type: json['type'] is int ? json['type'] as int : int.tryParse('${json['type'] ?? ''}'),
      totalAmount: json['totalAmount'] as num?,
      newUserRewardAmount: json['newUserRewardAmount'] as num?,
    );
  }
}
