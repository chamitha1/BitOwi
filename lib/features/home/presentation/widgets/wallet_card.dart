import 'package:BitDo/models/account_detail_res.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../wallet/presentation/pages/deposit_screen.dart';
import '../../../wallet/presentation/pages/withdrawal_page.dart';
import 'package:BitDo/api/account_api.dart';
import 'package:BitDo/core/storage/storage_service.dart';
import 'package:BitDo/features/auth/presentation/controllers/user_controller.dart';
import 'package:BitDo/core/storage/storage_service.dart';

class WalletCard extends StatefulWidget {
  const WalletCard({super.key});

  @override
  State<WalletCard> createState() => _WalletCardState();
}

class _WalletCardState extends State<WalletCard> {
  String _selectedCurrency = "USD";
  bool _isObscured = false;
  late String _userName;

  @override
  void initState() {
    super.initState();
    _fetchBalance();
  }

  AccountDetailAssetRes? _balanceData; //API response
  bool _isLoading = false;
  String? _errorMessage; //  error feedback

  final List<Map<String, String>> _currencies = [
    {'name': 'BTC', 'icon': 'assets/images/home/bitcoin.png'},
    {'name': 'USDT-TRC20', 'icon': 'assets/images/home/usdt.png'},
    {'name': 'BNB', 'icon': 'assets/images/home/binance.png'},
    {'name': 'Tron', 'icon': 'assets/images/home/tron.png'},
  ];

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
              _buildCurrencyDropdown(),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_isLoading)
                const CircularProgressIndicator(
                  color: Colors.white,
                ) // ← CHANGE: Show loading
              else if (_errorMessage != null)
                Text(
                  'Error: $_errorMessage', // ← CHANGE: Show error
                  style: const TextStyle(color: Colors.red, fontSize: 16),
                )
              else
                RichText(
                  text: TextSpan(
                    text: _isObscured
                        ? "******"
                        : "${_balanceData?.totalAmount.split('.').first ?? '0'}.",
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
                              text:
                                  _balanceData?.totalAmount.split('.').last ??
                                  '00',
                              style: TextStyle(
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
            _isObscured
                ? "****"
                : "≈${_balanceData?.totalAsset ?? '0.00'} ${_balanceData?.totalAssetCurrency ?? 'NGN'}",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
              fontFamily: 'Inter',
            ),
          ),
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
                        builder: (context) => const WithdrawalPage(),
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

  Future<void> _fetchBalance() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final res = await AccountApi.getBalanceAccount(
        assetCurrency:
            await StorageService.getCurrency(), 
      );

      print("Total Amount: ${res.totalAmount}");
      print("Total Asset: ${res.totalAsset}");
      print("Account List length: ${res.accountList.length}");

      setState(() {
        _balanceData = res;
      });

      if (res.accountList.isNotEmpty) {
        final accNum = res.accountList.first.accountNumber;
        await StorageService.saveAccountNumber(accNum);

        // Update reactive state
        try {
          Get.find<UserController>().setUserName(accNum);
        } catch (_) {}
      }
    } catch (e) {
      print("Fetch Balance ERROR!- $e");
      setState(() => _errorMessage = e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Widget _buildCurrencyDropdown() {
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
        setState(() {
          _selectedCurrency = value;
        });
        _fetchBalance();
      },
      itemBuilder: (context) => _currencies.map((currency) {
        return PopupMenuItem<String>(
          value: currency['name'],
          child: Row(
            children: [
              Image.asset(currency['icon']!, width: 24, height: 24),
              const SizedBox(width: 8),
              Text(
                currency['name']!,
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
          color: Color(0xff4A7DEA),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _selectedCurrency,
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
