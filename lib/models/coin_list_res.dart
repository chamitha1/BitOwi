import 'package:json_annotation/json_annotation.dart';

part 'coin_list_res.g.dart';

@JsonSerializable()
class CoinListRes {
  String? symbol;
  String? name;
  String? icon;

  CoinListRes({
    this.symbol,
    this.name,
    this.icon,
  });

  factory CoinListRes.fromJson(Map<String, dynamic> json) => _$CoinListResFromJson(json);

  Map<String, dynamic> toJson() => _$CoinListResToJson(this);
}
