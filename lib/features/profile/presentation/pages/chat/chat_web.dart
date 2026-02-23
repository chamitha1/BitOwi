
import 'package:flutter/material.dart';

class Chat extends StatelessWidget {
  final dynamic selectedConversation;
  final dynamic initFindingMsg;
  final dynamic showGroupProfile;
  final dynamic directToChat;
  final String? adsId;
  final String customerServiceUserID;
  final bool goBackOnBuy;

  const Chat({
    super.key,
    required this.selectedConversation,
    this.initFindingMsg,
    this.showGroupProfile,
    this.directToChat,
    this.adsId,
    this.customerServiceUserID = '',
    this.goBackOnBuy = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chat (Not supported on Web)')),
      body: const Center(
        child: Text(
          'Chat messaging is currently only supported on mobile devices.',
        ),
      ),
    );
  }
}