import 'package:flutter/material.dart';
import 'package:BitOwi/utils/tencent_sdk_models_wrapper.dart';

class TencentCloudChatCustomerServicePlugin {
  static bool isCustomerServiceMessage(V2TimMessage message) {
    return false;
  }
  static Future<void> sendCustomerServiceStartMessage(dynamic sendMessage) async {}
  static bool isCanSendEvaluateMessage(V2TimMessage message) => false;
  static bool isCanSendEvaluate(V2TimMessage message) => false;
  static bool isCustomerServiceMessageInvisible(V2TimMessage message) => false;
  static bool isRowCustomerServiceMessage(V2TimMessage message) => false;
}

class MessageCustomerService extends StatelessWidget {
  const MessageCustomerService({
    super.key,
    required this.message,
    required this.theme,
    required this.isShowJumpState,
    required this.sendMessage,
  });

  final V2TimMessage message;
  final dynamic theme;
  final bool isShowJumpState;
  final dynamic sendMessage;

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}
