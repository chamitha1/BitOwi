import 'package:BitOwi/api/im_api.dart';
import 'package:BitOwi/config/config.dart';
import 'package:BitOwi/config/im_config.dart';
import 'package:BitOwi/core/storage/storage_service.dart';
import 'package:BitOwi/features/orders/chat/controllers/custom_sticker_package_controller.dart';
import 'package:BitOwi/utils/app_logger.dart';
import 'package:BitOwi/utils/toast_util.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tencent_cloud_chat_sdk/enum/V2TimSDKListener.dart';
import 'package:tencent_cloud_chat_sdk/enum/log_level_enum.dart';
import 'package:tencent_cloud_chat_uikit/base_widgets/tim_callback.dart';
// import 'package:provider/provider.dart';
import 'package:tencent_cloud_chat_uikit/data_services/core/core_services.dart';
import 'package:tencent_cloud_chat_uikit/data_services/core/tim_uikit_config.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';
import 'package:tencent_cloud_chat_uikit/ui/widgets/emoji.dart';
// import 'package:wallet/api/im_api.dart';
// import 'package:wallet/config/config.dart';
// import 'package:wallet/config/im_config.dart';
// import 'package:wallet/providers/custom_sticker_package.dart';
// import 'package:wallet/utils/local_util.dart';
// import 'package:wallet/utils/toast_util.dart';
// import 'package:tencent_cloud_chat_sdk/tencent_cloud_chat_sdk.dart';
import 'package:tencent_cloud_chat_sdk/manager/v2_tim_manager.dart';

import 'constant.dart';
import 'unicode_emoji.dart';

class IMUtil {
  static final V2TIMManager _sdkInstance = TIMUIKitCore.getSDKInstance();
  static final CoreServicesImpl _coreInstance = TIMUIKitCore.getInstance();

  static V2TIMManager get sdkInstance => _sdkInstance;
  static CoreServicesImpl get coreInstance => _coreInstance;

  static bool isInitSuccess = false;
  static bool isLogin = false;
  static IMStatus imStatus = IMStatus.idle;
  static bool _handledKick = false;

  static Future<void> initIMSDKAndAddIMListeners(String userId) async {
    if (isInitSuccess) return;
    final isInitSuccessful = await _coreInstance.init(
      // You can specify the language here,
      // not providing this field means using the system language.
      config: const TIMUIKitConfig(
        // This status is default to true,
        // its unnecessary to specify this if you tend to use online status.
        isShowOnlineStatus: false,
        isCheckDiskStorageSpace: true,
      ),
      // onWebLoginSuccess: getLoginUserInfo,
      onTUIKitCallbackListener: (TIMCallback callbackValue) {
        switch (callbackValue.type) {
          case TIMCallbackType.INFO:
            // Shows the recommend text for info callback directly
            if (callbackValue.infoRecommendText != null &&
                callbackValue.infoRecommendText!.isNotEmpty) {
              // ToastUtil.showToast(callbackValue.infoRecommendText!);
            }
            break;

          case TIMCallbackType.API_ERROR:
            // Prints the API error to console, and shows the error message.
            AppLogger.d(
              "Error from TUIKit: ${callbackValue.errorMsg}, Code: ${callbackValue.errorCode}",
            );
            if (callbackValue.errorCode == 10004 &&
                callbackValue.errorMsg!.contains("not support @all")) {
              // ToastUtil.showError(callbackValue.errorMsg!);
              AppLogger.d(callbackValue.errorMsg!);
            } else if (callbackValue.errorCode == 10007 ||
                callbackValue.errorCode == 10010) {
              // 10007 未加入群；10010 群不存在
            } else if (callbackValue.errorCode == 10017) {
              // ToastUtil.showError(callbackValue.errorMsg ?? 'You are muted');
              AppLogger.d(callbackValue.errorMsg ?? 'You are muted');
            } else if (callbackValue.errorCode == -1) {
            } else {
              // ToastUtil.showError(
              //     callbackValue.errorMsg ?? callbackValue.errorCode.toString());
              AppLogger.d(
                callbackValue.errorMsg ?? callbackValue.errorCode.toString(),
              );
            }
            break;
          case TIMCallbackType.FLUTTER_ERROR:
          default:
            // prints the stack trace to console or shows the catch error
            if (callbackValue.catchError != null) {
              if (!AppConfig.isBuildApk) {
                // ToastUtil.showError(callbackValue.catchError.toString());
                AppLogger.d(callbackValue.catchError.toString());
              }
            } else {
              AppLogger.e(callbackValue, stackTrace: callbackValue.stackTrace);
            }
        }
      },
      language: LanguageEnum.en,
      sdkAppID: IMConfig.sdkappid,
      loglevel: LogLevelEnum.V2TIM_LOG_DEBUG,
      listener: V2TimSDKListener(
        onConnectFailed: (code, error) {
          AppLogger.d('$code');
          AppLogger.d(error);
        },
        onConnectSuccess: () {
          // Connected to Tencent IM server success
          AppLogger.d("IM connected successfully");
        },
        onConnecting: () {},
        onKickedOffline: () {
          ToastUtil.showError("IM onKickedOffline");

          // The current user has been kicked off, by other devices
          onKickedOffline(userId);
        },
        onSelfInfoUpdated: (info) {},
        onUserStatusChanged: (userStatusList) {
          AppLogger.d(userStatusList.toString());
        },
        onUserSigExpired: () {
          ToastUtil.showError("IM onUserSigExpired");
          onKickedOffline(userId);
        },
      ),
    );
    isInitSuccess = isInitSuccessful ?? false;
    if (!isInitSuccess) {
      ToastUtil.showError("IM init error");
    }
  }

  // static Future<void> onKickedOffline(String userId) async {
  //   if (await StorageService.getToken() != null) {
  //     IMUtil.loginIMUser(userId);
  //   }
  // }
  static Future<void> onKickedOffline(String userId) async {
    if (_handledKick) return;
    _handledKick = true;

    AppLogger.d("💬🚨 IM kicked offline");

    isLogin = false;
    imStatus = IMStatus.kicked;

    try {
      logoutIMUser();
    } catch (_) {}

    // ToastUtil.showError();
    AppLogger.d("Your account was logged in on another device");
  }

  /// Set custom emoticon
  static Future<void> setCustomSticker(BuildContext context) async {
    List<CustomStickerPackage> customStickerPackageList = [];

    // Emoticon item 1: Use the Emoji Unicode expression list in string form. Can be embedded in text content.
    // Solution A: Use Emoji Unicode list, as String. Can be added to text messages.
    final defEmojiList = emojiData.asMap().keys.map((emojiIndex) {
      final emoji = Emoji.fromJson(emojiData[emojiIndex]);
      return CustomSticker(
        index: emojiIndex,
        name: emoji.name,
        unicode: emoji.unicode,
      );
    }).toList();
    customStickerPackageList.add(
      CustomStickerPackage(
        name: "defaultEmoji",
        stickerList: defEmojiList,
        menuItem: defEmojiList[0],
      ),
    );

    // Emoticon item 2: Use the picture emoticon package you provided.
    // Solution B: Use the image sticker.
    customStickerPackageList.addAll(
      Const.emojiList.map((customEmojiPackage) {
        return CustomStickerPackage(
          name: customEmojiPackage.name,
          baseUrl: "assets/images/chat_face/${customEmojiPackage.name}",
          isEmoji: customEmojiPackage.isEmoji,
          stickerList: customEmojiPackage.list
              .asMap()
              .keys
              .map(
                (idx) => CustomSticker(
                  index: idx,
                  name: customEmojiPackage.list[idx],
                ),
              )
              .toList(),
          menuItem: CustomSticker(index: 0, name: customEmojiPackage.icon),
        );
      }).toList(),
    );
    // Provider.of<CustomStickerPackageData>(context, listen: false)
    //     .customStickerPackageList = customStickerPackageList;
    final stickerController = Get.find<CustomStickerPackageController>();

    stickerController.customStickerPackageList = customStickerPackageList;
  }

  // static Future<void> loginIMUser(String userId) async {
  //   try {
  //     final sign = await IMApi.getSign();
  //     AppLogger.d("💬 IMApi sign");

  //     final data = await _coreInstance.login(userID: userId, userSig: sign);
  //     AppLogger.d("💬 login");

  //     if (data.code != 0) {
  //       final option1 = data.desc;
  //       AppLogger.d('error---> $option1');
  //       AppLogger.d('error---> sign $sign');
  //       AppLogger.d('error---> uid $userId');
  //       ToastUtil.showError('im_util $option1');
  //       return;
  //     } else {
  //       isLogin = true;
  //     }
  //   } catch (e) {
  //     AppLogger.d('---im-----error-----');
  //     AppLogger.e(e);
  //   }
  // }

  static Future<void> loginIMUser(String userId) async {
    // Hard block if kicked
    if (imStatus == IMStatus.kicked) {
      AppLogger.d("💬 Login blocked — user is kicked");
      return;
    }

    try {
      final sign = await IMApi.getSign();
      AppLogger.d("💬 IMApi sign");

      final res = await _coreInstance.login(userID: userId, userSig: sign);
      AppLogger.d("💬 login");

      if (res.code == 0) {
        AppLogger.d("💬 IM login success");

        isLogin = true;
        imStatus = IMStatus.loggedIn;

        //  reset kick guard after successful login
        _handledKick = false;
      } else {
        AppLogger.e("💬 IM login failed — code=${res.code}, desc=${res.desc}");
      }
    } catch (e) {
      AppLogger.d('---im-----error-----');
      AppLogger.e(e);
    }
  }

  static Future<void> logoutIMUser() async {
    try {
      await _coreInstance.logout();
      isLogin = false;
    } catch (e) {
      AppLogger.e(e);
    }
  }

  static Future<void> initIM(
    String userId, {
    bool force = false, // 🔑 NEW
  }) async {
    // //  Never auto-reconnect if kicked
    // if (imStatus == IMStatus.kicked) {
    //   AppLogger.d("💬 IM init blocked — user is kicked");
    //   return;
    // }
    // 🚨 Never auto-reconnect if kicked
    if (imStatus == IMStatus.kicked && !force) {
      AppLogger.d("💬 IM init blocked — user is kicked");
      return;
    }

    // 🔓 Manual reconnect → clear kicked state
    if (force && imStatus == IMStatus.kicked) {
      AppLogger.d("💬 Manual reconnect — clearing kick state");
      imStatus = IMStatus.idle;
    }

    //  Init SDK (only once)
    if (!IMUtil.isInitSuccess) {
      try {
        // ToastUtil.showLoading();
        await IMUtil.initIMSDKAndAddIMListeners(userId);
        isInitSuccess = true;
        imStatus = IMStatus.initialized;
        // ToastUtil.dismiss();
      } catch (e) {
        AppLogger.d("💬 IM init failed");
        // ToastUtil.dismiss();
        return;
      }
    }
    // I18nUtils(null, 'zh-Hans');
    // I18nUtils(null, 'en');
    if (!IMUtil.isLogin) {
      try {
        // ToastUtil.showLoading();
        await IMUtil.loginIMUser(userId);
        // ToastUtil.dismiss();
      } catch (e) {
        AppLogger.d("💬 IM login failed");
        // ToastUtil.dismiss();
        return;
      }
    }
  }
}

enum IMStatus { idle, initialized, loggedIn, kicked }
