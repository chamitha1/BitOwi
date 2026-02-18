import 'package:tencent_cloud_chat_sdk/web/manager/v2_tim_manager.dart' as web_pkg;
import 'package:tencent_cloud_chat_sdk/web/manager/v2_tim_conversation_manager.dart' as web_conv;
import 'package:tencent_cloud_chat_sdk/web/manager/v2_tim_group_manager.dart' as web_group;
import 'package:tencent_cloud_chat_sdk/web/manager/v2_tim_message_manager.dart' as web_msg;
import 'package:tencent_cloud_chat_sdk/web/manager/v2_tim_friendship_manager.dart' as web_friend;
import 'package:tencent_cloud_chat_sdk/web/manager/v2_tim_signaling_manager.dart' as web_signaling;

import 'package:tencent_cloud_chat_sdk/web/compatible_models/v2_tim_value_callback.dart';
import 'package:tencent_cloud_chat_sdk/web/compatible_models/v2_tim_callback.dart';
import 'package:tencent_cloud_chat_sdk/enum/V2TimSDKListener.dart';
import 'package:tencent_cloud_chat_sdk/enum/V2TimSimpleMsgListener.dart';
import 'package:tencent_cloud_chat_sdk/enum/V2TimGroupListener.dart';
import 'package:tencent_cloud_chat_sdk/web/compatible_models/v2_tim_user_full_info.dart';
import 'package:tencent_cloud_chat_sdk/web/compatible_models/v2_tim_conversation_result.dart';
import 'package:tencent_cloud_chat_sdk/enum/V2TimAdvancedMsgListener.dart';
import 'package:tencent_cloud_chat_sdk/enum/V2TimConversationListener.dart';

  // Shim Classes
class V2TIMConversationManager {
  final web_conv.V2TIMConversationManager _webManager;
  final Map<V2TimConversationListener, String> _listeners = {};

  V2TIMConversationManager(this._webManager);

  Future<V2TimValueCallback<V2TimConversationResult>> getConversationList({
    String? nextSeq,
    int? count,
  }) async {
    // Web SDK ignores params, but we accept them to match Native API
    return _webManager.getConversationList();
  }
  
  void addConversationListener({required V2TimConversationListener listener}) {
    String uuid = DateTime.now().microsecondsSinceEpoch.toString();
    _listeners[listener] = uuid;
    _webManager.setConversationListener(listener, uuid);
  }

  void removeConversationListener({V2TimConversationListener? listener}) {
     String? uuid;
     if (listener != null) {
       uuid = _listeners[listener];
       _listeners.remove(listener);
     } else {
       _listeners.clear();
     }
     _webManager.removeConversationListener(listenerUuid: uuid, hasListener: listener != null);
  }
}

class V2TIMMessageManager {
  final web_msg.V2TIMMessageManager _webManager;
  final Map<V2TimAdvancedMsgListener, String> _listeners = {};

  V2TIMMessageManager(this._webManager);

  Future<void> addAdvancedMsgListener({required V2TimAdvancedMsgListener listener}) async {
    String uuid = DateTime.now().microsecondsSinceEpoch.toString();
    _listeners[listener] = uuid;
    // Web API uses positional args
    _webManager.addAdvancedMsgListener(listener, uuid);
  }
  
  Future<void> removeAdvancedMsgListener({V2TimAdvancedMsgListener? listener}) async {
    String? uuid;
    if (listener != null) {
      uuid = _listeners[listener];
      _listeners.remove(listener);
    } else {
      _listeners.clear();
    }
    // Web API uses positional args
    _webManager.removeAdvancedMsgListener(uuid, listener != null);
  }
}

class V2TIMGroupManager {
  final web_group.V2TIMGroupManager _webManager;
  V2TIMGroupManager(this._webManager);
   // methods if needed
}

class V2TIMFriendshipManager {
  final web_friend.V2TIMFriendshipManager _webManager;
  V2TIMFriendshipManager(this._webManager);
}

class V2TIMSignalingManager {
  final web_signaling.V2TIMSignalingManager _webManager;
  V2TIMSignalingManager(this._webManager);
}

/// Shim class to align Web SDK API with Native SDK API
class V2TIMManager {
  // Underlying Web SDK Managers
  static final web_pkg.V2TIMManager _webManager = web_pkg.V2TIMManager();
  
  // Wrap them in our Shim classes
  static final V2TIMConversationManager _conversationManager = V2TIMConversationManager(web_conv.V2TIMConversationManager());
  static final V2TIMGroupManager _groupManager = V2TIMGroupManager(web_group.V2TIMGroupManager());
  static final V2TIMMessageManager _messageManager = V2TIMMessageManager(web_msg.V2TIMMessageManager());
  static final V2TIMFriendshipManager _friendshipManager = V2TIMFriendshipManager(web_friend.V2TIMFriendshipManager());
  static final V2TIMSignalingManager _signalingManager = V2TIMSignalingManager(web_signaling.V2TIMSignalingManager());

  /// Getters for Sub-Managers (Matching Native API)
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
  
  // Method Delegation
  Future<V2TimValueCallback<bool>> initSDK({
    required int sdkAppID,
    required int loglevel,
    V2TimSDKListener? listener,
    List<dynamic>? plugins,
  }) async {
    // Note: Web initSDK signature might differ slightly in naming or params
    return _webManager.initSDK(sdkAppID: sdkAppID, listener: listener);
  }

  Future<V2TimCallback> login({required String userID, required String userSig}) {
    return _webManager.login(userID: userID, userSig: userSig);
  }

  Future<V2TimCallback> logout() async {
     final res = await _webManager.logout();
     if (res is V2TimCallback) {
       return res;
     }
     return V2TimCallback(code: 0, desc: "logout success");
  }

  Future<V2TimValueCallback<String>> getLoginUser() {
    return _webManager.getLoginUser();
  }

   Future<V2TimValueCallback<List<V2TimUserFullInfo>>> getUsersInfo({required List<String> userIDList}) {
    return _webManager.getUsersInfo({"userIDList": userIDList});
  }
  
  void addSimpleMsgListener(V2TimSimpleMsgListener listener) {
    _webManager.addSimpleMsgListener(listener);
  }

  void removeSimpleMsgListener(V2TimSimpleMsgListener listener) {
    _webManager.removeSimpleMsgListener();
  }

  void setGroupListener(V2TimGroupListener listener) {
    _webManager.setGroupListener(listener, null);
  }
}

class TencentImSDKPlugin {
  static V2TIMManager v2TIMManager = V2TIMManager();
  static V2TIMManager managerInstance() {
    return v2TIMManager;
  }
}
