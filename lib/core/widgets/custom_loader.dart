import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:lottie/lottie.dart';

class CustomLoader extends StatelessWidget {
  final double width;
  final double height;

  const CustomLoader({super.key, this.width = 100, this.height = 100});

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return Align(
        alignment: Alignment.topCenter,
        child: Lottie.asset(
          'assets/animations/web_loading.json',
          width: MediaQuery.of(context).size.width * 0.9,
          height: height + 1,
          fit: BoxFit.fitWidth,
          errorBuilder: (context, error, stackTrace) {
            return const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(Color(0xff1D5DE5)),
            );
          },
        ),
      );
    }

    return Center(
      child: Lottie.asset(
        'assets/animations/mobile_loading.json',
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
