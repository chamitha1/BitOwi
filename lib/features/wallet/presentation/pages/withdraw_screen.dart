import 'package:BitOwi/constants/sms_constants.dart';
import 'package:BitOwi/core/widgets/custom_snackbar.dart';
import 'package:BitOwi/features/auth/presentation/controllers/user_controller.dart';
import 'package:BitOwi/features/auth/presentation/pages/otp_bottom_sheet.dart';
import 'package:BitOwi/features/wallet/presentation/controllers/withdraw_controller.dart';
import 'package:BitOwi/features/wallet/presentation/pages/balance_history_page.dart';
import 'package:BitOwi/features/wallet/presentation/pages/transaction_history_page.dart';
import 'package:BitOwi/features/wallet/presentation/widgets/success_dialog.dart';
import 'package:BitOwi/core/storage/storage_service.dart';
import 'package:BitOwi/utils/app_logger.dart';
import 'package:flutter/material.dart';
import 'package:BitOwi/features/wallet/presentation/pages/qr_scanner_page.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:BitOwi/features/wallet/presentation/widgets/coin_selector_card.dart';
import 'package:BitOwi/features/address_book/presentation/pages/address_book_page.dart';
import 'package:get/get.dart';

class WithdrawScreen extends StatefulWidget {
  final String symbol;
  final String accountNumber;

  const WithdrawScreen({
    super.key,
    required this.symbol,
    required this.accountNumber,
  });

  @override
  State<WithdrawScreen> createState() => _WithdrawScreenState();
}

class _WithdrawScreenState extends State<WithdrawScreen> {
  // final TextEditingController _addressController = TextEditingController();
  // final TextEditingController _amountController = TextEditingController();
  final WithdrawController controller = Get.put(WithdrawController());

  bool _isWithdrawAll = false;
  bool _isPasswordObscure = true;

  final _verificationCodeController = TextEditingController();
  final _authenticatorCodeController = TextEditingController();

  // Verification State
  bool _isSendingOtp = false;
  bool _isVerified = false;
  String _verifiedOtp = "";
  String _userEmail = "";

  @override
  void initState() {
    super.initState();
    controller.setArgs(widget.symbol, widget.accountNumber);
    _loadUserEmail();
  }

  void _loadUserEmail() {
    final userController = Get.find<UserController>();
    final user = userController.user.value;
    _userEmail = user?.loginName ?? user?.email ?? "jonothan@gmail.com";
    AppLogger.d("GOOGLE STATUS : ${user?.googleStatus}");
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
    Get.delete<WithdrawController>();
    super.dispose();
  }

  bool _isWithdrawEnabled() {
    final amount = double.tryParse(controller.amountController.text) ?? 0.0;

    final isGoogleEnabled = controller.googleStatus.value == '1';
    final isGoogleCodeEntered =
        !isGoogleEnabled || _authenticatorCodeController.text.isNotEmpty;

    return controller.addrController.text.isNotEmpty &&
        amount >= 10 &&
        controller.tradeController.text.isNotEmpty &&
        _isVerified &&
        isGoogleCodeEntered;
  }

  void _handleWithdraw() async {
    if (!_isWithdrawEnabled()) return;

    final googleCode = _authenticatorCodeController.text.trim();

    final success = await controller.createWithdrawRequest(
      otp: _verifiedOtp,
      googleCode: googleCode,
    );

    if (success) {
      controller.clearInputs();
      _authenticatorCodeController.clear();
      _verificationCodeController.clear();

      setState(() {
        controller.calculateFee('');
        _isWithdrawAll = false;
        _isVerified = false;
        _verifiedOtp = "";
      });

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
    }
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
                    Text(
                      "Withdraw Address",
                      style: const TextStyle(
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
                          color: Color(0xFF717F9A),
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                          fontSize: 15,
                        ),
                        contentPadding: const EdgeInsets.only(
                          left: 10,
                          right: 16,
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
                              onTap: () async {
                                final result = await Get.to(
                                  () => const AddressBookPage(
                                    isSelectionMode: true,
                                  ),
                                );
                                if (result != null && result is String) {
                                  controller.addrController.text = result;
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(4),
                                child: SvgPicture.asset(
                                  'assets/icons/withdrawal/book.svg',
                                  width: 20,
                                  height: 20,
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
                                  CustomSnackbar.showError(
                                    title: "Permission Denied",
                                    message:
                                        "Camera permission is required to scan QR codes.",
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
                                child: SvgPicture.asset(
                                  'assets/icons/withdrawal/scan.svg',
                                  width: 20,
                                  height: 20,
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
                        Text(
                          "Withdraw Amount",
                          style: const TextStyle(
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
                      onChanged: (val) {},
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: "0.00",
                        hintStyle: const TextStyle(
                          color: Color(0xFF717F9A),
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                        ),
                        contentPadding: const EdgeInsets.only(
                          left: 10,
                          right: 16,
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
                            Text(
                              "Withdraw All",
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                                fontSize: 12,
                                color: Color(0xFF2E3D5B),
                              ),
                            ),
                          ],
                        ),
                        Obx(
                          () => Text(
                            "Fee : ${controller.fee.value.toStringAsFixed(2)} ${controller.symbol.value}",
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                              color: Color(0xFF2E3D5B),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    Text(
                      "Transaction Password",
                      style: const TextStyle(
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
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                        ),
                        contentPadding: const EdgeInsets.only(
                          left: 10,
                          right: 16,
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

                    // Verification Code
                    _label("Verification code"),
                    TextFormField(
                      controller: _verificationCodeController,
                      style: const TextStyle(
                        color: Color(0xFF151E2F),
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Inter',
                      ),
                      readOnly: true,
                      decoration: _inputDecoration(
                        hint: _userEmail,
                        fillColor: const Color(0xFFECEFF5),
                        suffixWidget: Padding(
                          padding: const EdgeInsets.only(
                            right: 6,
                            top: 6,
                            bottom: 6,
                          ),
                          child: _verifyButton(
                            text: _isVerified
                                ? "Verified"
                                : (_isSendingOtp ? "Sending..." : "Get a code"),
                            onPressed: _handleGetCode,
                            isEnabled: !_isSendingOtp && !_isVerified,
                            isVerified: _isVerified,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    Obx(() {
                      final isGoogleEnabled =
                          controller.googleStatus.value == '1';
                      if (!isGoogleEnabled) return const SizedBox.shrink();

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _label("Authenticator code"),
                          TextFormField(
                            controller: _authenticatorCodeController,
                            keyboardType: TextInputType.number,
                            style: const TextStyle(
                              color: Color(0xFF151E2F),
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'Inter',
                            ),
                            decoration: _inputDecoration(
                              hint: "Enter Authenticator Code",
                              fillColor: Colors.white,
                            ),
                            onChanged: (_) => setState(
                              () {},
                            ), // Refresh state to enable button
                          ),
                          const SizedBox(height: 24),
                        ],
                      );
                    }),

                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEAF9F0),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SvgPicture.asset(
                            'assets/icons/withdrawal/lightbulb.svg',
                            width: 24,
                            height: 24,
                            color: const Color(0xFF40A372),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Friendly Reminder",
                                  style: const TextStyle(
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    color: Color(0xFF40A372),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Obx(
                                  () => Text(
                                    controller.note.value.isNotEmpty
                                        ? controller.note.value
                                        : "Minimum withdrawal amount: ${controller.ruleInfo.value?.minAmount ?? '10'} ${controller.symbol.value}",
                                    style: const TextStyle(
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14,
                                      color: Color(0xFF40A372),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),

                          color: _isWithdrawEnabled()
                              ? const Color(0xff1D5DE5)
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
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      alignment: Alignment.center,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 32,
            height: 32,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Color(0xffF6F9FF),
            ),
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: SvgPicture.asset(
                'assets/icons/withdrawal/arrow-left.svg',
                width: 24,
                height: 24,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            "Blockchain Address".tr,
            style: const TextStyle(
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
            child: SvgPicture.asset(
              'assets/icons/withdrawal/clock.svg',
              width: 24,
              height: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Color(0xFF2E3D5B),
          fontFamily: 'Inter',
        ),
      ),
    );
  }

  Future<void> _handleGetCode() async {
    if (_isSendingOtp || _isVerified) return;

    setState(() => _isSendingOtp = true);

    //OTP Send
    final success = await controller.sendOtp(type: SmsBizType.withdraw);

    if (!success) {
      if (mounted) setState(() => _isSendingOtp = false);
      return;
    }

    if (mounted) {
      setState(() => _isSendingOtp = false);

      final userController = Get.find<UserController>();
      final email =
          userController.user.value?.loginName ??
          userController.user.value?.email ??
          '';

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
            final isValid = await controller.verifyOtp(pin);
            if (isValid) {
              _verifiedOtp = pin;
            }
            return isValid;
          },

          onResend: () async {
            return await controller.sendOtp();
          },

          onVerified: () {
            Navigator.pop(context);
            setState(() {
              _isVerified = true;
              _verificationCodeController.text = _verifiedOtp;
            });
          },
        ),
      );
    }
  }

  Widget _verifyButton({
    required String text,
    required VoidCallback onPressed,
    required bool isEnabled,
    bool isVerified = false,
  }) {
    return SizedBox(
      height: 32,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: isVerified
              ? const Color(0xffEAF9F0)
              : (isEnabled ? null : const Color(0XFFB9C6E2)),
          gradient: (isEnabled && !isVerified)
              ? const LinearGradient(
                  colors: [Color(0xFF1D5DE5), Color(0xFF28A6FF)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                )
              : null,
          borderRadius: BorderRadius.circular(8),
          border: isVerified
              ? Border.all(color: const Color(0xFFABEAC6), width: 1.0)
              : null,
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            foregroundColor: Colors.white,
            elevation: 0,
            disabledBackgroundColor: Colors.transparent,
            disabledForegroundColor: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: isVerified ? 10 : 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: (isEnabled && !isVerified) ? onPressed : null,
          child: isVerified
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(
                      "assets/icons/forgot_password/check_circle.svg",
                      width: 20,
                      height: 20,
                      colorFilter: const ColorFilter.mode(
                        Color(0xFF40A372),
                        BlendMode.srcIn,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      text,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Inter',
                        color: Color(0xFF40A372),
                      ),
                    ),
                  ],
                )
              : Text(
                  text,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Inter',
                    color: Colors.white,
                  ),
                ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String hint,
    bool enabled = true,
    String? suffixIconPath,
    Widget? suffixWidget,
    bool isPassword = false,
    bool isVisible = false,
    VoidCallback? onToggleVisibility,
    Color? fillColor,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(
        fontSize: 16,
        fontFamily: 'Inter',
        fontWeight: FontWeight.w400,
        color: Color(0xFF717F9A),
      ),
      contentPadding: const EdgeInsets.only(left: 10, right: 16),
      errorStyle: const TextStyle(
        fontSize: 12,
        fontFamily: 'Inter',
        fontWeight: FontWeight.w400,
        color: Color(0xFFE74C3C),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE74C3C), width: 1.0),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE74C3C), width: 1.0),
      ),
      suffixIcon: isPassword && suffixIconPath != null
          ? Padding(
              padding: const EdgeInsets.only(right: 4.0),
              child: IconButton(
                onPressed: enabled ? onToggleVisibility : null,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SvgPicture.asset(
                    suffixIconPath,
                    width: 20,
                    height: 20,
                    colorFilter: const ColorFilter.mode(
                      Color(0xff2E3D5B),
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
            )
          : suffixWidget,
      filled: true,
      fillColor: fillColor ?? Color(0xFFDAE0EE),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFDAE0EE), width: 1.0),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFDAE0EE), width: 1.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFDAE0EE), width: 1.0),
      ),
    );
  }
}
