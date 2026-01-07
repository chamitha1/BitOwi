// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'personal_address_list_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PersonalAddressListRes _$PersonalAddressListResFromJson(
  Map<String, dynamic> json,
) => PersonalAddressListRes(
  id: json['id'] as String,
  symbol: json['symbol'] as String,
  address: json['address'] as String,
  name: json['name'] as String,
  userId: json['userId'] as String,
  status: json['status'] as String,
  createDatetime: json['createDatetime'] as num,
  updateDatetime: json['updateDatetime'] as num?,
  remark: json['remark'] as String?,
  statusName: json['statusName'] as String,
);

Map<String, dynamic> _$PersonalAddressListResToJson(
  PersonalAddressListRes instance,
) => <String, dynamic>{
  'id': instance.id,
  'symbol': instance.symbol,
  'address': instance.address,
  'name': instance.name,
  'userId': instance.userId,
  'status': instance.status,
  'createDatetime': instance.createDatetime,
  'updateDatetime': instance.updateDatetime,
  'remark': instance.remark,
  'statusName': instance.statusName,
};
