import 'package:BitOwi/core/widgets/app_text.dart';
import 'package:BitOwi/core/widgets/common_appbar.dart';
import 'package:BitOwi/core/widgets/custom_loader.dart';
import 'package:BitOwi/core/widgets/primary_button.dart';
import 'package:BitOwi/core/widgets/soft_circular_loader.dart';
import 'package:BitOwi/features/profile/presentation/controllers/settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LocalCurrency extends StatelessWidget {
  LocalCurrency({super.key});

  final settingsController = Get.find<SettingsController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: CommonAppBar(
        title: "Preferred Currency",
        onBack: () => Get.back(),
      ),
      body: SafeArea(
        top: false,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Obx(() {
                  if (settingsController.currencyLoading.value) {
                    return const Center(child: CustomLoader());
                  }

                  if (settingsController.currencyList.isEmpty) {
                    return const Center(child: Text("No currencies available"));
                  }

                  return SingleChildScrollView(
                    child: Column(
                      children: List.generate(
                        settingsController.currencyList.length,
                        (index) {
                          final isSelected =
                              settingsController.selectedIndex.value == index;

                          return GestureDetector(
                            onTap: () => settingsController.onSelect(index),
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? const Color(0xFFEFF6FF)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isSelected
                                      ? const Color(0xFF1D5DE5)
                                      : const Color(0xFFECEFF5),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: AppText.p2Medium(
                                      settingsController.currencyList[index],
                                    ),
                                  ),
                                  Icon(
                                    isSelected
                                        ? Icons.radio_button_checked
                                        : Icons.radio_button_off_outlined,
                                    color: isSelected
                                        ? const Color(0xFF1D5DE5)
                                        : const Color(0xFFDAE0EE),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                }),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 40.0),
                child: buildUpdateButton(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // SizedBox buildUpdateButton() {
  //   return SizedBox(
  //     width: double.infinity,
  //     height: 56,
  //     child: Obx(() {
  //       final isLoading = settingsController.currencyUpdating.value;
  //       final isChanged =
  //           settingsController.selectedIndex.value !=
  //           settingsController.savedIndex.value;

  //       return ElevatedButton(
  //         onPressed: (!isChanged || isLoading)
  //             ? null
  //             : settingsController.onChoseUpdate,
  //         style: ElevatedButton.styleFrom(
  //           backgroundColor: const Color(0xFF1D5DE5),
  //           elevation: 0,
  //           shape: RoundedRectangleBorder(
  //             borderRadius: BorderRadius.circular(12),
  //           ),
  //         ),
  //         child: isLoading
  //             ? const SizedBox(
  //                 width: 22,
  //                 height: 22,
  //                 child: SoftCircularLoader(color: Colors.white),
  //               )
  //             : AppText.p2SemiBold("Update", color: Colors.white),
  //       );
  //     }),
  //   );
  // }

  Widget buildUpdateButton() {
    return Obx(() {
      final isLoading = settingsController.currencyUpdating.value;
      final isChanged =
          settingsController.selectedIndex.value !=
          settingsController.savedIndex.value;

      return PrimaryButton(
        text: "Update",
        enabled: isChanged && !isLoading,
        onPressed: settingsController.onChoseUpdate,
        child: isLoading ? const SoftCircularLoader(color: Colors.white) : null,
      );
    });
  }
}
