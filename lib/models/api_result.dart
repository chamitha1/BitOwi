class ApiResult {
  final bool success;
  final String? message;

  ApiResult({required this.success, this.message});

  Map<String, dynamic> toJson() {
    return {'success': success, 'message': message};
  }

  factory ApiResult.fromJson(Map<String, dynamic> json) {
    return ApiResult(
      success: json['success'] as bool,
      message: json['message'] as String?,
    );
  }
}