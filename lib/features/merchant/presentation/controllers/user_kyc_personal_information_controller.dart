import 'package:BitOwi/api/common_api.dart';
import 'package:BitOwi/api/user_api.dart';
import 'package:BitOwi/core/widgets/custom_snackbar.dart';
import 'package:BitOwi/core/widgets/image_picker_modal.dart';
import 'package:BitOwi/models/country_list_res.dart';
import 'package:BitOwi/models/dict.dart';
import 'package:BitOwi/models/identify_order_list_res.dart';
import 'package:BitOwi/utils/aws_upload_util.dart';
import 'package:BitOwi/utils/date_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class UserKycInformationController extends GetxController {
  /// ───────────────── UI STATE ─────────────────
  final isLoading = false.obs;
  final showWarning = true.obs;
  final showCalendar = false.obs;
  final isIdImageUploading = false.obs;

  /// ───────────────── DATA ─────────────────
  final countryList = <CountryListRes>[].obs;
  final idTypeList = <Dict>[].obs;

  final countryIndex = (-1).obs;
  final idTypeIndex = (-1).obs;

  final selectedExpiryDate = Rxn<DateTime>();

  final focusedDay = DateTime.now().obs;
  void syncFocusedDay() {
    focusedDay.value = selectedExpiryDate.value ?? DateTime.now();
  }

  final name = ''.obs;
  final idNumber = ''.obs;
  final nameController = TextEditingController();
  final idController = TextEditingController();
  late final Worker _nameWorker;
  late final Worker _idWorker;

  final faceUrl = RxnString();

  final topTip = ''.obs;

  final latestIdentifyOrderStatus = RxnString();
  IdentifyOrderListRes? latestSubmittedInfo;

  /// ───────────────── COMPUTED ─────────────────
  bool get isFormReady =>
      countryIndex.value >= 0 &&
      name.value.isNotEmpty &&
      idTypeIndex.value >= 0 &&
      idNumber.value.isNotEmpty &&
      faceUrl.value != null &&
      faceUrl.value!.isNotEmpty;

  /// ───────────────── LIFECYCLE ─────────────────
  @override
  void onInit() {
    super.onInit();
    _nameWorker = ever(name, (v) {
      if (nameController.text != v) {
        nameController.text = v;
      }
    });
    _idWorker = ever(idNumber, (v) {
      if (idController.text != v) {
        idController.text = v;
      }
    });
    getInitData();
  }

  @override
  void onClose() {
    _nameWorker.dispose(); // 🧹
    _idWorker.dispose(); // 🧹
    nameController.dispose();
    idController.dispose();
    super.onClose();
  }

  /// ───────────────── API ─────────────────
  Future<void> getLatestIdentifyOrderList() async {
    final list = await UserApi.getIdentifyOrderList();
    latestSubmittedInfo = list.isNotEmpty ? list.first : null;
    latestIdentifyOrderStatus.value = latestSubmittedInfo?.status;
  }

  Future<void> getInitData() async {
    try {
      isLoading.value = true;

      final results = await Future.wait([
        CommonApi.getDictList(parentKey: 'id_kind'),
        CommonApi.getCountryList(),
        CommonApi.getConfig(type: 'identify_config'),
      ]);

      await getLatestIdentifyOrderList(); // 🔁 AFTER

      // ✅ Explicit casts (VERY IMPORTANT)
      final List<Dict> dicts = results[0] as List<Dict>;
      final List<CountryListRes> countries = results[1] as List<CountryListRes>;
      final configRes = results[2] as dynamic; // config response model

      idTypeList.assignAll(dicts);
      countryList.assignAll(countries);
      topTip.value = configRes.data['identify_note'] ?? '';

      if (latestSubmittedInfo != null &&
          countryList.isNotEmpty &&
          idTypeList.isNotEmpty &&
          ['0', '1', '2'].contains(latestSubmittedInfo!.status)) {
        _fillFormFromLatestInfo();
      }
    } finally {
      isLoading.value = false;
    }
  }

  void _fillFormFromLatestInfo() {
    final info = latestSubmittedInfo!;

    countryIndex.value = countryList.indexWhere((c) => c.id == info.countryId);

    idTypeIndex.value = idTypeList.indexWhere((d) => d.key == info.kind);

    name.value = info.realName;
    idNumber.value = info.idNo;
    faceUrl.value = info.frontImage;

    // if (info.expireDate != '00/0000') {
    //   final parts = info.expireDate.split('/');
    //   selectedExpiryDate.value = DateTime(
    //     int.parse(parts[1]),
    //     int.parse(parts[0]),
    //   );
    // }
    selectedExpiryDate.value = ExpiryDateUtils.parse(info.expireDate);
  }

  /// ───────────────── IMAGE PICK ─────────────────
  // Future<void> pickImageFromGallery() async {
  //   if (isIdImageUploading.value) return; // ⛔️ GUARD (HERE)
  //   try {
  //     isIdImageUploading.value = true;

  //     final ImagePicker picker = ImagePicker();
  //     final XFile? picked = await picker.pickImage(
  //       source: ImageSource.gallery,
  //       imageQuality: 85,
  //     );

  //     if (picked == null) {
  //       isIdImageUploading.value = false;
  //       return;
  //     }

  //     final bytes = await picked.readAsBytes();
  //     if (bytes.lengthInBytes > 5 * 1024 * 1024) {
  //       CustomSnackbar.showError(
  //         title: "Error",
  //         message: "Image size cannot exceed 5MB",
  //       );
  //       isIdImageUploading.value = false;
  //       return;
  //     }

  //     // ---------- UPLOAD ----------
  //     final url = await AwsUploadUtil().upload(file: picked);
  //     faceUrl.value = url;
  //   } catch (e) {
  //     CustomSnackbar.showError(
  //       title: "Image Upload Failed",
  //       message: "Image upload failed, please try again",
  //     );
  //     AppLogger.d(e);
  //   } finally {
  //     isIdImageUploading.value = false;
  //   }
  // }

  void removeIdImage() {
    faceUrl.value = null;
  }

  Future<void> pickKYCImage(ValueChanged<String> onPicked) async {
    if (isIdImageUploading.value) return; // ⛔️ GUARD

    isIdImageUploading.value = true;

    try {
      final XFile? pickedFile = await ImagePickerModal.showModal(Get.context!);
      if (pickedFile == null) {
        isIdImageUploading.value = false;
        return;
      }
      removeIdImage();

      // final file = File(pickedFile.path);
      // final size = await file.length();
      final bytes = await pickedFile.readAsBytes();
      final size = bytes.lengthInBytes;
      const maxSize = 5 * 1024 * 1024;

      if (size > maxSize) {
        CustomSnackbar.showError(
          title: "Upload Failed",
          message: "Image is too large. Please upload an image under 5MB.",
        );
        isIdImageUploading.value = false;
        return;
      }

      // ---------- UPLOAD ----------
      final url = await AwsUploadUtil().upload(file: pickedFile);
      onPicked(url);
    } on UploadTooLargeException {
      CustomSnackbar.showError(
        title: "Upload Failed",
        message: "Image is too large. Please upload an image under 5MB.",
      );
    } catch (e) {
      CustomSnackbar.showError(
        title: "Upload Failed",
        message: "Image upload failed, please try again",
      );
    } finally {
      isIdImageUploading.value = false;
    }
  }

  Future<void> onPickIdImage() async {
    await pickKYCImage((String key) {
      faceUrl.value = key;
    });
  }

  /// ───────────────── SUBMIT ─────────────────
  Future<void> submit() async {
    try {
      isLoading.value = true;

      // final formattedDate = selectedExpiryDate.value != null
      //     ? "${selectedExpiryDate.value!.day.toString().padLeft(2, '0')}/${selectedExpiryDate.value!.month.toString().padLeft(2, '0')}/${selectedExpiryDate.value!.year}"
      //     : "00/00/0000";
      final formattedDate = ExpiryDateUtils.format(selectedExpiryDate.value);

      if (!isFormReady) {
        CustomSnackbar.showError(
          title: "Error",
          message: "Please complete all required fields",
        );
        return;
      }

      final res = await UserApi.createIdentifyOrder({
        "countryId": countryList[countryIndex.value].id,
        "realName": name.value,
        "kind": idTypeList[idTypeIndex.value].key,
        "expireDate": formattedDate,
        "idNo": idNumber.value,
        "frontImage": faceUrl.value,
      });

      if (res['errorCode'] == 'Success' || res['errorMsg'] == 'SUCCESS') {
        await getLatestIdentifyOrderList();
        CustomSnackbar.showSuccess(
          title: "Success",
          message: "KYC Information Submitted!",
        );
      } else {
        CustomSnackbar.showError(title: "Error", message: "Submission failed");
      }
    } finally {
      isLoading.value = false;
    }
  }
}
