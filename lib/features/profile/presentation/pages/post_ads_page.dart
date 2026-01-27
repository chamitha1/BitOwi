import 'package:BitOwi/api/account_api.dart';
import 'package:BitOwi/api/c2c_api.dart';
import 'package:BitOwi/api/common_api.dart';
import 'package:BitOwi/config/routes.dart';
import 'package:BitOwi/core/theme/app_input_decorations.dart';
import 'package:BitOwi/core/widgets/app_text.dart';
import 'package:BitOwi/core/widgets/common_appbar.dart';
import 'package:BitOwi/core/widgets/common_bottom_sheets.dart';
import 'package:BitOwi/core/widgets/common_image.dart';
import 'package:BitOwi/core/widgets/custom_snackbar.dart';
import 'package:BitOwi/core/widgets/info_dialog.dart';
import 'package:BitOwi/core/widgets/primary_button.dart';
import 'package:BitOwi/core/widgets/soft_circular_loader.dart';
import 'package:BitOwi/models/ads_detail_res.dart';
import 'package:BitOwi/models/bankcard_list_res.dart';
import 'package:BitOwi/models/coin_list_res.dart';
import 'package:BitOwi/models/dict.dart';
import 'package:BitOwi/utils/app_logger.dart';
import 'package:BitOwi/utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
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
  final TextEditingController priceController = TextEditingController(text: '');

  List<CoinListRes> coinList = [];
  int coinIndex = 0;

  List<Dict> currencyList = [];
  int currencyIndex = 0;

  List<BankcardListRes> bankCardList = [];
  int bankCardSelectedIndex = -1; // -1 means nothing selected

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

  // ! ------ step 2 ------

  // Step 2 controllers
  final TextEditingController totalQuantityController = TextEditingController();
  String totalAmount = '0.00';

  final TextEditingController minLimitController = TextEditingController();
  final TextEditingController maxLimitController = TextEditingController();

  // ! ------ step 3 ------

  final TextEditingController commentController = TextEditingController();

  String openHour = 'any'; // 'any' | 'custom'
  final List<TimeSlotModel> timeSlots = [];

  int _weekToIndex(String week) {
    const map = {
      'Monday': 1,
      'Tuesday': 2,
      'Wednesday': 3,
      'Thursday': 4,
      'Friday': 5,
      'Saturday': 6,
      'Sunday': 7,
    };
    return map[week]!;
  }

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
    id = Get.parameters["id"] ?? '';
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

  String _apiWeekToName(int week) {
    const map = {
      1: 'Monday',
      2: 'Tuesday',
      3: 'Wednesday',
      4: 'Thursday',
      5: 'Friday',
      6: 'Saturday',
      7: 'Sunday',
    };
    return map[week] ?? 'Monday';
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
      if (id.isNotEmpty) {
        final adsInfo = result[5] as AdsDetailRes;

        /// BUY / SELL
        typeIndex = int.parse(adsInfo.tradeType);

        /// COIN
        coinIndex = coinList.indexWhere(
          (element) => element.symbol == adsInfo.tradeCoin,
        );

        /// CURRENCY
        currencyIndex = currencyList.indexWhere(
          (element) => element.key == adsInfo.tradeCurrency,
        );

        /// PREMIUM (decimal → percentage)
        premiumController.text = (num.parse(adsInfo.premiumRate) * 100)
            .toString();
        onPremiumRateChange(premiumController.text);

        /// PRICE
        highestPriceController.text = adsInfo.protectPrice;
        priceController.text = adsInfo.truePrice;

        /// TOTAL AMOUNT
        totalQuantityController.text = adsInfo.totalCount;
        if (adsInfo.totalCount.isNum) {
          final truePrice = num.parse(priceController.text);
          totalAmount = (truePrice * num.parse(adsInfo.totalCount))
              .toStringAsFixed(2);
        } else {
          totalAmount = '0.00';
        }

        /// LIMITS
        minLimitController.text = adsInfo.minTrade;
        maxLimitController.text = adsInfo.maxTrade;

        /// PAYMENT METHOD
        bankCardSelectedIndex = bankCardList.indexWhere(
          (element) => element.id == adsInfo.bankcardId,
        );

        /// COMMENT
        commentController.text = adsInfo.leaveMessage;

        /// OPEN HOUR
        if (adsInfo.displayTime?.isNotEmpty ?? false) {
          timeSlots.clear();
          for (final e in adsInfo.displayTime!) {
            timeSlots.add(
              TimeSlotModel(
                week: _apiWeekToName(int.parse(e.week)),
                start: TimeOfDay(hour: e.startTime.toInt(), minute: 0),
                end: TimeOfDay(hour: e.endTime.toInt(), minute: 0),
              ),
            );
          }
          openHour = 'custom';
        }

        //   if (adsInfo.displayTime?.isNotEmpty ?? false) {
        //     timeList = adsInfo.displayTime!.map((e) {
        //       final apiWeek = int.parse(e.week);
        //       AppLogger.d({e.week});
        //       final dartWeek = (((apiWeek - 2) % 7) + 7) % 7 + 1;
        //       AppLogger.d("API week: $apiWeek → Dart week: $dartWeek");

        //       return WeekTimePickModalResult(
        //         week: WeekPickModalResult.fromWeekday(int.parse(e.week)),
        //         // week: WeekPickModalResult.fromWeekday(((int.parse(e.week)) % 7) -1),
        //         startTime: TimePickModalResult.fromHour(e.startTime.toInt()),
        //         endTime: TimePickModalResult.fromHour(e.endTime.toInt()),
        //       );
        //     }).toList();
        //     timeTypeIndex = 1;
        //   }
      }
      getPrice();
      setState(() {});
    } catch (e) {
      AppLogger.d("$e");
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
      AppLogger.d("getPrice error: $e");
    }
  }

  void onSaveDraftTap() {
    FocusManager.instance.primaryFocus?.unfocus();

    final premium = premiumController.text;
    final highestPrice = highestPriceController.text;
    final totalCount = totalQuantityController.text;
    final min = minLimitController.text;
    final max = maxLimitController.text;
    final remark = commentController.text;

    final String totalMsg = typeIndex == 0
        ? 'Enter total purchase amount'
        : 'Enter total sales amount';
    final String totalMsgAsNumber = typeIndex == 0
        ? 'Purchase amount can only be entered as numbers'
        : 'Sales amount can only be entered as numbers';

    /// -------- STEP 1 (PRICE) --------
    if (premium.isEmpty) {
      CustomSnackbar.showSimpleValidation(message: 'Please enter premium');
      return;
    }

    if (!premium.isNum) {
      CustomSnackbar.showSimpleValidation(
        message: 'Premiums can only be entered as numbers',
      );
      return;
    }

    if (highestPrice.isEmpty) {
      CustomSnackbar.showSimpleValidation(
        message: typeIndex == 0 ? 'Enter highest price' : 'Enter lowest price',
      );
      return;
    }

    if (!highestPrice.isNum) {
      CustomSnackbar.showSimpleValidation(
        message: typeIndex == 0
            ? 'Highest price can only be entered as numbers'
            : 'Lowest price can only be entered as numbers',
      );
      return;
    }

    /// -------- STEP 2 (AMOUNT + PAYMENT) --------
    if (totalCount.isEmpty) {
      CustomSnackbar.showSimpleValidation(message: totalMsg);
      return;
    }

    if (!totalCount.isNum) {
      CustomSnackbar.showSimpleValidation(message: totalMsgAsNumber);
      return;
    }

    if (min.isEmpty) {
      CustomSnackbar.showSimpleValidation(message: 'Enter minimum order limit');
      return;
    }

    if (!min.isNum) {
      CustomSnackbar.showSimpleValidation(
        message: 'Order minimum limit can only be entered as numbers',
      );
      return;
    }

    if (max.isEmpty) {
      CustomSnackbar.showSimpleValidation(message: 'Enter maximum order limit');
      return;
    }

    if (!max.isNum) {
      CustomSnackbar.showSimpleValidation(
        message: 'Order maximum limit can only be entered as numbers',
      );
      return;
    }

    if (double.tryParse(max)! < double.tryParse(min)!) {
      CustomSnackbar.showSimpleValidation(
        message: 'Maximum limit must be greater than minimum limit',
      );
      return;
    }

    if (bankCardSelectedIndex < 0) {
      CustomSnackbar.showSimpleValidation(
        message: 'Please choose a payment method',
      );
      return;
    }

    /// -------- STEP 3 (COMMENT + TIME) --------
    if (remark.isEmpty) {
      CustomSnackbar.showSimpleValidation(
        message: 'Please enter payment comment',
      );
      return;
    }

    if (openHour == 'custom' && timeSlots.isEmpty) {
      CustomSnackbar.showSimpleValidation(
        message: 'Please add at least one time slot',
      );
      return;
    }

    if (openHour == 'custom' && !_areAllTimeSlotsValid()) {
      CustomSnackbar.showSimpleValidation(
        message: 'Start time must be before end time',
      );
      return;
    }

    /// -------- SAVE DRAFT --------
    doSubmit(true);
  }

  void onNextStepTap() {
    hideKeyboard();

    /// STEP 1
    if (currentStep == 1) {
      final premium = premiumController.text;
      final highestPrice = highestPriceController.text;
      if (premium.isEmpty) {
        CustomSnackbar.showSimpleValidation(message: 'Please enter premium');
      } else if (double.tryParse(premium) == null) {
        CustomSnackbar.showSimpleValidation(
          message: 'Premiums can only be entered as numbers',
        );
      } else if (highestPrice.isEmpty) {
        CustomSnackbar.showSimpleValidation(
          message: typeIndex == 0
              ? 'Enter highest price'
              : 'Enter lowest price',
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
      String totalMsg = typeIndex == 0
          ? 'Enter total purchase amount'
          : 'Enter total sales amount';
      final String totalMsgAsNumber = typeIndex == 0
          ? 'Purchase amount can only be entered as numbers'
          : 'Sales amount can only be entered as numbers';

      final min = minLimitController.text;
      final max = maxLimitController.text;

      if (totalCount.isEmpty) {
        CustomSnackbar.showSimpleValidation(message: totalMsg);
      } else if (!totalCount.isNum) {
        CustomSnackbar.showSimpleValidation(message: totalMsgAsNumber);
      } else if (min.isEmpty) {
        CustomSnackbar.showSimpleValidation(
          message: 'Enter minimum order limit',
        );
      } else if (!min.isNum) {
        CustomSnackbar.showSimpleValidation(
          message: 'Order minimum limit can only be entered as numbers',
        );
      } else if (max.isEmpty) {
        CustomSnackbar.showSimpleValidation(
          message: 'Enter maximum order limit',
        );
      } else if (!max.isNum) {
        CustomSnackbar.showSimpleValidation(
          message: 'Order maximum limit can only be entered as numbers',
        );
      } else if (double.parse(max) < double.parse(min)) {
        CustomSnackbar.showSimpleValidation(
          message: 'Maximum limit must be greater than minimum limit',
        );
      } else if (bankCardSelectedIndex < 0) {
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
      } else if (openHour == 'custom' && timeSlots.isEmpty) {
        CustomSnackbar.showSimpleValidation(
          message: 'Please add at least one time slot',
        );
      } else if (openHour == 'custom' && !_areAllTimeSlotsValid()) {
        CustomSnackbar.showSimpleValidation(
          message: 'Start time must be before end time',
        );
      } else if (openHour.isEmpty) {
        CustomSnackbar.showSimpleValidation(message: 'Please Add time slot');
      } else {
        doSubmit();
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
          bankCardSelectedIndex < 0;
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

  Future<void> doSubmit([bool saveDraft = false]) async {
    try {
      setState(() {
        isLoading = true;
      });

      String publishType = '';
      // if (id.isNotEmpty) {
      //   //todo has a issue here
      //   publishType = status == '1' ? '3' : '2';
      // } else {
      //   publishType = saveDraft ? "0" : "1";
      // }
      //todo: temp below
      publishType = saveDraft ? "0" : "1";

      final params = {
        "publishType": publishType,

        // BUY / SELL
        "tradeType": typeIndex, // 0 = buy, 1 = sell
        // COIN & CURRENCY
        "tradeCoin": coinList[coinIndex].symbol,
        "tradeCurrency": currencyList[currencyIndex].key,

        // FLAGS
        "onlyTrust": 0,

        // PRICE
        "premiumRate": premiumController.text.isEmpty
            ? 0
            : num.parse(premiumController.text) / 100,

        "protectPrice": highestPriceController.text,

        // AMOUNTS
        "totalCount": totalQuantityController.text,
        "minTrade": minLimitController.text,
        "maxTrade": maxLimitController.text,

        // PAYMENT METHOD
        "bankcardId": bankCardList[bankCardSelectedIndex].id,

        // COMMENT
        "leaveMessage": commentController.text,

        // OPEN HOUR
        "displayTime": openHour == 'any'
            ? []
            //todo check
            : timeSlots
                  .map(
                    (e) => {
                      "week": _weekToIndex(e.week),
                      "startTime": e.start.hour,
                      "endTime": e.end.hour,
                    },
                  )
                  .toList(),
      };

      if (id.isEmpty) {
        final resCreate = await C2CApi.createAds(params);
        // BACKEND-LEVEL ERROR (even though HTTP = 200)
        if (resCreate['code'] != '200') {
          CustomSnackbar.showError(
            title: "Error",
            message: resCreate['errorMsg'] ?? 'Operation failed',
          );
          return;
        } else {
          // SUCCESS
          CustomSnackbar.showSuccess(
            title: "Success",
            message: "Ad created successfully",
          );
        }

        // EventBusUtil.fireAdsEdit();
      } else {
        final resEdit = await C2CApi.editAds({...params, "id": id});

        // BACKEND-LEVEL ERROR (even though HTTP = 200)
        if (resEdit['code'] != '200') {
          CustomSnackbar.showError(
            title: "Error",
            message: resEdit['errorMsg'] ?? 'Operation failed',
          );
          return;
        } else {
          // SUCCESS
          CustomSnackbar.showSuccess(
            title: "Success",
            message: "Ad updated successfully",
          );
        }
        // EventBusUtil.fireAdsEdit();
      }
      Get.back(result: true, closeOverlays: true);
    } catch (e) {
      AppLogger.d("doSubmit error: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: CommonAppBar(
        title: "Post Ads",
        onBack: () => Get.back(),
        actions: [
          TextButton(
            onPressed: onSaveDraftTap,
            child: AppText.p1Medium(
              'Save Draft',
              color: const Color(0xFF1D5DE5),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
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
                    stepHeader(),

                    /// CONTENT
                    Expanded(
                      child: SingleChildScrollView(
                        keyboardDismissBehavior:
                            ScrollViewKeyboardDismissBehavior.onDrag,
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
  ///
  Container stepHeader() {
    return Container(
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
          AppText.p4Regular("Step $currentStep of 3", color: Color(0xFF717F9A)),
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
    );
  }

  Widget _buildLabel(String text, {VoidCallback? onInfo}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          AppText.p3Regular(text, color: Color(0xFF2E3D5B)),
          if (onInfo != null) ...[
            const SizedBox(width: 6),
            GestureDetector(
              onTap: onInfo,
              child: SvgPicture.asset(
                'assets/icons/post_ads/info_circle.svg',
                width: 16,
                height: 16,
              ),
            ),
          ],
        ],
      ),
    );
  }

  void showInfoTip(String title, String key) {
    final message = typeIndex == 0 ? buyTips[key] ?? '' : sellTips[key] ?? '';
    showCommonInfoDialog(context, title: title, message: message);
  }

  Widget _buildFormField({
    required TextEditingController controller,
    String? hint,
    String? suffix,
    bool enabled = true,
    ValueChanged<String>? onChanged,
  }) {
    return Stack(
      alignment: Alignment.centerRight,
      children: [
        TextField(
          controller: controller,
          enabled: enabled,
          keyboardType: TextInputType.number,
          onChanged: onChanged,
          decoration: AppInputDecorations.textField(
            hintText: hint,
            enabled: enabled,
          ),
        ),
        if (suffix != null)
          IgnorePointer(
            child: Padding(
              padding: const EdgeInsets.only(right: 16),
              child: AppText.p2Regular(suffix, color: Color(0xFF717F9A)),
            ),
          ),
      ],
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
                        hint: AppText.p2Regular(
                          'Select Coin',
                          color: const Color(0xFF717F9A),
                        ),
                        icon: Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: const Color(0xFF2E3D5B),
                          size: 20,
                        ),
                        items: List.generate(
                          coinList.length,
                          (index) => DropdownMenuItem(
                            value: index,
                            child: AppText.p2Regular(
                              coinList[index].symbol ?? '',
                              color: Color(0xFF151E2F),
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
                        hint: AppText.p2Regular(
                          'Select Currency',
                          color: const Color(0xFF717F9A),
                        ),
                        icon: Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: const Color(0xFF2E3D5B),
                          size: 20,
                        ),
                        items: List.generate(
                          currencyList.length,
                          (index) => DropdownMenuItem(
                            value: index,
                            child: AppText.p2Regular(
                              currencyList[index].value,
                              color: Color(0xFF151E2F),
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
          onInfo: () => showInfoTip('Premium', 'premiumRate'),
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
            _squareButton(
              premiumController.text.isEmpty
                  ? 'assets/icons/post_ads/minus_square.svg'
                  : 'assets/icons/post_ads/minus_square_selected.svg',

              () {
                final value = premiumController.text;
                if (!value.isNum) {
                  premiumController.text = '0';
                } else {
                  num rate = num.parse(value);
                  rate -= 1;
                  premiumController.text = rate.toString();
                  onPremiumRateChange(rate.toString());
                }
              },
            ),
            const SizedBox(width: 8),
            _squareButton(
              premiumController.text.isEmpty
                  ? 'assets/icons/post_ads/add_square.svg'
                  : 'assets/icons/post_ads/add_square_selected.svg',
              () {
                final value = premiumController.text;
                if (!value.isNum) {
                  premiumController.text = '0';
                } else {
                  num rate = num.parse(value);
                  rate += 1;
                  premiumController.text = rate.toString();
                  onPremiumRateChange(rate.toString());
                }
              },
            ),
          ],
        ),

        const SizedBox(height: 20),

        /// PRICE
        _buildLabel("Price", onInfo: () => showInfoTip('Price', 'price')),
        _buildFormField(
          controller: priceController,
          enabled: false,
          onChanged: (_) => setState(() {}),
        ),

        const SizedBox(height: 20),

        /// HIGHEST PRICE
        _buildLabel(
          typeIndex == 0 ? 'Highest price' : 'Lowest price',
          onInfo: () => showInfoTip(
            typeIndex == 0 ? 'Highest price' : 'Lowest price',
            'protectPrice',
          ),
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

  bool get _isPremiumValid {
    final text = premiumController.text;
    return text.isNotEmpty && text.isNum;
  }

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
          padding: EdgeInsets.symmetric(horizontal: 16),
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
            children: [
              Icon(
                selected ? Icons.radio_button_checked : Icons.radio_button_off,
                size: 18,
                color: selected
                    ? const Color(0xFF1D5DE5)
                    : const Color(0xFF9CA3AF),
              ),
              const SizedBox(width: 8),
              AppText.p3SemiBold(
                text,
                color: selected
                    ? const Color(0xFF2E3D5B)
                    : const Color(0xFF717F9A),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _squareButton(String icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          color: const Color(0xFFF6F9FF),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: EdgeInsets.all(8),
        child: SvgPicture.asset(icon, width: 26, height: 26),
      ),
    );
  }

  //! ----------------- step 2 content -----------------

  Widget _buildStep2(int typeIndex) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // / BUY QUANTITY
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildLabel(
              typeIndex == 0 ? 'Buy quantity' : 'Sold quantity',
              onInfo: () => showInfoTip(
                typeIndex == 0 ? 'Buy quantity' : 'Sold quantity',
                'totalCount',
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2.0),
              child: Text.rich(
                TextSpan(
                  children: [
                    const TextSpan(text: '≈ '),
                    TextSpan(
                      text: totalAmount,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF2E3D5B),
                      ),
                    ),
                    TextSpan(
                      text: currencyList.isNotEmpty
                          ? currencyList[currencyIndex].value
                          : '',
                    ),
                  ],
                  style: TextStyle(fontSize: 14, color: Color(0xFF2E3D5B)),
                ),
              ),
            ),
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
        _buildLabel(
          "Order Limit",
          onInfo: () => showInfoTip('Order Limit', 'trade'),
        ),
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
        _buildLabel(
          "Payment Method",
          onInfo: () => showInfoTip('Payment Method', 'payType'),
        ),
        const SizedBox(height: 4),
        ..._paymentMethodList(),
        const SizedBox(height: 12),
        _addPaymentMethod(),
        const SizedBox(height: 12),
      ],
    );
  }

  List<Widget> _paymentMethodList() {
    return List.generate(bankCardList.length, (index) {
      final card = bankCardList[index];
      final selected = bankCardSelectedIndex == index;

      return GestureDetector(
        onTap: () {
          setState(() {
            bankCardSelectedIndex = index;
          });
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: selected ? const Color(0xFFE8EFFF) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: selected
                  ? const Color(0xFF1D5DE5)
                  : const Color(0xFFECEFF5),
              width: selected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              /// Left icon
              _paymentIcon(card),
              const SizedBox(width: 12),

              /// Title
              Expanded(child: AppText.p2Medium(_cardTitleMasked(card))),

              /// Radio
              Icon(
                selected ? Icons.radio_button_checked : Icons.radio_button_off,
                color: selected
                    ? const Color(0xFF1D5DE5)
                    : const Color(0xFFCBD5E1),
                size: 22,
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _paymentIcon(BankcardListRes card) {
    return card.pic == null
        ? SvgPicture.asset(
            'assets/icons/post_ads/bankcard.svg',
            width: 32,
            height: 32,
          )
        : ClipOval(child: CommonImage(card.pic ?? '', width: 32, height: 32));
  }

  String _cardTitleMasked(BankcardListRes card) {
    final masked = CommonUtils.maskBankno(
      card.bankcardNumber ?? card.bindMobile ?? '',
    );

    return '${card.bankName} ($masked)';
  }

  Widget _addPaymentMethod() {
    return GestureDetector(
      onTap: () async {
        // Get.toNamed(Routes.paymentMethodsPage);
        final result = await CommonBottomSheets.showPaymentMethodBottomSheet();
        if (result == 0) {
          // Bank Card flow
          final refreshed = await Get.toNamed(Routes.addBankCardPage);
          if (refreshed == true) {
            CustomSnackbar.showSuccess(
              title: "Success",
              message: "Bank card added successfully",
            );
            await refrershGetBankCardList();
          }
        } else if (result == 1) {
          // Mobile Money flow
          final refreshed = await Get.toNamed(Routes.addMobileMoneyPage);
          if (refreshed == true) {
            CustomSnackbar.showSuccess(
              title: "Success",
              message: "Mobile money updated successfully",
            );
            await refrershGetBankCardList();
          }
        }
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.add_circle_outline_rounded, color: Color(0xFF1D5DE5)),
          SizedBox(width: 8),
          AppText.p2Medium('Add Payment Method', color: Color(0xFF1D5DE5)),
        ],
      ),
    );
  }

  Future<void> refrershGetBankCardList() async {
    try {
      final resList = await AccountApi.getBankCardList();
      if (!mounted) return;
      setState(() {
        bankCardList = resList;
      });
    } catch (e) {
      AppLogger.d("getBankCardList getList refresh error: $e");
    }
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
          onChanged: (_) => setState(() {}),
        ),

        const SizedBox(height: 20),

        /// OPEN HOUR
        _buildLabel("Open Hour"),

        _radioTile(value: 'any', title: 'Any Time'),

        const SizedBox(height: 12),

        _radioTile(value: 'custom', title: 'Customise'),

        /// 👇 CONDITIONAL UI
        if (openHour == 'custom') ...[
          const SizedBox(height: 16),

          /// Time slot list
          ...timeSlots.asMap().entries.map(
            (entry) => _timeSlotCard(entry.key, entry.value),
          ),

          /// Add time slot button
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [_addTimeSlotButton()],
          ),
        ],
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
            Expanded(child: AppText.p2Medium(title)),
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

  // customise
  Widget _addTimeSlotButton() {
    return GestureDetector(
      onTap: () {
        setState(() {
          timeSlots.add(
            TimeSlotModel(
              week: 'Monday',
              start: const TimeOfDay(hour: 0, minute: 0),
              end: const TimeOfDay(hour: 0, minute: 0),
            ),
          );
        });
      },
      child: Container(
        width: 168,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFF1D5DE5)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_circle_outline, color: Color(0xFF1D5DE5), size: 20),
            SizedBox(width: 8),
            AppText.p2Medium('Add Time Slot', color: Color(0xFF1D5DE5)),
          ],
        ),
      ),
    );
  }

  Widget _timeSlotCard(int index, TimeSlotModel slot) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: Color(0xFFF6F9FF).withOpacity(0.45),
        border: Border.all(color: const Color(0xFFDAE0EE)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          /// Header row
          Row(
            children: [
              DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: slot.week,
                  icon: const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: Color(0xFF2E3D5B),
                    size: 20,
                  ),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF000000),
                  ),
                  items:
                      const [
                            'Monday',
                            'Tuesday',
                            'Wednesday',
                            'Thursday',
                            'Friday',
                            'Saturday',
                            'Sunday',
                          ]
                          .map(
                            (e) => DropdownMenuItem(value: e, child: Text(e)),
                          )
                          .toList(),
                  onChanged: (v) {
                    if (v == null) return;
                    setState(() => slot.week = v);
                  },
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  setState(() => timeSlots.removeAt(index));
                },
                child: const Icon(
                  Icons.close_rounded,
                  color: Color(0xFFE74C3C),
                  size: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          /// Time pickers
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText.p3Regular('Start Time', color: Color(0xFF2E3D5B)),
                    SizedBox(height: 4),
                    _timePicker(slot.start, (t) {
                      // ignore validation if end time is still unset
                      if (!_isUnset(slot.end) &&
                          !_isStartBeforeEnd(t, slot.end)) {
                        CustomSnackbar.showSimpleValidation(
                          message: "Start time must be before end time",
                        );
                        return;
                      }
                      setState(() => slot.start = t);
                    }),
                  ],
                ),
              ),
              Column(
                children: [
                  SizedBox(height: 16),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      "—",
                      style: TextStyle(color: Color(0xFFB9C6E2)),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText.p3Regular('End Time', color: Color(0xFF2E3D5B)),
                    SizedBox(height: 4),
                    _timePicker(slot.end, (t) {
                      // ignore validation if start time is still unset
                      if (!_isUnset(slot.start) &&
                          !_isStartBeforeEnd(slot.start, t)) {
                        CustomSnackbar.showSimpleValidation(
                          message: "End time must be after start time",
                        );
                        return;
                      }
                      setState(() => slot.end = t);
                    }),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  bool _isUnset(TimeOfDay t) => t.hour == 0 && t.minute == 0;

  bool _isStartBeforeEnd(TimeOfDay start, TimeOfDay end) {
    final startMinutes = start.hour * 60 + start.minute;
    final endMinutes = end.hour * 60 + end.minute;
    return startMinutes < endMinutes;
  }

  bool _areAllTimeSlotsValid() {
    for (final slot in timeSlots) {
      //   if (_isUnset(slot.start) || _isUnset(slot.end)) {
      //   return false; // incomplete slot
      // }
      if (!_isStartBeforeEnd(slot.start, slot.end)) {
        return false;
      }
    }
    return true;
  }

  Widget _timePicker(TimeOfDay time, ValueChanged<TimeOfDay> onPicked) {
    return GestureDetector(
      onTap: () async {
        final picked = await showTimePicker(
          context: context,
          initialTime: time,
          builder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(
                alwaysUse24HourFormat: true, // force 24h picker
              ),
              child: Theme(
                data: Theme.of(context).copyWith(
                  colorScheme: Theme.of(
                    context,
                  ).colorScheme.copyWith(primary: const Color(0xFF1D5DE5)),
                  timePickerTheme: const TimePickerThemeData(
                    // selected hour/minute box background
                    hourMinuteColor: Color(0xFFE8EFFF),
                    // selected hour/minute text
                    hourMinuteTextColor: Color(0xFF151E2F),
                    dialHandColor: Color(0xFF1D5DE5),
                  ),
                  textSelectionTheme: const TextSelectionThemeData(
                    cursorColor: Color(0xFF1D5DE5),
                    selectionColor: Color(0x331D5DE5), // optional, soft blue
                    selectionHandleColor: Color(0xFF1D5DE5),
                  ),
                ),
                child: child!,
              ),
            );
          },
        );
        if (picked != null) onPicked(picked);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xFFDAE0EE)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppText.p2Regular(
              _format24Hour(time),
              color: const Color(0xFF454F63),
            ),
            Container(width: 8, color: const Color(0xFFB9C6E2)),
            const Icon(Icons.access_time, size: 18, color: Color(0xFF2E3D5B)),
          ],
        ),
      ),
    );
  }
}

String _format24Hour(TimeOfDay time) {
  final hour = time.hour.toString().padLeft(2, '0');
  final minute = time.minute.toString().padLeft(2, '0');
  return '$hour:$minute';
}

class TimeSlotModel {
  String week;
  TimeOfDay start;
  TimeOfDay end;

  TimeSlotModel({required this.week, required this.start, required this.end});
}
