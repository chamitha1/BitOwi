// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Account _$AccountFromJson(Map<String, dynamic> json) => Account(
  accountType: json['accountType'] as String?,
  currency: json['currency'] as String?,
  totalAmount: json['totalAmount'] as String?,
  availableAmount: json['availableAmount'] as String?,
  frozenAmount: json['frozenAmount'] as String?,
  usableAmount: json['usableAmount'] as String?,
  user: json['user'] == null
      ? null
      : User.fromJson(json['user'] as Map<String, dynamic>),
);

Map<String, dynamic> _$AccountToJson(Account instance) => <String, dynamic>{
  'accountType': instance.accountType,
  'currency': instance.currency,
  'totalAmount': instance.totalAmount,
  'availableAmount': instance.availableAmount,
  'frozenAmount': instance.frozenAmount,
  'usableAmount': instance.usableAmount,
  'user': instance.user,
};
