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
import 'features/onboarding/presentation/pages/onboarding_screen.dart';
import 'l10n/translations.dart';
import 'config/routes.dart';
import 'features/auth/presentation/controllers/user_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

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
    // Disable debugPrint
    debugPrint = (String? message, {int? wrapWidth}) {};
  }

  if (kDebugMode) {
    PluginManager.instance
      ..register(WidgetInfoInspector())
      ..register(WidgetDetailInspector())
      ..register(ColorSucker())
      ..register(AlignRuler());
    // Run with UME Overlay
    runApp(const UMEWidget(child: BitOwi()));
  } else {
    runApp(const BitOwi());
  }
}

class BitOwi extends StatelessWidget {
  const BitOwi({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,

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
          // home: null,
          initialRoute: Routes.splash,
          getPages: AppPages.routes,
        );
      },
    );
  }
}

/// Click on another area of ​​the screen to hide the keyboard
void hideKeyboard(BuildContext context) {
  FocusScopeNode currentFocus = FocusScope.of(context);
  if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
    FocusManager.instance.primaryFocus?.unfocus();
  }
}
