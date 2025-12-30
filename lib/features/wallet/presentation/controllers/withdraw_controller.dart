import 'package:BitOwi/api/account_api.dart';
import 'package:BitOwi/models/withdraw_rule_detail_res.dart';
import 'package:BitOwi/models/account.dart'; // Added
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:BitOwi/api/user_api.dart';
import 'package:BitOwi/constants/sms_constants.dart';
import 'package:BitOwi/core/storage/storage_service.dart';
import 'package:BitOwi/features/auth/presentation/pages/bind_trade_pwd_sheet.dart';
import 'package:BitOwi/features/home/presentation/controllers/balance_controller.dart';
import 'package:BitOwi/features/wallet/presentation/widgets/success_dialog.dart';
import 'package:BitOwi/models/withdraw_request.dart';
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

  @override
  void onInit() {
    super.onInit();

    if (Get.parameters.containsKey('symbol')) {
      symbol.value = Get.parameters['symbol'] ?? '';
      getInitData();
    }
  }

  void setArgs(String symbolVal, String accountNumVal) {
    symbol.value = symbolVal;
    accountNumber.value = accountNumVal;
    getInitData();
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

      // Fetch Account Balance
      print("Fetching details for ${symbol.value}...");
      final accountRes = await AccountApi.getDetailAccount(symbol.value);

      ruleInfo.value = ruleRes;
      note.value = ruleRes.withdrawRule ?? 'No special rules.';

      availableAmount.value = accountRes.usableAmount?.toString() ?? '0.00';
    } catch (e) {
      print("Error fetching withdraw init data: $e");

      note.value = "Unable to load withdrawal details. Please try again later.";
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

    await StorageService.saveTempWithdrawData(payCardNo, amount, tradePwd);
    return true;
  }

  void updateAddressFromScan(String scannedCode) {
    if (scannedCode.isNotEmpty) {
      addrController.text = scannedCode;
    }
  }

  Future<bool> sendOtp({SmsBizType type = SmsBizType.bindTradePwd}) async {
    final email = await StorageService.getUserName();
    if (email == null) return false;

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

      print("Finalizing Withdrawal: Bind Password First...");

      final email = await StorageService.getUserName();
      if (email == null) {
        throw Exception("User email not found");
      }

      // Bind Trade Password
      final bindRes = await UserApi().bindTradePwd(
        email: email,
        smsCode: otp,
        tradePwd: savedPwd,
      );

      print("Bind Password Response: $bindRes");

      if (bindRes['code'] != 200 &&
          bindRes['code'] != '200' &&
          bindRes['errorCode'] != 'Success' &&
          bindRes['errorCode'] != 'SUCCESS') {
        throw Exception(
          "Bind Password Failed: ${bindRes['msg'] ?? bindRes['errorMsg'] ?? 'Unknown error'}",
        );
      }
      print("Bind Password Success. Creating Withdrawal...");

      // Create Withdrawal
      final params = {
        "accountNumber": accountNumber.value,
        "amount": savedAmount,
        "payCardNo": savedAddr,
        "tradePwd": savedPwd,
        "smsCaptcha": otp,
        "googleSecret": googleController.text.trim(),
        // "currency": symbol.value,
        // "bizType": '2',
        // "bizCategory": 'withdraw',
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
      Get.snackbar("Error", "$e");
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Deprecated onApplyTap - kept empty or removed.
  // We'll rename it to avoid confusion or remove it if not overridden.
  // Since the UI calls it via OtpBottomSheet, we should update the UI call in WithdrawalPage.
  // But for now, let's leave a stub or just rely on finalizeWithdrawal being called.
  Future<bool> onApplyTap() async {
    // This should not be called directly anymore in the new flow
    return false;
  }

  void setAddress(String address) {
    addrController.text = address;
  }

  void setMaxAmount() {
    amountController.text = availableAmount.value;
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
