import 'package:BitOwi/core/widgets/custom_snackbar.dart';
import 'package:BitOwi/core/widgets/image_picker_modal.dart';
import 'package:BitOwi/utils/aws_upload_util.dart';
import 'package:BitOwi/utils/date_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:BitOwi/api/common_api.dart';
import 'package:BitOwi/api/user_api.dart';
import 'package:BitOwi/models/country_list_res.dart';
import 'package:BitOwi/models/dict.dart';
import 'package:BitOwi/models/identify_order_list_res.dart';
import 'package:image_picker/image_picker.dart';

class KycPersonalInformationController extends GetxController {
  /// 🔄 UI STATE
  final isLoading = false.obs;
  final isIdImageUploading = false.obs;
  final showWarning = true.obs;
  final showCalendar = false.obs;

  /// 📦 DATA
  final countryList = <CountryListRes>[].obs;
  final idTypeList = <Dict>[].obs;

  final countryIndex = (-1).obs;
  var idTypeIndex = (-1).obs;

  final selectedExpiryDate = Rxn<DateTime>();

  final focusedDay = DateTime.now().obs;
  void syncFocusedDay() {
    focusedDay.value = selectedExpiryDate.value ?? DateTime.now();
  }

  final faceUrl = RxnString();

  final name = ''.obs;
  final idNumber = ''.obs;
  final nameController = TextEditingController();
  final idController = TextEditingController();
  late final Worker _nameWorker;
  late final Worker _idWorker;

  IdentifyOrderListRes? latestSubmittedInfo;

  final isEdit = false.obs;
  final merchantStatus = '-1'.obs; // ✅ reactive
  String topTip = '';

  // bool _initialized = false;

  /// 🚀 INIT (called once from page)
  // void init({required bool isEdit, required String merchantStatus}) {
  //   if (_initialized) return; // ✅ prevent re-init
  //   _initialized = true;
  //   this.isEdit = isEdit;
  //   this.merchantStatus.value = merchantStatus; // 🔁 FIX
  //   _loadInitData();
  // }
  @override
  void onReady() {
    super.onReady();

    // 🔥 This runs ONCE per navigation to the screen
    final args = Get.arguments as Map<String, dynamic>;

    isEdit.value = args['isEdit'] ?? false; // 🔁
    merchantStatus.value = args['merchantStatus'] ?? '-1';


    _nameWorker = ever(name, (v) => nameController.text = v);
    _idWorker = ever(idNumber, (v) => idController.text = v);

    _loadInitData();
  }

  @override
  void onClose() {
    _nameWorker.dispose();
    _idWorker.dispose();
    nameController.dispose();
    idController.dispose();
    super.onClose();
  }

  /// 🔎 FORM READY CHECK
  bool get isFormReady =>
      countryIndex.value >= 0 &&
      name.value.isNotEmpty &&
      idTypeIndex.value >= 0 &&
      idNumber.value.isNotEmpty &&
      faceUrl.value != null &&
      faceUrl.value!.isNotEmpty;

  /// 🔁 INIT DATA
  Future<void> _loadInitData() async {
    try {
      isLoading.value = true;

      final results = await Future.wait([
        CommonApi.getDictList(parentKey: 'id_kind'),
        CommonApi.getCountryList(),
        CommonApi.getConfig(type: 'identify_config'),
      ]);

      // ✅ Explicit casts (VERY IMPORTANT)
      final List<Dict> dicts = results[0] as List<Dict>;
      final List<CountryListRes> countries = results[1] as List<CountryListRes>;
      final configRes = results[2] as dynamic; // config response model

      idTypeList.assignAll(dicts);
      countryList.assignAll(countries);

      topTip = configRes.data?['identify_note'] ?? '';

      if (isEdit.value) {
        final list = await UserApi.getIdentifyOrderList();
        if (list.isNotEmpty) {
          final order = list.first;
          countryIndex.value = countryList.indexWhere(
            (e) => e.id == order.countryId,
          );
          idTypeIndex.value = idTypeList.indexWhere((e) => e.key == order.kind);
          name.value = order.realName;
          idNumber.value = order.idNo;
          faceUrl.value = order.frontImage;
          selectedExpiryDate.value = ExpiryDateUtils.parse(order.expireDate);
        }
      }
    } finally {
      isLoading.value = false;
    }
  }

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

  /// 📝 SUBMIT KYC
  Future<bool> submitKyc() async {
    try {
      isLoading.value = true;

      // final formattedDate = selectedExpiryDate.value != null
      //     ? "${selectedExpiryDate.value!.month.toString().padLeft(2, '0')}/${selectedExpiryDate.value!.year}"
      //     : "00/0000";
      final formattedDate = ExpiryDateUtils.format(selectedExpiryDate.value);

      // Guard invalid index access
      if (countryIndex.value < 0 || idTypeIndex.value < 0) {
        return false;
      }

      final res = await UserApi.createIdentifyOrder({
        "countryId": countryList[countryIndex.value].id,
        "realName": name.value,
        "kind": idTypeList[idTypeIndex.value].key,
        "expireDate": formattedDate,
        "idNo": idNumber.value,
        "frontImage": faceUrl.value,
      });
      final success =
          res['errorCode'] == 'Success' || res['errorMsg'] == 'SUCCESS';

      if (success) {
        // 🔁 FETCH LATEST STATUS
        final list = await UserApi.getIdentifyOrderList();

        if (list.isNotEmpty) {
          latestSubmittedInfo = list.first;
          merchantStatus.value = latestSubmittedInfo!.status; // ✅ CRITICAL
        }
      }

      return success;
    } catch (e) {
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
