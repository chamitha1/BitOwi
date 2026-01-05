import 'dart:typed_data';
import 'package:BitOwi/core/widgets/custom_snackbar.dart';
import 'package:flutter/foundation.dart';
import 'package:BitOwi/api/account_api.dart';
import 'package:BitOwi/models/chain_symbol_list_res.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gal/gal.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';

class DepositController extends GetxController {
  var isLoading = false.obs;
  var coinList = <ChainSymbolListRes>[].obs;
  var selectedCoin = Rxn<ChainSymbolListRes>();
  var depositAddress = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCoinList();
  }

  Future<void> fetchCoinList() async {
    try {
      isLoading.value = true;
      final list = await AccountApi.getChainSymbolList(chargeFlag: '1');

      coinList.value = list;

      if (coinList.isNotEmpty) {
        selectedCoin.value = coinList.first;
        fetchAddress();
      }
    } catch (e) {
      print("Error fetching coin list: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchAddress() async {
    if (selectedCoin.value == null) return;
    try {
      isLoading.value = true;

      String? symbolToUse = selectedCoin.value?.chainSymbol;
      if (symbolToUse != null) {
        final address = await AccountApi.getChainAddress(symbolToUse);
        depositAddress.value = address;
      }
    } catch (e) {
      print("Error fetching address: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void onCoinSelected(ChainSymbolListRes coin) {
    selectedCoin.value = coin;
    fetchAddress();
  }

  final ScreenshotController screenshotController = ScreenshotController();

  Future<void> saveQrCode(BuildContext context) async {
    if (depositAddress.isEmpty) return;

    try {
      // Check for access permissions
      if (!kIsWeb) {
        final hasAccess = await Gal.hasAccess();
        if (!hasAccess) {
          await Gal.requestAccess();
        }
      }

      final Uint8List? image = await screenshotController.capture();
      if (image != null) {
        await Gal.putImageBytes(
          image,
          name: "deposit_qr_${selectedCoin.value?.symbol ?? 'code'}",
        );

        CustomSnackbar.showSuccess(
          title: "Success",
          message: "QR Code saved to gallery!",
        );
      }
    } catch (e) {
      print("Error saving image: $e");
      CustomSnackbar.showError(
        title: "Error",
        message: "Error saving image: $e",
      );
    }
  }
}
