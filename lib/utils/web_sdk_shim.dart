/// Pure Dart Stub for Web/Wasm compatibility.
/// No imports from 'package:tencent_cloud_chat_sdk' allowed here.

// -----------------------------------------------------------------------------
// Enums & Constants
// -----------------------------------------------------------------------------

class V2TimSDKListener {
  void onKickedOffline() {}
  void onUserSigExpired() {}
}

class V2TimSimpleMsgListener {
  void onRecvC2CTextMessage(String msgID, V2TimUserInfo sender, String text) {}
  void onRecvC2CCustomMessage(String msgID, V2TimUserInfo sender, String customData) {}
}

class V2TimAdvancedMsgListener {
  void onRecvNewMessage(V2TimMessage msg) {}
}

class V2TimGroupListener {
  void onMemberEnter(String groupID, List<V2TimGroupMemberInfo> memberList) {}
  void onMemberLeave(String groupID, V2TimGroupMemberInfo member) {}
}

class V2TimConversationListener {
  void onConversationChanged(List<V2TimConversation> conversationList) {}
  void onNewConversation(List<V2TimConversation> conversationList) {}
}

// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------
// Enums
// -----------------------------------------------------------------------------

class MessageElemType {
  static const int V2TIM_ELEM_TYPE_NONE = 0;
  static const int V2TIM_ELEM_TYPE_TEXT = 1;
  static const int V2TIM_ELEM_TYPE_CUSTOM = 2;
  static const int V2TIM_ELEM_TYPE_IMAGE = 3;
  static const int V2TIM_ELEM_TYPE_SOUND = 4;
  static const int V2TIM_ELEM_TYPE_VIDEO = 5;
  static const int V2TIM_ELEM_TYPE_FILE = 6;
  static const int V2TIM_ELEM_TYPE_LOCATION = 7;
  static const int V2TIM_ELEM_TYPE_FACE = 8;
  static const int V2TIM_ELEM_TYPE_GROUP_TIPS = 9;
  static const int V2TIM_ELEM_TYPE_MERGER = 10;
  static const int V2TIM_ELEM_TYPE_GROUP_REPORT = 11;
}

class LogLevelEnum {
  static const int V2TIM_LOG_NONE = 0;
  static const int V2TIM_LOG_DEBUG = 3;
  static const int V2TIM_LOG_INFO = 4;
  static const int V2TIM_LOG_WARN = 5;
  static const int V2TIM_LOG_ERROR = 6;
}

class MessagePriorityEnum {
  static const int V2TIM_PRIORITY_DEFAULT = 0;
  static const int V2TIM_PRIORITY_HIGH = 1;
  static const int V2TIM_PRIORITY_NORMAL = 2;
  static const int V2TIM_PRIORITY_LOW = 3;
}

class HistoryMsgGetTypeEnum {
   static const int V2TIM_GET_CLOUD_OLDER_MSG = 1;
   static const int V2TIM_GET_CLOUD_NEWER_MSG = 2;
   static const int V2TIM_GET_LOCAL_OLDER_MSG = 3;
   static const int V2TIM_GET_LOCAL_NEWER_MSG = 4;
}

// -----------------------------------------------------------------------------
// Models
// -----------------------------------------------------------------------------

class V2TimValueCallback<T> {
  final int code;
  final String desc;
  final T? data;
  V2TimValueCallback({required this.code, required this.desc, this.data});
}

class V2TimCallback {
  final int code;
  final String desc;
  V2TimCallback({required this.code, required this.desc});
}

class V2TimUserInfo {
  String? userID;
  String? nickName;
  String? faceUrl;
  V2TimUserInfo({this.userID, this.nickName, this.faceUrl});
}

class V2TimUserFullInfo {
  String? userID;
  String? nickName;
  String? faceUrl;
  String? selfSignature;
  int? gender;
  int? role;
  int? level;
  int? birthDay;
  Map<String, String>? customInfo;
  V2TimUserFullInfo({this.userID, this.nickName, this.faceUrl});
}

class V2TimGroupInfo {
  String? groupID;
  String? groupType;
  String? groupName;
  String? notification;
  String? introduction;
  String? faceUrl;
  String? owner;
  int? createTime;
  int? memberCount;
  V2TimGroupInfo({this.groupID, this.groupName, this.faceUrl});
}

class V2TimGroupMemberInfo {
  String? userID;
  String? nickName;
  String? nameCard;
  String? faceUrl;
  V2TimGroupMemberInfo({this.userID, this.nickName, this.faceUrl});
}

class V2TimGroupMemberFullInfo {
  String? userID;
  String? nickName;
  String? nameCard;
  String? faceUrl;
  int? role;
  int? muteUntil;
  int? joinTime;
  Map<String, String>? customInfo;
  V2TimGroupMemberFullInfo({this.userID, this.nickName});
}

class V2TimConversation {
  String? conversationID;
  int? type;
  String? userID;
  String? groupID;
  String? showName;
  String? faceUrl;
  int? unreadCount;
  V2TimMessage? lastMessage;
  String? draftText;
  int? draftTimestamp;
  bool? isPinned;
  int? recvOpt;
  List<V2TimGroupAtInfo>? groupAtInfoList; 
  V2TimConversation({this.conversationID, this.showName});
}

class V2TimConversationResult {
    String? nextSeq;
    bool? isFinished;
    List<V2TimConversation>? conversationList;
    V2TimConversationResult({this.nextSeq, this.isFinished, this.conversationList});
}

class V2TimMessage {
  String? msgID;
  String? timestamp;
  String? sender;
  String? nickName;
  String? faceUrl;
  String? groupID;
  String? userID;
  int? status;
  int? elemType;
  V2TimTextElem? textElem;
  V2TimCustomElem? customElem;
  V2TimImageElem? imageElem;
  V2TimSoundElem? soundElem;
  V2TimVideoElem? videoElem;
  V2TimFileElem? fileElem;
  V2TimFaceElem? faceElem;
  V2TimLocationElem? locationElem;
  V2TimMergerElem? mergerElem;
  V2TimGroupTipsElem? groupTipsElem;
  bool? isSelf;
  bool? isRead;
  bool? isPeerRead;
  V2TimOfflinePushInfo? offlinePushInfo;
  String? cloudCustomData;
  String? localCustomData;
  
  V2TimMessage({
    this.msgID,
    this.elemType
  });
}

class V2TimTextElem {
  String? text;
  V2TimTextElem({this.text});
}

class V2TimCustomElem {
  String? data;
  String? desc;
  String? extension;
  V2TimCustomElem({this.data, this.desc, this.extension});
}

class V2TimImageElem {
   String? path;
   List<V2TimImage>? imageList;
}
class V2TimImage {
    String? uuid;
    int? type;
    int? size;
    int? width;
    int? height;
    String? url;
}

class V2TimSoundElem {
    String? path;
    String? uuid;
    int? dataSize;
    int? duration;
    String? url;
}

class V2TimVideoElem {
    String? videoPath;
    String? videoUUID;
    int? videoSize;
    int? duration;
    String? videoUrl;
    String? snapshotPath;
    String? snapshotUUID;
    int? snapshotSize;
    int? snapshotWidth;
    int? snapshotHeight;
    String? snapshotUrl;
}

class V2TimFileElem {
    String? path;
    String? uuid;
    String? fileName;
    int? fileSize;
    String? url;
}

class V2TimFaceElem {
    int? index;
    String? data;
}

class V2TimLocationElem {
    String? desc;
    double? longitude;
    double? latitude;
}

class V2TimMergerElem {
    List<String>? abstractList;
    String? title;
    bool? isLayersOverLimit;
}

class V2TimGroupTipsElem {
    int? type;
    int? memberCount;
    List<V2TimGroupMemberInfo>? memberList;
    V2TimGroupMemberInfo? opMember;
    String? groupName;
    String? groupID;
}

class V2TimOfflinePushInfo {
    String? title;
    String? desc;
}

class V2TimGroupAtInfo {
    String? seq;
    int? atType;
}

class V2TimTopicInfo {
  String? topicID;
  String? topicName;
  String? topicFaceUrl;
  String? introduction;
  String? notification;
  bool? isAllMute;
  int? selfMuteTime;
  int? customString;
  int? recvOpt;
  int? draftTimestamp;
  int? unreadCount;
  V2TimMessage? lastMessage;
  V2TimGroupInfo? groupAtInfoList; 
}


class V2TimGroupApplication {
    String? groupID;
    String? fromUser;
    String? fromUserNickName;
    String? fromUserFaceUrl;
    String? toUser;
    String? addTime;
    String? requestMsg;
    String? handledMsg;
    int? type;
    int? handleStatus;
    int? handleResult;
}


class V2TimUserStatus {
    String? userID;
    int? statusType;
    String? customStatus;
}


// -----------------------------------------------------------------------------
// Managers
// -----------------------------------------------------------------------------

class V2TIMConversationManager {
  Future<V2TimValueCallback<V2TimConversationResult>> getConversationList({
    String? nextSeq,
    int? count,
  }) async {
    return V2TimValueCallback(code: 0, desc: "Success", data: V2TimConversationResult(conversationList: [], isFinished: true, nextSeq: "0"));
  }
  
  Future<V2TimValueCallback<V2TimConversation>> getConversation({required String conversationID}) async {
       return V2TimValueCallback(code: 0, desc: "Success", data: null);
  }

  void addConversationListener({required V2TimConversationListener listener}) {}
  void removeConversationListener({V2TimConversationListener? listener}) {}
}

class V2TIMGroupManager {
  Future<V2TimValueCallback<List<V2TimTopicInfo>>> getTopicInfoList({required String groupID, required List<String> topicIDList}) async {
      return V2TimValueCallback(code: 0, desc: "Success", data: []);
  }
}

class V2TIMMessageManager {
  Future<void> addAdvancedMsgListener({required V2TimAdvancedMsgListener listener}) async {}
  Future<void> removeAdvancedMsgListener({V2TimAdvancedMsgListener? listener}) async {}
  
  Future<V2TimValueCallback<V2TimMessage>> sendMessage({
    required String id,
    required String receiver,
    required String groupID,
    required int priority,
    bool onlineUserOnly = false,
    bool isExcludedFromUnreadCount = false,
    Map<String, dynamic>? offlinePushInfo,
    bool? needReadReceipt,
    String? cloudCustomData,
    String? localCustomData,
  }) async {
      return V2TimValueCallback(code: 0, desc: "Success");
  }
}

class V2TIMFriendshipManager {
}

class V2TIMSignalingManager {
}


// -----------------------------------------------------------------------------
// Main Plugin Class
// -----------------------------------------------------------------------------

class V2TIMManager {
  static final V2TIMConversationManager _conversationManager = V2TIMConversationManager();
  static final V2TIMGroupManager _groupManager = V2TIMGroupManager();
  static final V2TIMMessageManager _messageManager = V2TIMMessageManager();
  static final V2TIMFriendshipManager _friendshipManager = V2TIMFriendshipManager();
  static final V2TIMSignalingManager _signalingManager = V2TIMSignalingManager();

  V2TIMConversationManager getConversationManager() {
    return _conversationManager;
  }

  V2TIMGroupManager getGroupManager() {
    return _groupManager;
  }

  V2TIMMessageManager getMessageManager() {
    return _messageManager;
  }

  V2TIMFriendshipManager getFriendshipManager() {
    return _friendshipManager;
  }

  V2TIMSignalingManager getSignalingManager() {
    return _signalingManager;
  }
  
  // Methods
  Future<V2TimValueCallback<bool>> initSDK({
    required int sdkAppID,
    required int loglevel,
    V2TimSDKListener? listener,
    List<dynamic>? plugins,
  }) async {
    return V2TimValueCallback(code: 0, desc: "Success", data: true);
  }

  Future<V2TimCallback> login({required String userID, required String userSig}) async {
     return V2TimCallback(code: 0, desc: "Success");
  }

  Future<V2TimCallback> logout() async {
     return V2TimCallback(code: 0, desc: "logout success");
  }

  Future<V2TimValueCallback<String>> getLoginUser() async {
    return V2TimValueCallback(code: 0, desc: "Success", data: "");
  }

   Future<V2TimValueCallback<List<V2TimUserFullInfo>>> getUsersInfo({required List<String> userIDList}) async {
    return V2TimValueCallback(code: 0, desc: "Success", data: []);
  }
  
  void addSimpleMsgListener(V2TimSimpleMsgListener listener) {}
  void removeSimpleMsgListener(V2TimSimpleMsgListener listener) {}
  void setGroupListener(V2TimGroupListener listener) {}
}

class TencentImSDKPlugin {
  static V2TIMManager v2TIMManager = V2TIMManager();
  static V2TIMManager managerInstance() {
    return v2TIMManager;
  }
}
