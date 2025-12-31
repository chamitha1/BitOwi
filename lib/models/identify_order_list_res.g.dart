// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'identify_order_list_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IdentifyOrderListRes _$IdentifyOrderListResFromJson(
        Map<String, dynamic> json) =>
    IdentifyOrderListRes()
      ..id = json['id'] as String
      ..userId = json['userId'] as String
      ..countryId = json['countryId'] as String
      ..realName = json['realName'] as String
      ..kind = json['kind'] as String
      ..idNo = json['idNo'] as String
      ..expireDate = json['expireDate'] as String
      ..frontImage = json['frontImage'] as String
      ..backImage = json['backImage'] as String?
      ..faceImage = json['faceImage'] as String?
      ..status = json['status'] as String
      ..createDatetime = json['createDatetime'] as num
      ..remark = json['remark'] as String?
      ..kindName = json['kindName'] as String
      ..statusName = json['statusName'] as String;

Map<String, dynamic> _$IdentifyOrderListResToJson(
        IdentifyOrderListRes instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'countryId': instance.countryId,
      'realName': instance.realName,
      'kind': instance.kind,
      'idNo': instance.idNo,
      'expireDate': instance.expireDate,
      'frontImage': instance.frontImage,
      'backImage': instance.backImage,
      'faceImage': instance.faceImage,
      'status': instance.status,
      'createDatetime': instance.createDatetime,
      'remark': instance.remark,
      'kindName': instance.kindName,
      'statusName': instance.statusName,
    };
