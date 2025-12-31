import 'package:json_annotation/json_annotation.dart';

part 'country_list_res.g.dart';

@JsonSerializable()
class CountryListRes {
  CountryListRes();

  late String id;
  late String interCode;
  late String interName;
  late String chineseName;
  String? interSimpleCode;
  late String pic;
  
  factory CountryListRes.fromJson(Map<String,dynamic> json) => _$CountryListResFromJson(json);
  Map<String, dynamic> toJson() => _$CountryListResToJson(this);
}
