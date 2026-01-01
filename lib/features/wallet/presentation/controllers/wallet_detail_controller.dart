import 'package:BitOwi/api/account_api.dart';
import 'package:BitOwi/core/storage/storage_service.dart';
import 'package:BitOwi/models/account_detail_account_and_jour_res.dart';
import 'package:BitOwi/models/jour.dart';
import 'package:get/get.dart';

class WalletDetailController extends GetxController {
  var isLoading = false.obs;
  var accountInfo = Rxn<AccountDetailAccountAndJourRes>();
  var transactionList = <Jour>[].obs;
  
  // Pagination
  int pageNum = 1;
  var isEnd = false.obs;
  var isLoadMore = false.obs;

  String symbol = '';
  String accountNumber = '';

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is Map) {
      symbol = args['symbol'] ?? '';
      accountNumber = args['accountNumber'] ?? '';
    } else {
        symbol = Get.parameters['symbol'] ?? '';
        accountNumber = Get.parameters['accountNumber'] ?? '';
    }

    if(accountNumber.isEmpty) {
        // Fallback or error?
        print("WalletDetailController: accountNumber is empty!");
    }
  }
  
  @override
  void onReady() {
      super.onReady();
      refreshData();
  }

  Future<void> refreshData() async {
    try {
      if(symbol.isEmpty || accountNumber.isEmpty) return;
      
      // isLoading.value = transactionList.isEmpty; // Show global loading only on init
      
      // Fetch Account Detail

      final detailRes = await AccountApi.getDetailAccountAndJour(accountNumber, symbol);
      accountInfo.value = detailRes;

      // Refresh List
      pageNum = 1;
      isEnd.value = false;
      await fetchTransactionList(isRefresh: true);

    } catch (e) {
      print("Error refreshing wallet detail: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchTransactionList({bool isRefresh = false}) async {
    if(!isRefresh && isEnd.value) return;
    
    try {
      if(!isRefresh) isLoadMore.value = true;

      final params = {
        "accountNumber": accountNumber,
        "pageNum": pageNum,
        "pageSize": 10,
        "bizCategory": '',
        "type": "0", 
      };

      final res = await AccountApi.getJourPageList(params);
      
      if(isRefresh) {
        transactionList.value = res.list;
      } else {
        transactionList.addAll(res.list);
      }
      
      isEnd.value = res.isEnd;
      if(!isEnd.value) pageNum++;

    } catch (e) {
      print("Error fetching transaction list: $e");
    } finally {
      isLoadMore.value = false;
    }
  }

  void loadMore() {
      fetchTransactionList();
  }
}
