import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class P2PSellScreen extends StatefulWidget {
  const P2PSellScreen({super.key});

  @override
  State<P2PSellScreen> createState() => _P2PSellScreenState();
}

class _P2PSellScreenState extends State<P2PSellScreen> {
  bool isSellQuantityMode = true;
  final TextEditingController _amountController = TextEditingController();
  bool _isMaxChecked = false;

  final String _maxLimitStr = "113788237.00";
  final String _assetName = "BTC";
  final String _fiatName = "NGN";
  final double _pricePerUnit = 3566878988.00; 

  @override
  void initState() {
    super.initState();
    _amountController.addListener(() {
      setState(
        () {},
      ); 
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _onMaxChanged(bool? value) {
    setState(() {
      _isMaxChecked = value ?? false;
      if (_isMaxChecked) {
        _amountController.text = isSellQuantityMode
            ? "9.990007843"
            : _maxLimitStr;
      } else {
        _amountController.clear();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F9FF),
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: const Text(
          "Sell",
          style: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: Color(0xFF151E2F),
          ),
        ),
        titleSpacing: 0,
        centerTitle: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: SvgPicture.asset(
            'assets/icons/merchant_details/arrow_left.svg',
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildTopInfoCard(),
            const SizedBox(height: 16),
            _buildMainInputCard(),
            const SizedBox(height: 16),
            _buildLabel("Payment Method"),
            const SizedBox(height: 8),
            _buildPaymentMethodDropdown(),
            const SizedBox(height: 16),
            _buildMerchantInfoCard(),
            const SizedBox(height: 16),
            _buildTradingAlertCard(),
            const SizedBox(height: 24),
            _buildBottomActions(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildTopInfoCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBF6),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Image.asset(
            'assets/images/home/bitcoin.png',
            width: 48,
            height: 48,
            errorBuilder: (context, error, stackTrace) => const Icon(
              Icons.currency_bitcoin,
              color: Colors.orange,
              size: 48,
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _assetName,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF151E2F),
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                "₦ 3,566,878,988.00",
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF151E2F),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMainInputCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: _buildToggleButton(
                  "Sell Quantity",
                  isSellQuantityMode,
                  () => setState(() => isSellQuantityMode = true),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildToggleButton(
                  "Sell Amount",
                  !isSellQuantityMode,
                  () => setState(() => isSellQuantityMode = false),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Ads Balance Qty",
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF717F9A),
                ),
              ),
              Text(
                "0.00544$_assetName", 
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF151E2F),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          _buildLabel(isSellQuantityMode ? "Sell Quantity" : "Sell Amount"),
          const SizedBox(height: 8),
          TextField(
            controller: _amountController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              hintText: "0.00",
              hintStyle: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Color(0xFF717F9A),
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              suffixText: isSellQuantityMode
                  ? "BTC"
                  : "NGN",
              suffixStyle: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Color(0xFF151E2F),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFDAE0EE)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFDAE0EE)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFF1D5DE5)),
              ),
            ),
          ),
          const SizedBox(height: 8),

          Row(
            children: [
              SizedBox(
                height: 24,
                width: 24,
                child: Checkbox(
                  value: _isMaxChecked,
                  onChanged: _onMaxChanged,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  side: const BorderSide(color: Color(0xFFDAE0EE)),
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                "Max",
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF2E3D5B),
                ),
              ),
              const Spacer(),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            "Limit : 113788237.00 - 2883888",
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Color(0xFF717F9A), 
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "Available Balance : 9.990.0007843 BTC",
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Color(0xFF717F9A),
            ),
          ),
          const SizedBox(height: 16),

          _buildCalculationRow(),
        ],
      ),
    );
  }

  Widget _buildCalculationRow() {
    double inputVal = double.tryParse(_amountController.text) ?? 0.0;

    if (isSellQuantityMode) {
      String receivable = (inputVal * _pricePerUnit).toStringAsFixed(2);

      return Container(
        padding: const EdgeInsets.only(top: 16),
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: Color(0xFFECEFF5))),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Receivable",
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black, 
              ),
            ),
            Text(
              "₦ $receivable",
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF151E2F),
              ),
            ),
          ],
        ),
      );
    } else {
      String sellCrypto = (inputVal / _pricePerUnit).toStringAsFixed(8);

      return Container(
        padding: const EdgeInsets.only(top: 16),
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: Color(0xFFECEFF5))),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Sell",
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Text(
              "$sellCrypto BTC",
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF151E2F),
              ),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildPaymentMethodDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFDAE0EE)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Bank Card - ****5674",
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Color(0xFF151E2F),
            ),
          ),
          SvgPicture.asset(
            'assets/icons/p2p/down-arrow.svg',
            colorFilter: const ColorFilter.mode(
              Color(0xFF151E2F),
              BlendMode.srcIn,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMerchantInfoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Merchant Info",
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF151E2F),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const CircleAvatar(
                radius: 20,
                backgroundImage: AssetImage('assets/images/home/avatar.png'),
              ),
              const SizedBox(width: 12),
              const Text(
                "Melanie Moen",
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF151E2F),
                ),
              ),
              const Spacer(),
              // Verified Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xffEAF9F0),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: const Color(0xFFABEAC6),
                    width: 1.0,
                  ),
                ),
                child: Row(
                  children: [
                    SvgPicture.asset(
                      'assets/icons/forgot_password/check_circle.svg',
                      width: 14,
                      height: 14,
                      colorFilter: const ColorFilter.mode(
                        Color(0xFF40A372),
                        BlendMode.srcIn,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      "Verified",
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF40A372),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              SvgPicture.asset(
                'assets/icons/p2p/like.svg',
                width: 16,
                height: 16,
                colorFilter: const ColorFilter.mode(
                  Colors.orange,
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(width: 4),
              const Text(
                "99.0%",
                style: TextStyle(fontSize: 12, color: Color(0xFF717F9A)),
              ),
              _buildDivider(),
              const Text(
                "Trust  453,657",
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF717F9A),
                  fontWeight: FontWeight.w500,
                ),
              ),
              _buildDivider(),
              const Text(
                "Trade  453,657 / 99.9%",
                style: TextStyle(fontSize: 12, color: Color(0xFF717F9A)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFDAE0EE)),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Ads Message",
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF151E2F),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Selling USDT with quick confirmation.\nSecure Escrow No Delays Verified Merchant",
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF717F9A),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTradingAlertCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBF6),
        border: Border.all(color: const Color(0xFFFFE2C1)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            children: [
              SvgPicture.asset(
                'assets/icons/p2p/lightbulb.svg',
                width: 24,
                height: 24,
                colorFilter: const ColorFilter.mode(
                  Color(0xFFFF9B29),
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                "Trading Alert",
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFFC9710D),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            "1. Please thoroughly understand the seller’s dealing info before proceeding.\n2. Please communicate and make agreements through the platform.",
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Color(0xFFC9710D),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActions() {
    // Validate Input
    bool isValid =
        _amountController.text.isNotEmpty &&
        (double.tryParse(_amountController.text) ?? 0) > 0;

    return Row(
      children: [
        // Contact Button
        Expanded(
          child: SizedBox(
            height: 48,
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFF1D5DE5), width: 2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                backgroundColor: const Color(0xFFF6F9FF),
              ),
              child: const Text(
                "Contact",
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1D5DE5),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        // Sell Button
        Expanded(
          child: SizedBox(
            height: 48,
            child: ElevatedButton(
              onPressed: isValid
                  ? () {
                      // Sell Action
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: isValid
                    ? const Color(0xFF1D5DE5)
                    : const Color(0xFFB9C6E2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
                disabledBackgroundColor: const Color(0xFFB9C6E2),
                disabledForegroundColor: Colors.white,
              ),
              child: Text(
                "Sell",
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isValid
                      ? Colors.white
                      : const Color(
                          0xFF717F9A,
                        ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildToggleButton(String text, bool isActive, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFFE8EFFF) : Colors.white,
          border: isActive ? null : Border.all(color: const Color(0xFFDAE0EE)),
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isActive
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              size: 16,
              color: isActive
                  ? const Color(0xFF1D5DE5)
                  : const Color(0xFFDAE0EE),
            ),
            const SizedBox(width: 8),
            Text(
              text,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isActive
                    ? const Color(0xFF1D5DE5)
                    : const Color(0xFF717F9A),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontFamily: 'Inter',
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: Color(0xFF2E3D5B),
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 6),
      width: 1,
      height: 10,
      color: const Color(0xFFDAE0EE),
    );
  }
}
