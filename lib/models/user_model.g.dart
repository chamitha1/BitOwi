// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
  id: json['id'] as String?,
  nickname: json['nickname'] as String?,
  email: json['email'] as String?,
  avatar: json['photo'] as String?,
  realName: json['realName'] as String?,
  loginName: json['loginName'] as String?,
  tradePwdFlag: json['tradePwdFlag'] as String?,
  merchantStatus: json['merchantStatus'] as String?,
  googleStatus: json['googleStatus'] as String?,
  identifyStatus: json['identifyStatus'] as String?,
);

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
  'id': instance.id,
  'nickname': instance.nickname,
  'email': instance.email,
  'photo': instance.avatar,
  'realName': instance.realName,
  'loginName': instance.loginName,
  'tradePwdFlag': instance.tradePwdFlag,
  'merchantStatus': instance.merchantStatus,
  'googleStatus': instance.googleStatus,
  'identifyStatus': instance.identifyStatus,
};
