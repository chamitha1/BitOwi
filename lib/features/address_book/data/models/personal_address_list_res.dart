import 'package:json_annotation/json_annotation.dart';

part 'personal_address_list_res.g.dart';

@JsonSerializable()
class PersonalAddressListRes {
  PersonalAddressListRes({
    required this.id,
    required this.symbol,
    required this.address,
    required this.name,
    required this.userId,
    required this.status,
    required this.createDatetime,
    this.updateDatetime,
    this.remark,
    required this.statusName,
  });

  final String id;
  final String symbol;
  final String address;
  final String name;
  final String userId;
  final String status;
  final num createDatetime;
  final num? updateDatetime;
  final String? remark;
  final String statusName;

  factory PersonalAddressListRes.fromJson(Map<String, dynamic> json) =>
      _$PersonalAddressListResFromJson(json);
  Map<String, dynamic> toJson() => _$PersonalAddressListResToJson(this);
}
