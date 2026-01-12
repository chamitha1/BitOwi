// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'article.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Article _$ArticleFromJson(Map<String, dynamic> json) => Article()
  ..id = json['id'] as String
  ..typeId = json['typeId'] as String
  ..type = json['type'] as String
  ..title = json['title'] as String
  ..contentType = json['contentType'] as String
  ..content = json['content'] as String?
  ..status = json['status'] as String
  ..orderNo = json['orderNo'] as num
  ..updater = json['updater'] as String
  ..updaterName = json['updaterName'] as String
  ..updateDatetime = json['updateDatetime'] as num
  ..articleDetailList = (json['articleDetailList'] as List<dynamic>?)
      ?.map((e) => ArticleDetail.fromJson(e as Map<String, dynamic>))
      .toList();

Map<String, dynamic> _$ArticleToJson(Article instance) => <String, dynamic>{
  'id': instance.id,
  'typeId': instance.typeId,
  'type': instance.type,
  'title': instance.title,
  'contentType': instance.contentType,
  'content': instance.content,
  'status': instance.status,
  'orderNo': instance.orderNo,
  'updater': instance.updater,
  'updaterName': instance.updaterName,
  'updateDatetime': instance.updateDatetime,
  'articleDetailList': instance.articleDetailList,
};
