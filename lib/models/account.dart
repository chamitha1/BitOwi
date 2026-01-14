import 'package:json_annotation/json_annotation.dart';
import 'package:BitOwi/models/user_model.dart';

part 'account.g.dart';

@JsonSerializable()
class Account {
  final String? accountType;
  final String? currency;
  final String? totalAmount;
  final String? availableAmount;
  final String? frozenAmount;
  final String? usableAmount; 
  final User? user;

  Account({
    this.accountType,
    this.currency,
    this.totalAmount,
    this.availableAmount,
    this.frozenAmount,
    this.usableAmount,
    this.user,
  });

  factory Account.fromJson(Map<String, dynamic> json) => _$AccountFromJson(json);

  Map<String, dynamic> toJson() => _$AccountToJson(this);
}
