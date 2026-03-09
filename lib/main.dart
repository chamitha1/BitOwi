import 'package:BitOwi/features/orders/chat/controllers/custom_sticker_package_controller.dart';
import 'package:BitOwi/features/profile/presentation/controllers/settings_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_ume_kit_ui_plus/flutter_ume_kit_ui_plus.dart';
import 'package:flutter_ume_plus/flutter_ume_plus.dart';

import 'package:get/get.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

import 'package:BitOwi/core/services/app_update_service.dart';

import 'features/onboarding/presentation/pages/onboarding_screen.dart';
import 'l10n/translations.dart';
import 'config/routes.dart';
import 'features/auth/presentation/controllers/user_controller.dart';
import 'firebase_options.dart';

FirebaseAnalytics analytics = FirebaseAnalytics.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// 🔥 Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp
  ]);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarDividerColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  if (kReleaseMode) {
    debugPrint = (String? message, {int? wrapWidth}) {};
  }

  if (kDebugMode) {
    PluginManager.instance
      ..register(WidgetInfoInspector())
      ..register(WidgetDetailInspector())
      ..register(ColorSucker())
      ..register(AlignRuler());

    runApp(const UMEWidget(child: BitOwi()));
  } else {
    runApp(const BitOwi());
  }
}

class BitOwi extends StatefulWidget {
  const BitOwi({super.key});

  @override
  State<BitOwi> createState() => _BitOwiState();
}

class _BitOwiState extends State<BitOwi> {

  @override
  void initState() {
    super.initState();

    /// 🔥 Check version after UI loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      AppVersionService.checkVersion(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,

          /// 📊 Automatic screen tracking
          navigatorObservers: [
            FirebaseAnalyticsObserver(analytics: analytics),
          ],

          builder: EasyLoading.init(
            builder: (context, widget) {
              return GestureDetector(
                onTap: () => hideKeyboard(context),
                child: widget,
              );
            },
          ),

          translations: AppTranslations(),
          locale: Get.deviceLocale,
          fallbackLocale: AppTranslations.fallbackLocale,

          supportedLocales: AppTranslations.supportedLocales,

          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],

          initialBinding: BindingsBuilder(() {
            Get.put(UserController(), permanent: true);
            Get.put(SettingsController(), permanent: true);
            Get.put(CustomStickerPackageController(), permanent: true);
          }),

          initialRoute: Routes.splash,
          getPages: AppPages.routes,
        );
      },
    );
  }
}

/// Hide keyboard when tapping outside
void hideKeyboard(BuildContext context) {
  FocusScopeNode currentFocus = FocusScope.of(context);

  if (!currentFocus.hasPrimaryFocus &&
      currentFocus.focusedChild != null) {
    FocusManager.instance.primaryFocus?.unfocus();
  }
}