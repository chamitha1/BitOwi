import 'package:BitOwi/api/account_api.dart';
import 'package:BitOwi/models/withdraw_rule_detail_res.dart';
import 'package:BitOwi/models/account.dart'; 
import 'package:BitOwi/models/chain_symbol_list_res.dart'; // Added
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:BitOwi/api/user_api.dart';
import 'package:BitOwi/constants/sms_constants.dart';
import 'package:BitOwi/core/storage/storage_service.dart';
import 'package:BitOwi/features/auth/presentation/pages/bind_trade_pwd_sheet.dart';
import 'package:BitOwi/features/home/presentation/controllers/balance_controller.dart';
import 'package:BitOwi/features/wallet/presentation/widgets/success_dialog.dart';
import 'package:BitOwi/models/withdraw_request.dart';
import 'package:BitOwi/features/auth/presentation/controllers/user_controller.dart';
import 'package:BitOwi/models/jour.dart';

class WithdrawController extends GetxController {
  final TextEditingController addrController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController tradeController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController googleController = TextEditingController();

  var isLoading = false.obs;
  var ruleInfo = Rxn<WithdrawRuleDetailRes>();
  var availableAmount = '0.00'.obs;
  var note = ''.obs;
  var symbol = ''.obs;
  var accountNumber = ''.obs;
  var lastWithdrawTransaction = Rxn<Jour>();

  var coinList = <ChainSymbolListRes>[].obs;
  var selectedCoin = Rxn<ChainSymbolListRes>();

  @override
  void onInit() {
    super.onInit();

    if (Get.parameters.containsKey('symbol')) {
      symbol.value = Get.parameters['symbol'] ?? '';
      getInitData();
    }
    fetchCoinList();
  }

  void setArgs(String symbolVal, String accountNumVal) async {
    symbol.value = symbolVal;
    if (accountNumVal.isNotEmpty) {
      accountNumber.value = accountNumVal;
    } else {
      // Fallback: Try to get from storage
      final storedAcc = await StorageService.getAccountNumber();
      print("WithdrawController: args account empty, fetched from storage: $storedAcc");
      if (storedAcc != null) {
        accountNumber.value = storedAcc;
      }
    }
    getInitData();
    
    if(coinList.isNotEmpty && symbol.value.isNotEmpty){
       final match = coinList.firstWhereOrNull((c) => c.symbol == symbol.value);
       if(match != null) selectedCoin.value = match;
    }
  }

  Future<void> fetchCoinList() async {
    try {
      // isLoading.value = true; 
      final list = await AccountApi.getChainSymbolList(withdrawFlag: '1');
      coinList.value = list;

      if (symbol.value.isNotEmpty) {
           final match = coinList.firstWhereOrNull((c) => c.symbol == symbol.value);
           if(match != null) selectedCoin.value = match;
      } else if (coinList.isNotEmpty) {
         
         selectedCoin.value = coinList.first;
         symbol.value = coinList.first.symbol ?? '';
         getInitData();
      }

    } catch (e) {
      print("Error fetching coin list: $e");
    } 
  }

  var fee = 0.0.obs;

  void onCoinSelected(ChainSymbolListRes coin) {
    if(coin.symbol == symbol.value) return;

    selectedCoin.value = coin;
    symbol.value = coin.symbol ?? '';
    
    // Clear inputs when switching coins
    addrController.clear();
    amountController.clear();
    tradeController.clear();
    availableAmount.value = '0.00';
    fee.value = 0.0; 

    getInitData();
  }

  void calculateFee(String value) {
    
     if(ruleInfo.value?.withdrawFee != null){
         fee.value = double.tryParse(ruleInfo.value!.withdrawFee!) ?? 0.0;
     } else {
        fee.value = 0.0;
     }
  }

  void getInitData() async {
    if (symbol.value.isEmpty) {
      print("Symbol is empty");
      return;
    }

    try {
      isLoading.value = true;

      // Fetch Rules
      print("Fetching rules for ${symbol.value}...");
      final ruleRes = await AccountApi.getWithdrawRuleDetail(symbol.value);
      ruleInfo.value = ruleRes; 
      
      // Update Fee from Rule
      if(ruleRes.withdrawFee != null) {
          fee.value = double.tryParse(ruleRes.withdrawFee!) ?? 0.0;
      }

      // Fetch Account Balance
      // print("Fetching details for ${symbol.value}...");
      final accountRes = await AccountApi.getDetailAccount(symbol.value);

      note.value = ruleRes.withdrawRule ?? ''; // Use empty default if null
      
      // Update min amount text logic if needed, usually just displayed in UI from ruleInfo
      
      availableAmount.value = accountRes.availableAmount?.toString() ?? '0.00';
    } catch (e) {
      print("Error fetching withdraw init data: $e");
      
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> beforeSend() async {
    final payCardNo = addrController.text.trim();
    final amount = amountController.text.trim();
    final tradePwd = tradeController.text.trim();

    if (payCardNo.isEmpty) {
      Get.snackbar("Error", "Please enter withdrawal address or scan QR");
      return false;
    } else if (amount.isEmpty) {
      Get.snackbar("Error", "Please enter withdrawal amount");
      return false;
    } else if (double.tryParse(amount) == null) {
      Get.snackbar("Error", "Invalid amount");
      return false;
    } else if (tradePwd.isEmpty) {
      Get.snackbar("Error", "Please enter transaction password");
      return false;
    }

    try {
      isLoading.value = true;
      await AccountApi.withdrawCheck({
        "accountNumber": accountNumber.value,
        "amount": amount,
        "payCardNo": payCardNo,
        "tradePwd": tradePwd,
      });

      await StorageService.saveTempWithdrawData(payCardNo, amount, tradePwd);
      return true;
    } catch (e) {
      print("Withdraw check failed: $e");
      // Extract error
      String errorMsg = e.toString();
      if (errorMsg.startsWith("Exception: ")) {
        errorMsg = errorMsg.replaceFirst("Exception: ", "");
      }
      Get.snackbar("Error", errorMsg);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  void updateAddressFromScan(String scannedCode) {
    if (scannedCode.isNotEmpty) {
      addrController.text = scannedCode;
    }
  }

  Future<bool> sendOtp({SmsBizType type = SmsBizType.withdraw}) async {
    final userController = Get.find<UserController>();
    final email = userController.user.value?.loginName ??
        userController.user.value?.email;

    if (email == null) {
      Get.snackbar("Error", "Could not retrieve user email");
      return false;
    }

    try {
      final res = await UserApi().sendOtp(email: email, bizType: type);
      if (res) {
        Get.snackbar("Success", "OTP sent successfully");
        return true;
      } else {
        Get.snackbar("Error", "Failed to send OTP");
        return false;
      }
    } catch (e) {
      Get.snackbar("Error", "Error sending OTP: $e");
      return false;
    }
  }

  Future<bool> finalizeWithdrawal(String otp) async {
    isLoading.value = true;
    try {
      // Retrieve saved data
      final tempData = await StorageService.getTempWithdrawData();
      final savedAddr = tempData['addr'];
      final savedAmount = tempData['amount'];
      final savedPwd = tempData['pwd'];

      if (savedAddr == null || savedAmount == null || savedPwd == null) {
        Get.snackbar("Error", "Session expired. Please try again.");
        return false;
      }

      print("Finalizing Withdrawal: Creating Withdrawal directly...");

      // Create Withdrawal
      final params = {
        "accountNumber": accountNumber.value,
        "amount": savedAmount,
        "payCardNo": savedAddr,
        "tradePwd": savedPwd,
        "smsCaptcha": otp,
        "googleSecret": googleController.text.trim(),
        // "currency": symbol.value,
      };

      await AccountApi.createWithdraw(params);

      await StorageService.clearTempWithdrawData();

      //  Balance Update
      try {
        final currentBalance =
            double.tryParse(availableAmount.value.replaceAll(',', '')) ?? 0.0;
        final withdrawAmount = double.tryParse(savedAmount) ?? 0.0;
        final newBalance = currentBalance - withdrawAmount;
        availableAmount.value = newBalance.toStringAsFixed(8);

        if (Get.isRegistered<BalanceController>()) {
          Get.find<BalanceController>().updateOptimisticBalance(
            symbol.value,
            withdrawAmount,
          );
        }
      } catch (e) {
        print("Error updating local balance: $e");
      }

      final newTx = Jour(
        id: 'temp_${DateTime.now().millisecondsSinceEpoch}',
        transAmount: "-$savedAmount",
        bizType: '2',
        currency: symbol.value,
        createDatetime: DateTime.now().millisecondsSinceEpoch,
        bizNote: 'Processing',
        bizCategory: 'withdraw',
        remark: 'Processing',
        accountNumber: accountNumber.value,
        status: 'Processing',
      );

      lastWithdrawTransaction.value = newTx;
      return true;
    } catch (e) {
      print("Finalize withdrawal error: $e");
      String errorMsg = e.toString();
      if (errorMsg.startsWith("Exception: ")) {
        errorMsg = errorMsg.replaceFirst("Exception: ", "");
      }
      Get.snackbar("Error", errorMsg);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Deprecated onApplyTap - kept empty or removed.
  // rename it to avoid confusion or remove it if not overridden.
  // Since the UI calls it via OtpBottomSheet, we should update the UI call in WithdrawalPage.
  Future<bool> onApplyTap() async {
    return false;
  }

  void setAddress(String address) {
    addrController.text = address;
  }

  void setMaxAmount() {
    amountController.text = availableAmount.value;
  }

  void clearInputs() {
    addrController.clear();
    amountController.clear();
    tradeController.clear();
    googleController.clear();
  }

  @override
  void onClose() {
    addrController.dispose();
    amountController.dispose();
    tradeController.dispose();
    emailController.dispose();
    googleController.dispose();
    super.onClose();
  }
}
