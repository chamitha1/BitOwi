import 'package:json_annotation/json_annotation.dart';

part 'identify_order_list_res.g.dart';

@JsonSerializable()
class IdentifyOrderListRes {
  IdentifyOrderListRes();

  late String id;
  late String userId;
  late String countryId;
  late String realName;
  late String kind;
  late String idNo;
  late String expireDate;
  late String frontImage;
  String? backImage;
  String? faceImage;
  late String status;
  late num createDatetime;
  String? remark;
  late String kindName;
  late String statusName;
  
  factory IdentifyOrderListRes.fromJson(Map<String,dynamic> json) => _$IdentifyOrderListResFromJson(json);
  Map<String, dynamic> toJson() => _$IdentifyOrderListResToJson(this);
}
