import 'package:BitOwi/core/theme/app_input_decorations.dart';
import 'package:BitOwi/core/widgets/common_appbar.dart';
import 'package:BitOwi/core/widgets/common_image.dart';
import 'package:BitOwi/core/widgets/primary_button.dart';
import 'package:BitOwi/core/widgets/soft_circular_loader.dart';
import 'package:BitOwi/features/merchant/presentation/controllers/user_kyc_personal_information_controller.dart';
import 'package:BitOwi/features/merchant/presentation/widgets/expiry_calendar.dart';
import 'package:BitOwi/features/merchant/presentation/widgets/kyc_id_photo_ui.dart';
import 'package:BitOwi/core/widgets/input_title_label.dart';
import 'package:BitOwi/features/merchant/presentation/widgets/user_kyc_information_status_page.dart';
import 'package:BitOwi/models/country_list_res.dart';
import 'package:BitOwi/models/dict.dart';
import 'package:BitOwi/utils/string_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class UserKycInformationPage extends StatelessWidget {
  UserKycInformationPage({super.key});

  final _formKey = GlobalKey<FormState>();

  final UserKycInformationController controller =
      Get.find<UserKycInformationController>();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // prevent automatic pop
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        Get.back();
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF6F9FF),
        appBar: CommonAppBar(
          title: "Personal Information",
          onBack: () {
            Get.back();
          },
        ),
        body: SafeArea(
          child: Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: SoftCircularLoader());
            }

            final status = controller.latestIdentifyOrderStatus.value;

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: (status == null || status == '-1' || status == '2')
                  ? _buildForm(context)
                  : UserKycStatusPage(
                      countryIndex: controller.countryIndex.value,
                      countryList: controller.countryList,
                      idTypeIndex: controller.idTypeIndex.value,
                      idTypeList: controller.idTypeList,
                      name: controller.name.value,
                      idNumber: controller.idNumber.value,
                      expiryDate: controller.selectedExpiryDate.value,
                      identifyOrderLatestSubmittedInfoStatus: status,
                    ),
            );
          }),
        ),
      ),
    );
  }

  //* -- select nationality methods --
  GestureDetector buildNationalitySelection() {
    CountryListRes? country;

    if (controller.countryIndex.value >= 0 &&
        controller.countryIndex.value < controller.countryList.length) {
      country = controller.countryList[controller.countryIndex.value];
    }

    final isChinese = Get.locale?.toString() == 'zh_CN';

    final String countryName = country == null
        ? "Select Your Nationality"
        : isChinese
        ? country.chineseName
        : country.interName;

    final bool hasSelection = country != null;

    return GestureDetector(
      onTap: controller.countryList.isEmpty ? null : areaTapNationality,
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
      final index = await _showNationalityBottomSheet();

      if (index != null && index != controller.countryIndex.value) {
        controller.countryIndex.value = index; // 🔄
      }
    } catch (e) {
      debugPrint('areaTapNationality error: $e');
    }
  }

  Future<int?> _showNationalityBottomSheet() async {
    int? tempSelectedIndex =
        controller.countryIndex.value >=
            0 // 🔁 controller source
        ? controller.countryIndex.value
        : null;

    final bool isChinese = Get.locale?.toString() == 'zh_CN';

    return showModalBottomSheet<int>(
      context: Get.context!, // 🔁 safe for Stateless + GetX
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
                  // ---------- LIST ----------
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: controller.countryList.length, // 🔁
                      itemBuilder: (context, index) {
                        final nationality = controller.countryList[index]; // 🔁
                        final isSelected = tempSelectedIndex == index;

                        final name = isChinese
                            ? nationality.chineseName
                            : nationality.interName;

                        return GestureDetector(
                          onTap: () {
                            setModalState(() {
                              tempSelectedIndex = index; // ✅ local modal state
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
      // 🔁 reactive
      Dict? idType;

      if (controller.idTypeIndex.value >= 0 &&
          controller.idTypeIndex.value < controller.idTypeList.length) {
        idType = controller.idTypeList[controller.idTypeIndex.value]; // 🔁
      }

      final bool hasSelection = idType != null;
      final String displayText = hasSelection
          ? StringUtils.toTitleCase(idType.value)
          : "Select Type";

      return GestureDetector(
        onTap: controller.idTypeList.isEmpty ? null : areaTapIdType, // 🔁,
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
        controller.idTypeIndex.value = result; // 🔁 controller update
      }
    } catch (e) {
      debugPrint('areaTapIdType error: $e');
    }
  }

  Future<int?> _showIdTypeBottomSheet() async {
    int? tempSelectedIndex =
        controller.idTypeIndex.value >=
            0 // 🔁 controller source
        ? controller.idTypeIndex.value
        : null;

    return showModalBottomSheet<int>(
      context: Get.context!, // 🔁 Stateless-safe
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
                      itemCount: controller.idTypeList.length, // 🔁
                      itemBuilder: (context, index) {
                        final Dict idType = controller.idTypeList[index]; // 🔁
                        final bool isSelected = tempSelectedIndex == index;
                        return GestureDetector(
                          onTap: () {
                            setModalState(() {
                              tempSelectedIndex = index; // ✅ modal-local
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
                  //               Navigator.pop(
                  //                 context,
                  //                 tempSelectedIndex, // ✅ return index
                  //               );
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
                        Navigator.pop(
                          context,
                          tempSelectedIndex, // ✅ return index
                        );
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
      controller: controller.nameController, // ✅
      onChanged: (v) => controller.name.value = v, // ✅
      decoration: AppInputDecorations.textField(hintText: "Enter Your Name"),
    );
  }

  //* -- input Id methods --
  TextFormField buildIdTextInput() {
    return TextFormField(
      controller: controller.idController,
      onChanged: (v) => controller.idNumber.value = v,
      decoration: AppInputDecorations.textField(
        hintText: "Enter Your ID Number",
      ),
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
            controller.syncFocusedDay();
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
      // 🔁 reactive wrapper
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

  Widget _buildForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Warning Card
          if (controller.topTip.value.isNotEmpty &&
              controller.showWarning.value)
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

  Widget buildTopTipWarningCard() {
    return Obx(() {
      // 🔁 reactive wrapper
      final bool isRejected =
          controller.latestIdentifyOrderStatus.value == '2'; // 🔁
      return Container(
        padding: const EdgeInsets.all(10),
        margin: EdgeInsets.only(top: 10),
        decoration: BoxDecoration(
          color: isRejected ? Color(0xFFFDF4F5) : const Color(0xFFFFFBF6),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isRejected ? Color(0xFFF5B7B1) : const Color(0xFFFFE2C1),
            width: 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SvgPicture.asset(
              'assets/icons/merchant_details/info_circle.svg',
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(
                isRejected ? Color(0xFFCF4436) : Color(0xFFC9710D),
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isRejected
                        ? "KYC Verification Failed"
                        : "KYC Verification Required",
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: isRejected ? Color(0xFFCF4436) : Color(0xFFC9710D),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    controller.topTip.value, // 🔁 from controller
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                      color: isRejected ? Color(0xFFCF4436) : Color(0xFFC9710D),
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                controller.showWarning.value = false; // 🔁
              },
              child: SvgPicture.asset(
                'assets/icons/merchant_details/close-square.svg',
                width: 20,
                height: 20,
                colorFilter: ColorFilter.mode(
                  isRejected ? Color(0xFFCF4436) : Color(0xFFC9710D),
                  BlendMode.srcIn,
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
  
  Widget buildSubmitButton(BuildContext context) {
    return Obx(() {
      final isReady = controller.isFormReady; 
      final isRejected =
          controller.latestIdentifyOrderStatus.value == '2'; 

      return PrimaryButton(
        text: isRejected ? "Resubmit" : "Submit", 
        enabled: isReady,
        onPressed: () async {
          if (!_formKey.currentState!.validate()) return;

          await controller.submitUserKyc(); 
        },
      );
    });
  }
}
