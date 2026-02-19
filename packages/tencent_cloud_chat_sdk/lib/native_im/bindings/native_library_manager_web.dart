import 'package:tencent_cloud_chat_sdk/enum/V2TimAdvancedMsgListener.dart';
import 'package:tencent_cloud_chat_sdk/enum/V2TimCommunityListener.dart';
import 'package:tencent_cloud_chat_sdk/enum/V2TimConversationListener.dart';
import 'package:tencent_cloud_chat_sdk/enum/V2TimFriendshipListener.dart';
import 'package:tencent_cloud_chat_sdk/enum/V2TimGroupListener.dart';
import 'package:tencent_cloud_chat_sdk/enum/V2TimSDKListener.dart';
import 'package:tencent_cloud_chat_sdk/enum/V2TimSignalingListener.dart';

class NativeLibraryManager {
  static NativeLibraryManager instance = NativeLibraryManager();

  static void setSdkListener(V2TimSDKListener listener) {}
  static void setAdvancedMessageListener(V2TimAdvancedMsgListener listener) {}
  static void setConversationListener(V2TimConversationListener listener) {}
  static void setGroupListener(V2TimGroupListener listener) {}
  static void setCommunityListener(V2TimCommunityListener listener) {}
  static void setFriendshipListener(V2TimFriendshipListener listener) {}
  static void setSignalingListener(V2TimSignalingListener listener) {}
  
  static void registerPort() {}
  static void unregisterPort() {}
}
