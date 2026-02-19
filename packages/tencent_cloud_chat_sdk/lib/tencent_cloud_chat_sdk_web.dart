import 'dart:async';
import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:tencent_cloud_chat_sdk/enum/V2TimAdvancedMsgListener.dart';
import 'package:tencent_cloud_chat_sdk/enum/V2TimConversationListener.dart';
import 'package:tencent_cloud_chat_sdk/enum/V2TimFriendshipListener.dart';
import 'package:tencent_cloud_chat_sdk/enum/V2TimGroupListener.dart';
import 'package:tencent_cloud_chat_sdk/enum/V2TimSDKListener.dart';
import 'package:tencent_cloud_chat_sdk/enum/V2TimSignalingListener.dart';
import 'package:tencent_cloud_chat_sdk/enum/V2TimSimpleMsgListener.dart';
import 'package:tencent_cloud_chat_sdk/enum/history_message_get_type.dart';
import 'package:tencent_cloud_chat_sdk/enum/v2_tim_plugins.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_callback.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_conversation.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_conversation_operation_result.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_conversation_result.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_friend_application_result.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_friend_check_result.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_friend_group.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_friend_info.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_friend_info_result.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_friend_operation_result.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_friend_search_param.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_group_application_result.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_group_info.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_group_info_result.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_group_member.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_group_member_full_info.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_group_member_info_result.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_group_member_operation_result.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_group_member_search_param.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_group_member_search_result.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_group_search_param.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_message.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_message_list_result.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_msg_create_info_result.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_receive_message_opt_info.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_topic_info.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_topic_info_result.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_topic_operation_result.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_user_full_info.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_user_search_result.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_user_status.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_value_callback.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_user_info.dart';
import 'package:tencent_cloud_chat_sdk/enum/callbacks.dart';
import 'package:tencent_cloud_chat_sdk/enum/message_elem_type.dart';
import 'tencent_cloud_chat_sdk_platform_interface.dart';

/// A web implementation of the TencentCloudChatSdkPlatform of the TencentCloudChatSdk plugin.
/// WASM-Safe Stub Implementation.
class TencentCloudChatSdkWeb extends TencentCloudChatSdkPlatform {
  TencentCloudChatSdkWeb();

  static void registerWith(Registrar registrar) {
    TencentCloudChatSdkPlatform.instance = TencentCloudChatSdkWeb();
  }

  @override
  addNativeCallback() {}

  @override
  Future<void> emitUIKitEvent(UIKitEvent event) async {}

  @override
  Future<void> emitPluginEvent(PluginEvent event) async {}

  @override
  Future<String?> getPlatformVersion() async {
    return "Web Stub";
  }

  @override
  Future<V2TimCallback> cleanConversationUnreadMessageCount({
    required String conversationID,
    required int cleanTimestamp,
    required int cleanSequence,
  }) async {
    return V2TimCallback(code: 0, desc: "Success");
  }

  @override
  Future<void> uikitTrace({
    required String trace,
  }) async {
    debugPrint(trace);
  }

  @override
  Future<V2TimValueCallback<bool>> initSDK({
    required int sdkAppID,
    required int loglevel,
    String? listenerUuid,
    required int uiPlatform,
    bool? showImLog,
    List<V2TimPlugins>? plugins,
    V2TimSDKListener? listener,
  }) async {
    return V2TimValueCallback<bool>(code: 0, desc: "Success", data: true);
  }

  @override
  Future<V2TimCallback> unInitSDK() async {
    return V2TimCallback(code: 0, desc: "Success");
  }

  @override
  Future<V2TimValueCallback<int>> getServerTime() async {
    return V2TimValueCallback<int>(code: 0, desc: "Success", data: DateTime.now().millisecondsSinceEpoch ~/ 1000);
  }

  @override
  Future<V2TimCallback> login({
    required String userID,
    required String userSig,
  }) async {
    return V2TimCallback(code: 0, desc: "Success");
  }

  @override
  Future<V2TimCallback> logout() async {
    return V2TimCallback(code: 0, desc: "Success");
  }

  @override
  Future<V2TimValueCallback<V2TimMessage>> sendC2CTextMessage({
    required String text,
    required String userID,
  }) async {
    return V2TimValueCallback<V2TimMessage>(code: 0, desc: "Success", data: V2TimMessage(msgID: "stub_msg_id", elemType: MessageElemType.V2TIM_ELEM_TYPE_NONE));
  }

  @override
  Future<V2TimValueCallback<String>> getLoginUser() async {
    return V2TimValueCallback<String>(code: 0, desc: "Success", data: "");
  }

  @override
  Future<V2TimValueCallback<V2TimMessage>> sendC2CCustomMessage({
    required String customData,
    required String userID,
  }) async {
    return V2TimValueCallback<V2TimMessage>(code: 0, desc: "Success", data: V2TimMessage(msgID: "stub_msg_id", elemType: MessageElemType.V2TIM_ELEM_TYPE_NONE));
  }

  @override
  Future<V2TimValueCallback<V2TimMessage>> sendGroupTextMessage({
    required String text,
    required String groupID,
    int priority = 0,
  }) async {
    return V2TimValueCallback<V2TimMessage>(code: 0, desc: "Success", data: V2TimMessage(msgID: "stub_msg_id", elemType: MessageElemType.V2TIM_ELEM_TYPE_NONE));
  }

  @override
  Future<V2TimValueCallback<V2TimMessage>> sendGroupCustomMessage({
    required String customData,
    required String groupID,
    int priority = 0,
  }) async {
    return V2TimValueCallback<V2TimMessage>(code: 0, desc: "Success", data: V2TimMessage(msgID: "stub_msg_id", elemType: MessageElemType.V2TIM_ELEM_TYPE_NONE));
  }

  @override
  Future<V2TimValueCallback<String>> getVersion() async {
    return V2TimValueCallback<String>(code: 0, desc: "Success", data: "Stub 1.0");
  }

  @override
  Future<V2TimValueCallback<int>> getLoginStatus() async {
    return V2TimValueCallback<int>(code: 0, desc: "Success", data: 1); // 1 = Login
  }

  @override
  Future<V2TimValueCallback<List<V2TimUserFullInfo>>> getUsersInfo({
    required List<String> userIDList,
  }) async {
    return V2TimValueCallback<List<V2TimUserFullInfo>>(code: 0, desc: "Success", data: <V2TimUserFullInfo>[]);
  }

  @override
  Future<V2TimCallback> joinGroup({
    required String groupID,
    required String message,
    String? groupType,
  }) async {
    return V2TimCallback(code: 0, desc: "Success");
  }

  @override
  Future<V2TimCallback> dismissGroup({
    required String groupID,
  }) async {
    return V2TimCallback(code: 0, desc: "Success");
  }

  @override
  Future<V2TimCallback> quitGroup({
    required String groupID,
  }) async {
    return V2TimCallback(code: 0, desc: "Success");
  }

  @override
  Future<V2TimCallback> setSelfInfo({
    required V2TimUserFullInfo userFullInfo,
  }) async {
    return V2TimCallback(code: 0, desc: "Success");
  }

  @override
  Future<V2TimValueCallback<Object>> callExperimentalAPI({
    required String api,
    Object? param,
  }) async {
    return V2TimValueCallback<Object>(code: 0, desc: "Success", data: null);
  }

  @override
  Future<String> addSimpleMsgListener({
    required V2TimSimpleMsgListener listener,
  }) async {
    return "";
  }

  @override
  Future<void> removeSimpleMsgListener({
    V2TimSimpleMsgListener? listener,
    String? uuid,
  }) async {}

  @override
  Future<V2TimValueCallback<V2TimConversationResult>> getConversationList({
    required String nextSeq,
    required int count,
  }) async {
    return V2TimValueCallback<V2TimConversationResult>(code: 0, desc: "Success", data: V2TimConversationResult(nextSeq: "0", isFinished: true, conversationList: <V2TimConversation>[]));
  }

  @override
  Future<void> setConversationListener(
      {required V2TimConversationListener listener,
      String? listenerUuid}) async {}

  @override
  Future<void> addConversationListener(
      {required V2TimConversationListener listener}) async {}

  @override
  Future<V2TimValueCallback<List<V2TimConversation>>>
      getConversationListByConversationIds({
    required List<String> conversationIDList,
  }) async {
    return V2TimValueCallback<List<V2TimConversation>>(code: 0, desc: "Success", data: <V2TimConversation>[]);
  }

  @override
  Future<V2TimValueCallback<V2TimConversation>> getConversation({
    required String conversationID,
  }) async {
    return V2TimValueCallback<V2TimConversation>(code: 0, desc: "Success", data: V2TimConversation(conversationID: conversationID, showName: "Stub Conversation"));
  }

  @override
  Future<V2TimCallback> deleteConversation({
    required String conversationID,
  }) async {
    return V2TimCallback(code: 0, desc: "Success");
  }

  @override
  Future<V2TimValueCallback<List<V2TimConversationOperationResult>>>
      deleteConversationList({
    required List<String> conversationIDList,
    required bool clearMessage,
  }) async {
    return V2TimValueCallback<List<V2TimConversationOperationResult>>(code: 0, desc: "Success", data: <V2TimConversationOperationResult>[]);
  }

  @override
  Future<V2TimCallback> setConversationDraft({
    required String conversationID,
    String? draftText,
  }) async {
    return V2TimCallback(code: 0, desc: "Success");
  }

  @override
  Future<V2TimCallback> pinConversation({
    required String conversationID,
    required bool isPinned,
  }) async {
    return V2TimCallback(code: 0, desc: "Success");
  }

  @override
  Future<V2TimValueCallback<int>> getTotalUnreadMessageCount() async {
    return V2TimValueCallback<int>(code: 0, desc: "Success", data: 0);
  }

  @override
  Future<V2TimValueCallback<List<V2TimFriendInfo>>> getFriendList() async {
    return V2TimValueCallback<List<V2TimFriendInfo>>(code: 0, desc: "Success", data: <V2TimFriendInfo>[]);
  }

  @override
  Future<void> setFriendListener(
      {required V2TimFriendshipListener listener, String? listenerUuid}) async {}

  @override
  Future<V2TimValueCallback<List<V2TimFriendInfoResult>>> getFriendsInfo({
    required List<String> userIDList,
  }) async {
    return V2TimValueCallback<List<V2TimFriendInfoResult>>(code: 0, desc: "Success", data: <V2TimFriendInfoResult>[]);
  }

  @override
  Future<V2TimValueCallback<V2TimFriendOperationResult>> addFriend({
    required String userID,
    String? remark,
    String? friendGroup,
    String? addWording,
    String? addSource,
    required int addType,
  }) async {
    return V2TimValueCallback<V2TimFriendOperationResult>(code: 0, desc: "Success", data: V2TimFriendOperationResult(userID: "stub_user_id"));
  }

  @override
  Future<V2TimCallback> setFriendInfo({
    required String userID,
    String? friendRemark,
    Map<String, String>? friendCustomInfo,
  }) async {
    return V2TimCallback(code: 0, desc: "Success");
  }

  @override
  Future<V2TimValueCallback<List<V2TimFriendOperationResult>>>
      deleteFromFriendList({
    required List<String> userIDList,
    required int deleteType,
  }) async {
    return V2TimValueCallback<List<V2TimFriendOperationResult>>(code: 0, desc: "Success", data: <V2TimFriendOperationResult>[]);
  }

  @override
  Future<V2TimValueCallback<List<V2TimFriendCheckResult>>> checkFriend({
    required List<String> userIDList,
    required int checkType,
  }) async {
    return V2TimValueCallback<List<V2TimFriendCheckResult>>(code: 0, desc: "Success", data: <V2TimFriendCheckResult>[]);
  }

  @override
  Future<V2TimValueCallback<V2TimFriendApplicationResult>>
      getFriendApplicationList() async {
    return V2TimValueCallback<V2TimFriendApplicationResult>(code: 0, desc: "Success", data: V2TimFriendApplicationResult());
  }

  @override
  Future<V2TimValueCallback<V2TimFriendOperationResult>>
      acceptFriendApplication({
    required int responseType,
    required int type,
    required String userID,
  }) async {
    return V2TimValueCallback<V2TimFriendOperationResult>(code: 0, desc: "Success", data: V2TimFriendOperationResult(userID: "stub_user_id"));
  }

  @override
  Future<V2TimValueCallback<V2TimFriendOperationResult>>
      refuseFriendApplication({
    required int type,
    required String userID,
  }) async {
    return V2TimValueCallback<V2TimFriendOperationResult>(code: 0, desc: "Success", data: V2TimFriendOperationResult(userID: "stub_user_id"));
  }

  @override
  Future<V2TimCallback> deleteFriendApplication({
    required int type,
    required String userID,
  }) async {
    return V2TimCallback(code: 0, desc: "Success");
  }

  @override
  Future<V2TimCallback> setFriendApplicationRead() async {
    return V2TimCallback(code: 0, desc: "Success");
  }

  @override
  Future<V2TimValueCallback<List<V2TimFriendInfo>>> getBlackList() async {
    return V2TimValueCallback<List<V2TimFriendInfo>>(code: 0, desc: "Success", data: <V2TimFriendInfo>[]);
  }

  @override
  Future<V2TimValueCallback<List<V2TimFriendOperationResult>>> addToBlackList({
    required List<String> userIDList,
  }) async {
    return V2TimValueCallback<List<V2TimFriendOperationResult>>(code: 0, desc: "Success", data: <V2TimFriendOperationResult>[]);
  }

  @override
  Future<V2TimValueCallback<List<V2TimFriendOperationResult>>>
      deleteFromBlackList({
    required List<String> userIDList,
  }) async {
    return V2TimValueCallback<List<V2TimFriendOperationResult>>(code: 0, desc: "Success", data: <V2TimFriendOperationResult>[]);
  }

  @override
  Future<V2TimValueCallback<List<V2TimFriendOperationResult>>>
      createFriendGroup({
    required String groupName,
    List<String>? userIDList,
  }) async {
    return V2TimValueCallback<List<V2TimFriendOperationResult>>(code: 0, desc: "Success", data: <V2TimFriendOperationResult>[]);
  }

  @override
  Future<V2TimValueCallback<List<V2TimFriendGroup>>> getFriendGroups({
    List<String>? groupNameList,
  }) async {
    return V2TimValueCallback<List<V2TimFriendGroup>>(code: 0, desc: "Success", data: <V2TimFriendGroup>[]);
  }

  @override
  Future<V2TimCallback> deleteFriendGroup({
    required List<String> groupNameList,
  }) async {
    return V2TimCallback(code: 0, desc: "Success");
  }

  @override
  Future<V2TimCallback> renameFriendGroup({
    required String oldName,
    required String newName,
  }) async {
    return V2TimCallback(code: 0, desc: "Success");
  }

  @override
  Future<V2TimValueCallback<List<V2TimFriendOperationResult>>>
      addFriendsToFriendGroup({
    required String groupName,
    required List<String> userIDList,
  }) async {
    return V2TimValueCallback<List<V2TimFriendOperationResult>>(code: 0, desc: "Success", data: <V2TimFriendOperationResult>[]);
  }

  @override
  Future<V2TimValueCallback<List<V2TimFriendOperationResult>>>
      deleteFriendsFromFriendGroup({
    required String groupName,
    required List<String> userIDList,
  }) async {
    return V2TimValueCallback<List<V2TimFriendOperationResult>>(code: 0, desc: "Success", data: <V2TimFriendOperationResult>[]);
  }

  @override
  Future<V2TimValueCallback<List<V2TimFriendInfoResult>>> searchFriends({
    required V2TimFriendSearchParam searchParam,
  }) async {
    return V2TimValueCallback<List<V2TimFriendInfoResult>>(code: 0, desc: "Success", data: <V2TimFriendInfoResult>[]);
  }

  @override
  Future<V2TimValueCallback<List<V2TimGroupInfo>>> getJoinedGroupList() async {
    return V2TimValueCallback<List<V2TimGroupInfo>>(code: 0, desc: "Success", data: <V2TimGroupInfo>[]);
  }

    @override
  Future<V2TimValueCallback<List<V2TimGroupInfo>>>
      getJoinedCommunityList() async {
    return V2TimValueCallback<List<V2TimGroupInfo>>(code: 0, desc: "Success", data: <V2TimGroupInfo>[]);
  }

  @override
  Future<V2TimValueCallback<String>> createTopicInCommunity({
    required String groupID,
    required V2TimTopicInfo topicInfo,
  }) async {
      return V2TimValueCallback<String>(code: 0, desc: "Success", data: "");
  }

  @override
  Future<V2TimValueCallback<List<V2TimTopicInfoResult>>> getTopicInfoList({
    required String groupID,
    required List<String> topicIDList,
  }) async {
    return V2TimValueCallback<List<V2TimTopicInfoResult>>(code: 0, desc: "Success", data: <V2TimTopicInfoResult>[]);
  }

  @override
  Future<V2TimCallback> setTopicInfo({
    required V2TimTopicInfo topicInfo,
  }) async {
     return V2TimCallback(code: 0, desc: "Success");
  }

  @override
  Future<V2TimValueCallback<List<V2TimTopicOperationResult>>>
      deleteTopicFromCommunity({
    required String groupID,
    required List<String> topicIDList,
  }) async {
     return V2TimValueCallback<List<V2TimTopicOperationResult>>(code: 0, desc: "Success", data: <V2TimTopicOperationResult>[]);
  }

  @override
  Future<V2TimValueCallback<String>> createGroup({
    String? groupID,
    required String groupType,
    required String groupName,
    String? notification,
    String? introduction,
    String? faceUrl,
    bool? isAllMuted,
    int? addOpt,
    List<V2TimGroupMember>? memberList,
    bool? isSupportTopic = false,
    int? approveOpt,
    bool? isEnablePermissionGroup,
    int? defaultPermissions,
  }) async {
     return V2TimValueCallback<String>(code: 0, desc: "Success", data: groupID ?? "stub_group_id");
  }

  @override
  Future<V2TimValueCallback<List<V2TimGroupInfoResult>>> getGroupsInfo({
    required List<String> groupIDList,
  }) async {
     return V2TimValueCallback<List<V2TimGroupInfoResult>>(code: 0, desc: "Success", data: <V2TimGroupInfoResult>[]);
  }

  @override
  Future<V2TimCallback> setGroupInfo({
    required V2TimGroupInfo info,
  }) async {
     return V2TimCallback(code: 0, desc: "Success");
  }

  @override
  Future<V2TimCallback> setGroupAttributes({
    required String groupID,
    required Map<String, String> attributes,
  }) async {
     return V2TimCallback(code: 0, desc: "Success");
  }

  @override
  Future<V2TimCallback> deleteGroupAttributes({
    required String groupID,
    required List<String> keys,
  }) async {
     return V2TimCallback(code: 0, desc: "Success");
  }

  @override
  Future<V2TimValueCallback<Map<String, String>>> getGroupAttributes({
    required String groupID,
    List<String>? keys,
  }) async {
     return V2TimValueCallback<Map<String, String>>(code: 0, desc: "Success", data: {});
  }

  @override
  Future<V2TimValueCallback<int>> getGroupOnlineMemberCount({
    required String groupID,
  }) async {
     return V2TimValueCallback<int>(code: 0, desc: "Success", data: 0);
  }

  @override
  Future<V2TimValueCallback<V2TimGroupMemberInfoResult>> getGroupMemberList({
    required String groupID,
    required int filter,
    required String nextSeq,
    int count = 15,
    int offset = 0,
  }) async {
    return V2TimValueCallback<V2TimGroupMemberInfoResult>(code: 0, desc: "Success", data: V2TimGroupMemberInfoResult(nextSeq: "0", memberInfoList: <V2TimGroupMemberFullInfo>[]));
  }

  @override
  Future<V2TimValueCallback<List<V2TimGroupMemberFullInfo>>>
      getGroupMembersInfo({
    required String groupID,
    required List<String> memberList,
  }) async {
     return V2TimValueCallback<List<V2TimGroupMemberFullInfo>>(code: 0, desc: "Success", data: <V2TimGroupMemberFullInfo>[]);
  }

  @override
  Future<V2TimCallback> setGroupMemberInfo({
    required String groupID,
    required String userID,
    String? nameCard,
    Map<String, String>? customInfo,
  }) async {
     return V2TimCallback(code: 0, desc: "Success");
  }

  @override
  Future<V2TimCallback> muteGroupMember({
    required String groupID,
    required String userID,
    required int seconds,
  }) async {
     return V2TimCallback(code: 0, desc: "Success");
  }

  @override
  Future<V2TimValueCallback<List<V2TimGroupMemberOperationResult>>>
      inviteUserToGroup({
    required String groupID,
    required List<String> userList,
  }) async {
     return V2TimValueCallback<List<V2TimGroupMemberOperationResult>>(code: 0, desc: "Success", data: <V2TimGroupMemberOperationResult>[]);
  }

  @override
  Future<V2TimCallback> kickGroupMember({
    required String groupID,
    required List<String> memberList,
    int? duration,
    String? reason,
  }) async {
     return V2TimCallback(code: 0, desc: "Success");
  }

  @override
  Future<V2TimCallback> setGroupMemberRole({
    required String groupID,
    required String userID,
    required int role,
  }) async {
     return V2TimCallback(code: 0, desc: "Success");
  }

  @override
  Future<V2TimCallback> transferGroupOwner({
    required String groupID,
    required String userID,
  }) async {
     return V2TimCallback(code: 0, desc: "Success");
  }

  @override
  Future<V2TimValueCallback<V2TimGroupApplicationResult>>
      getGroupApplicationList() async {
     return V2TimValueCallback<V2TimGroupApplicationResult>(code: 0, desc: "Success", data: V2TimGroupApplicationResult());
  }

  @override
  Future<V2TimCallback> acceptGroupApplication({
    required String groupID,
    String? reason,
    required String fromUser,
    required String toUser,
    int? addTime,
    int? type,
    String? webMessageInstance,
  }) async {
     return V2TimCallback(code: 0, desc: "Success");
  }

  @override
  Future<V2TimCallback> refuseGroupApplication({
    required String groupID,
    String? reason,
    required String fromUser,
    required String toUser,
    required int addTime,
    required int type,
    String? webMessageInstance,
  }) async {
     return V2TimCallback(code: 0, desc: "Success");
  }

  @override
  Future<V2TimCallback> setGroupApplicationRead() async {
     return V2TimCallback(code: 0, desc: "Success");
  }

  @override
  Future<V2TimValueCallback<List<V2TimGroupInfo>>> searchGroups({
    required V2TimGroupSearchParam searchParam,
  }) async {
     return V2TimValueCallback<List<V2TimGroupInfo>>(code: 0, desc: "Success", data: <V2TimGroupInfo>[]);
  }

  @override
  Future<V2TimValueCallback<V2GroupMemberInfoSearchResult>> searchGroupMembers({
    required V2TimGroupMemberSearchParam param,
  }) async {
     return V2TimValueCallback<V2GroupMemberInfoSearchResult>(code: 0, desc: "Success", data: V2GroupMemberInfoSearchResult());
  }

  @override
  Future<V2TimValueCallback<V2TimGroupInfo>> searchGroupByID({
    required String groupID,
  }) async {
     return V2TimValueCallback<V2TimGroupInfo>(code: 0, desc: "Success", data: V2TimGroupInfo(groupID: groupID, groupType: "Public", groupName: "Stub Group"));
  }

  @override
  Future<V2TimCallback> initGroupAttributes({
    required String groupID,
    required Map<String, String> attributes,
  }) async {
     return V2TimCallback(code: 0, desc: "Success");
  }

  @override
  Future<V2TimValueCallback<V2TimMsgCreateInfoResult>> createTextMessage(
      {required String text}) async {
     return V2TimValueCallback<V2TimMsgCreateInfoResult>(code: 0, desc: "Success", data: V2TimMsgCreateInfoResult(id: "stub_msg_id"));
  }

  @override
  Future<V2TimValueCallback<V2TimMsgCreateInfoResult>> createCustomMessage(
      {required String data, String? desc, String? extension}) async {
     return V2TimValueCallback<V2TimMsgCreateInfoResult>(code: 0, desc: "Success", data: V2TimMsgCreateInfoResult(id: "stub_msg_id"));
  }

  @override
  Future<V2TimValueCallback<V2TimMsgCreateInfoResult>> createImageMessage({
    required String imagePath,
    String? imageName,
    Uint8List? fileContent,
    dynamic inputElement,
  }) async {
     return V2TimValueCallback<V2TimMsgCreateInfoResult>(code: 0, desc: "Success", data: V2TimMsgCreateInfoResult(id: "stub_msg_id"));
  }

  @override
  Future<V2TimValueCallback<V2TimMsgCreateInfoResult>> createVideoMessage({
    required String videoFilePath,
    required String? type,
    required int? duration,
    required String? snapshotPath,
    dynamic inputElement,
  }) async {
     return V2TimValueCallback<V2TimMsgCreateInfoResult>(code: 0, desc: "Success", data: V2TimMsgCreateInfoResult(id: "stub_msg_id"));
  }

  @override
  Future<V2TimValueCallback<V2TimMsgCreateInfoResult>> createFaceMessage({
    required int index,
    required String data,
  }) async {
    return V2TimValueCallback<V2TimMsgCreateInfoResult>(code: 0, desc: "Success", data: V2TimMsgCreateInfoResult(id: "stub_msg_id"));
  }

  @override
  Future<V2TimValueCallback<V2TimMsgCreateInfoResult>> createFileMessage(
      {required String filePath,
      required String fileName,
      dynamic inputElement}) async {
    return V2TimValueCallback<V2TimMsgCreateInfoResult>(code: 0, desc: "Success", data: V2TimMsgCreateInfoResult(id: "stub_msg_id"));
  }

  @override
  Future<V2TimValueCallback<V2TimMsgCreateInfoResult>> createTextAtMessage({
    required String text,
    required List<String> atUserList,
  }) async {
    return V2TimValueCallback<V2TimMsgCreateInfoResult>(code: 0, desc: "Success", data: V2TimMsgCreateInfoResult(id: "stub_msg_id"));
  }

  @override
  Future<V2TimValueCallback<V2TimMsgCreateInfoResult>> createLocationMessage({
    required String desc,
    required double longitude,
    required double latitude,
  }) async {
    return V2TimValueCallback<V2TimMsgCreateInfoResult>(code: 0, desc: "Success", data: V2TimMsgCreateInfoResult(id: "stub_msg_id"));
  }

  @override
  Future<V2TimValueCallback<V2TimMsgCreateInfoResult>> createMergerMessage(
      {List<String>? msgIDList,
      required String title,
      required List<String> abstractList,
      required String compatibleText,
      List<String>? webMessageInstanceList}) async {
     return V2TimValueCallback<V2TimMsgCreateInfoResult>(code: 0, desc: "Success", data: V2TimMsgCreateInfoResult(id: "stub_msg_id"));
  }

  @override
  Future<V2TimValueCallback<V2TimMsgCreateInfoResult>> createForwardMessage(
      {String? msgID, String? webMessageInstance}) async {
     return V2TimValueCallback<V2TimMsgCreateInfoResult>(code: 0, desc: "Success", data: V2TimMsgCreateInfoResult(id: "stub_msg_id"));
  }

  /// 3.6.0 新接口统一发送消息实例
  @override
  Future<V2TimValueCallback<V2TimMessage>> sendMessage(
      {String? id,
      required String receiver,
      required String groupID,
      int priority = 0,
      bool onlineUserOnly = false,
      bool? isExcludedFromUnreadCount = false,
      bool? isExcludedFromLastMessage = false,
      bool? isSupportMessageExtension = false,
      bool? isExcludedFromContentModeration = false,
      bool? needReadReceipt = false,
      Map<String, dynamic>? offlinePushInfo,
      String? cloudCustomData, // 云自定义消息字段，只能在消息发送前添加
      String? localCustomData // 本地自定义消息字段
      }) async {
     return V2TimValueCallback<V2TimMessage>(code: 0, desc: "Success", data: V2TimMessage(msgID: id ?? "stub_msg_id", elemType: MessageElemType.V2TIM_ELEM_TYPE_NONE));
  }

  @override

  ///发送高级文本消息
  Future<V2TimValueCallback<V2TimMessage>> sendTextMessage({
    required String text,
    required String receiver,
    required String groupID,
    String? id,
    int priority = 0,
    bool onlineUserOnly = false,
    bool isExcludedFromUnreadCount = false,
    Map<String, dynamic>? offlinePushInfo,
  }) async {
     return V2TimValueCallback<V2TimMessage>(code: 0, desc: "Success", data: V2TimMessage(msgID: id ?? "stub_msg_id", elemType: MessageElemType.V2TIM_ELEM_TYPE_NONE));
  }

  @override
  Future<V2TimValueCallback<V2TimMessage>> sendCustomMessage({
    required String data,
    required String receiver,
    required String groupID,
    int priority = 0,
    String desc = "",
    String extension = "",
    bool onlineUserOnly = false,
    bool isExcludedFromUnreadCount = false,
    Map<String, dynamic>? offlinePushInfo,
  }) async {
     return V2TimValueCallback<V2TimMessage>(code: 0, desc: "Success", data: V2TimMessage(msgID: "stub_msg_id", elemType: MessageElemType.V2TIM_ELEM_TYPE_NONE));
  }

  @override
  Future<V2TimValueCallback<V2TimMessage>> sendImageMessage(
      {required String imagePath,
      required String receiver,
      required String groupID,
      int priority = 0,
      bool onlineUserOnly = false,
      bool isExcludedFromUnreadCount = false,
      Map<String, dynamic>? offlinePushInfo,
      String? fileName,
      Uint8List? fileContent}) async {
     return V2TimValueCallback<V2TimMessage>(code: 0, desc: "Success", data: V2TimMessage(msgID: "stub_msg_id", elemType: MessageElemType.V2TIM_ELEM_TYPE_NONE));
  }

  @override
  Future<V2TimValueCallback<V2TimMessage>> sendVideoMessage({
    required String videoFilePath,
    required String receiver,
    required String type,
    required String snapshotPath,
    required int duration,
    required String groupID,
    int priority = 0,
    bool onlineUserOnly = false,
    bool isExcludedFromUnreadCount = false,
    Map<String, dynamic>? offlinePushInfo,
    String? fileName,
    Uint8List? fileContent,
  }) async {
     return V2TimValueCallback<V2TimMessage>(code: 0, desc: "Success", data: V2TimMessage(msgID: "stub_msg_id", elemType: MessageElemType.V2TIM_ELEM_TYPE_NONE));
  }

  @override
  Future<V2TimValueCallback<V2TimMessage>> sendFileMessage(
      {required String filePath,
      required String fileName,
      required String receiver,
      required String groupID,
      int priority = 0,
      bool onlineUserOnly = false,
      bool isExcludedFromUnreadCount = false,
      Map<String, dynamic>? offlinePushInfo,
      Uint8List? fileContent}) async {
     return V2TimValueCallback<V2TimMessage>(code: 0, desc: "Success", data: V2TimMessage(msgID: "stub_msg_id", elemType: MessageElemType.V2TIM_ELEM_TYPE_NONE));
  }

  @override
  Future<V2TimValueCallback<V2TimMessage>> sendSoundMessage({
    required String soundPath,
    required String receiver,
    required String groupID,
    required int duration,
    int priority = 0,
    bool onlineUserOnly = false,
    bool isExcludedFromUnreadCount = false,
    Map<String, dynamic>? offlinePushInfo,
  }) async {
     return V2TimValueCallback<V2TimMessage>(code: 0, desc: "Success", data: V2TimMessage(msgID: "stub_msg_id", elemType: MessageElemType.V2TIM_ELEM_TYPE_NONE));
  }

  @override
  Future<V2TimValueCallback<V2TimMessage>> sendTextAtMessage({
    required String text,
    required List<String> atUserList,
    required String receiver,
    required String groupID,
    int priority = 0,
    bool onlineUserOnly = false,
    bool isExcludedFromUnreadCount = false,
    Map<String, dynamic>? offlinePushInfo,
  }) async {
     return V2TimValueCallback<V2TimMessage>(code: 0, desc: "Success", data: V2TimMessage(msgID: "stub_msg_id", elemType: MessageElemType.V2TIM_ELEM_TYPE_NONE));
  }

  @override
  Future<V2TimValueCallback<V2TimMessage>> sendLocationMessage({
    required String desc,
    required double longitude,
    required double latitude,
    required String receiver,
    required String groupID,
    int priority = 0,
    bool onlineUserOnly = false,
    bool isExcludedFromUnreadCount = false,
    Map<String, dynamic>? offlinePushInfo,
  }) async {
     return V2TimValueCallback<V2TimMessage>(code: 0, desc: "Success", data: V2TimMessage(msgID: "stub_msg_id", elemType: MessageElemType.V2TIM_ELEM_TYPE_NONE));
  }

  @override
  Future<V2TimValueCallback<V2TimMessage>> sendFaceMessage({
    required int index,
    required String data,
    required String receiver,
    required String groupID,
    int priority = 0,
    bool onlineUserOnly = false,
    bool isExcludedFromUnreadCount = false,
    Map<String, dynamic>? offlinePushInfo,
  }) async {
     return V2TimValueCallback<V2TimMessage>(code: 0, desc: "Success", data: V2TimMessage(msgID: "stub_msg_id", elemType: MessageElemType.V2TIM_ELEM_TYPE_NONE));
  }

  @override
  Future<V2TimValueCallback<V2TimMessage>> sendMergerMessage(
      {required List<String> msgIDList,
      required String title,
      required List<String> abstractList,
      required String compatibleText,
      required String receiver,
      required String groupID,
      int priority = 0,
      bool onlineUserOnly = false,
      bool isExcludedFromUnreadCount = false,
      Map<String, dynamic>? offlinePushInfo,
      List<String>? webMessageInstanceList}) async {
     return V2TimValueCallback<V2TimMessage>(code: 0, desc: "Success", data: V2TimMessage(msgID: "stub_msg_id", elemType: MessageElemType.V2TIM_ELEM_TYPE_NONE));
  }

  @override
  Future<V2TimValueCallback<List<V2TimMessage>>> getC2CHistoryMessageList({
    required String userID,
    required int count,
    String? lastMsgID,
  }) async {
     return V2TimValueCallback<List<V2TimMessage>>(code: 0, desc: "Success", data: <V2TimMessage>[]);
  }

  @override
  Future<V2TimCallback> setLocalCustomData({
    String? msgID,
    required String localCustomData,
  }) async {
     return V2TimCallback(code: 0, desc: "Success");
  }

  @override
  Future<V2TimCallback> setLocalCustomInt({
    String? msgID,
    required int localCustomInt,
  }) async {
     return V2TimCallback(code: 0, desc: "Success");
  }

  @override
  Future<V2TimCallback> setCloudCustomData({
    required String data,
    String? msgID,
  }) async {
     return V2TimCallback(code: 0, desc: "Success");
  }

  @override
  Future<V2TimValueCallback<List<V2TimMessage>>> getGroupHistoryMessageList({
    required String groupID,
    required int count,
    String? lastMsgID,
  }) async {
     return V2TimValueCallback<List<V2TimMessage>>(code: 0, desc: "Success", data: <V2TimMessage>[]);
  }

  @override
  Future<V2TimCallback> revokeMessage(
      {String? msgID, Object? webMessageInstatnce}) async {
    return V2TimCallback(code: 0, desc: "Success");
  }

  @override
  Future<V2TimCallback> markC2CMessageAsRead({
    required String userID,
  }) async {
    return V2TimCallback(code: 0, desc: "Success");
  }

  @override
  Future<LinkedHashMap<dynamic, dynamic>> getHistoryMessageListWithoutFormat({
    int getType = HistoryMessageGetType.V2TIM_GET_LOCAL_OLDER_MSG,
    String? userID,
    String? groupID,
    int lastMsgSeq = -1,
    required int count,
    String? lastMsgID,
    List<int>? messageSeqList,
    int? timeBegin,
    int? timePeriod,
  }) async {
     return LinkedHashMap();
  }

  @override
  Future<V2TimValueCallback<List<V2TimMessage>>> getHistoryMessageList({
    int getType = HistoryMessageGetType.V2TIM_GET_LOCAL_OLDER_MSG,
    String? userID,
    String? groupID,
    int lastMsgSeq = -1,
    required int count,
    List<int>? messageTypeList, // web暂不处理
    String? lastMsgID,
    List<int>? messageSeqList,
    int? timeBegin,
    int? timePeriod,
  }) async {
     return V2TimValueCallback<List<V2TimMessage>>(code: 0, desc: "Success", data: <V2TimMessage>[]);
  }

  @override
  Future<V2TimValueCallback<V2TimMessageListResult>> getHistoryMessageListV2({
    int getType = HistoryMessageGetType.V2TIM_GET_LOCAL_OLDER_MSG,
    String? userID,
    String? groupID,
    int lastMsgSeq = -1,
    required int count,
    List<int>? messageTypeList, // web暂不处理
    String? lastMsgID,
    List<int>? messageSeqList,
    int? timeBegin,
    int? timePeriod,
  }) async {
     return V2TimValueCallback<V2TimMessageListResult>(code: 0, desc: "Success", data: V2TimMessageListResult(isFinished: true, messageList: <V2TimMessage>[]));
  }

  @override
  Future<V2TimValueCallback<V2TimMessage>> sendForwardMessage(
      {required String msgID,
      required String receiver,
      required String groupID,
      int priority = 0,
      bool onlineUserOnly = false,
      bool isExcludedFromUnreadCount = false,
      Map<String, dynamic>? offlinePushInfo,
      String? webMessageInstance}) async {
     return V2TimValueCallback<V2TimMessage>(code: 0, desc: "Success", data: V2TimMessage(msgID: "stub_msg_id", elemType: MessageElemType.V2TIM_ELEM_TYPE_NONE));
  }

  @override
  Future<V2TimValueCallback<V2TimMessage>> reSendMessage(
      {required String msgID,
      bool onlineUserOnly = false,
      Object? webMessageInstatnce}) async {
     return V2TimValueCallback<V2TimMessage>(code: 0, desc: "Success", data: V2TimMessage(msgID: msgID, elemType: MessageElemType.V2TIM_ELEM_TYPE_NONE));
  }

  @override
  Future<V2TimCallback> setC2CReceiveMessageOpt({
    required List<String> userIDList,
    required int opt,
  }) async {
     return V2TimCallback(code: 0, desc: "Success");
  }

  @override
  Future<V2TimValueCallback<List<V2TimReceiveMessageOptInfo>>>
      getC2CReceiveMessageOpt({
    required List<String> userIDList,
  }) async {
     return V2TimValueCallback<List<V2TimReceiveMessageOptInfo>>(code: 0, desc: "Success", data: <V2TimReceiveMessageOptInfo>[]);
  }

  @override
  Future<V2TimCallback> setGroupReceiveMessageOpt({
    required String groupID,
    required int opt,
  }) async {
     return V2TimCallback(code: 0, desc: "Success");
  }

  @override
  Future<V2TimCallback> markGroupMessageAsRead({
    required String groupID,
  }) async {
     return V2TimCallback(code: 0, desc: "Success");
  }

  @override
  Future<V2TimValueCallback<Map<String, String>>> translateText({
    required List<String> texts,
    required String targetLanguage,
    String? sourceLanguage,
  }) async {
     return V2TimValueCallback<Map<String, String>>(code: 0, desc: "Success", data: <String, String>{});
  }

  @override
  Future<V2TimCallback> deleteMessageFromLocalStorage({
    String? msgID,
  }) async {
     return V2TimCallback(code: 0, desc: "Success");
  }
  
  @override
  String addUIKitListener({required dynamic listener}) {
    return "";
  }
  
  @override
  void removeUIKitListener({String? uuid}) {}
  
  @override
  void emitUIKitListener({required Map<String, dynamic> data}) {}

  @override
  Future<V2TimValueCallback<int>> checkAbility({int? ability}) async {
     return V2TimValueCallback<int>(code: 0, desc: "Success", data: 0);
  }
    
  @override
  Future<V2TimValueCallback<List<V2TimUserStatus>>> getUserStatus({
    required List<String> userIDList,
  }) async {
     return V2TimValueCallback<List<V2TimUserStatus>>(code: 0, desc: "Success", data: <V2TimUserStatus>[]);
  }

  @override
  Future<V2TimCallback> setSelfStatus({
    required String status,
  }) async {
     return V2TimCallback(code: 0, desc: "Success");
  }

  @override
  Future<V2TimCallback> subscribeUserStatus({
    required List<String> userIDList,
  }) async {
     return V2TimCallback(code: 0, desc: "Success");
  }

  @override
  Future<V2TimCallback> unsubscribeUserStatus({
    required List<String> userIDList,
  }) async {
     return V2TimCallback(code: 0, desc: "Success");
  }


  @override
  Future<V2TimCallback> subscribeUserInfo({
    required List<String> userIDList,
  }) async {
     return V2TimCallback(code: 0, desc: "Success");
  }

  @override
  Future<V2TimCallback> unsubscribeUserInfo({
    required List<String> userIDList,
  }) async {
     return V2TimCallback(code: 0, desc: "Success");
  }

  @override
  Future<V2TimValueCallback<V2TimUserSearchResult>> searchUsers({required dynamic param}) async {
      return V2TimValueCallback<V2TimUserSearchResult>(code: 0, desc: "Success", data: V2TimUserSearchResult(userInfoList: <V2TimUserInfo>[]));
  }
}
