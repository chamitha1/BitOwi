import 'package:BitOwi/api/common_api.dart';
import 'package:BitOwi/api/user_api.dart';
import 'package:BitOwi/core/storage/storage_service.dart';
import 'package:BitOwi/core/widgets/custom_snackbar.dart';
import 'package:BitOwi/core/widgets/image_picker_modal.dart';
import 'package:BitOwi/features/auth/presentation/controllers/user_controller.dart';
import 'package:BitOwi/utils/aws_upload_util.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsController extends GetxController {
  /// ====================== Me ======================

  final RxBool userAvatarLoading = false.obs;
  final RxBool userNicknameLoading = false.obs;

  final nickName = ''.obs;
  final nickNameController = TextEditingController();

  void initNickname() {
    final currentNickname = userController.userName.value;
    nickNameController.text = currentNickname;
    nickName.value = currentNickname;
  }

  @override
  void onClose() {
    nickNameController.clear();
    super.onClose();
  }

  final userController = Get.find<UserController>();

  Future<void> changeUserAvatarImage() async {
    if (userAvatarLoading.value) return;

    userAvatarLoading.value = true;

    try {
      final context = Get.context;
      if (context == null) return;
      final pickedFile = await ImagePickerModal.showModal(context);

      if (pickedFile == null) return;

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
        return;
      }

      final url = await AwsUploadUtil().upload(file: pickedFile);
      await setPhoto(url);
      CustomSnackbar.showSuccess(
        title: "Success",
        message: "Profile image changed successfully",
      );
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
      userAvatarLoading.value = false;
    }
  }

  Future<void> setPhoto(String photo) async {
    await UserApi.modifyUser({"photo": photo});
    userController.userAvatar.value = photo;
  }

  // /// 📝 SUBMIT KYC
  // Future<bool> submitKyc() async {
  //   try {
  //     final res = await UserApi.createIdentifyOrder({
  //       "countryId": countryList[countryIndex.value].id,
  //       "realName": name.value,
  //       "kind": idTypeList[idTypeIndex.value].key,
  //       "expireDate": formattedDate,
  //       "idNo": idNumber.value,
  //       "frontImage": faceUrl.value,
  //     });

  //     return success;
  //   } catch (e) {
  //     return false;
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }

  Future<void> onSave() async {
    if (userNicknameLoading.value) return;

    final nickname = nickNameController.text.trim();

    // Length Check
    if (nickname.isEmpty || nickname.length > 16) {
      CustomSnackbar.showError(
        title: "Warning",
        message: "Nickname must be 1-16 characters",
      );
      return;
    }

    userNicknameLoading.value = true;

    try {
      await setNickname(nickname);
      Get.back();
      CustomSnackbar.showSuccess(
        title: "Success",
        message: "Nickname changed successfully",
      );
    } catch (e) {
      String msg = e.toString();
      if (msg.startsWith("Exception: ")) {
        msg = msg.substring(11);
      }
      CustomSnackbar.showError(
        title: "Error",
        message: msg,
      );
    } finally {
      userNicknameLoading.value = false;
    }
  }

  Future<void> setNickname(String nickname) async {
    await UserApi.modifyUser({"nickname": nickname});
    userController.userName.value = nickname;
  }

  /// ====================== Preferred Currency ======================

  final RxBool currencyLoading = false.obs;

  final RxList<String> currencyList = <String>[].obs;

  /// UI state (temporary)
  final RxInt selectedIndex = 0.obs;

  final RxInt savedIndex = 0.obs;

  final RxBool currencyUpdating = false.obs;

  Future<void> getCurrency() async {
    currencyLoading.value = true;

    try {
      final result = await CommonApi.getDictList(
        parentKey: 'ads_trade_currency',
      );
      currencyList.value = result.map((item) => item.key).toList();

      // Ensure current selected currency is valid/set
      final currentCurrency = await StorageService.getCurrency();
      int index = currencyList.indexOf(currentCurrency);
      //
      savedIndex.value = index == -1 ? 0 : index;
      selectedIndex.value = savedIndex.value;
    } catch (e) {
      savedIndex.value = 0;
      selectedIndex.value = 0;
    } finally {
      currencyLoading.value = false;
    }
  }

  /// UI-only selection
  void onSelect(int index) {
    selectedIndex.value = index;
  }

  /// Persist on Update
  Future<void> onChoseUpdate() async {
    if (selectedIndex.value == savedIndex.value) {
      Get.back(); // nothing changed
      return;
    }

    currencyUpdating.value = true;

    try {
      final currency = currencyList[selectedIndex.value];
      await StorageService.setCurrency(currency);
      savedIndex.value = selectedIndex.value;
      Get.back();
    } catch (e) {
      CustomSnackbar.showError(
        title: "Error",
        message: "Failed to update currency",
      );
    } finally {
      currencyUpdating.value = false;
    }
  }

  /// ====================== ADD BANK CARD ======================
}
