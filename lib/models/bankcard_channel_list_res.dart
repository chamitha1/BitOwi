import 'package:json_annotation/json_annotation.dart';
part 'bankcard_channel_list_res.g.dart';

@JsonSerializable()
class BankcardChannelListRes {
  BankcardChannelListRes();

  late String logo;
  late String bankName;
  late String id;

  factory BankcardChannelListRes.fromJson(Map<String, dynamic> json) =>
      _$BankcardChannelListResFromJson(json);
  Map<String, dynamic> toJson() => _$BankcardChannelListResToJson(this);
}
