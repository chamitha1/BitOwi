import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            //background: linear-gradient(180deg, #ECEFF5 0%, #DAE0EE 100%);
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xffECEFF5), Color(0xffDAE0EE)],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset('assets/images/onboarding/splash.svg'),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
