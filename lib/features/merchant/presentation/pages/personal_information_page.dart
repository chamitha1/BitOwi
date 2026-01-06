import 'package:BitOwi/features/merchant/presentation/controllers/kyc_personal_information_controller.dart';
import 'package:BitOwi/features/merchant/presentation/widgets/expiry_calendar.dart';
import 'package:BitOwi/features/merchant/presentation/widgets/personal_information_status_page.dart';
import 'package:BitOwi/models/country_list_res.dart';
import 'package:BitOwi/models/dict.dart';
import 'package:BitOwi/utils/aws_upload_util.dart';
import 'package:BitOwi/utils/string_utils.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class KycPersonalInformationPage extends StatelessWidget {
  KycPersonalInformationPage({super.key});

  // 🧠 GetX controller (provided by Binding)
  final KycPersonalInformationController controller =
      Get.find<KycPersonalInformationController>(); // 🧠

  final _formKey = GlobalKey<FormState>(); // unchanged (UI concern)

  @override
  Widget build(BuildContext context) {
    // 🧠 INIT controller ONCE using Get.arguments
    // final args = Get.arguments as Map<String, dynamic>; // 🧠
    // controller.init(
    //   isEdit: args['isEdit'],
    //   merchantStatus: args['merchantStatus'],
    // ); // 🧠

    return PopScope(
      canPop: false, // prevent automatic pop
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;

        // Handle system back + gesture back
        Get.back(result: controller.merchantStatus.value != '-1'); // 🔁
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF6F9FF),
        appBar: AppBar(
          backgroundColor: const Color(0xFFF6F9FF),
          surfaceTintColor: const Color(0xFFF6F9FF),
          elevation: 0,
          scrolledUnderElevation: 0,
          leading: IconButton(
            icon: SvgPicture.asset(
              'assets/icons/merchant_details/arrow_left.svg',
              width: 24,
              height: 24,
              colorFilter: const ColorFilter.mode(
                Color(0xFF151E2F),
                BlendMode.srcIn,
              ),
            ),
            onPressed: () =>
                Get.back(result: controller.merchantStatus.value != '-1'), // 🔁
          ),
          title: const Text(
            "Personal Information",
            style: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
              fontSize: 18,
              color: Color(0xFF151E2F),
            ),
          ),
          centerTitle: false,
        ),
        body: SafeArea(
          child: Obx(() {
            // 👀 replaces setState rebuilds
            if (controller.isLoading.value) {
              return const Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Color(0xFF1D5DE5),
                ),
              );
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: controller.merchantStatus.value == '-1'
                  ? personalInfoInputContent(context) // unchanged
                  : SuccessfullySubmittedKYCInfo(
                      countryIndex: controller.countryIndex.value, // 🔁
                      countryList: controller.countryList, // 🔁
                      idTypeIndex: controller.idTypeIndex.value, // 🔁
                      idTypeList: controller.idTypeList, // 🔁
                      name: controller.name.value, // 🔁
                      idNumber: controller.idNumber.value, // 🔁
                      expiryDate: controller.selectedExpiryDate.value, // 🔁
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
    // ✅ SAFE index access via controller
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
                    child: Image.network(
                      country.pic,
                      width: 24,
                      height: 24,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) {
                        return const SizedBox(width: 24, height: 24);
                      },
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
                                  child: Image.network(
                                    nationality.pic,
                                    width: 48,
                                    height: 48,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, _, _) {
                                      return const SizedBox(
                                        width: 48,
                                        height: 48,
                                      );
                                    },
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
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: tempSelectedIndex == null
                            ? null
                            : () => Navigator.pop(context, tempSelectedIndex),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: tempSelectedIndex == null
                              ? const Color(0xFFB9C6E2)
                              : const Color(0xFF1D5DE5),
                          elevation: 0,
                          disabledBackgroundColor: const Color(0xFFB9C6E2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          "Continue",
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
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
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
                                  idType.value == "passport"
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
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: tempSelectedIndex == null
                            ? null
                            : () {
                                Navigator.pop(context, tempSelectedIndex);
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: tempSelectedIndex == null
                              ? const Color(0xFFB9C6E2)
                              : const Color(0xFF1D5DE5),
                          elevation: 0,
                          disabledBackgroundColor: const Color(0xFFB9C6E2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          "Continue",
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
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
  Widget buildNameTextInput() {
    return TextFormField(
      controller: controller.nameController,
      onChanged: (v) => controller.name.value = v.trim(),
      decoration: InputDecoration(
        hintText: "Enter Your Name",
        hintStyle: const TextStyle(
          fontFamily: 'Inter',
          fontWeight: FontWeight.w400,
          fontSize: 14,
          color: Color(0xFF717F9A),
        ),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF929EB8)),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return "Name is required";
        }
        return null;
      },
    );
  }

  //* -- input Id methods --
  Widget buildIdTextInput() {
    return TextFormField(
      controller: controller.idController,
      onChanged: (v) => controller.idNumber.value = v.trim(),
      decoration: InputDecoration(
        hintText: "Enter Your ID Number",
        hintStyle: const TextStyle(
          fontFamily: 'Inter',
          fontWeight: FontWeight.w400,
          fontSize: 14,
          color: Color(0xFF717F9A),
        ),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF929EB8)),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
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
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
      if (controller.faceUrl.value != null &&
          controller.faceUrl.value!.isNotEmpty) {
        return _buildUploadedIDPreview();
      }
      return _buildUploadPlaceholder();
    });
  }

  DottedBorder _buildUploadPlaceholder() {
    return DottedBorder(
      options: RoundedRectDottedBorderOptions(
        dashPattern: [2, 4],
        strokeWidth: 1.5,
        radius: Radius.circular(16),
        color: Color(0xFFB9C6E2),
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: controller.isIdImageUploading.value
            ? const SizedBox(
                height: 274,
                child: Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Color(0xFF1D5DE5),
                  ),
                ),
              )
            : Column(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    padding: const EdgeInsets.all(18),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFEFF6FF),
                    ),
                    child: SvgPicture.asset(
                      'assets/icons/merchant_details/upload.svg',
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Upload ID Picture",
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Color(0xFF151E2F),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Drag and drop your file here or",
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                      color: Color(0xFF717F9A),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: onPickFaceImage,
                    icon: SvgPicture.asset(
                      'assets/icons/merchant_details/upload.svg',
                      height: 16,
                      width: 16,
                      colorFilter: const ColorFilter.mode(
                        Colors.white,
                        BlendMode.srcIn,
                      ),
                    ),
                    label: Text(
                      controller.uploadedFileName.value ?? "Click to Upload",
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1D5DE5),
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/icons/merchant_details/personalcard.svg',
                      ),
                      const SizedBox(width: 4),
                      const Text(
                        "JPG or PNG only • Max 5MB",
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                          color: Color(0xFF717F9A),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildRequirement("Clear, readable text on the document"),
                  const SizedBox(height: 8),
                  _buildRequirement(
                    "All four corners of the ID must be visible",
                  ),
                  const SizedBox(height: 8),
                  _buildRequirement("Photo taken in good lighting"),
                ],
              ),
      ),
    );
  }

  Widget _buildUploadedIDPreview() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        // color: Colors.red,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          // ---------- IMAGE PREVIEW ----------
          Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    controller.faceUrl.value!,
                    width: double.infinity,
                    height: 274,
                    fit: BoxFit.cover,
                    //  SHOW LOADING UNTIL IMAGE IS READY
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) {
                        return child; // image fully loaded
                      }

                      return Container(
                        height: 274,
                        alignment: Alignment.center,
                        color: const Color(0xFFEFF6FF),
                        child: const CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Color(0xFF1D5DE5),
                        ),
                      );
                    },
                    errorBuilder: (_, _, _) {
                      return Container(
                        height: 274,
                        alignment: Alignment.center,
                        color: const Color(0xFFEFF6FF),
                        child: const Text("Failed to load image"),
                      );
                    },
                  ),
                ),
              ),

              // ---------- UPLOADED BADGE ----------
              Positioned(
                top: 14,
                left: 14,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEAF9F0),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: const [
                      Icon(
                        Icons.check_circle,
                        size: 16,
                        color: Color(0xFF40A372),
                      ),
                      SizedBox(width: 6),
                      Text(
                        "Uploaded",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF40A372),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ---------- REMOVE BUTTON ----------
              // ❌ Remove
              Positioned(
                top: 14,
                right: 14,
                child: GestureDetector(
                  onTap: removeFaceImage,
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: const BoxDecoration(
                      color: Color(0xFFE74C3C),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close,
                      size: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              // ---------- BOTTOM ACTION BAR ----------
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: Container(
                    height: 82,
                    decoration: BoxDecoration(
                      color: const Color(0xFFECEFF5),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: SizedBox(
                        height: 48,
                        child: OutlinedButton.icon(
                          onPressed: onPickFaceImage,
                          icon: SvgPicture.asset(
                            'assets/icons/merchant_details/upload.svg',
                            height: 16,
                            width: 16,
                          ),
                          label: const Text(
                            "Upload Different Photo",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF1D5DE5),
                            side: const BorderSide(color: Color(0xFF1D5DE5)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> pickImageFromGallery() async {
    if (controller.isIdImageUploading.value) return; // 🛑
    try {
      controller.isIdImageUploading.value = true;

      final ImagePicker picker = ImagePicker();

      final XFile? pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85, // compress slightly (optional)
      );

      if (pickedFile == null) {
        controller.isIdImageUploading.value = false;
        return;
      }

      // ---------- SIZE CHECK ----------
      final bytes = await pickedFile.readAsBytes();
      const maxSize = 5 * 1024 * 1024; // 5 MB

      if (bytes.lengthInBytes > maxSize) {
        Get.snackbar(
          'Error',
          'Image size cannot exceed 5MB',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        controller.isIdImageUploading.value = false;
        return;
      }

      // ---------- UPLOAD ----------
      // If you still upload to AWS like before
      // show loading if needed
      // showLoadingToast(context, "Uploading image...");

      final url = await AwsUploadUtil().upload(file: pickedFile);

      // success
      controller.uploadedFileName.value = pickedFile.name; // ✅
      controller.faceUrl.value = url;
    } catch (e) {
      Get.snackbar(
        'Upload Failed',
        'Image upload failed, please try again',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      print(e);
    } finally {
      controller.isIdImageUploading.value = false;
    }
  }

  Future<void> onPickFaceImage() async {
    await pickImageFromGallery();
  }

  /// ❌ Remove image
  void removeFaceImage() {
    controller.faceUrl.value = null;
    controller.uploadedFileName.value = null;
  }

  //! -- submit button methods --
  void showRedToast(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 2),
  }) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
          backgroundColor: const Color(0xFFD32F2F), // 🔴 Red
          duration: duration,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
  }

  Widget personalInfoInputContent(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Warning Card
          if (controller.topTip.isNotEmpty &&
              controller.showWarning.value) // 🔁
            buildTopTipWarningCard(),
          // Nationality
          buildTitleLabelText("Nationality"),
          buildNationalitySelection(),
          // Name
          buildTitleLabelText("Name"),
          buildNameTextInput(),
          // Type of ID
          buildTitleLabelText("Type of ID"),
          buildIdTypeSelection(),
          // Expiry Date
          buildTitleLabelText("Expiry Date"),
          buildExpirySelection(context),
          // ID Number
          buildTitleLabelText("ID Number"),
          buildIdTextInput(),
          // ID Picture
          buildTitleLabelText("ID Picture"),
          buildIDPhotoSelection(),
          const SizedBox(height: 32),
          buildSubmitButton(context),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Padding buildTitleLabelText(String titleText) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 8),
      child: Text(
        titleText,
        style: TextStyle(
          fontFamily: 'Inter',
          fontWeight: FontWeight.w400,
          fontSize: 14,
          color: Color(0xFF2E3D5B),
        ),
      ),
    );
  }

  // 🔁 CHANGED: setState → controller.showWarning
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
              controller.showWarning.value = false; // 🔁
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

  SizedBox buildSubmitButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,

      child: Obx(() {
        final canSubmit = controller.isFormReady;
        return ElevatedButton(
          onPressed:
              canSubmit // 🔁
              ? () async {
                  if (!_formKey.currentState!.validate()) return;

                  final success = await controller.submitKyc(); // 🧠

                  if (success) {
                    Get.snackbar(
                      "Success",
                      "KYC Information Submitted!",
                      backgroundColor: const Color(0xFF10B981),
                      colorText: Colors.white,
                    );
                    // //TODO:   getLatestIdentifyOrderList getLatestIdentifyOrderList getLatestIdentifyOrderList getLatestIdentifyOrderList
                    //       await getLatestIdentifyOrderList();
                    //       setState(() {
                    //         _isLoading = false;
                    //         widget.merchantStatus =
                    //             latestSubmittedInfo?.status ?? '0';
                    //       }
                    // Get.back(result: true); // 🔁 return result
                  } else {
                    Get.snackbar(
                      "Error",
                      "Submission failed",
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                    );
                  }

                  // try {
                  //   setState(() {
                  //     _isLoading = true;
                  //   });

                  //   final formattedDate = _selectedExpiryDate != null
                  //       ? "${_selectedExpiryDate!.month.toString().padLeft(2, '0')}/${_selectedExpiryDate!.year}"
                  //       : "00/0000";

                  //   await UserApi.createIdentifyOrder({
                  //     "countryId": countryList[countryIndex].id,
                  //     "realName": _nameController.text,
                  //     "kind": idTypeList[idTypeIndex].key,
                  //     "expireDate": formattedDate,
                  //     "idNo": _idNumberController.text,
                  //     "frontImage": faceUrl,
                  //   }).then((value) async {
                  //     if (value['errorMsg'] == 'SUCCESS' ||
                  //         value['errorCode'] == 'Success') {
                  //       ScaffoldMessenger.of(context).showSnackBar(
                  //         const SnackBar(
                  //           content: Text("KYC Information Submitted!"),
                  //           backgroundColor: Color(0xFF10B981),
                  //         ),
                  //       );

                  //       await getLatestIdentifyOrderList();
                  //       setState(() {
                  //         _isLoading = false;
                  //         widget.merchantStatus =
                  //             latestSubmittedInfo?.status ?? '0';
                  //       });
                  //     } else {
                  //       setState(() {
                  //         _isLoading = false;
                  //         ScaffoldMessenger.of(context).showSnackBar(
                  //           SnackBar(
                  //             content: Text(
                  //               "${value['errorMsg']}",
                  //               style: TextStyle(color: const Color(0xFFCF4436)),
                  //             ),
                  //             backgroundColor: const Color(0xFFFDF4F5),
                  //           ),
                  //         );
                  //       });
                  //     }
                  //   });
                  // } catch (e) {
                  //   controller.isLoading.value = false;
                  //   showRedToast(context, 'Submission failed. Please try again.');
                  // }
                }
              : null, //DISABLED
          style: ElevatedButton.styleFrom(
            backgroundColor: canSubmit
                ? const Color(0xFF1D5DE5)
                : const Color(0xFFB9C6E2),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text(
            "Submit",
            style: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        );
      }),
    );
  }

  Widget _buildRequirement(String text) {
    return Row(
      children: [
        const Icon(
          Icons.check_circle_outline,
          color: Color(0xFF40A372),
          size: 14,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
              fontSize: 12,
              color: Color(0xFF717F9A),
            ),
          ),
        ),
      ],
    );
  }
}
