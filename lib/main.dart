import 'package:BitDo/features/home/presentation/pages/home_screen.dart';
import 'package:flutter/material.dart';

import 'features/onboarding/presentation/pages/onboarding_screen.dart';

void main() {
  runApp(const BitDo());
}

class BitDo extends StatelessWidget {
  const BitDo({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const OnboardingScreen(),
    );
  }
}
