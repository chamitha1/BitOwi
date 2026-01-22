class UserRelationPageRes {
  final String nickname;
  final String photo;
  final int commentCount;
  final int commentGoodCount;
  final int confidenceCount;
  final int id;
  final int orderCount;
  final int orderFinishCount;
  final int userId;
  final int toUser;
  final String type;
  final String createDatetime;

  UserRelationPageRes({
    this.nickname = '',
    this.photo = '',
    this.commentCount = 0,
    this.commentGoodCount = 0,
    this.confidenceCount = 0,
    this.id = 0,
    this.orderCount = 0,
    this.orderFinishCount = 0,
    this.userId = 0,
    this.toUser = 0,
    this.type = '',
    this.createDatetime = '',
  });

  factory UserRelationPageRes.fromJson(Map<String, dynamic> json) {
    try {
      return UserRelationPageRes(
        nickname: json['nickname']?.toString() ?? '',
        photo: json['photo']?.toString() ?? '',
        commentCount: _parseDaily(json['commentCount']),
        commentGoodCount: _parseDaily(json['commentGoodCount']),
        confidenceCount: _parseDaily(json['confidenceCount']),
        id: _parseDaily(json['id']),
        orderCount: _parseDaily(json['orderCount']),
        orderFinishCount: _parseDaily(json['orderFinishCount']),
        userId: _parseDaily(json['userId']),
        toUser: _parseDaily(json['toUser']),
        type: json['type']?.toString() ?? '',
        createDatetime: json['createDatetime']?.toString() ?? '',
      );
    } catch (e) {
      print("Error parsing UserRelationPageRes: $e");
      print("JSON: $json");
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'nickname': nickname,
      'photo': photo,
      'commentCount': commentCount,
      'commentGoodCount': commentGoodCount,
      'confidenceCount': confidenceCount,
      'id': id,
      'orderCount': orderCount,
      'orderFinishCount': orderFinishCount,
      'userId': userId,
      'toUser': toUser,
      'type': type,
      'createDatetime': createDatetime,
    };
  }

  static int _parseDaily(dynamic val) {
    if (val == null) return 0;
    if (val is int) return val;
    if (val is double) return val.toInt();
    if (val is String) return int.tryParse(val) ?? 0;
    return 0;
  }
}
