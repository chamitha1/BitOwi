// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ads_display_time.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdsDisplayTime _$AdsDisplayTimeFromJson(Map<String, dynamic> json) =>
    AdsDisplayTime()
      ..id = json['id'] as String
      ..week = json['week'] as String
      ..startTime = json['startTime'] as num
      ..endTime = json['endTime'] as num;

Map<String, dynamic> _$AdsDisplayTimeToJson(AdsDisplayTime instance) =>
    <String, dynamic>{
      'id': instance.id,
      'week': instance.week,
      'startTime': instance.startTime,
      'endTime': instance.endTime,
    };
