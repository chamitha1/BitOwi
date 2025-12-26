import 'package:BitDo/api/account_api.dart';
import 'package:BitDo/models/chain_symbol_list_res.dart';
import 'package:get/get.dart';

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
}
