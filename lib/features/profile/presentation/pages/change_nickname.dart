import 'package:BitOwi/core/theme/app_input_decorations.dart';
import 'package:BitOwi/core/widgets/app_text.dart';
import 'package:BitOwi/core/widgets/common_appbar.dart';
import 'package:BitOwi/core/widgets/custom_loader.dart';
import 'package:BitOwi/core/widgets/input_title_label.dart';
import 'package:BitOwi/core/widgets/primary_button.dart';
import 'package:BitOwi/core/widgets/soft_circular_loader.dart';
import 'package:BitOwi/features/profile/presentation/controllers/settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChangeNickname extends StatelessWidget {
  ChangeNickname({super.key});

  final settingsController = Get.find<SettingsController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: CommonAppBar(title: "Change Nickname", onBack: () => Get.back()),
      body: SafeArea(
        top: false,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InputTitleLable("Nickname"),
                  buildNickNameTextInput(),
                ],
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

  Widget buildNickNameTextInput() {
    return TextFormField(
      controller: settingsController.nickNameController,
      onChanged: (v) => settingsController.nickName.value = v.trim(),
      decoration: AppInputDecorations.textField(
        hintText: "Enter Your Nickname",
      ),
    );
  }

  // SizedBox buildUpdateButton() {
  //   return SizedBox(
  //     width: double.infinity,
  //     height: 56,
  //     child: Obx(() {
  //       final isLoading = settingsController.userNicknameLoading.value;

  //       return ElevatedButton(
  //         onPressed: isLoading ? null : settingsController.onSave,
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
      final isLoading = settingsController.userNicknameLoading.value;

      return PrimaryButton(
        text: "Update",
        enabled: !isLoading,
        onPressed: settingsController.onSave,
        child: isLoading ? const CustomLoader() : null,
      );
    });
  }
}
