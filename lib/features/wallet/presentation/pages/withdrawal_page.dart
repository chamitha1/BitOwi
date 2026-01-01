import 'package:BitOwi/constants/sms_constants.dart';
import 'package:BitOwi/features/auth/presentation/controllers/user_controller.dart';
import 'package:BitOwi/features/auth/presentation/pages/otp_bottom_sheet.dart';
import 'package:BitOwi/features/wallet/presentation/controllers/withdraw_controller.dart';
import 'package:BitOwi/features/wallet/presentation/pages/balance_history_page.dart';
import 'package:BitOwi/features/wallet/presentation/pages/transaction_history_page.dart';
import 'package:BitOwi/features/wallet/presentation/widgets/success_dialog.dart';
import 'package:BitOwi/core/storage/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:BitOwi/features/wallet/presentation/pages/qr_scanner_page.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:BitOwi/features/wallet/presentation/widgets/coin_selector_card.dart'; 
import 'package:get/get.dart';

class WithdrawalPage extends StatefulWidget {
  final String symbol;
  final String accountNumber;

  const WithdrawalPage({
    super.key,
    required this.symbol,
    required this.accountNumber,
  });

  @override
  State<WithdrawalPage> createState() => _WithdrawalPageState();
}

class _WithdrawalPageState extends State<WithdrawalPage> {
  // final TextEditingController _addressController = TextEditingController();
  // final TextEditingController _amountController = TextEditingController();
  final WithdrawController controller = Get.put(WithdrawController());


  bool _isWithdrawAll = false;
  bool _isPasswordObscure = true;
  final double _balance = 543488384.94;

  @override
  void initState() {
    super.initState();
    controller.setArgs(widget.symbol, widget.accountNumber);
  }


  void _toggleWithdrawAll() {
    setState(() {
      _isWithdrawAll = !_isWithdrawAll;
      if (_isWithdrawAll) {
        double maxAmount =
            double.tryParse(
              controller.availableAmount.value.replaceAll(',', ''),
            ) ??
            0.0;

        controller.amountController.text = maxAmount.toString();
   
        controller.calculateFee(maxAmount.toString());
      } else {
        controller.amountController.clear();
        controller.calculateFee('');
      }
    });
  }

  // final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
  }

  bool _isWithdrawEnabled() {
    final amount = double.tryParse(controller.amountController.text) ?? 0.0;
    return controller.addrController.text.isNotEmpty &&
        amount >= 10 &&
        controller.tradeController.text.isNotEmpty;
  }

  void _handleWithdraw() async {
    if (!_isWithdrawEnabled()) return;

    if (!await controller.beforeSend()) return;

    if (!await controller.sendOtp(type: SmsBizType.withdraw)) return;

   
    controller.clearInputs();
    setState(() {
      controller.calculateFee('');
      _isWithdrawAll = false;
    });

    final userController = Get.find<UserController>();
    final email = userController.user.value?.loginName ??
        userController.user.value?.email ??
        '';

    if (!mounted) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: const Color(0xFF000000).withOpacity(0.4),
      builder: (context) => OtpBottomSheet(
        email: email,
        otpLength: 6,
        bizType: SmsBizType.withdraw,

        onVerifyPin: (pin) async {
          controller.emailController.text = pin;
          return await controller.finalizeWithdrawal(pin);
        },

        onResend: () async {
          return await controller.sendOtp();
        },

        onVerified: () {
          Navigator.pop(context);
          showDialog(
            context: context,
            barrierDismissible: false,
            barrierColor: const Color(0xFF000000).withOpacity(0.4),
            builder: (context) => SuccessDialog(
              symbol: widget.symbol,
              accountNumber: widget.accountNumber,
              newTransaction: controller.lastWithdrawTransaction.value,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F9FF),
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(context),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Coin Selector
                    Obx(
                      () => CoinSelectorCard(
                        coinList: controller.coinList,
                        selectedCoin: controller.selectedCoin.value,
                        onCoinSelected: controller.onCoinSelected,
                        isLoading: controller.isLoading.value,
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      "Withdraw Address",
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: Color(0xFF2E3D5B),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: controller.addrController,
                      onChanged: (_) => setState(() {}),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: "Enter withdraw address or scan code",
                        hintStyle: const TextStyle(
                          color: Color(0xFFB9C6E2),
                          fontFamily: 'Inter',
                          fontSize: 14,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 16,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFFDAE0EE),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFFDAE0EE),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFF1D5DE5),
                          ),
                        ),
                        suffixIcon: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            GestureDetector(
                              onTap: () {
                                // Address book logic
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Image.asset(
                                  'assets/icons/withdrawal/book.png',
                                  width: 24,
                                  height: 24,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () async {
                                var status = await Permission.camera.request();
                                if (status.isGranted) {
                                  final result = await Get.to(
                                    () => const QrScannerPage(),
                                  );
                                  if (result != null && result is String) {
                                    controller.updateAddressFromScan(result);
                                  }
                                } else if (status.isPermanentlyDenied) {
                                  openAppSettings();
                                } else {
                                  Get.snackbar(
                                    "Permission Denied",
                                    "Camera permission is required to scan QR codes.",
                                    snackPosition: SnackPosition.BOTTOM,
                                  );
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  right: 12.0,
                                  top: 10,
                                  bottom: 10,
                                  left: 4,
                                ),
                                child: Image.asset(
                                  'assets/icons/withdrawal/scan.png',
                                  width: 24,
                                  height: 24,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Withdraw Amount",
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: Color(0xFF2E3D5B),
                          ),
                        ),
                        Obx(
                          () => Text(
                            "= ${controller.availableAmount.value}",
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              color: Color(0xFF2E3D5B),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: controller.amountController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      onChanged: (val) {
                          
                      },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: "0.00",
                        hintStyle: const TextStyle(
                          color: Color(0xFFB9C6E2),
                          fontFamily: 'Inter',
                          fontSize: 14,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 16,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFFDAE0EE),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFFDAE0EE),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFF1D5DE5),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            GestureDetector(
                              onTap: _toggleWithdrawAll,
                              child: Container(
                                width: 16,
                                height: 16,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: const Color(0xFFDAE0EE),
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(4),
                                  color: _isWithdrawAll
                                      ? const Color(0xFF1D5DE5)
                                      : Colors.transparent,
                                ),
                                child: _isWithdrawAll
                                    ? const Icon(
                                        Icons.check,
                                        size: 12,
                                        color: Colors.white,
                                      )
                                    : null,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              "Withdraw All",
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                                fontSize: 12,
                                color: Color(0xFF2E3D5B),
                              ),
                            ),
                          ],
                        ),
                        Obx(() => Text(
                          "Fee : ${controller.fee.value.toStringAsFixed(2)} ${controller.symbol.value}",
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                            color: Color(0xFF2E3D5B),
                          ),
                        )),
                      ],
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      "Transaction Password",
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: Color(0xFF2E3D5B),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: controller.tradeController,
                      onChanged: (_) => setState(() {}),
                      obscureText: _isPasswordObscure,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: "Enter Transaction Password",
                        hintStyle: const TextStyle(
                          color: Color(0xFF717F9A),
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 16,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFFDAE0EE),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFFDAE0EE),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFF1D5DE5),
                          ),
                        ),
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              _isPasswordObscure = !_isPasswordObscure;
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: SvgPicture.asset(
                              _isPasswordObscure
                                  ? 'assets/icons/forgot_password/eye-slash.svg'
                                  : 'assets/icons/forgot_password/eye.svg',
                              width: 20,
                              height: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    const SizedBox(height: 24),

                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEAF9F0),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset(
                            'assets/icons/withdrawal/lightbulb.png',
                            width: 24,
                            height: 24,
                            color: const Color(0xFF40A372),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Friendly Reminder",
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    color: Color(0xFF40A372),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Obx(() => Text(
                                  controller.note.value.isNotEmpty ? controller.note.value : "Minimum withdrawal amount: ${controller.ruleInfo.value?.minAmount ?? '10'} ${controller.symbol.value}",
                                  style: const TextStyle(
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                    color: Color(0xFF40A372),
                                  ),
                                )),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 130),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          gradient: _isWithdrawEnabled()
                              ? const LinearGradient(
                                  colors: [
                                    Color(0xFF1D5DE5),
                                    Color(0xFF174AB7),
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                )
                              : null,
                          color: _isWithdrawEnabled()
                              ? null
                              : const Color(0xFFB9C6E2),
                        ),
                        child: ElevatedButton(
                          onPressed: _isWithdrawEnabled()
                              ? _handleWithdraw
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            "Withdraw",
                            style: TextStyle(
                              color: _isWithdrawEnabled()
                                  ? Color(0xffFFFFFF)
                                  : Color(0xff717F9A),
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Color(0xffF6F9FF),
            ),
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Image.asset(
                'assets/icons/withdrawal/back_arrow.png',
                width: 24,
                height: 24,
              ),
            ),
          ),
          const SizedBox(width: 12),
          const Text(
            "Blockchain Address",
            style: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
              fontSize: 18,
              color: Color(0xFF151E2F),
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () {
              if (mounted) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TransactionHistoryPage(),
                    settings: RouteSettings(
                      arguments: {
                        'symbol': widget.symbol,
                        'accountNumber': widget.accountNumber,
                      },
                    ),
                  ),
                );
              }
            },
            child: Image.asset(
              'assets/icons/withdrawal/clock.png',
              width: 24,
              height: 24,
            ),
          ),
        ],
      ),
    );
  }
}
