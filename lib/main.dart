import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'features/onboarding/presentation/pages/onboarding_screen.dart';
import 'l10n/translations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const BitOwi());
}

class BitOwi extends StatelessWidget {
  const BitOwi({super.key});

  @override
  Widget build(BuildContext context) {
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

      home: const OnboardingScreen(),
    );
  }
}
