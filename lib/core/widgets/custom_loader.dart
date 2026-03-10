import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:lottie/lottie.dart';

class CustomLoader extends StatelessWidget {
  final double width;
  final double height;

  const CustomLoader({super.key, this.width = 100, this.height = 100});

  @override
  Widget build(BuildContext context) {
    final String animationPath = kIsWeb
        ? 'assets/animations/web_loading.json'
        : 'assets/animations/mobile_loading.json';

    return Center(
      child: Lottie.asset(
        animationPath,
        width: width,
        height: height,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(Color(0xff1D5DE5)),
          );
        },
      ),
    );
  }
}
