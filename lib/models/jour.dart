import 'package:json_annotation/json_annotation.dart';

part 'jour.g.dart';

@JsonSerializable()
class Jour {
  Jour({
    this.id,
    this.type,
    this.userId,
    this.accountNumber,
    this.accountType,
    this.currency,
    this.bizCategory,
    this.bizCategoryNote,
    this.bizType,
    this.bizNote,
    this.refNo,
    this.transAmount,
    this.preAmount,
    this.postAmount,
    this.prevJourCode,
    this.status,
    this.remark,
    this.createDatetime,
    this.channelType,
  });

  String? id;
  String? type;
  String? userId;
  String? accountNumber;
  String? accountType;
  String? currency;
  String? bizCategory;
  String? bizCategoryNote;
  String? bizType;
  String? bizNote;
  String? refNo;
  @JsonKey(name: 'transAmount')
  String? transAmount;
  String? preAmount;
  String? postAmount;
  String? prevJourCode;
  String? status;
  String? remark;
  @JsonKey(name: 'createDatetime')
  dynamic createDatetime;
  String? channelType;

  Jour copyWith({
    String? id,
    String? type,
    String? userId,
    String? accountNumber,
    String? accountType,
    String? currency,
    String? bizCategory,
    String? bizCategoryNote,
    String? bizType,
    String? bizNote,
    String? refNo,
    String? transAmount,
    String? preAmount,
    String? postAmount,
    String? prevJourCode,
    String? status,
    String? remark,
    dynamic createDatetime,
    String? channelType,
  }) {
    return Jour(
      id: id ?? this.id,
      type: type ?? this.type,
      userId: userId ?? this.userId,
      accountNumber: accountNumber ?? this.accountNumber,
      accountType: accountType ?? this.accountType,
      currency: currency ?? this.currency,
      bizCategory: bizCategory ?? this.bizCategory,
      bizCategoryNote: bizCategoryNote ?? this.bizCategoryNote,
      bizType: bizType ?? this.bizType,
      bizNote: bizNote ?? this.bizNote,
      refNo: refNo ?? this.refNo,
      transAmount: transAmount ?? this.transAmount,
      preAmount: preAmount ?? this.preAmount,
      postAmount: postAmount ?? this.postAmount,
      prevJourCode: prevJourCode ?? this.prevJourCode,
      status: status ?? this.status,
      remark: remark ?? this.remark,
      createDatetime: createDatetime ?? this.createDatetime,
      channelType: channelType ?? this.channelType,
    );
  }

  factory Jour.fromJson(Map<String, dynamic> json) => _$JourFromJson(json);
  Map<String, dynamic> toJson() => _$JourToJson(this);
}
