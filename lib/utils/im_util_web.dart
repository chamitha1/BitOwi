// IM SDK Web target
class IMUtil {
  static bool isInitSuccess = false;
  static bool isLogin = false;
  static IMStatus imStatus = IMStatus.idle;

  static Future<void> initIM(String userId, {bool force = false}) async {}
  static Future<void> initIMSDKAndAddIMListeners(String userId) async {}
  static Future<void> loginIMUser(String userId) async {}
  static Future<void> logoutIMUser() async {}
  static Future<void> setupConnectivityListener() async {}

  static dynamic get sdkInstance => _SDKInstanceStub();
  static dynamic get coreInstance => _CoreInstanceStub();
}

class _SDKInstanceStub {
  dynamic getConversationManager() => _ManagerStub();
  dynamic getMessageManager() => _ManagerStub();
}

class _CoreInstanceStub {
  Future<dynamic> init({
    dynamic config,
    dynamic onTUIKitCallbackListener,
    dynamic language,
    dynamic sdkAppID,
    dynamic loglevel,
    dynamic listener,
  }) async => null;
  Future<dynamic> login({
    required String userID,
    required String userSig,
  }) async => _ResultStub();
  Future<void> logout() async {}
}

class _ManagerStub {
  dynamic getConversationList({dynamic nextSeq, dynamic count}) async =>
      _ResultStub();
  void addConversationListener({dynamic listener}) {}
  void addAdvancedMsgListener({dynamic listener}) {}
}

class _ResultStub {
  dynamic get data => null;
  int get code => 0;
  String get desc => "";
}

class V2TimConversation {
  String? groupID;
  int? unreadCount;
  int? type;
  String? userID;
  String? showName;
  String? draftText;
  dynamic groupAtInfoList;
}

class V2TimMessage {
  bool? isSelf;
  String? faceUrl;
  String? sender;
  dynamic elemType;
  dynamic textElem;
  dynamic customElem;
}

class V2TimAdvancedMsgListener {
  V2TimAdvancedMsgListener({dynamic onRecvNewMessage});
}

class V2TimConversationListener {
  V2TimConversationListener({dynamic onConversationChanged});
}

class V2TimSDKListener {
  V2TimSDKListener({
    dynamic onConnectFailed,
    dynamic onConnectSuccess,
    dynamic onConnecting,
    dynamic onKickedOffline,
    dynamic onSelfInfoUpdated,
    dynamic onUserStatusChanged,
    dynamic onUserSigExpired,
  });
}

enum IMStatus { idle, initialized, loggedIn, kicked }

enum ConvType { c2c, group }

// or
// class IMUtil {
//   static bool isInitSuccess = false;
//   static bool isLogin = false;

//   static Future<void> initIM(
//     String userId, {
//     bool force = false,
//   }) async {
//     // no-op on web
//   }

//   static Future<void> loginIMUser(String userId) async {}
//   static Future<void> logoutIMUser() async {}
// }