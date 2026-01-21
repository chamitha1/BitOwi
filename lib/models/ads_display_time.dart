import 'package:json_annotation/json_annotation.dart';

part 'ads_display_time.g.dart';

@JsonSerializable()
class AdsDisplayTime {
  AdsDisplayTime();

  late String id;
  late String week;
  late num startTime;
  late num endTime;
  
  factory AdsDisplayTime.fromJson(Map<String,dynamic> json) => _$AdsDisplayTimeFromJson(json);
  Map<String, dynamic> toJson() => _$AdsDisplayTimeToJson(this);
}
