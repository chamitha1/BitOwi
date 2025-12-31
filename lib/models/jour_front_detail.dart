class JourFrontDetail {
  final String id;
  final String? userId; 
  final String? accountNumber;
  final String? accountType;
  final String? currency;
  final String? bizCategory;
  final String? bizCategoryNote;
  final String? bizType;
  final String? bizNote;
  final String? refNo;
  final String transAmount;
  final String? preAmount;
  final String? postAmount;
  final String? prevJourCode;
  final String? status;
  final String? remark;
  final dynamic createDatetime; 
  final String? channelType;

  JourFrontDetail({
    required this.id,
    this.userId,
    this.accountNumber,
    this.accountType,
    this.currency,
    this.bizCategory,
    this.bizCategoryNote,
    this.bizType,
    this.bizNote,
    this.refNo,
    required this.transAmount,
    this.preAmount,
    this.postAmount,
    this.prevJourCode,
    this.status,
    this.remark,
    this.createDatetime,
    this.channelType,
  });

  factory JourFrontDetail.fromJson(Map<String, dynamic> json) {
    return JourFrontDetail(
      id: json['id']?.toString() ?? '',
      userId: json['userId']?.toString(),
      accountNumber: json['accountNumber']?.toString(),
      accountType: json['accountType']?.toString(),
      currency: json['currency']?.toString(),
      bizCategory: json['bizCategory']?.toString(),
      bizCategoryNote: json['bizCategoryNote']?.toString(),
      bizType: json['bizType']?.toString(),
      bizNote: json['bizNote']?.toString(),
      refNo: json['refNo']?.toString(),
      transAmount: json['transAmount']?.toString() ?? '0',
      preAmount: json['preAmount']?.toString(),
      postAmount: json['postAmount']?.toString(),
      prevJourCode: json['prevJourCode']?.toString(),
      status: json['status']?.toString(),
      remark: json['remark']?.toString(),
      createDatetime: json['createDatetime'],
      channelType: json['channelType']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'accountNumber': accountNumber,
      'accountType': accountType,
      'currency': currency,
      'bizCategory': bizCategory,
      'bizCategoryNote': bizCategoryNote,
      'bizType': bizType,
      'bizNote': bizNote,
      'refNo': refNo,
      'transAmount': transAmount,
      'preAmount': preAmount,
      'postAmount': postAmount,
      'prevJourCode': prevJourCode,
      'status': status,
      'remark': remark,
      'createDatetime': createDatetime,
      'channelType': channelType,
    };
  }
}
