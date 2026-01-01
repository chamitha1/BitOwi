// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_detail_account_and_jour_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccountDetailAccountAndJourRes _$AccountDetailAccountAndJourResFromJson(
  Map<String, dynamic> json,
) => AccountDetailAccountAndJourRes(
  currency: json['currency'] as String?,
  totalAmount: json['totalAmount'] as String?,
  usableAmount: json['usableAmount'] as String?,
  frozenAmount: json['frozenAmount'] as String?,
  totalAmountUsdt: json['totalAmountUsdt'] as String?,
  totalAsset: json['totalAsset'] as String?,
  totalAssetCurrency: json['totalAssetCurrency'] as String?,
  icon: json['icon'] as String?,
);

Map<String, dynamic> _$AccountDetailAccountAndJourResToJson(
  AccountDetailAccountAndJourRes instance,
) => <String, dynamic>{
  'currency': instance.currency,
  'totalAmount': instance.totalAmount,
  'usableAmount': instance.usableAmount,
  'frozenAmount': instance.frozenAmount,
  'totalAmountUsdt': instance.totalAmountUsdt,
  'totalAsset': instance.totalAsset,
  'totalAssetCurrency': instance.totalAssetCurrency,
  'icon': instance.icon,
};
