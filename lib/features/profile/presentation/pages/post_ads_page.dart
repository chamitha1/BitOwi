import 'package:BitOwi/api/account_api.dart';
import 'package:BitOwi/api/c2c_api.dart';
import 'package:BitOwi/api/common_api.dart';
import 'package:BitOwi/core/theme/app_input_decorations.dart';
import 'package:BitOwi/core/widgets/app_text.dart';
import 'package:BitOwi/core/widgets/common_appbar.dart';
import 'package:BitOwi/core/widgets/custom_snackbar.dart';
import 'package:BitOwi/core/widgets/primary_button.dart';
import 'package:BitOwi/core/widgets/soft_circular_loader.dart';
import 'package:BitOwi/models/bankcard_list_res.dart';
import 'package:BitOwi/models/coin_list_res.dart';
import 'package:BitOwi/models/dict.dart';
import 'package:BitOwi/utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lazy_load_indexed_stack/lazy_load_indexed_stack.dart';

class PostAdsPage extends StatefulWidget {
  const PostAdsPage({super.key});

  @override
  State<PostAdsPage> createState() => _PostAdsPageState();
}

class _PostAdsPageState extends State<PostAdsPage> {
  String id = '';
  bool isLoading = false;
  int currentStep = 1;

  // ! ------ step 1 ------
  int typeIndex = 0; // 0 buy, 1 sell

  Map<String, String> buyTips = {};
  Map<String, String> sellTips = {};

  late Function debounceGetPrice;

  final TextEditingController premiumController = TextEditingController();
  final TextEditingController highestPriceController = TextEditingController();
  final TextEditingController priceController = TextEditingController(
    text: '473,288,835,774.967',
  );

  List<CoinListRes> coinList = [];
  int coinIndex = 0;

  List<Dict> currencyList = [];
  int currencyIndex = 0;

  List<BankcardListRes> bankCardList = [];
  int bankCardIndex = -1;

  void onPremiumRateChange(String value) {
    if (!value.isNum) {
      premiumController.text = '';
    } else {
      num rate = num.parse(value);
      if (rate > 100) {
        rate = 100;
        premiumController.text = rate.toString();
      } else if (rate < -100) {
        rate = -100;
        premiumController.text = rate.toString();
      }
    }
    debounceGetPrice();
    setState(() {});
  }

  void showInfo(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Info"),
        // content: Text(currentStep == 1 ? buyTips[key] ?? '' : sellTips[key] ?? ''), //todo
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  // ! ------ step 2 ------

  // Step 2 controllers
  final TextEditingController totalQuantityController = TextEditingController();
  String totalAmount = '0.00';

  final TextEditingController minLimitController = TextEditingController();
  final TextEditingController maxLimitController = TextEditingController();

 String? selectedPaymentMethod; // 'bank_card' | 'airtel'
int? selectedBankCardIndex;

  // ! ------ step 3 ------

  final TextEditingController commentController = TextEditingController();

  String openHour = 'any'; // 'any' | 'custom'

  @override
  void dispose() {
    premiumController.dispose();
    highestPriceController.dispose();
    priceController.dispose();

    totalQuantityController.dispose();
    minLimitController.dispose();
    maxLimitController.dispose();

    commentController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    id = Get.parameters["id"] ?? ''; // todo for edit
    getInitData();
    debounceGetPrice = CommonUtils.debounce(getPrice, 300);
    // beStream = EventBusUtil.listenBankcardEdit((event) async {
    //   try {
    //     AccountApi.getBankCardList();
    //     final list = await AccountApi.getBankCardList();
    //     setState(() {
    //       bankCardList = list;
    //     });
    //   } catch (e) {}
    // });
  }

  //! ----- helper methods -----

  Future<void> getInitData() async {
    try {
      setState(() {
        isLoading = true;
      });
      List<Future<dynamic>> futures = [
        // AccountApi.getCoinList({"otcFlag": "1"}), //todo check param
        AccountApi.getCoinList(),
        CommonApi.getDictList(parentKey: 'ads_trade_currency'),
        AccountApi.getBankCardList(),
        CommonApi.getConfig(type: 'buy_ads_hint'),
        CommonApi.getConfig(type: 'sell_ads_hint'),
      ];
      if (id.isNotEmpty) {
        futures.add(C2CApi.getAdsInfo(id));
      }

      final result = await Future.wait(futures);

      coinList = result[0];
      currencyList = result[1];
      bankCardList = result[2];
      buyTips = result[3].data;
      sellTips = result[4].data;
      // if (id.isNotEmpty) {
      //   final adsInfo = result[5] as AdsDetailRes;
      //   typeIndex = int.parse(adsInfo.tradeType);
      //   coinIndex = coinList.indexWhere(
      //     (element) => element.symbol == adsInfo.tradeCoin,
      //   );
      //   currencyIndex = currencyList.indexWhere(
      //     (element) => element.key == adsInfo.tradeCurrency,
      //   );
      //   premiumController.text = (num.parse(adsInfo.premiumRate) * 100).toString();
      //   onPremiumRateChange(premiumController.text);
      //   maxPriceController.text = adsInfo.protectPrice;
      //   priceController.text = adsInfo.truePrice;
      //   totalQuantityController.text = adsInfo.totalCount;
      //   if (adsInfo.totalCount.isNum) {
      //     final truePrice = num.parse(priceController.text);
      //     totalAmount = (truePrice * num.parse(adsInfo.totalCount))
      //         .toStringAsFixed(2);
      //   } else {
      //     totalAmount = '0.00';
      //   }
      //   minLimitController.text = adsInfo.minTrade;
      //   maxLimitController.text = adsInfo.maxTrade;
      //   bankCardIndex = bankCardList.indexWhere(
      //     (element) => element.id == adsInfo.bankcardId,
      //   );
      //   remarkController.text = adsInfo.leaveMessage;
      //   if (adsInfo.displayTime?.isNotEmpty ?? false) {
      //     timeList = adsInfo.displayTime!.map((e) {
      //       final apiWeek = int.parse(e.week);
      //       print({e.week});
      //       final dartWeek = (((apiWeek - 2) % 7) + 7) % 7 + 1;
      //       print("API week: $apiWeek → Dart week: $dartWeek");

      //       return WeekTimePickModalResult(
      //         week: WeekPickModalResult.fromWeekday(int.parse(e.week)),
      //         // week: WeekPickModalResult.fromWeekday(((int.parse(e.week)) % 7) -1),
      //         startTime: TimePickModalResult.fromHour(e.startTime.toInt()),
      //         endTime: TimePickModalResult.fromHour(e.endTime.toInt()),
      //       );
      //     }).toList();
      //     timeTypeIndex = 1;
      //   }
      // }
      getPrice();
      setState(() {});
    } catch (e) {
      print("$e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> getPrice() async {
    try {
      String rate = premiumController.text;
      if (rate.isNum || rate.isEmpty) {
        rate = rate.isEmpty ? '0' : rate;
        final res = await C2CApi.getPrice({
          "tradeCurrency": currencyList[currencyIndex].key,
          "tradeCoin": coinList[coinIndex].symbol,
          "premiumRate": num.parse(rate) / 100,
        });
        priceController.text = res;
        final totalCount = totalQuantityController.text;
        if (totalCount.isNum) {
          final truePrice = num.parse(priceController.text);
          totalAmount = (truePrice * num.parse(totalCount)).toStringAsFixed(2);
        } else {
          totalAmount = '0.00';
        }
        setState(() {});
      }
    } catch (e) {
      print("getPrice error: $e");
    }
  }

  void onNextStepTap() {
    FocusManager.instance.primaryFocus?.unfocus();

    /// STEP 1
    if (currentStep == 1) {
      final premium = premiumController.text;
      final highestPrice = highestPriceController.text;
      if (premium.isEmpty) {
        CustomSnackbar.showSimpleValidation(message: 'Please enter premium');
      } else if (double.tryParse(premium) == null) {
        CustomSnackbar.showSimpleValidation(
          message: 'Premium must be a number',
        );
      } else if (highestPrice.isEmpty) {
        CustomSnackbar.showSimpleValidation(
          message: typeIndex == 0
              ? 'Enter highest price'
              : 'Enter lowest price'.tr,
        );
      } else if (!highestPrice.isNum) {
        CustomSnackbar.showSimpleValidation(
          message: typeIndex == 0
              ? 'Highest price can only be entered as numbers'
              : 'Lowest price can only be entered as numbers',
        );
      } else {
        setState(() => currentStep++);
      }
      return;
    }

    /// STEP 2
    if (currentStep == 2) {
      final totalCount = totalQuantityController.text;
      String msg = typeIndex == 0
          ? 'Enter total purchase amount'
          : 'Enter total sales amount';

      final min = minLimitController.text;
      final max = maxLimitController.text;

      if (totalCount.isEmpty) {
        CustomSnackbar.showSimpleValidation(
          message: 'Please enter buy quantity',
        );
      } else if (!totalCount.isNum) {
        CustomSnackbar.showSimpleValidation(
          message: 'Purchase amount can only be entered as numbers',
        );
      } else if (min.isEmpty) {
        CustomSnackbar.showSimpleValidation(message: 'Enter order limit');
      } else if (!min.isNum) {
        CustomSnackbar.showSimpleValidation(
          message: 'Order limit can only be entered as numbers',
        );
      } else if (max.isEmpty) {
        CustomSnackbar.showSimpleValidation(
          message: 'Please enter maximum limit',
        );
      } else if (!max.isNum) {
        CustomSnackbar.showSimpleValidation(
          message: 'Maximum limit must be numeric',
        );
      }
      //  else if (double.parse(max) < double.parse(min)) {
      //   CustomSnackbar.showSimpleValidation(
      //     message: 'Maximum must be greater than minimum',
      //   );
      // }
      else if (bankCardIndex < 0) {
        CustomSnackbar.showSimpleValidation(
          message: 'Please choose a payment method',
        );
      } else {
        setState(() => currentStep++);
      }
      return;
    }

    /// STEP 3 (Submit)
    if (currentStep == 3) {
      final remark = commentController.text;

      if (remark.isEmpty) {
        CustomSnackbar.showSimpleValidation(
          message: 'Please enter payment comment',
        );
      }
      // else if (timeTypeIndex == 1 && timeList.isEmpty) {
      //  CustomSnackbar.showSimpleValidation(
      //     message: 'Please Add time slot',
      //   );
      // }
      else {
        // _submitAd();
        // TODO: submit
      }
    }
  }

  bool get isBtnDisabled {
    /// STEP 1
    if (currentStep == 1) {
      final premium = premiumController.text;
      final highestPrice = highestPriceController.text;

      return premium.isEmpty ||
          !premium.isNum ||
          highestPrice.isEmpty ||
          !highestPrice.isNum;
    }

    /// STEP 2
    if (currentStep == 2) {
      final total = totalQuantityController.text;
      final min = minLimitController.text;
      final max = maxLimitController.text;

      return total.isEmpty ||
          double.tryParse(total) == null ||
          min.isEmpty ||
          double.tryParse(min) == null ||
          max.isEmpty ||
          double.tryParse(max) == null ||
          double.parse(max) < double.parse(min) ||
          selectedPaymentMethod == null;
    }

    /// STEP 3
    if (currentStep == 3) {
      return commentController.text.isEmpty;
    }

    return true;
  }

  void hideKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  void onPrevStepTap() {
    hideKeyboard();
    setState(() => currentStep--);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: CommonAppBar(title: "Post Ads", onBack: () => Get.back()),
      body: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: isLoading
              ? SoftCircularLoader()
              : Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    /// STEP HEADER
                    Container(
                      margin: const EdgeInsets.only(top: 16),
                      padding: const EdgeInsets.all(16),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0x0F555555),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText.p4Regular(
                            "Step $currentStep of 3",
                            color: Color(0xFF717F9A),
                          ),
                          SizedBox(height: 6),
                          AppText.p2Medium(
                            currentStep == 1
                                ? "Set Types & Prices"
                                : currentStep == 2
                                ? "Set Total Amount and Payment Method"
                                : "Add Comment and Time",
                            color: Color(0xFF151E2F),
                          ),
                        ],
                      ),
                    ),

                    /// FORM
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.only(top: 16, bottom: 16),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0x0F555555),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: LazyLoadIndexedStack(
                            index: currentStep - 1,
                            children: [
                              _buildStep1(),
                              _buildStep2(typeIndex),
                              _buildStep3(),
                            ],
                          ),
                        ),
                      ),
                    ),

                    /// BUTTON
                    Padding(
                      padding: const EdgeInsets.only(bottom: 40.0, top: 20),
                      child: Row(
                        children: [
                          if (currentStep > 1)
                            Expanded(
                              child: PrimaryButton(
                                text: "Previous",
                                enabled: true,
                                onPressed: onPrevStepTap,
                              ),
                            ),
                          if (currentStep > 1) const SizedBox(width: 12),
                          Expanded(
                            child: PrimaryButton(
                              text: currentStep == 3 ? "Post Ad" : "Next",

                              showArrow: true,
                              enabled: !isBtnDisabled,
                              onPressed: isBtnDisabled ? null : onNextStepTap,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  /// ---------- WIDGETS ----------

  Widget _buildToggle({
    required String text,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 48,
          decoration: BoxDecoration(
            color: selected ? const Color(0xFFE8EFFF) : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: selected
                  ? const Color(0xFF1D5DE5)
                  : const Color(0xFFDAE0EE),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                selected ? Icons.radio_button_checked : Icons.radio_button_off,
                size: 18,
                color: selected
                    ? const Color(0xFF1D5DE5)
                    : const Color(0xFF9CA3AF),
              ),
              const SizedBox(width: 8),
              Text(
                text,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: selected
                      ? const Color(0xFF2E3D5B)
                      : const Color(0xFF717F9A),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget _buildDropdown({
  //   required String label,
  //   required String? value,
  //   required String hint,
  //   required List<String> items,
  //   required Function(String) onChanged,
  // }) {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       _buildLabel(label),
  //       Container(
  //         height: 48,
  //         padding: const EdgeInsets.symmetric(horizontal: 12),
  //         decoration: BoxDecoration(
  //           borderRadius: BorderRadius.circular(12),
  //           border: Border.all(color: const Color(0xFFE5E7EB)),
  //         ),
  //         child: DropdownButtonHideUnderline(
  //           child: DropdownButtonFormField<String>(
  //             value: value,
  //             hint: Text(hint),
  //             items: items
  //                 .map((e) => DropdownMenuItem(value: e, child: Text(e)))
  //                 .toList(),
  //             onChanged: (v) => onChanged(v!),
  //             decoration: const InputDecoration(border: InputBorder.none),
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }

  Widget _buildFormField({
    required TextEditingController controller,
    String? hint,
    String? suffix,
    bool enabled = true,
    ValueChanged<String>? onChanged,
  }) {
    return TextField(
      controller: controller,
      enabled: enabled,
      keyboardType: TextInputType.number,
      onChanged: onChanged,
      decoration: AppInputDecorations.textField(
        hintText: hint,
        suffixText: suffix,
      ),
    );
  }

  Widget _squareButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: const Color(0xFFEFF6FF),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: const Color(0xFF1D5DE5)),
      ),
    );
  }

  Widget _buildLabel(String text, {VoidCallback? onInfo}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Text(
            text,
            style: const TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
          ),
          if (onInfo != null) ...[
            const SizedBox(width: 4),
            GestureDetector(
              onTap: onInfo,
              child: const Icon(
                Icons.info_outline,
                size: 16,
                color: Color(0xFF9CA3AF),
              ),
            ),
          ],
        ],
      ),
    );
  }

  //! ----------------- step 1 content -----------------

  Widget _buildStep1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// BUY / SELL
        Row(
          children: [
            _buildToggle(
              text: "Buy",
              selected: typeIndex == 0,
              onTap: () => setState(() => typeIndex = 0),
            ),
            const SizedBox(width: 12),
            _buildToggle(
              text: "Sell",
              selected: typeIndex == 1,
              onTap: () => setState(() => typeIndex = 1),
            ),
          ],
        ),

        const SizedBox(height: 20),

        /// DROPDOWNS
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel("Trading Coin"),
                  Container(
                    height: 48,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE5E7EB)),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButtonFormField<int>(
                        value: coinIndex,
                        isExpanded: true,
                        hint: Text('Select Coin'),
                        items: List.generate(
                          coinList.length,
                          (index) => DropdownMenuItem(
                            value: index,
                            child: Text(
                              coinList[index].symbol ?? '',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        onChanged: (index) {
                          if (index == null) return;
                          setState(() {
                            coinIndex = index;
                          });
                          debounceGetPrice();
                        },
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel("Currency"),
                  Container(
                    height: 48,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE5E7EB)),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButtonFormField<int>(
                        value: currencyIndex,
                        isExpanded: true,
                        hint: Text('Select Currency'),
                        items: List.generate(
                          currencyList.length,
                          (index) => DropdownMenuItem(
                            value: index,
                            child: Text(
                              currencyList[index].value,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        onChanged: (index) {
                          if (index == null) return;
                          setState(() {
                            currencyIndex = index;
                          });
                          debounceGetPrice();
                        },
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),

        /// PREMIUM
        _buildLabel(
          "Premium",
          onInfo: () => showInfo("Premium affects final market price."),
        ),
        Row(
          children: [
            Expanded(
              child: _buildFormField(
                controller: premiumController,
                hint: "Enter Premium",
                suffix: "%",
                onChanged: (value) {
                  onPremiumRateChange(value);
                  setState(() {});
                },
              ),
            ),
            const SizedBox(width: 12),
            _squareButton(Icons.remove, () {
              final value = premiumController.text;
              if (!value.isNum) {
                premiumController.text = '0';
              } else {
                num rate = num.parse(value);
                rate -= 1;
                premiumController.text = rate.toString();
                onPremiumRateChange(rate.toString());
              }
            }),
            const SizedBox(width: 8),
            _squareButton(Icons.add, () {
              final value = premiumController.text;
              if (!value.isNum) {
                premiumController.text = '0';
              } else {
                num rate = num.parse(value);
                rate += 1;
                premiumController.text = rate.toString();
                onPremiumRateChange(rate.toString());
              }
            }),
          ],
        ),

        const SizedBox(height: 20),

        /// PRICE
        _buildLabel(
          "Price",
          onInfo: () =>
              showInfo("Price is auto-calculated and cannot be edited."),
        ),
        _buildFormField(
          controller: priceController,
          enabled: false,
          onChanged: (_) => setState(() {}),
        ),

        const SizedBox(height: 20),

        /// HIGHEST PRICE
        _buildLabel(
          typeIndex == 0 ? 'Highest price' : 'Lowest price',
          onInfo: () => showInfo("Maximum acceptable price for this ad."),
        ),
        _buildFormField(
          controller: highestPriceController,
          hint: typeIndex == 0 ? 'Enter highest price' : 'Enter lowest price',
          suffix: currencyList.isNotEmpty
              ? currencyList[currencyIndex].value
              : '',
          enabled: true,
          onChanged: (_) => setState(() {}),
        ),
      ],
    );
  }

  //! ----------------- step 2 content -----------------

  Widget _buildStep2(int typeIndex) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // / BUY QUANTITY
        Row(
          children: [
            _buildLabel(typeIndex == 0 ? 'Buy Quantity' : 'Sold quantity'),
            //todo not in ui
            // Text.rich(TextSpan(
            //   children: [
            //     const TextSpan(text: '≈ '),
            //     TextSpan(
            //       text: totalAmount,
            //       style: const TextStyle(fontFamily: 'DINAlternate'),
            //     ),
            //     TextSpan(
            //       text: currencyList.isNotEmpty
            //           ? currencyList[currencyIndex].value
            //           : '',
            //     ),
            //   ],
            //   style: TextStyle(
            //     fontSize: 14.sp,
            //     color: customTheme.p2pPublishTip,
            //     fontFamily: 'SFPro',
            //   ),
            // )),
          ],
        ),
        _buildFormField(
          controller: totalQuantityController,
          hint: typeIndex == 0
              ? 'Enter total purchase amount'
              : 'Enter total sales amount',
          suffix: coinList.isNotEmpty ? coinList[coinIndex].symbol : '',
          onChanged: (_) => setState(() {}),
        ),

        const SizedBox(height: 20),

        /// ORDER LIMIT
        _buildLabel("Order Limit"),
        _buildFormField(
          controller: minLimitController,
          hint: "Min Quantity",
          suffix: currencyList.isNotEmpty
              ? currencyList[currencyIndex].value
              : '',
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 12),
        _buildFormField(
          controller: maxLimitController,
          hint: "Max Quantity",
          suffix: currencyList.isNotEmpty
              ? currencyList[currencyIndex].value
              : '',
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 20),

        /// PAYMENT METHOD
        _buildLabel("Payment Method"),

        _paymentTile(
          id: 'card',
          title: 'Bank Card (**** **** 7654)',
          icon: Icons.credit_card,
        ),

        const SizedBox(height: 12),

        _paymentTile(
          id: 'airtel',
          title: 'Airtel Money',
          icon: Icons.account_balance_wallet,
        ),

        const SizedBox(height: 16),

        GestureDetector(
          onTap: () {
            // add payment method
          },
          child: Row(
            children: const [
              Icon(Icons.add_circle_outline, color: Color(0xFF1D5DE5)),
              SizedBox(width: 8),
              Text(
                "Add Payment Method",
                style: TextStyle(
                  color: Color(0xFF1D5DE5),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _paymentTile({
    required String id,
    required String title,
    required IconData icon,
  }) {
    final selected = selectedPaymentMethod == id;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPaymentMethod = id;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFEFF6FF) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? const Color(0xFF1D5DE5) : const Color(0xFFE5E7EB),
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: selected ? const Color(0xFF1D5DE5) : Colors.grey),
            const SizedBox(width: 12),
            Expanded(child: Text(title)),
            Icon(
              selected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: selected
                  ? const Color(0xFF1D5DE5)
                  : const Color(0xFF9CA3AF),
            ),
          ],
        ),
      ),
    );
  }

  //! ----------------- step 3 content -----------------

  Widget _buildStep3() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// ADS COMMENT
        _buildLabel("Ads Comment"),
        TextField(
          controller: commentController,
          maxLines: 4,
          decoration: AppInputDecorations.textField(
            hintText:
                "Selling USDT with quick confirmation\n"
                "Secure escrow • No delays • Verified merchant",
          ),
        ),

        const SizedBox(height: 20),

        /// OPEN HOUR
        _buildLabel("Open Hour"),

        _radioTile(value: 'any', title: 'Any Time'),

        const SizedBox(height: 12),

        _radioTile(value: 'custom', title: 'Customise'),
      ],
    );
  }

  Widget _radioTile({required String value, required String title}) {
    final selected = openHour == value;

    return GestureDetector(
      onTap: () {
        setState(() {
          openHour = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFEFF6FF) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? const Color(0xFF1D5DE5) : const Color(0xFFE5E7EB),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
            Icon(
              selected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: selected
                  ? const Color(0xFF1D5DE5)
                  : const Color(0xFF9CA3AF),
            ),
          ],
        ),
      ),
    );
  }
}
