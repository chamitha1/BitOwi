// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_asset_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccountAssetRes _$AccountAssetResFromJson(Map<String, dynamic> json) =>
    AccountAssetRes()
      ..totalAmount = json['totalAmount'] as String
      ..totalAmountCurrency = json['totalAmountCurrency'] as String
      ..totalAsset = json['totalAsset'] as String
      ..totalAssetCurrency = json['totalAssetCurrency'] as String
      ..totalTbayAsset = json['totalTbayAsset'] as String
      ..totalCardgoalAsset = json['totalCardgoalAsset'] as String
      ..merchantStatus = json['merchantStatus'] as String
      ..merchantRemark = json['merchantRemark'] as String?;

Map<String, dynamic> _$AccountAssetResToJson(AccountAssetRes instance) =>
    <String, dynamic>{
      'totalAmount': instance.totalAmount,
      'totalAmountCurrency': instance.totalAmountCurrency,
      'totalAsset': instance.totalAsset,
      'totalAssetCurrency': instance.totalAssetCurrency,
      'totalTbayAsset': instance.totalTbayAsset,
      'totalCardgoalAsset': instance.totalCardgoalAsset,
      'merchantStatus': instance.merchantStatus,
      'merchantRemark': instance.merchantRemark,
    };
