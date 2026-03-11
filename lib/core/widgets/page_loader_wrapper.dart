import 'package:BitOwi/core/widgets/custom_loader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PageLoaderWrapper extends StatelessWidget {
  final RxBool isLoading;
  final Widget child;

  const PageLoaderWrapper({
    super.key,
    required this.isLoading,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // The main working page
        child,
        // The global overlay loader sitting at the absolute top
        Obx(() {
          if (isLoading.value) {
            return const CustomLoader();
          }
          return const SizedBox.shrink();
        }),
      ],
    );
  }
}