import 'package:BitDo/features/auth/presentation/pages/signup_screen.dart';
import 'package:BitDo/features/onboarding/presentation/pages/onboarding_screen.dart';

import 'package:flutter/material.dart';

void main() {
  runApp(const BitDo());
}

class BitDo extends StatelessWidget {
  const BitDo({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "BitDo",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: OnboardingScreen(),
    );
  }
}
