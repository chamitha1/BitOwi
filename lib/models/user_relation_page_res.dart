import 'package:json_annotation/json_annotation.dart';
import 'package:BitOwi/models/page_info.dart';

part 'user_relation_page_res.g.dart';

@JsonSerializable()
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

  factory UserRelationPageRes.fromJson(Map<String, dynamic> json) =>
      _$UserRelationPageResFromJson(json);

  Map<String, dynamic> toJson() => _$UserRelationPageResToJson(this);
}
