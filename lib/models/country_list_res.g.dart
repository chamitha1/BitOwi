// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'country_list_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CountryListRes _$CountryListResFromJson(Map<String, dynamic> json) =>
    CountryListRes()
      ..id = json['id'] as String
      ..interCode = json['interCode'] as String
      ..interName = json['interName'] as String
      ..chineseName = json['chineseName'] as String
      ..interSimpleCode = json['interSimpleCode'] as String?
      ..pic = json['pic'] as String;

Map<String, dynamic> _$CountryListResToJson(CountryListRes instance) =>
    <String, dynamic>{
      'id': instance.id,
      'interCode': instance.interCode,
      'interName': instance.interName,
      'chineseName': instance.chineseName,
      'interSimpleCode': instance.interSimpleCode,
      'pic': instance.pic,
    };
