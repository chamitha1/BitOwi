import 'package:BitOwi/core/theme/app_input_decorations.dart';
import 'package:BitOwi/core/widgets/common_appbar.dart';
import 'package:BitOwi/core/widgets/common_image.dart';
import 'package:BitOwi/core/widgets/custom_snackbar.dart';
import 'package:BitOwi/core/widgets/primary_button.dart';
import 'package:BitOwi/core/widgets/soft_circular_loader.dart';
import 'package:BitOwi/features/merchant/presentation/controllers/kyc_personal_information_controller.dart';
import 'package:BitOwi/features/merchant/presentation/widgets/expiry_calendar.dart';
import 'package:BitOwi/features/merchant/presentation/widgets/kyc_id_photo_ui.dart';
import 'package:BitOwi/core/widgets/input_title_label.dart';
import 'package:BitOwi/features/merchant/presentation/widgets/personal_information_status_page.dart';
import 'package:BitOwi/models/country_list_res.dart';
import 'package:BitOwi/models/dict.dart';
import 'package:BitOwi/utils/string_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class KycPersonalInformationPage extends StatelessWidget {
  KycPersonalInformationPage({super.key});

  final KycPersonalInformationController controller =
      Get.find<KycPersonalInformationController>();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // prevent automatic pop
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;

        // Handle system back + gesture back
        Get.back(result: controller.merchantStatus.value != '-1');
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF6F9FF),
        appBar: CommonAppBar(
          title: "Personal Information",
          onBack: () =>
              Get.back(result: controller.merchantStatus.value != '-1'),
        ),

        body: SafeArea(
          child: Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: SoftCircularLoader());
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: controller.merchantStatus.value == '-1'
                  ? personalInfoInputContent(context)
                  : SuccessfullySubmittedKYCInfo(
                      countryIndex: controller.countryIndex.value, //
                      countryList: controller.countryList, //
                      idTypeIndex: controller.idTypeIndex.value, //
                      idTypeList: controller.idTypeList, //
                      name: controller.name.value, //
                      idNumber: controller.idNumber.value, //
                      expiryDate: controller.selectedExpiryDate.value, //
                      merchantStatus: controller.merchantStatus.value,
                      identifyOrderLatestSubmittedInfoStatus:
                          controller.latestSubmittedInfo?.status ?? '0',
                    ),
            );
          }),
        ),
      ),
    );
  }

  //* -- select nationality methods --
  GestureDetector buildNationalitySelection() {
    // CountryListRes? country;
    // if (countryIndex > -1) {
    //   country = countryList[countryIndex];
    // }
    // final locale = Get.locale;
    // String countryName = '';
    // if (locale != null && locale.toString() == 'zh_CN') {
    //   countryName = country?.chineseName ?? '';
    // } else {
    //   countryName = country?.interName ?? '';
    // }
    CountryListRes? country;

    // if (countryIndex >= 0 && countryIndex < countryList.length) {
    //   country = countryList[countryIndex];
    // }
    // SAFE index access via controller
    if (controller.countryIndex.value >= 0 &&
        controller.countryIndex.value < controller.countryList.length) {
      country = controller.countryList[controller.countryIndex.value];
    }

    final locale = Get.locale;
    final bool isChinese = locale?.toString() == 'zh_CN';

    final String countryName = country == null
        ? "Select Your Nationality"
        : isChinese
        ? country.chineseName
        : country.interName;

    final bool hasSelection = country != null;

    return GestureDetector(
      onTap: controller.countryList.isEmpty ? () {} : areaTapNationality,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                // ---------- FLAG ----------
                if (hasSelection) ...[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CommonImage(
                      country.pic,
                      fit: BoxFit.cover,
                      width: 24,
                      height: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                ],

                // ---------- COUNTRY NAME ----------
                Text(
                  countryName,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: hasSelection
                        ? const Color(0xFF151E2F)
                        : const Color(0xFF717F9A),
                  ),
                ),
              ],
            ),

            // ---------- DROPDOWN ICON ----------
            const Icon(
              Icons.keyboard_arrow_down,
              color: Color(0xFF2E3D5B),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> areaTapNationality() async {
    try {
      final result = await _showNationalityBottomSheet();

      if (result != null && result != controller.countryIndex.value) {
        controller.countryIndex.value = result;
      }
    } catch (e) {
      debugPrint('areaTapNationality error: $e');
    }
  }

  Future<int?> _showNationalityBottomSheet() async {
    int? tempSelectedIndex = controller.countryIndex.value >= 0
        ? controller.countryIndex.value
        : null;

    final bool isChinese = Get.locale?.toString() == 'zh_CN';

    return showModalBottomSheet<int>(
      context: Get.context!,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.7,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Select Nationality",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: const Icon(Icons.close),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: controller.countryList.length,
                      itemBuilder: (context, index) {
                        final nationality = controller.countryList[index];
                        final isSelected = tempSelectedIndex == index;

                        final name = isChinese
                            ? nationality.chineseName
                            : nationality.interName;

                        return GestureDetector(
                          onTap: () {
                            setModalState(() {
                              tempSelectedIndex = index;
                            });
                          },
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
                                ClipOval(
                                  child: CommonImage(
                                    nationality.pic,
                                    fit: BoxFit.cover,
                                    width: 48,
                                    height: 48,
                                  ),
                                ),
                                SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    name,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Color(0xFF151E2F),
                                      fontWeight: FontWeight.w500,
                                    ),
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
                  // Padding(
                  //   padding: const EdgeInsets.all(20),
                  //   child: SizedBox(
                  //     width: double.infinity,
                  //     height: 56,
                  //     child: ElevatedButton(
                  //       onPressed: tempSelectedIndex == null
                  //           ? null
                  //           : () => Navigator.pop(context, tempSelectedIndex),
                  //       style: ElevatedButton.styleFrom(
                  //         backgroundColor: tempSelectedIndex == null
                  //             ? const Color(0xFFB9C6E2)
                  //             : const Color(0xFF1D5DE5),
                  //         elevation: 0,
                  //         disabledBackgroundColor: const Color(0xFFB9C6E2),
                  //         shape: RoundedRectangleBorder(
                  //           borderRadius: BorderRadius.circular(12),
                  //         ),
                  //       ),
                  //       child: const Text(
                  //         "Continue",
                  //         style: TextStyle(
                  //           fontFamily: 'Inter',
                  //           fontWeight: FontWeight.w600,
                  //           fontSize: 16,
                  //           color: Colors.white,
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: PrimaryButton(
                      text: "Continue",
                      enabled: tempSelectedIndex != null,
                      onPressed: () =>
                          Navigator.pop(context, tempSelectedIndex),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            );
          },
        );
      },
    );
  }

  //* -- select id type methods --
  Widget buildIdTypeSelection() {
    return Obx(() {
      Dict? idType;

      // ✅ SAFE access from controller
      if (controller.idTypeIndex.value >= 0 &&
          controller.idTypeIndex.value < controller.idTypeList.length) {
        idType = controller.idTypeList[controller.idTypeIndex.value];
      }

      final bool hasSelection = idType != null;
      final String displayText = hasSelection
          ? StringUtils.toTitleCase(idType.value)
          : "Select Type";

      return GestureDetector(
        onTap: controller.idTypeList.isEmpty ? () {} : areaTapIdType,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                displayText,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: hasSelection
                      ? const Color(0xFF151E2F)
                      : const Color(0xFF717F9A),
                ),
              ),
              const Icon(
                Icons.keyboard_arrow_down,
                color: Color(0xFF2E3D5B),
                size: 20,
              ),
            ],
          ),
        ),
      );
    });
  }

  Future<void> areaTapIdType() async {
    try {
      final result = await _showIdTypeBottomSheet();

      if (result != null && result != controller.idTypeIndex.value) {
        controller.idTypeIndex.value = result;
      }
    } catch (e) {
      debugPrint('areaTapIdType error: $e');
    }
  }

  Future<int?> _showIdTypeBottomSheet() async {
    int? tempSelectedIndex = controller.idTypeIndex.value >= 0
        ? controller.idTypeIndex.value
        : null;

    return showModalBottomSheet<int>(
      context: Get.context!, // ✅ GetX context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.65,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Color(0xFFE2E8F0),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),

                  // ---------- HEADER ----------
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Select ID Type",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: const Icon(Icons.close),
                        ),
                      ],
                    ),
                  ),

                  // ---------- LIST ----------
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: controller.idTypeList.length,
                      itemBuilder: (context, index) {
                        final Dict idType = controller.idTypeList[index];
                        final bool isSelected = tempSelectedIndex == index;

                        return GestureDetector(
                          onTap: () {
                            setModalState(() {
                              tempSelectedIndex = index;
                            });
                          },
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
                                SvgPicture.asset(
                                  idType.value.toLowerCase() == "passport"
                                      ? "assets/icons/merchant_details/passport.svg"
                                      : "assets/icons/merchant_details/personalcard.svg",
                                  height: 48,
                                  width: 48,
                                  colorFilter: ColorFilter.mode(
                                    isSelected
                                        ? const Color(0xFF1D5DE5)
                                        : const Color(0xFF47464F),
                                    BlendMode.srcIn,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Text(
                                    StringUtils.toTitleCase(idType.value),
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: isSelected
                                          ? const Color(0xFF1D5DE5)
                                          : const Color(0xFF151E2F),
                                    ),
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

                  // ---------- CONTINUE ----------
                  // Padding(
                  //   padding: const EdgeInsets.all(20),
                  //   child: SizedBox(
                  //     width: double.infinity,
                  //     height: 56,
                  //     child: ElevatedButton(
                  //       onPressed: tempSelectedIndex == null
                  //           ? null
                  //           : () {
                  //               Navigator.pop(context, tempSelectedIndex);
                  //             },
                  //       style: ElevatedButton.styleFrom(
                  //         backgroundColor: tempSelectedIndex == null
                  //             ? const Color(0xFFB9C6E2)
                  //             : const Color(0xFF1D5DE5),
                  //         elevation: 0,
                  //         disabledBackgroundColor: const Color(0xFFB9C6E2),
                  //         shape: RoundedRectangleBorder(
                  //           borderRadius: BorderRadius.circular(12),
                  //         ),
                  //       ),
                  //       child: const Text(
                  //         "Continue",
                  //         style: TextStyle(
                  //           fontFamily: 'Inter',
                  //           fontWeight: FontWeight.w600,
                  //           fontSize: 16,
                  //           color: Colors.white,
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: PrimaryButton(
                      text: "Continue",
                      enabled: tempSelectedIndex != null,
                      onPressed: () {
                        Navigator.pop(context, tempSelectedIndex);
                      },
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            );
          },
        );
      },
    );
  }

  //* -- input name methods --
  TextFormField buildNameTextInput() {
    return TextFormField(
      controller: controller.nameController,
      onChanged: (v) => controller.name.value = v.trim(),
      decoration: AppInputDecorations.textField(hintText: "Enter Your Name"),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return "Name is required";
        }
        return null;
      },
    );
  }

  //* -- input Id methods --
  TextFormField buildIdTextInput() {
    return TextFormField(
      controller: controller.idController,
      onChanged: (v) => controller.idNumber.value = v.trim(),
      decoration: AppInputDecorations.textField(
        hintText: "Enter Your ID Number",
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return "ID number is required";
        }
        return null;
      },
    );
  }

  //* -- select expiry methods --

  Column buildExpirySelection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Select Date Field
        GestureDetector(
          onTap: () {
            controller.syncFocusedDay(); // ✅ focus today or selected date
            controller.showCalendar.value = true;
          },
          child: Obx(() {
            final selectedDate = controller.selectedExpiryDate.value;

            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    selectedDate == null
                        ? "Select Date"
                        : DateFormat('MMM dd yyyy').format(selectedDate),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: selectedDate == null
                          ? const Color(0xFF717F9A)
                          : const Color(0xFF151E2F),
                    ),
                  ),
                  SvgPicture.asset(
                    'assets/icons/merchant_details/calendar.svg',
                  ),
                ],
              ),
            );
          }),
        ),

        // Calendar
        Obx(() {
          if (!controller.showCalendar.value) {
            return const SizedBox.shrink();
          }

          return Container(
            margin: const EdgeInsets.only(top: 6),
            padding: const EdgeInsets.only(bottom: 12, left: 4, right: 4),

            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE2E8F0)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: CommonExpiryCalendar(
              focusedDay: controller.focusedDay.value,
              selectedDate: controller.selectedExpiryDate.value,

              onDaySelected: (date) {
                controller.selectedExpiryDate.value = date;
                controller.focusedDay.value = date;
                controller.showCalendar.value = false;
              },

              onMonthChanged: (date) {
                controller.focusedDay.value = date;
              },
            ),
          );
        }),
      ],
    );
  }

  //* -- select ID picture methods --
  Widget buildIDPhotoSelection() {
    return Obx(() {
      // reactive wrapper
      final faceUrl = controller.faceUrl.value;

      if (faceUrl != null && faceUrl.isNotEmpty) {
        return buildUploadedIdPreview(
          faceUrl: faceUrl,
          onPick: controller.onPickIdImage,
          onRemove: controller.removeIdImage,
        );
      }
      return buildIdUploadPlaceholder(
        isUploading: controller.isIdImageUploading.value,
        onPick: controller.onPickIdImage,
      );
    });
  }

  Widget personalInfoInputContent(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Warning Card
          if (controller.topTip.isNotEmpty && controller.showWarning.value) //
            buildTopTipWarningCard(),
          // Nationality
          InputTitleLable("Nationality"),
          buildNationalitySelection(),
          // Name
          InputTitleLable("Name"),
          buildNameTextInput(),
          // Type of ID
          InputTitleLable("Type of ID"),
          buildIdTypeSelection(),
          // Expiry Date
          InputTitleLable("Expiry Date"),
          buildExpirySelection(context),
          // ID Number
          InputTitleLable("ID Number"),
          buildIdTextInput(),
          // ID Picture
          InputTitleLable("ID Picture"),
          buildIDPhotoSelection(),
          const SizedBox(height: 32),
          buildSubmitButton(context),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  // CHANGED: setState → controller.showWarning
  Container buildTopTipWarningCard() {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBF6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFFE2C1), width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset(
            'assets/icons/merchant_details/info_circle.svg',
            width: 24,
            height: 24,
            colorFilter: ColorFilter.mode(Color(0xFFC9710D), BlendMode.srcIn),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "KYC Verification Required",
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Color(0xFFC9710D),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  controller.topTip,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    color: Color(0xFFC9710D),
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              controller.showWarning.value = false; //
            },
            child: SvgPicture.asset(
              'assets/icons/merchant_details/close-square.svg',
              width: 20,
              height: 20,
              colorFilter: ColorFilter.mode(Color(0xFFC9710D), BlendMode.srcIn),
            ),
          ),
        ],
      ),
    );
  }

  // SizedBox buildSubmitButton(BuildContext context) {
  //   return SizedBox(
  //     width: double.infinity,
  //     height: 56,

  //     child: Obx(() {
  //       final canSubmit = controller.isFormReady;
  //       return ElevatedButton(
  //         onPressed:
  //             canSubmit //
  //             ? () async {
  //                 if (!_formKey.currentState!.validate()) return;

  //                 final success = await controller.submitKyc();

  //                 if (success) {
  //                   CustomSnackbar.showError(
  //                     title: "Success",
  //                     message: "KYC Information Submitted!",
  //                   );
  //                   // //TODO:   getLatestIdentifyOrderList getLatestIdentifyOrderList getLatestIdentifyOrderList getLatestIdentifyOrderList
  //                   //       await getLatestIdentifyOrderList();
  //                   //       setState(() {
  //                   //         _isLoading = false;
  //                   //         widget.merchantStatus =
  //                   //             latestSubmittedInfo?.status ?? '0';
  //                   //       }
  //                   // Get.back(result: true); // return result
  //                 } else {
  //                   CustomSnackbar.showError(
  //                     title: "Error",
  //                     message: "Submission failed",
  //                   );
  //                 }
  //               }
  //             : null, //DISABLED
  //         style: ElevatedButton.styleFrom(
  //           backgroundColor: canSubmit
  //               ? const Color(0xFF1D5DE5)
  //               : const Color(0xFFB9C6E2),
  //           elevation: 0,
  //           shape: RoundedRectangleBorder(
  //             borderRadius: BorderRadius.circular(12),
  //           ),
  //         ),
  //         child: const Text(
  //           "Submit",
  //           style: TextStyle(
  //             fontFamily: 'Inter',
  //             fontWeight: FontWeight.w600,
  //             fontSize: 16,
  //             color: Colors.white,
  //           ),
  //         ),
  //       );
  //     }),
  //   );
  // }

  Widget buildSubmitButton(BuildContext context) {
    return Obx(() {
      final canSubmit = controller.isFormReady;

      return PrimaryButton(
        text: "Submit",
        enabled: canSubmit,
        onPressed: () async {
          if (!_formKey.currentState!.validate()) return;

          final success = await controller.submitKyc();

          if (success) {
            CustomSnackbar.showSuccess(
              title: "Success",
              message: "KYC Information Submitted!",
            );
            // //TODO:   getLatestIdentifyOrderList getLatestIdentifyOrderList getLatestIdentifyOrderList getLatestIdentifyOrderList
            //       await getLatestIdentifyOrderList();
            //       setState(() {
            //         _isLoading = false;
            //         widget.merchantStatus =
            //             latestSubmittedInfo?.status ?? '0';
            //       }
            // Get.back(result: true);
          } else {
            CustomSnackbar.showError(
              title: "Error",
              message: "Submission failed",
            );
          }
        },
      );
    });
  }
}
