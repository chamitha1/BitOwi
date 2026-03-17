// import 'package:firebase_analytics/firebase_analytics.dart';
// import 'package:package_info_plus/package_info_plus.dart';
// import 'package:flutter/foundation.dart';

// class AnalyticsService {

//   static final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

//   static bool analyticsEnabled = true;

//   static Future<Map<String, Object>> _defaultParams() async {
//     final packageInfo = await PackageInfo.fromPlatform();

//     String platform;

//     if (kIsWeb) {
//       platform = "Web";
//     } else {
//       switch (defaultTargetPlatform) {
//         case TargetPlatform.android:
//           platform = "Android";
//           break;
//         case TargetPlatform.iOS:
//           platform = "iOS";
//           break;
//         default:
//           platform = "Other";
//       }
//     }

//     return {
//       "app_version": packageInfo.version,
//       "platform": platform,
//     };
//   }

//   static void disableAnalytics() {
//     analyticsEnabled = false;
//     _analytics.setAnalyticsCollectionEnabled(false);
//   }

//   static void enableAnalytics() {
//     analyticsEnabled = true;
//     _analytics.setAnalyticsCollectionEnabled(true);
//   }

//   static Future<void> trackScreen(String screen) async {
//     if (!analyticsEnabled) return;

//     final params = await _defaultParams();

//     await _analytics.logEvent(
//       name: "screen_view",
//       parameters: {
//         "screen_name": screen,
//         ...params
//       },
//     );
//   }

//   static Future<void> login(String method) async {
//     if (!analyticsEnabled) return;

//     final params = await _defaultParams();

//     await _analytics.logLogin(
//       loginMethod: method,
//       parameters: params,
//     );
//   }

//   static Future<void> logout() async {
//     if (!analyticsEnabled) return;

//     final params = await _defaultParams();

//     await _analytics.logEvent(
//       name: "logout",
//       parameters: params,
//     );
//   }

//   static Future<void> signUp(String method) async {
//     if (!analyticsEnabled) return;

//     final params = await _defaultParams();

//     await _analytics.logSignUp(
//       signUpMethod: method,
//       parameters: params,
//     );
//   }

//   static Future<void> buttonClick(String name) async {
//     if (!analyticsEnabled) return;

//     final params = await _defaultParams();

//     await _analytics.logEvent(
//       name: "button_click",
//       parameters: {
//         "button_name": name,
//         ...params
//       },
//     );
//   }

//   static Future<void> errorEvent(String message) async {
//     if (!analyticsEnabled) return;

//     final params = await _defaultParams();

//     await _analytics.logEvent(
//       name: "error_event",
//       parameters: {
//         "error_message": message,
//         ...params
//       },
//     );
//   }

//   static Future<void> setUserType(String userType) async {
//     if (!analyticsEnabled) return;

//     await _analytics.setUserProperty(
//       name: "user_type",
//       value: userType,
//     );
//   }
// }

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AnalyticsService {
  static final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  static bool analyticsEnabled = true;

  static Future<Map<String, Object>> _defaultParams() async {
    final packageInfo = await PackageInfo.fromPlatform();

    String platform;

    if (kIsWeb) {
      platform = "Web";
    } else {
      switch (defaultTargetPlatform) {
        case TargetPlatform.android:
          platform = "Android";
          break;
        case TargetPlatform.iOS:
          platform = "iOS";
          break;
        default:
          platform = "Other";
      }
    }

    return {
      "app_version": packageInfo.version,
      "platform": platform,
    };
  }

  static void disableAnalytics() {
    analyticsEnabled = false;
    _analytics.setAnalyticsCollectionEnabled(false);
  }

  static void enableAnalytics() {
    analyticsEnabled = true;
    _analytics.setAnalyticsCollectionEnabled(true);
  }

  static Future<void> trackScreen(String screen) async {
    if (!analyticsEnabled) return;

    final params = await _defaultParams();

    await _analytics.logEvent(
      name: "screen_view",
      parameters: {
        "screen_name": screen,
        ...params,
      },
    );
  }

  static Future<void> appLaunch() async {
    final params = await _defaultParams();

    await _analytics.logEvent(
      name: "Vo_app_launch",
      parameters: {
        "device_type": kIsWeb ? "web" : "mobile",
        ...params,
      },
    );
  }

  static Future<void> login(String method) async {
    if (!analyticsEnabled) return;

    final params = await _defaultParams();

    await _analytics.logLogin(
      loginMethod: method,
      parameters: params,
    );
  }

  static Future<void> logout() async {
    if (!analyticsEnabled) return;

    final params = await _defaultParams();

    await _analytics.logEvent(
      name: "logout",
      parameters: params,
    );
  }

  static Future<void> signUp(String method) async {
    if (!analyticsEnabled) return;

    final params = await _defaultParams();

    await _analytics.logSignUp(
      signUpMethod: method,
      parameters: params,
    );
  }

  static Future<void> clickEmailRegister() async {
    await _analytics.logEvent(name: "Vo_click_email_register");
  }

  static Future<void> registerSubmit(String method) async {
    final params = await _defaultParams();

    await _analytics.logEvent(
      name: "Vo_register_submit",
      parameters: {
        "register_method": method,
        ...params,
      },
    );
  }

  static Future<void> emailCodeSent() async {
    await _analytics.logEvent(name: "Vo_email_code_sent");
  }

  static Future<void> emailVerifySuccess() async {
    await _analytics.logEvent(name: "Vo_email_code_verify_success");
  }

  static Future<void> kycApproved() async {
    await _analytics.logEvent(name: "Vo_kyc_approved");
  }

  static Future<void> depositInitiate(String assetType) async {
    await _analytics.logEvent(
      name: "Vo_deposit_initiate",
      parameters: {"asset_type": assetType},
    );
  }

  static Future<void> depositSuccess(double amount, String assetType) async {
    await _analytics.logEvent(
      name: "Vo_deposit_success",
      parameters: {
        "amount": amount,
        "asset_type": assetType,
      },
    );
  }

  static Future<void> p2pOrderCreate(String type) async {
    await _analytics.logEvent(
      name: "Vo_p2p_order_create",
      parameters: {"order_type": type},
    );
  }

  static Future<void> p2pOrderComplete(double amount) async {
    await _analytics.logEvent(
      name: "Vo_p2p_order_complete",
      parameters: {"amount": amount},
    );
  }

  /// ----------------------
  /// WITHDRAW
  /// ----------------------
  static Future<void> withdrawInitiate(String assetType) async {
    await _analytics.logEvent(
      name: "Vo_withdraw_initiate",
      parameters: {"asset_type": assetType},
    );
  }

  static Future<void> withdrawSuccess(double amount, String assetType) async {
    await _analytics.logEvent(
      name: "Vo_withdraw_success",
      parameters: {
        "amount": amount,
        "asset_type": assetType,
      },
    );
  }

  static Future<void> buttonClick(String name) async {
    if (!analyticsEnabled) return;

    final params = await _defaultParams();

    await _analytics.logEvent(
      name: "button_click",
      parameters: {
        "button_name": name,
        ...params,
      },
    );
  }

  static Future<void> errorEvent(String message) async {
    if (!analyticsEnabled) return;

    final params = await _defaultParams();

    await _analytics.logEvent(
      name: "error_event",
      parameters: {
        "error_message": message,
        ...params,
      },
    );
  }

  static Future<void> setUserType(String userType) async {
    if (!analyticsEnabled) return;

    await _analytics.setUserProperty(
      name: "user_type",
      value: userType,
    );
  }
}