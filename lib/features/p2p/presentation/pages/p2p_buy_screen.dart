import 'package:BitOwi/utils/app_logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:dio/dio.dart';
import 'package:BitOwi/models/ads_page_res.dart';
import 'package:BitOwi/models/ads_detail_res.dart';
import 'package:BitOwi/api/p2p_api.dart';
import 'package:BitOwi/core/widgets/common_image.dart';
import 'package:BitOwi/utils/debounce_utils.dart';
import 'package:BitOwi/features/p2p/presentation/widgets/order_confirmation_dialog.dart';
import 'package:BitOwi/core/widgets/custom_snackbar.dart';
import 'package:BitOwi/features/orders/presentation/pages/order_details_page.dart';
import 'package:BitOwi/config/routes.dart';
import 'package:get/get.dart';

class P2PBuyScreen extends StatefulWidget {
  final AdItem adItem;
  final String? coinIcon;

  const P2PBuyScreen({super.key, required this.adItem, this.coinIcon});

  @override
  State<P2PBuyScreen> createState() => _P2PBuyScreenState();
}

class _P2PBuyScreenState extends State<P2PBuyScreen> {
  int tabIndex = 0;
  final TextEditingController _amountController = TextEditingController();
  bool _isMaxChecked = false;

  late String adId;
  AdsDetailRes? adsDetail;
  String amount = '';
  late Function debounceGetDetail;
  String? selectedPaymentMethod;

  @override
  void initState() {
    super.initState();
    adId = widget.adItem.id!;
    debounceGetDetail = DebounceUtils.debounce(getDetail, 300);
    _amountController.addListener(() {
      amount = _amountController.text;
      if (amount.isNotEmpty) {
        debounceGetDetail();
      }
    });
    // Set default payment method from ad
    if (widget.adItem.bankName != null) {
      selectedPaymentMethod = widget.adItem.bankName;
    }
    getDetail();
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  Future<void> getDetail() async {
    try {
      final res = await P2PApi.getAdsInfo(
        adId,
        tradeAmount: tabIndex == 1 ? amount : null,
        count: tabIndex == 0 ? amount : null,
      );
      if (mounted) {
        setState(() {
          adsDetail = res;
        });
      }
    } on DioException catch (e) {
      AppLogger.d("API error: $e");
      final data = e.response?.data;
      final msg = (data is Map) ? (data['errorMsg'] ?? e.message) : e.message;
      CustomSnackbar.showError(title: "Error", message: msg ?? 'Unknown error');
    } catch (e) {
      AppLogger.d("Unexpected error: $e");
      String errorMsg = e.toString();
      if (errorMsg.startsWith("Exception: ")) {
        errorMsg = errorMsg.replaceFirst("Exception: ", "");
        CustomSnackbar.showError(title: "Error", message: errorMsg);
      } else {
        CustomSnackbar.showError(
          title: "Error",
          message: 'Unexpected error occurred',
        );
      }
    }
  }

  void _onMaxChanged(bool? value) {
    setState(() {
      _isMaxChecked = value ?? false;
      if (_isMaxChecked && adsDetail != null) {
        if (tabIndex == 0) {
          _amountController.text = adsDetail!.countMax;
        } else {
          _amountController.text = adsDetail!.tradeAmountMax;
        }
        getDetail();
      } else {
        _amountController.clear();
      }
    });
  }

  String _getCurrencySymbol(String? currency) {
    if (currency == 'NGN') return '₦';
    if (currency == 'USD') return '\$';
    return '';
  }

  String _calculatePositiveRate() {
    final stats = widget.adItem.userStatistics;
    if (stats == null ||
        stats.commentCount == null ||
        stats.commentCount == 0) {
      return '0.0';
    }
    final rate = (stats.commentGoodCount ?? 0) / stats.commentCount! * 100;
    return rate.toStringAsFixed(1);
  }

  String _calculateCompletionRate() {
    final stats = widget.adItem.userStatistics;
    if (stats == null || stats.orderCount == null || stats.orderCount == 0) {
      return '0.0';
    }
    final rate = (stats.orderFinishCount ?? 0) / stats.orderCount! * 100;
    return rate.toStringAsFixed(1);
  }

  Future<void> _onBuyTap() async {
    if (adsDetail == null || amount.isEmpty) return;

    // Validation Logic
    final double inputVal = double.tryParse(amount) ?? 0;
    final double minLimit = double.tryParse(adsDetail!.minTrade) ?? 0;
    final double maxLimit = double.tryParse(adsDetail!.maxTrade) ?? 0;
    final double price = double.tryParse(adsDetail!.truePrice) ?? 0;

    double tradeVal = 0;
    if (tabIndex == 1) {
      // Amount
      tradeVal = inputVal;
    } else {
      // Quantity * Price
      tradeVal = inputVal * price;
    }

    if (tradeVal < minLimit) {
      CustomSnackbar.showError(
        title: "Error",
        message: "Transaction amount lower than minimum amount",
      );
      return;
    }

    if (tradeVal > maxLimit) {
      CustomSnackbar.showError(
        title: "Error",
        message: "You cannot exceed the maximum transaction amount",
      );
      return;
    }

    await OrderConfirmationDialog.show(
      context: context,
      type: "Buying",
      price:
          "${_getCurrencySymbol(adsDetail!.tradeCurrency)} ${adsDetail!.truePrice}",
      amount: tabIndex == 0
          ? "${_getCurrencySymbol(adsDetail!.tradeCurrency)} ${adsDetail!.tradeAmount}"
          : "${_getCurrencySymbol(adsDetail!.tradeCurrency)} $amount",
      qty: tabIndex == 0
          ? "$amount ${adsDetail!.tradeCoin}"
          : "${adsDetail!.count} ${adsDetail!.tradeCoin}",
      onConfirm: () async {
        try {
          final orderId = await P2PApi.buyOrder({
            "adsId": adId,
            "tradeAmount": tabIndex == 1 ? amount : "",
            "count": tabIndex == 0 ? amount : "",
          });

          if (mounted) {
            // Navigate to OrderDetailsPage with the orderId
            Get.off(() => OrderDetailsPage(orderId: orderId));
          }
        } catch (e) {
          String errorMessage = "Transaction failed";
          if (e is DioException) {
            errorMessage = e.error.toString();
          } else {
            errorMessage = e.toString();
          }
          CustomSnackbar.showError(title: "Error", message: errorMessage);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F9FF),
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: const Text(
          "Buy",
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
            SizedBox(height: 20 + MediaQuery.of(context).padding.bottom),
          ],
        ),
      ),
    );
  }

  Widget _buildTopInfoCard() {
    if (adsDetail == null) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBF6),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          CommonImage(
            widget.coinIcon ?? '',
            width: 48,
            height: 48,
            errorWidgetChild: Image.asset(
              'assets/images/home/bitcoin.png',
              width: 48,
              height: 48,
              errorBuilder: (context, error, stackTrace) => const Icon(
                Icons.currency_bitcoin,
                color: Colors.orange,
                size: 48,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                adsDetail!.tradeCoin,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF151E2F),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "${_getCurrencySymbol(adsDetail!.tradeCurrency)} ${adsDetail!.truePrice}",
                style: const TextStyle(
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
          // Toggle Row
          Row(
            children: [
              Expanded(
                child: _buildToggleButton("Buy Quantity", tabIndex == 0, () {
                  setState(() {
                    tabIndex = 0;
                    _amountController.clear();
                    amount = '';
                  });
                  getDetail();
                }),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildToggleButton("Buy Amount", tabIndex == 1, () {
                  setState(() {
                    tabIndex = 1;
                    _amountController.clear();
                    amount = '';
                  });
                  getDetail();
                }),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Balance Info
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
                "${adsDetail?.leftCount ?? '0'} ${adsDetail?.tradeCoin ?? ''}",
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

          // Input Field Area
          _buildLabel(tabIndex == 0 ? "Buy Quantity" : "Buy Amount"),
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
              suffixText: tabIndex == 0
                  ? (adsDetail?.tradeCoin ?? 'USDT')
                  : (adsDetail?.tradeCurrency ?? 'NGN'),
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
              Text(
                "Limit : ${_getCurrencySymbol(adsDetail?.tradeCurrency)}${adsDetail?.minTrade ?? '0'} - ${_getCurrencySymbol(adsDetail?.tradeCurrency)}${adsDetail?.maxTrade ?? '0'}",
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF2E3D5B),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Calculation Result Row
          _buildCalculationRow(),
        ],
      ),
    );
  }

  Widget _buildCalculationRow() {
    if (tabIndex == 0) {
      // By Quantity - show Payable amount
      return Container(
        padding: const EdgeInsets.only(top: 16),
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: Color(0xFFECEFF5))),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Payable",
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF151E2F),
              ),
            ),
            Text(
              "${_getCurrencySymbol(adsDetail?.tradeCurrency)} ${adsDetail?.tradeAmount ?? '0.00'}",
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF717F9A),
              ),
            ),
          ],
        ),
      );
    } else {
      // By Amount - show Receive quantity
      return Container(
        padding: const EdgeInsets.only(top: 16),
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: Color(0xFFECEFF5))),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Receive",
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Text(
              "${adsDetail?.count ?? '0.00'} ${adsDetail?.tradeCoin ?? ''}",
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
    final paymentMethod = widget.adItem.bankName ?? 'Bank Transfer';
    final cardNumber = widget.adItem.bankcardNumber;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFDAE0EE)),
      ),
      child: Text(
        cardNumber != null && cardNumber.length >= 4
            ? "$paymentMethod - ****${cardNumber.substring(cardNumber.length - 4)}"
            : paymentMethod,
        style: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: Color(0xFF151E2F),
        ),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildMerchantInfoCard() {
    return GestureDetector(
      onTap: () {
        if (widget.adItem.userId != null) {
          Get.toNamed(
            Routes.merchantProfilePage,
            arguments: widget.adItem.userId,
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
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
            // User Row
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: adsDetail?.photo != null
                      ? NetworkImage(adsDetail!.photo)
                      : const AssetImage('assets/images/home/avatar.png')
                            as ImageProvider,
                ),
                const SizedBox(width: 12),
                Text(
                  adsDetail?.nickname ?? "Merchant",
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF151E2F),
                  ),
                ),
                const Spacer(),
                // Verified Badge - conditionally shown
                if (widget.adItem.userStatistics?.isTrust == '1')
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
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
            // Stats Row - using userStatistics data
            Row(
              children: [
                // SvgPicture.asset(
                //   'assets/icons/p2p/like.svg',
                //   width: 16,
                //   height: 16,
                //   colorFilter: const ColorFilter.mode(
                //     Colors.orange,
                //     BlendMode.srcIn,
                //   ),
                // ),
                // const SizedBox(width: 4),
                // Text(
                //   "${_calculatePositiveRate()}%",
                //   style: const TextStyle(
                //     fontSize: 12,
                //     color: Color(0xFF717F9A),
                //   ),
                // ),
                // _buildDivider(),
                Text(
                  "Trust  ${widget.adItem.userStatistics?.confidenceCount ?? 0}",
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF717F9A),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                _buildDivider(),
                Text(
                  "Trade  ${widget.adItem.userStatistics?.orderFinishCount ?? 0} / ${_calculateCompletionRate()}%",
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF717F9A),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Ads Message
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFDAE0EE)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
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
                    adsDetail?.leaveMessage ?? "No message",
                    style: const TextStyle(
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
        // Buy Button
        Expanded(
          child: SizedBox(
            height: 48,
            child: ElevatedButton(
              onPressed: isValid ? _onBuyTap : null,
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
                "Buy",
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isValid ? Colors.white : const Color(0xFF717F9A),
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
