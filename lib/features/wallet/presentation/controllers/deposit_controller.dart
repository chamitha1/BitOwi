import 'dart:typed_data';
import 'package:BitOwi/core/widgets/custom_snackbar.dart';
import 'package:BitOwi/utils/app_logger.dart';
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

  //coins: key = symbol, value = list of coins
  var realCoinEnum = <String, List<ChainSymbolListRes>>{}.obs;

  //coin list for dropdown
  var nameList = <ChainSymbolListRes>[].obs;

  var selectedCoin = Rxn<ChainSymbolListRes>();
  var depositAddress = ''.obs;

  var networkList = <String>[].obs;
  var selectedNetwork = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCoinList();
  }

  Future<void> fetchCoinList() async {
    try {
      isLoading.value = true;
      final list = await AccountApi.getChainSymbolList(chargeFlag: '1');

      realCoinEnum.clear();
      nameList.clear();

      for (var element in list) {
        if (element.symbol == null) continue;

        if (!realCoinEnum.containsKey(element.symbol)) {
          realCoinEnum[element.symbol!] = [];
          nameList.add(element);
        }
        realCoinEnum[element.symbol]!.add(element);
      }

      if (nameList.isNotEmpty) {
        if (Get.parameters.containsKey('symbol')) {
           final paramSymbol = Get.parameters['symbol'];
           final match = nameList.firstWhereOrNull((e) => e.symbol == paramSymbol);
           if (match != null) {
             selectedCoin.value = match;
           } else {
             selectedCoin.value = nameList.first;
           }
        } else {
           selectedCoin.value = nameList.first;
        }
        updateNetworkList();
      }
    } catch (e) {
      AppLogger.d("Error fetching coin list: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void updateNetworkList() {
    if (selectedCoin.value == null || selectedCoin.value!.symbol == null)
      return;

    final symbol = selectedCoin.value!.symbol!;
    final chains = realCoinEnum[symbol];

    if (chains != null && chains.isNotEmpty) {
      // get chainTags
      networkList.value = chains
          .map((e) => e.chainTag ?? '')
          .where((e) => e.isNotEmpty)
          .toList();

      if (networkList.isNotEmpty) {
        selectedNetwork.value = networkList.first;
        fetchAddress();
      } else {
        selectedNetwork.value = '';
        depositAddress.value = '';
      }
    } else {
      networkList.clear();
      selectedNetwork.value = '';
      depositAddress.value = '';
    }
  }

  Future<void> fetchAddress() async {
    if (selectedCoin.value == null || selectedNetwork.value.isEmpty) return;

    try {
      isLoading.value = true;
      final symbol = selectedCoin.value!.symbol!;
      final chains = realCoinEnum[symbol];

      if (chains != null) {
        final chainObj = chains.firstWhere(
          (element) => element.chainTag == selectedNetwork.value,
          orElse: () => chains.first,
        );

        if (chainObj.chainSymbol != null) {
          final address = await AccountApi.getChainAddress(
            chainObj.chainSymbol!,
          );
          depositAddress.value = address;
        }
      }
    } catch (e) {
      AppLogger.d("Error fetching address: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void onCoinSelected(ChainSymbolListRes coin) {
    selectedCoin.value = coin;
    updateNetworkList();
  }

  void onNetworkSelected(String network) {
    selectedNetwork.value = network;
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
      AppLogger.d("Error saving image: $e");
      CustomSnackbar.showError(
        title: "Error",
        message: "Error saving image: $e",
      );
    }
  }
}
