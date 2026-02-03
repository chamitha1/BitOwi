import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class User {
  String? id;
  String? nickname;
  String? email;
  @JsonKey(name: 'photo')
  String? avatar;
  String? realName;
  String? loginName;
  String? tradePwdFlag;
  String? merchantStatus;
  String? googleStatus;
  String? identifyStatus;

  User({
    this.id,
    this.nickname,
    this.email,
    this.avatar,
    this.realName,
    this.loginName,
    this.tradePwdFlag,
    this.merchantStatus,
    this.googleStatus,
    this.identifyStatus,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
