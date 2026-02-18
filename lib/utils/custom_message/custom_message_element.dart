import 'dart:async';

import 'package:BitOwi/utils/custom_message/link_message.dart';
import 'package:BitOwi/utils/custom_message/web_link_message.dart';
import 'package:BitOwi/utils/toast_util.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
// import 'package:provider/provider.dart';
import 'package:tencent_chat_i18n_tool/tencent_chat_i18n_tool.dart';
// import 'package:tencent_cloud_chat_sdk/models/v2_tim_message.dart';
import 'package:BitOwi/utils/tencent_sdk_models_wrapper.dart';
// import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';
import 'package:tencent_cloud_chat_uikit/theme/tui_theme.dart';
import 'package:tencent_im_base/theme/tui_theme.dart' as BaseTheme;
import 'package:tencent_cloud_chat_uikit/ui/controller/tim_uikit_chat_controller.dart';
import 'package:tencent_cloud_chat_uikit/ui/widgets/link_preview/common/extensions.dart';
import 'package:tencent_cloud_chat_uikit/ui/widgets/link_preview/common/utils.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:BitOwi/utils/tencent_chat_plugin_wrapper.dart';
// import 'package:tencent_cloud_chat_customer_service_plugin/tencent_cloud_chat_customer_service_plugin.dart';
// import 'package:wallet/providers/theme_provider.dart';
// import 'package:wallet/utils/custom_message/link_message.dart';
// import 'package:wallet/utils/custom_message/web_link_message.dart';
// import 'package:wallet/utils/toast_util.dart';

class CustomMessageElem extends StatefulWidget {
  final TextStyle? messageFontStyle;
  final BorderRadius? messageBorderRadius;
  final Color? messageBackgroundColor;
  final EdgeInsetsGeometry? textPadding;
  final V2TimMessage message;
  final bool isShowJump;
  final VoidCallback? clearJump;
  final TIMUIKitChatController chatController;

  const CustomMessageElem({
    super.key,
    required this.message,
    required this.isShowJump,
    required this.chatController,
    this.clearJump,
    this.messageFontStyle,
    this.messageBorderRadius,
    this.messageBackgroundColor,
    this.textPadding,
  });

  static Future<void> launchWebURL(BuildContext context, String url) async {
    try {
      await launchUrl(
        Uri.parse(url).withScheme,
        mode: LaunchMode.externalApplication,
      );
    } catch (e) {
      ToastUtil.showToast('Cannot launch the url');
    }
  }

  @override
  State<CustomMessageElem> createState() => _CustomMessageElemState();
}

class _CustomMessageElemState extends State<CustomMessageElem> {
  bool isShowJumpState = false;
  bool isShining = false;
  bool isShowBorder = false;

  void _showJumpColor() {
    isShining = true;
    int shineAmount = 6;
    setState(() {
      isShowJumpState = true;
      isShowBorder = true;
    });
    Timer.periodic(const Duration(milliseconds: 300), (timer) {
      if (mounted) {
        setState(() {
          isShowJumpState = shineAmount.isOdd ? true : false;
          isShowBorder = shineAmount.isOdd ? true : false;
        });
      }
      if (shineAmount == 0 || !mounted) {
        isShining = false;
        timer.cancel();
      }
      shineAmount--;
    });
    if (widget.clearJump != null) {
      widget.clearJump!();
    }
  }

  Widget _callElemBuilder(BuildContext context, TUITheme theme) {
    final BaseTheme.TUITheme baseTheme = BaseTheme.TUITheme(
      primaryColor: const Color(0xFF3371CD),
      lightPrimaryColor: const Color(0xFF3371CD),
      weakDividerColor: const Color(0xFFEBEDF0),
      appbarBgColor: Colors.white,
      chatBgColor: const Color(0xFFF5F6FA),
      darkTextColor: const Color(0xFF444444),
    );

    final customElem = widget.message.customElem;
    final linkMessage = getLinkMessage(customElem);
    final webLinkMessage = getWebLinkMessage(customElem);
    final isCustomerServiceMessage =
        TencentCloudChatCustomerServicePlugin.isCustomerServiceMessage(
          widget.message,
        );
    if (customElem?.data == "group_create") {
      return renderMessageItem(
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [Text(TIM_t(("群聊创建成功！")))],
        ),
        theme,
        false,
      );
    } else if (isCustomerServiceMessage) {
      return MessageCustomerService(
        message: widget.message,
        theme: baseTheme, //
        isShowJumpState: isShowJumpState,
        sendMessage: widget.chatController.sendMessage,
      );
    } else if (linkMessage != null) {
      final String option1 = linkMessage.link ?? "";
      return renderMessageItem(
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(linkMessage.text ?? ""),
            MarkdownBody(
              data: TIM_t_para("[查看详情 >>]({{option1}})", "[查看详情 >>]($option1)")(
                option1: option1,
              ),
              styleSheet: MarkdownStyleSheet.fromTheme(
                ThemeData(
                  textTheme: const TextTheme(
                    bodyMedium: TextStyle(fontSize: 16.0),
                  ),
                ),
              ).copyWith(a: const TextStyle(color: Color(0xFF015FFF))),
              onTapLink: (String link, String? href, String title) {
                LinkUtils.launchURL(context, linkMessage.link ?? "");
              },
            ),
          ],
        ),
        theme,
        false,
      );
    } else if (webLinkMessage != null) {
      return renderMessageItem(
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text.rich(
              TextSpan(
                style: const TextStyle(fontSize: 16),
                children: [
                  TextSpan(text: webLinkMessage.title),
                  TextSpan(
                    text: webLinkMessage.hyperlinks_text?["key"],
                    style: const TextStyle(
                      color: Color.fromRGBO(0, 110, 253, 1),
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        CustomMessageElem.launchWebURL(
                          context,
                          webLinkMessage.hyperlinks_text?["value"],
                        );
                      },
                  ),
                ],
              ),
            ),
            if (webLinkMessage.description != null &&
                webLinkMessage.description!.isNotEmpty)
              Text(
                webLinkMessage.description!,
                style: const TextStyle(fontSize: 16),
              ),
          ],
        ),
        theme,
        false,
      );
    } else {
      return renderMessageItem(Text('[Customize]'), theme, false);
    }
  }

  Widget renderMessageItem(Widget child, TUITheme theme, bool isVoteMessage) {
    final isFromSelf = widget.message.isSelf ?? true;
    final borderRadius = isFromSelf
        ? const BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(2),
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10),
          )
        : const BorderRadius.only(
            topLeft: Radius.circular(2),
            topRight: Radius.circular(10),
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10),
          );

    final defaultStyle = isFromSelf
        ? theme.lightPrimaryMaterialColor.shade50
        : theme.weakBackgroundColor;
    final backgroundColor = isShowJumpState
        ? const Color.fromRGBO(245, 166, 35, 1)
        : defaultStyle;

    return Container(
      padding: isVoteMessage
          ? null
          : (widget.textPadding ?? const EdgeInsets.all(10)),
      decoration: isVoteMessage
          ? BoxDecoration(
              border: Border.all(
                width: 1,
                color: theme.weakDividerColor ?? Colors.grey,
              ),
            )
          : BoxDecoration(
              color: widget.messageBackgroundColor ?? backgroundColor,
              borderRadius: widget.messageBorderRadius ?? borderRadius,
            ),
      constraints: BoxConstraints(
        maxWidth: isVoteMessage ? 298 : 240,
      ), // vote message width need more
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = TUITheme(
      primaryColor: const Color(0xFF3371CD),
      lightPrimaryColor: const Color(0xFF3371CD),
      weakDividerColor: const Color(0xFFEBEDF0),
      appbarBgColor: Colors.white,
      // chatMessageItemFromSelfBgColor:
      //     const Color(0xFFFF8930).withOpacity(0.3),
      chatMessageItemFromOthersBgColor: Colors.white,
      chatBgColor: const Color(0xFFF5F6FA),
      appbarTextColor: const Color(0xFF3371CD),
      darkTextColor: const Color(0xFF444444),
    );

    if (widget.isShowJump) {
      if (!isShining) {
        Future.delayed(Duration.zero, () {
          _showJumpColor();
        });
      } else {
        if (widget.clearJump != null) {
          widget.clearJump!();
        }
      }
    }

    return _callElemBuilder(context, theme);
  }
}
