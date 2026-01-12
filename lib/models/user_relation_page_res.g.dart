// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_relation_page_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserRelationPageRes _$UserRelationPageResFromJson(Map<String, dynamic> json) =>
    UserRelationPageRes(
      nickname: json['nickname'] as String? ?? '',
      photo: json['photo'] as String? ?? '',
      commentCount: (json['commentCount'] as num?)?.toInt() ?? 0,
      commentGoodCount: (json['commentGoodCount'] as num?)?.toInt() ?? 0,
      confidenceCount: (json['confidenceCount'] as num?)?.toInt() ?? 0,
      id: (json['id'] as num?)?.toInt() ?? 0,
      orderCount: (json['orderCount'] as num?)?.toInt() ?? 0,
      orderFinishCount: (json['orderFinishCount'] as num?)?.toInt() ?? 0,
      userId: (json['userId'] as num?)?.toInt() ?? 0,
      toUser: (json['toUser'] as num?)?.toInt() ?? 0,
      type: json['type'] as String? ?? '',
      createDatetime: json['createDatetime'] as String? ?? '',
    );

Map<String, dynamic> _$UserRelationPageResToJson(
  UserRelationPageRes instance,
) => <String, dynamic>{
  'nickname': instance.nickname,
  'photo': instance.photo,
  'commentCount': instance.commentCount,
  'commentGoodCount': instance.commentGoodCount,
  'confidenceCount': instance.confidenceCount,
  'id': instance.id,
  'orderCount': instance.orderCount,
  'orderFinishCount': instance.orderFinishCount,
  'userId': instance.userId,
  'toUser': instance.toUser,
  'type': instance.type,
  'createDatetime': instance.createDatetime,
};
