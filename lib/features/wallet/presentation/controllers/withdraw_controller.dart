import 'package:BitOwi/api/account_api.dart';
import 'package:BitOwi/core/widgets/custom_snackbar.dart';
import 'package:BitOwi/models/withdraw_rule_detail_res.dart';
import 'package:BitOwi/models/account.dart';
import 'package:BitOwi/models/chain_symbol_list_res.dart'; // Added
import 'package:BitOwi/utils/app_logger.dart';
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
  var googleStatus = ''.obs;

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
      // Fallback Try to get from storage
      final storedAcc = await StorageService.getAccountNumber();
      AppLogger.d(
        "WithdrawController: args account empty, fetched from storage: $storedAcc",
      );
      if (storedAcc != null) {
        accountNumber.value = storedAcc;
      }
    }
    getInitData();

    if (coinList.isNotEmpty && symbol.value.isNotEmpty) {
      final match = coinList.firstWhereOrNull((c) => c.symbol == symbol.value);
      if (match != null) selectedCoin.value = match;
    }
  }

  Future<void> fetchCoinList() async {
    try {
      // isLoading.value = true;
      final list = await AccountApi.getChainSymbolList(withdrawFlag: '1');
      coinList.value = list;

      if (symbol.value.isNotEmpty) {
        final match = coinList.firstWhereOrNull(
          (c) => c.symbol == symbol.value,
        );
        if (match != null) selectedCoin.value = match;
      } else if (coinList.isNotEmpty) {
        selectedCoin.value = coinList.first;
        symbol.value = coinList.first.symbol ?? '';
        getInitData();
      }
    } catch (e) {
      AppLogger.d("Error fetching coin list: $e");
    }
  }

  var fee = 0.0.obs;

  void onCoinSelected(ChainSymbolListRes coin) {
    if (coin.symbol == symbol.value) return;

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
    if (ruleInfo.value?.withdrawFee != null) {
      fee.value = double.tryParse(ruleInfo.value!.withdrawFee!) ?? 0.0;
    } else {
      fee.value = 0.0;
    }
  }

  void getInitData() async {
    if (symbol.value.isEmpty) {
      AppLogger.d("Symbol is empty");
      return;
    }

    try {
      isLoading.value = true;

      // Fetch Rules
      AppLogger.d("Fetching rules for ${symbol.value}...");
      final ruleRes = await AccountApi.getWithdrawRuleDetail(symbol.value);
      ruleInfo.value = ruleRes;

      // Update Fee from Rule
      if (ruleRes.withdrawFee != null) {
        fee.value = double.tryParse(ruleRes.withdrawFee!) ?? 0.0;
      }

      // Fetch Account Balance
      // AppLogger.d("Fetching details for ${symbol.value}...");
      final accountRes = await AccountApi.getDetailAccount(symbol.value);

      accountNumber.value = accountRes.accountNumber ?? '';
      note.value = ruleRes.withdrawRule ?? '';

      availableAmount.value = accountRes.usableAmount?.toString() ?? '0.00';
      if (accountRes.user != null) {
        googleStatus.value = accountRes.user?.googleStatus ?? '';
        AppLogger.d("googleStatus from AccountRes ${googleStatus.value}");
      }

      // Fallback: If googleStatus is empt check global User state
      if (googleStatus.value.isEmpty) {
        final userController = Get.find<UserController>();
        final globalStatus = userController.user.value?.googleStatus;
        if (globalStatus != null && globalStatus.isNotEmpty) {
          googleStatus.value = globalStatus;
          AppLogger.d("googleStatus from UserController ${googleStatus.value}");
        }
      }
    } catch (e) {
      AppLogger.d("Error fetching withdraw init data: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> beforeSend() async {
    final payCardNo = addrController.text.trim();
    final amount = amountController.text.trim();
    final tradePwd = tradeController.text.trim();

    if (payCardNo.isEmpty) {
      CustomSnackbar.showError(
        title: "Error",
        message: "Please enter withdrawal address or scan QR",
      );
      return false;
    } else if (amount.isEmpty) {
      CustomSnackbar.showError(
        title: "Error",
        message: "Please enter withdrawal amount",
      );
      return false;
    } else if (double.tryParse(amount) == null) {
      CustomSnackbar.showError(title: "Error", message: "Invalid amount");
      return false;
    } else if (tradePwd.isEmpty) {
      CustomSnackbar.showError(
        title: "Error",
        message: "Please enter transaction password",
      );
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
      AppLogger.d("Withdraw check failed: $e");
      // Extract error
      String errorMsg = e.toString();
      if (errorMsg.startsWith("Exception: ")) {
        errorMsg = errorMsg.replaceFirst("Exception: ", "");
      }
      CustomSnackbar.showError(title: "Error", message: errorMsg);
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
    final email =
        userController.user.value?.loginName ??
        userController.user.value?.email;

    if (email == null) {
      CustomSnackbar.showError(
        title: "Error",
        message: "Could not retrieve user email",
      );
      return false;
    }

    try {
      final res = await UserApi().sendOtp(email: email, bizType: type);
      if (res) {
        CustomSnackbar.showSuccess(
          title: "Success",
          message: "OTP sent successfully",
        );
        return true;
      } else {
        CustomSnackbar.showError(title: "Error", message: "Failed to send OTP");
        return false;
      }
    } catch (e) {
      CustomSnackbar.showError(
        title: "Error",
        message: "Error sending OTP: $e",
      );
      return false;
    }
  }

  Future<bool> verifyOtp(String otp) async {
    return true;
  }

  Future<bool> createWithdrawRequest({
    required String otp,
    required String googleCode,
  }) async {
    isLoading.value = true;
    try {
      final payCardNo = addrController.text.trim();
      final amount = amountController.text.trim();
      final tradePwd = tradeController.text.trim();

      if (payCardNo.isEmpty || amount.isEmpty || tradePwd.isEmpty) {
        CustomSnackbar.showError(
          title: "Error",
          message: "Please fill all fields",
        );
        return false;
      }

      AppLogger.d("Creating Withdrawal Request");

      final params = {
        "accountNumber": accountNumber.value,
        "amount": amount,
        "payCardNo": payCardNo,
        "tradePwd": tradePwd,
        "smsCaptcha": otp,
      };

      if (googleCode.isNotEmpty) {
        params["googleSecret"] = googleCode;
      }

      await AccountApi.createWithdraw(params);

      //  Balance Update
      try {
        final currentBalance =
            double.tryParse(availableAmount.value.replaceAll(',', '')) ?? 0.0;
        final withdrawAmount = double.tryParse(amount) ?? 0.0;
        final newBalance = currentBalance - withdrawAmount;
        availableAmount.value = newBalance.toStringAsFixed(8);

        if (Get.isRegistered<BalanceController>()) {
          Get.find<BalanceController>().updateOptimisticBalance(
            symbol.value,
            withdrawAmount,
          );
        }
      } catch (e) {
        AppLogger.d("Error updating local balance: $e");
      }

      final newTx = Jour(
        id: 'temp_${DateTime.now().millisecondsSinceEpoch}',
        transAmount: "-$amount",
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

      CustomSnackbar.showSuccess(
        title: "Success",
        message: "Withdrawal request created successfully",
      );

      return true;
    } catch (e) {
      AppLogger.d("Create withdrawal error: $e");
      String errorMsg = e.toString();
      if (errorMsg.startsWith("Exception: ")) {
        errorMsg = errorMsg.replaceFirst("Exception: ", "");
      }
      CustomSnackbar.showError(title: "Error", message: errorMsg);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

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
