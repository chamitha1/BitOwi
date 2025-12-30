import 'package:BitOwi/features/home/presentation/controllers/balance_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../wallet/presentation/pages/deposit_screen.dart';
import '../../../wallet/presentation/pages/withdrawal_page.dart';

class WalletCard extends StatefulWidget {
  const WalletCard({super.key});

  @override
  State<WalletCard> createState() => _WalletCardState();
}

class _WalletCardState extends State<WalletCard> {
  final BalanceController controller = Get.put(BalanceController());

  bool _isObscured = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xff1D5DE5), Color(0xff174AB7)],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1D5DE5).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "My Wallet",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Inter',
                ),
              ),
              Obx(() => _buildCurrencyDropdown()),
            ],
          ),
          const SizedBox(height: 16),
          _buildBalanceContent(),
          const SizedBox(height: 24),

          Row(
            children: [
              Expanded(
                child: _walletActionButton(
                  "Deposit",
                  "assets/icons/home/deposit.png",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DepositScreen(),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _walletActionButton(
                  "Withdraw",
                  "assets/icons/home/withdraw.png",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WithdrawalPage(
                          symbol: controller.selectedAsset?.currency ?? '',
                          accountNumber:
                              controller.selectedAsset?.accountNumber ?? '',
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceContent() {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(
          child: CircularProgressIndicator(color: Colors.white),
        );
      }

      if (controller.errorMessage.value.isNotEmpty) {
        return Text(
          'Error: ${controller.errorMessage.value}',
          style: const TextStyle(color: Colors.red, fontSize: 16),
        );
      }

      final asset = controller.selectedAsset;

      final totalAmount = asset?.totalAmount ?? '0.00';
      final totalAsset = asset?.totalAsset ?? '0.00';
      final totalAssetCurrency = asset?.totalAssetCurrency ?? 'USDT';

      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RichText(
                text: TextSpan(
                  text: _isObscured
                      ? "******"
                      : "${totalAmount.split('.').first}.",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Inter',
                  ),
                  children: _isObscured
                      ? []
                      : <TextSpan>[
                          TextSpan(
                            text: totalAmount.contains('.')
                                ? totalAmount.split('.').last
                                : '00',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ],
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isObscured = !_isObscured;
                  });
                },
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: const Color(0xff4A7DEA),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Image.asset(
                    _isObscured
                        ? 'assets/icons/login/eye.png'
                        : 'assets/icons/home/eye_slash.png',
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            _isObscured ? "****" : "≈$totalAsset $totalAssetCurrency",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
              fontFamily: 'Inter',
            ),
          ),
        ],
      );
    });
  }

  Widget _buildCurrencyDropdown() {
    if (controller.balanceData.value == null ||
        controller.balanceData.value!.accountList.isEmpty) {
      return const SizedBox.shrink();
    }

    final currencies = controller.balanceData.value!.accountList;

    return PopupMenuButton<String>(
      offset: const Offset(0, 40),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFFF1F1F8), width: 1),
      ),
      elevation: 8,
      shadowColor: const Color(0x0F555555),
      color: Colors.white,
      onSelected: (value) {
        controller.onChangeCurrency(value);
      },
      itemBuilder: (context) => currencies.map((currency) {
        return PopupMenuItem<String>(
          value: currency.currency,
          child: Row(
            children: [
              _buildNetworkImage(currency.icon),
              const SizedBox(width: 8),
              Text(
                currency.currency,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  fontFamily: 'Inter',
                  color: Color(0xff151E2F),
                ),
              ),
            ],
          ),
        );
      }).toList(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xff4A7DEA),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              controller.selectedCurrency.value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 4),
            Image.asset(
              'assets/icons/home/arrow_down.png',
              width: 16,
              height: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNetworkImage(String url) {
    if (url.isEmpty || !url.startsWith('http')) {
      return Container(
        width: 24,
        height: 24,
        decoration: const BoxDecoration(
          color: Color(0xFFF0F0F0),
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.currency_bitcoin, size: 16, color: Colors.grey),
      );
    }

    return Image.network(
      url,
      width: 24,
      height: 24,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          width: 24,
          height: 24,
          decoration: const BoxDecoration(
            color: Color(0xFFF0F0F0),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.error_outline, size: 16, color: Colors.grey),
        );
      },
    );
  }

  Widget _walletActionButton(
    String text,
    String iconPath, {
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: const Color(0xff1D5DE5),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF1D5DE5).withOpacity(0.3),
              offset: const Offset(0, 4),
              blurRadius: 24,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(iconPath, width: 20, height: 20),
            const SizedBox(width: 8),
            Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 16,
                fontFamily: 'Inter',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
