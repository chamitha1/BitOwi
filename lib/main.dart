import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  runApp(const BitOwi());
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
          }),
          home: null,
          initialRoute: Routes.splash,
          getPages: AppPages.routes,
        );
      },
    );
  }
}
