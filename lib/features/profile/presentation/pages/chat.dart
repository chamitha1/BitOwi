import 'package:BitOwi/api/c2c_api.dart';
import 'package:BitOwi/core/widgets/primary_button.dart';
import 'package:BitOwi/features/orders/chat/chat_avatar.dart';
import 'package:BitOwi/features/orders/chat/controllers/custom_sticker_package_controller.dart';
import 'package:BitOwi/features/orders/chat/tim_uikit_chat_pro.dart';
import 'package:BitOwi/models/ads_detail_res.dart';
import 'package:BitOwi/utils/custom_message/custom_message_element.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
// import 'package:tencent_cloud_chat_customer_service_plugin/tencent_cloud_chat_customer_service_plugin.dart';
import 'package:BitOwi/utils/tencent_chat_plugin_wrapper.dart';

import 'package:tencent_cloud_chat_sdk/enum/message_elem_type.dart';
// import 'package:tencent_cloud_chat_sdk/manager/v2_tim_manager.dart';
// import 'package:tencent_cloud_chat_sdk/models/v2_tim_conversation.dart';
// import 'package:tencent_cloud_chat_sdk/models/v2_tim_message.dart';
import 'package:BitOwi/utils/tencent_sdk_models_wrapper.dart';

import 'package:tencent_cloud_chat_uikit/business_logic/life_cycle/chat_life_cycle.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/view_models/tui_chat_global_model.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';
import 'package:tencent_cloud_chat_uikit/ui/controller/tim_uikit_chat_controller.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/message.dart';
import 'package:tencent_cloud_chat_uikit/data_services/services_locatar.dart';
import 'package:tencent_cloud_chat_uikit/theme/tui_theme.dart';
import 'package:tencent_cloud_chat_uikit/theme/tui_theme_view_model.dart';
// import 'package:provider/provider.dart';
// import 'package:wallet/api/c2c_api.dart';
// import 'package:wallet/config/routes.dart';
// import 'package:wallet/models/ads_detail_res.dart';
// import 'package:wallet/providers/custom_sticker_package.dart';
// import 'package:wallet/providers/theme_provider.dart';
// import 'package:wallet/utils/custom_message/custom_message_element.dart';
// import 'package:wallet/widgets/primary_button.dart';

// import 'widgets/chat/tim_uikit_chat_pro.dart';
// import 'widgets/chat_avatar.dart';

class Chat extends StatefulWidget {
  final V2TimConversation selectedConversation;
  final V2TimMessage? initFindingMsg;
  final VoidCallback? showGroupProfile;
  final ValueChanged<V2TimConversation>? directToChat;
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
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final TIMUIKitChatController _chatController = TIMUIKitChatController();
  // final themeController = Get.find<ThemeController>();
  final stickerController = Get.find<CustomStickerPackageController>();

  String? backRemark;
  final V2TIMManager sdkInstance = TencentImSDKPlugin.v2TIMManager;
  GlobalKey<dynamic> tuiChatField = GlobalKey();
  String? conversationName;
  bool canSendEvaluate = false;

  AdsDetailRes? adsInfo;

  String _getTitle() {
    return 'Contact'; // ?? widget.selectedConversation.showName ?? "聊天".tr;
  }

  String? _getDraftText() {
    return widget.selectedConversation.draftText;
  }

  String? _getConvID() {
    return widget.selectedConversation.type == 1
        ? widget.selectedConversation.userID
        : widget.selectedConversation.groupID;
  }

  ConvType _getConvType() {
    return widget.selectedConversation.type == 1
        ? ConvType.c2c
        : ConvType.group;
  }

  @override
  void initState() {
    super.initState();
    if (widget.customerServiceUserID == widget.selectedConversation.userID) {
      TencentCloudChatCustomerServicePlugin.sendCustomerServiceStartMessage(
        _chatController.sendMessage,
      );
    }
    if (widget.adsId != null && widget.adsId!.isNotEmpty) {
      getAdsDetail();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> getAdsDetail() async {
    final res = await C2CApi.getAdsInfo(widget.adsId!);
    setState(() {
      adsInfo = res;
    });
  }

  // Widget renderCustomStickerPanel({
  //   sendTextMessage,
  //   sendFaceMessage,
  //   deleteText,
  //   addCustomEmojiText,
  //   addText,
  //   List<CustomEmojiFaceData> defaultCustomEmojiStickerList = const [],
  //   double? width,
  //   double? height,
  // }) {
  //   // final customTheme = Provider.of<ThemeProvider>(context).customTheme;
  //   // final customStickerPackageList =
  //   //     Provider.of<CustomStickerPackageData>(context).customStickerPackageList;

  //   final unicodeEmojiPackage = CustomStickerPackage(
  //     name: "defaultEmoji",
  //     stickerList: TUIKitStickerConstData.defaultUnicodeEmojiList.map((emoji) {
  //       return CustomSticker(index: 0, name: emoji.toString(), unicode: emoji);
  //     }).toList(),
  //     menuItem: CustomSticker(
  //       index: 0,
  //       name: TUIKitStickerConstData.defaultUnicodeEmojiList.first.toString(),
  //       unicode: TUIKitStickerConstData.defaultUnicodeEmojiList.first,
  //     ),
  //   );

  //   final defaultEmojiList = defaultCustomEmojiStickerList.map((
  //     customEmojiPackage,
  //   ) {
  //     return CustomStickerPackage(
  //       name: customEmojiPackage.name,
  //       baseUrl: "assets/custom_face_resource/${customEmojiPackage.name}",
  //       isEmoji: customEmojiPackage.isEmoji,
  //       isDefaultEmoji: true,
  //       stickerList: customEmojiPackage.list
  //           .asMap()
  //           .keys
  //           .map(
  //             (idx) =>
  //                 CustomSticker(index: idx, name: customEmojiPackage.list[idx]),
  //           )
  //           .toList(),
  //       menuItem: CustomSticker(index: 0, name: customEmojiPackage.icon),
  //     );
  //   }).toList();

  //   return Obx(() {
  //     final customStickerPackageList =
  //         stickerController.customStickerPackageList;
  //     return StickerPanel(

  //       height: height,
  //       width: width,
  //       sendTextMsg: sendTextMessage,
  //       // sendFaceMsg: (index, data) =>
  //       //     sendFaceMessage(index + 1, (data.split("/")[4]).split("@")[0]),
  //       sendFaceMsg: (index, data) {
  //         String finalData = data;
  //         int finalIndex = index;

  //         if (data.contains("assets/custom_face_resource/")) {
  //           finalData = data.split("/").last.split("@").first;
  //           finalIndex = index + 1;
  //         }

  //         sendFaceMessage(finalIndex, finalData);
  //       },
  //       deleteText: deleteText,
  //       addText: addText,
  //       addCustomEmojiText: addCustomEmojiText,
  //       customStickerPackageList: [
  //         unicodeEmojiPackage,
  //         ...defaultEmojiList,
  //         ...customStickerPackageList,
  //       ],
  //       bottomColor: Colors.white,
  //       backgroundColor: Colors.white,
  //       lightPrimaryColor: const Color(0xFFF8F8FA),
  //     );
  //   });
  // }

  /// Top advertising information bar
  PreferredSize buildAdsBar() {
    return PreferredSize(
      preferredSize: Size.fromHeight(56.w),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(text: 'Quote: '),
                      TextSpan(
                        text: adsInfo!.truePrice,
                        style: const TextStyle(fontFamily: 'DINAlternate'),
                      ),
                      TextSpan(text: adsInfo!.tradeCurrency),
                    ],
                    style: TextStyle(
                      fontSize: 15.sp,
                      color: Color(0xFF000002),
                      fontWeight: FontWeight.w500,
                      fontFamily: 'SFPro',
                    ),
                  ),
                ),
                SizedBox(height: 2.w),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(text: 'Limit: '),
                      TextSpan(
                        text: '${adsInfo!.minTrade}-${adsInfo!.maxTrade}',
                        style: const TextStyle(fontFamily: 'DINAlternate'),
                      ),
                      TextSpan(text: adsInfo!.tradeCurrency),
                    ],
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Color(0xFF999999),
                      fontFamily: 'SFPro',
                    ),
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: PrimaryButton(
                text: adsInfo!.tradeType == '0' ? 'Sell' : 'Buy',
                enabled: true,
                onPressed: () {
                  debugPrint("🚀 Routes buyAd");
                  // if (widget.goBackOnBuy) {
                  //   Navigator.pop(context);
                  // } else {
                  //   Get.toNamed(Routes.buyAd, parameters: {"id": adsInfo!.id});
                  // }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // final theme = Provider.of<ThemeProvider>(context).imTheme;
    final TUITheme imTheme = serviceLocator<TUIThemeViewModel>().theme;
    // final customTheme = Provider.of<ThemeProvider>(context).customTheme;
    // final customThemeImage = Provider.of<ThemeProvider>(
    //   context,
    // ).customThemeImage;
    String title = conversationName ?? _getTitle();

    final leadingWidget = Container(
      width: 36.w,
      height: 36.w,
      margin: EdgeInsets.only(left: 16.w, right: 8.w),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFFF5F6FA),
        border: Border.all(width: 1.w, color: const Color(0xFFF5F6FA)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.maybePop(context);
          },
          child: Center(
            child: Image.asset(
              'assets/icons/chat/back.png',
              width: 24.w,
              height: 24.w,
            ),
          ),
        ),
      ),
    );

    return TIMUIKitChatPro(
      conversation: widget.selectedConversation,
      conversationShowName: title,
      controller: _chatController,
      lifeCycle: ChatLifeCycle(
        newMessageWillMount: (V2TimMessage message) async {
          // ChannelPush.displayDefaultNotificationForMessage(message);
          if (TencentCloudChatCustomerServicePlugin.isCustomerServiceMessage(
            message,
          )) {
            if (TencentCloudChatCustomerServicePlugin.isCanSendEvaluateMessage(
                  message,
                ) &&
                !TencentCloudChatCustomerServicePlugin.isCanSendEvaluate(
                  message,
                ) &&
                canSendEvaluate == true) {
              setState(() {
                canSendEvaluate = false;
              });
            } else if (TencentCloudChatCustomerServicePlugin.isCanSendEvaluateMessage(
                  message,
                ) &&
                TencentCloudChatCustomerServicePlugin.isCanSendEvaluate(
                  message,
                ) &&
                canSendEvaluate == false) {
              setState(() {
                canSendEvaluate = true;
              });
            }
          }
          return message;
        },
        messageShouldMount: (V2TimMessage message) {
          if (TencentCloudChatCustomerServicePlugin.isCustomerServiceMessageInvisible(
                message,
              ) &&
              TencentCloudChatCustomerServicePlugin.isCustomerServiceMessage(
                message,
              )) {
            return false;
          }
          return true;
        },
      ),
      groupAtInfoList: widget.selectedConversation.groupAtInfoList,
      key: tuiChatField,
      // customStickerPanel: renderCustomStickerPanel,
      showTotalUnReadCount: false,
      textFieldHintText: 'Say something',
      config: TIMUIKitChatConfig(
        isAllowSoundMessage: false,
        isShowReadingStatus: false,
        isShowGroupReadingStatus: false,
        showC2cMessageEditStatus: true,
        // isUseDefaultEmoji: true,
        // stickerPanelConfig: StickerPanelConfig(
        //   useQQStickerPackage: true,
        //   useTencentCloudChatStickerPackage: true,
        //   // unicodeEmojiList: TUIKitStickerConstData.defaultUnicodeEmojiList,
        // ),
        isAllowClickAvatar: true,
        isAllowLongPressMessage: false,
        notificationTitle: "",
        isSupportMarkdownForTextMessage: false,
        urlPreviewType: UrlPreviewType.previewCardAndHyperlink,
        isUseMessageReaction: true,
        // notificationOPPOChannelID: PushConfig.OPPOChannelID,
        groupReadReceiptPermissionList: [
          GroupReceiptAllowType.work,
          GroupReceiptAllowType.meeting,
          GroupReceiptAllowType.public,
        ],
        faceURIPrefix: (String path) {
          if (path.contains("assets/custom_face_resource/")) {
            return "";
          }
          int? dirNumber;
          if (path.contains("yz")) {
            dirNumber = 4350;
          }
          if (path.contains("ys")) {
            dirNumber = 4351;
          }
          if (path.contains("gcs")) {
            dirNumber = 4352;
          }
          if (dirNumber != null) {
            return "assets/images/chat_face/$dirNumber/"; //todo
          } else {
            return "";
          }
        },
        faceURISuffix: (String path) {
          return "@2x.png";
        },
        additionalDesktopControlBarItems: [],
      ),
      conversationID: _getConvID() ?? '',
      conversationType: ConvType.values[widget.selectedConversation.type ?? 1],
      // onTapAvatar: (userID, tapDetails) =>
      //     _onTapAvatar(userID, tapDetails, theme),
      initFindingMsg: widget.initFindingMsg,
      draftText: _getDraftText(),
      userAvatarBuilder: (context, message) {
        final isSelf = message.isSelf ?? true;
        final isGroupMessage = _getConvType() == ConvType.group;
        const isShowNickNameForSelf = false;
        final isShowNickNameForOthers = isGroupMessage; // true

        return Container(
          margin:
              (isSelf && isShowNickNameForSelf) ||
                  (!isSelf && isShowNickNameForOthers)
              ? const EdgeInsets.only(top: 2)
              : null,
          child: SizedBox(
            width: 40,
            height: 40,
            child: ChatAvatar(
              faceUrl: message.faceUrl ?? "",
              showName: MessageUtils.getDisplayName(message),
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        );
      },
      messageItemBuilder: MessageItemBuilder(
        messageRowBuilder:
            (
              message,
              messageWidget,
              onScrollToIndex,
              isNeedShowJumpStatus,
              clearJumpStatus,
              onScrollToIndexBegin,
            ) {
              if (TencentCloudChatCustomerServicePlugin.isRowCustomerServiceMessage(
                message,
              )) {
                return messageWidget;
              }
              if (MessageUtils.isGroupCallingMessage(message)) {
                // If group call message, not use default layout.
                return messageWidget;
              }
              if (message.sender == 'administrator' &&
                  message.elemType == MessageElemType.V2TIM_ELEM_TYPE_TEXT) {
                return MessageUtils.wrapMessageTips(
                  Text(
                    'System message: ${message.textElem?.text ?? ""}',
                    softWrap: true,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF999999),
                    ),
                  ),
                  imTheme,
                );
              }
              return null;
            },
        customMessageItemBuilder: (message, isShowJump, clearJump) {
          return CustomMessageElem(
            message: message,
            isShowJump: isShowJump,
            clearJump: clearJump,
            chatController: _chatController,
          );
        },
      ),
      morePanelConfig: MorePanelConfig(
        showFilePickAction: false,
        extraAction: [],
      ),
      appBarConfig: AppBar(
        actions: null,
        elevation: 0,
        leading: leadingWidget,
        leadingWidth: 60.w,
        bottom: adsInfo != null ? buildAdsBar() : null,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        foregroundColor: Theme.of(context).appBarTheme.foregroundColor,
      ),
    );
  }
}
