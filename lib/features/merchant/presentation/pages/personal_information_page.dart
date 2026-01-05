import 'package:BitOwi/api/common_api.dart';
import 'package:BitOwi/api/user_api.dart';
import 'package:BitOwi/core/widgets/custom_snackbar.dart';
import 'package:BitOwi/features/merchant/presentation/widgets/personal_information_status_page.dart';
import 'package:BitOwi/models/country_list_res.dart';
import 'package:BitOwi/models/dict.dart';
import 'package:BitOwi/models/identify_order_list_res.dart';
import 'package:BitOwi/utils/aws_upload_util.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
// import 'package:file_picker/file_picker.dart';

class KycPersonalInformationPage extends StatefulWidget {
  String merchantStatus;
  bool isEdit;

  KycPersonalInformationPage({
    super.key,
    required this.merchantStatus,
    required this.isEdit,
  });

  @override
  State<KycPersonalInformationPage> createState() =>
      _KycPersonalInformationPageState();
}

class _KycPersonalInformationPageState
    extends State<KycPersonalInformationPage> {
  final _formKey = GlobalKey<FormState>();

  String topTip = '';

  List<CountryListRes> countryList = [];
  int countryIndex = -1;

  // String? _selectedIdType;
  List<Dict> idTypeList = [];
  int idTypeIndex = -1;

  DateTime? _selectedExpiryDate;
  DateTime? _lastPickedDate;
  bool _showCalendar = false;

  String? _uploadedFileName;
  bool _showWarning = true;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _idNumberController = TextEditingController();

  String? faceUrl;
  bool _idImageUploading = false;

  bool _isLoading = false;

  bool get _isFormReady {
    return countryIndex >= 0 &&
        _nameController.text.isNotEmpty &&
        idTypeIndex >= 0 &&
        _idNumberController.text.isNotEmpty &&
        // _selectedExpiryDate != null && // optional
        faceUrl != null &&
        faceUrl!.isNotEmpty;
  }

  IdentifyOrderListRes? latestSubmittedInfo;

  bool isEdit = false;

  @override
  void initState() {
    super.initState();
    // isEdit = Get.parameters["edit"] == '1';
    // for rejected status re apply via edit
    isEdit = widget.isEdit;
    getInitData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _idNumberController.dispose();
    super.dispose();
  }

  Future<void> getLatestIdentifyOrderList() async {
    try {
      final list = await UserApi.getIdentifyOrderList();

      setState(() {
        // for success submit
        latestSubmittedInfo = list.isNotEmpty ? list.first : null;
      });
    } catch (e) {}
  }

  Future<void> getInitData() async {
    try {
      // ToastUtil.showLoading();
      setState(() {
        _isLoading = true;
      });

      final result = await Future.wait<dynamic>([
        CommonApi.getDictList(parentKey: 'id_kind'),
        CommonApi.getCountryList(),
        CommonApi.getConfig(type: 'identify_config'),
      ]);

      topTip = result[2].data['identify_note'] ?? '';
      // authTip = result[2].data['identify_order_note'] ?? '';

      idTypeList = result[0];
      countryList = result[1];

      if (isEdit) {
        final list = await UserApi.getIdentifyOrderList();
        if (list.isNotEmpty) {
          final order = list.first;
          countryIndex = countryList.indexWhere(
            (element) => element.id == order.countryId,
          );
          idTypeIndex = idTypeList.indexWhere(
            (element) => element.key == order.kind,
          );
          // expiry not loaded, since its optional
          _nameController.text = order.realName;
          _idNumberController.text = order.idNo;
          faceUrl = order.frontImage;
        }
      }
      // ToastUtil.dismiss();
      // setState(() {});

      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
    } catch (e, stackTrace) {
      debugPrint('getInitData error: $e');
      debugPrint('$stackTrace');
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // prevent automatic pop
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;

        // Handle system back + gesture back
        Navigator.pop(
          context,
          widget.merchantStatus != '-1',
        ); //  return value to previous screen
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
                Navigator.pop(context, widget.merchantStatus != '-1'),
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
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: widget.merchantStatus == '-1'
                ? personalInfoInputContent(context)
                : SuccessfullySubmittedKYCInfo(
                    countryIndex: countryIndex,
                    countryList: countryList,
                    idTypeIndex: idTypeIndex,
                    idTypeList: idTypeList,
                    name: _nameController.text,
                    idNumber: _idNumberController.text,
                    expiryDate: _selectedExpiryDate,
                    merchantStatus: widget.merchantStatus,
                    identifyOrderLatestSubmittedInfoStatus:
                        latestSubmittedInfo?.status ?? '0',
                  ),
          ),
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

    if (countryIndex >= 0 && countryIndex < countryList.length) {
      country = countryList[countryIndex];
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
      onTap: countryList.isEmpty ? () {} : areaTapNationality,
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
                      errorBuilder: (_, __, ___) {
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

      if (result != null && result != countryIndex) {
        setState(() {
          countryIndex = result;
        });
      }
    } catch (e) {
      debugPrint('areaTapNationality error: $e');
    }
  }

  Future<int?> _showNationalityBottomSheet() async {
    int? tempSelectedIndex = countryIndex >= 0 ? countryIndex : null;

    final bool isChinese = Get.locale?.toString() == 'zh_CN';

    return showModalBottomSheet<int>(
      context: context,
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
                      itemCount: countryList.length,
                      itemBuilder: (context, index) {
                        final nationality = countryList[index];
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
                                    errorBuilder: (_, __, ___) {
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
  GestureDetector buildIdTypeSelection() {
    Dict? idType;

    if (idTypeIndex >= 0 && idTypeIndex < idTypeList.length) {
      idType = idTypeList[idTypeIndex];
    }

    final bool hasSelection = idType != null;
    final String displayText = hasSelection ? idType.value : "Select Type";

    return GestureDetector(
      onTap: idTypeList.isEmpty ? () {} : areaTapIdType,
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
  }

  Future<void> areaTapIdType() async {
    try {
      final result = await _showIdTypeBottomSheet();

      if (result != null && result != idTypeIndex) {
        setState(() {
          idTypeIndex = result;
        });
      }
    } catch (e) {
      debugPrint('areaTapIdType error: $e');
    }
  }

  Future<int?> _showIdTypeBottomSheet() async {
    int? tempSelectedIndex = idTypeIndex >= 0 ? idTypeIndex : null;

    return showModalBottomSheet<int>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.55,
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
                      itemCount: idTypeList.length,
                      itemBuilder: (context, index) {
                        final Dict idType = idTypeList[index];
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
                                    idType.value,
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
                                Navigator.pop(
                                  context,
                                  tempSelectedIndex, // ✅ return index
                                );
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
  TextFormField buildNameTextInput() {
    return TextFormField(
      controller: _nameController,
      onChanged: (_) => setState(() {}),
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
    );
  }

  //* -- input Id methods --
  TextFormField buildIdTextInput() {
    return TextFormField(
      controller: _idNumberController,
      onChanged: (_) => setState(() {}),
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
    );
  }

  //* -- select expiry methods --

  String formatDate(DateTime? date) {
    if (date == null) return "Select Date";
    return DateFormat('MMM dd yyyy').format(date);
  }

  Column buildExpirySelection(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              _showCalendar = true;
            });
          },
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
                  formatDate(_selectedExpiryDate),
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: _selectedExpiryDate == null
                        ? const Color(0xFF717F9A)
                        : const Color(0xFF151E2F),
                  ),
                ),
                SvgPicture.asset('assets/icons/merchant_details/calendar.svg'),
              ],
            ),
          ),
        ),
        if (_showCalendar) ...[
          const SizedBox(height: 8),
          Container(
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
            child: Theme(
              data: Theme.of(context).copyWith(
                colorScheme: const ColorScheme.light(
                  primary: Color(0xFF1D5DE5), // Selected day, header
                  secondary: Color(0xFFE8EFFF), // Range / hover / accents
                  onPrimary: Colors.white, // Text on selected day
                  surface: Colors.white, // Calendar background
                  onSurface: Color(0xFF151E2F), // Default text
                ),
                textButtonTheme: TextButtonThemeData(
                  style: TextButton.styleFrom(
                    foregroundColor: Color(0xFF1D5DE5), // Month / year switch
                  ),
                ),
              ),
              child: CalendarDatePicker(
                initialDate: _selectedExpiryDate ?? DateTime.now(),
                firstDate: DateTime(1900),
                lastDate: DateTime(2100),
                // currentDate: _focusedDate,
                onDateChanged: (DateTime date) {
                  bool pickedFromYearMode = false;

                  if (_lastPickedDate != null) {
                    pickedFromYearMode =
                        date.year != _lastPickedDate!.year &&
                        date.month == _lastPickedDate!.month &&
                        date.day == _lastPickedDate!.day;
                  }

                  if (pickedFromYearMode) {
                    debugPrint("Picked from YEAR mode");

                    setState(() {
                      // Update date but KEEP calendar open
                      _lastPickedDate = date;
                      _selectedExpiryDate = date;
                    });
                  } else {
                    debugPrint("Picked from DAY mode");

                    setState(() {
                      _lastPickedDate = date;
                      _selectedExpiryDate = date;
                      _showCalendar = false; // close only here
                    });
                  }
                },
              ),
            ),
          ),
        ],
      ],
    );
  }

  //* -- select ID picture methods --
  Widget buildIDPhotoSelection() {
    if (faceUrl != null && faceUrl!.isNotEmpty) {
      return _buildUploadedIDPreview();
    }

    return _buildUploadPlaceholder();
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
        child: _idImageUploading
            ? Container(
                height: 274,
                alignment: Alignment.center,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Color(0xFF1D5DE5),
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
                      _uploadedFileName ?? "Click to Upload",
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
                    faceUrl!,
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
                    errorBuilder: (_, __, ___) {
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
              Positioned(
                top: 14,
                right: 14,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      faceUrl = null;
                      _uploadedFileName = null;
                    });
                  },
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

  Future<void> pickImageFromGallery(ValueChanged<String> onSuccess) async {
    setState(() {
      _idImageUploading = true;
    });
    try {
      final ImagePicker picker = ImagePicker();

      final XFile? pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85, // compress slightly (optional)
      );

      if (pickedFile == null) {
        setState(() {
          _idImageUploading = false;
        });
        return;
      }

      // ---------- SIZE CHECK ----------
      final bytes = await pickedFile.readAsBytes();
      const maxSize = 5 * 1024 * 1024; // 5 MB

      if (bytes.lengthInBytes > maxSize) {
        CustomSnackbar.showError(
          title: "Error",
          message: 'Image size cannot exceed 5MB',
        );
        return;
      }

      // ---------- UPLOAD ----------
      // If you still upload to AWS like before
      // show loading if needed
      // showLoadingToast(context, "Uploading image...");

      final url = await AwsUploadUtil().upload(file: pickedFile);

      // dismiss loading
      // hideLoadingToast();
      setState(() {
        _idImageUploading = false;
      });
      onSuccess(url);
    } catch (e) {
      CustomSnackbar.showError(
        title: "Error",
        message: 'Image upload failed, please try again',
      );
      setState(() {
        _idImageUploading = false;
      });
      print(e);
    }
  }

  Future<void> onPickFaceImage() async {
    await pickImageFromGallery((String url) {
      setState(() {
        faceUrl = url;
      });
    });
  }

  //! -- submit button methods --


  Widget personalInfoInputContent(BuildContext context) {
    return _isLoading
        ? SizedBox(
            height: MediaQuery.of(context).size.height,
            child: const Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Color(0xFF1D5DE5),
              ),
            ),
          )
        : Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Warning Card
                if (topTip.isNotEmpty && _showWarning) buildTopTipWarningCard(),
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
                  topTip,
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
              setState(() {
                _showWarning = false;
              });
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
      child: ElevatedButton(
        onPressed: _isFormReady
            ? () async {
                if (!_formKey.currentState!.validate()) return;

                try {
                  setState(() {
                    _isLoading = true;
                  });

                  final formattedDate = _selectedExpiryDate != null
                      ? "${_selectedExpiryDate!.month.toString().padLeft(2, '0')}/${_selectedExpiryDate!.year}"
                      : "00/0000";

                  await UserApi.createIdentifyOrder({
                    "countryId": countryList[countryIndex].id,
                    "realName": _nameController.text,
                    "kind": idTypeList[idTypeIndex].key,
                    "expireDate": formattedDate,
                    "idNo": _idNumberController.text,
                    "frontImage": faceUrl,
                  }).then((value) async {
                    if (value['errorMsg'] == 'SUCCESS' ||
                        value['errorCode'] == 'Success') {
                      CustomSnackbar.showSuccess(
                        title: "Success",
                        message: "KYC Information Submitted!",
                      );

                      await getLatestIdentifyOrderList();
                      setState(() {
                        _isLoading = false;
                        widget.merchantStatus =
                            latestSubmittedInfo?.status ?? '0';
                      });
                    } else {
                      setState(() {
                        _isLoading = false;
                        CustomSnackbar.showError(
                          title: "Error",
                          message: "${value['errorMsg']}",
                        );
                      });
                    }
                  });
                } catch (e) {
                  setState(() {
                    _isLoading = false;
                  });
                  CustomSnackbar.showError(
                    title: "Error",
                    message: 'Submission failed. Please try again.',
                  );
                }
              }
            : null, //DISABLED
        style: ElevatedButton.styleFrom(
          backgroundColor: _isFormReady
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
      ),
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
