import 'package:BitOwi/api/account_api.dart';
import 'package:BitOwi/api/common_api.dart';
import 'package:BitOwi/api/user_api.dart';
import 'package:BitOwi/core/storage/storage_service.dart';
import 'package:BitOwi/features/merchant/presentation/pages/personal_information_page.dart';
import 'package:BitOwi/features/merchant/presentation/widgets/decertification_result_dialog.dart';
import 'package:BitOwi/features/merchant/presentation/widgets/decertify_confirmation_bottom_sheet.dart';
import 'package:BitOwi/features/merchant/presentation/widgets/reminder_card.dart';
import 'package:BitOwi/features/merchant/presentation/widgets/step_card.dart';
import 'package:BitOwi/features/merchant/presentation/widgets/verified_merchant_bottom_sheet.dart';
import 'package:BitOwi/features/wallet/presentation/pages/deposit_screen.dart';
import 'package:BitOwi/models/account_asset_res.dart';
import 'package:BitOwi/models/identify_order_list_res.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BecomeMerchantPage extends StatefulWidget {
  const BecomeMerchantPage({super.key});

  @override
  State<BecomeMerchantPage> createState() => _BecomeMerchantPageState();
}

class _BecomeMerchantPageState extends State<BecomeMerchantPage> {
  bool _isLoading = false;
  AccountAssetRes? assetInfo;
  IdentifyOrderListRes? latestSubmittedInfo;

  late EasyRefreshController _controller;

  @override
  void initState() {
    super.initState();
    _controller = EasyRefreshController(controlFinishRefresh: true);
    getInitData();
  }

  Future<void> getInitData() async {
    try {
      // ToastUtil.showLoading();
      setState(() {
        _isLoading = true;
      });

      await Future.wait<void>([
        getLockAmount(),
        getHomeAsset(),
        getLatestIdentifyOrderList(),
        getUSDTAmount(),
      ]);
    } catch (e) {}

    // ToastUtil.dismiss();
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> getHomeAsset() async {
    try {
      // Merchant certification status -1: Not initiated, 0: Under review, 1: Review passed, 2: Review failed, 3: Decertification under review, 4: Decertification
      final res = await AccountApi.getHomeAsset();

      if (res.merchantStatus == '1') {
        final userIdGet = await StorageService.getUserId();
        final isShowed = await StorageService.getMerchantSucTip(
          userIdGet ?? '',
        );
        if (!isShowed) {
          // onetime
          showVerifiedMerchantBottomSheet(context);
        }
        StorageService.setMerchantSucTip(userIdGet ?? '');
      }

      setState(() {
        assetInfo = res;
        // hasEnoughAmount = assetInfo.merchantStatus
      });
    } catch (e) {}
  }

  double usdtAmount = 0;
  String frozenAmount = '';
  String get merchantStatus {
    return assetInfo?.merchantStatus ?? '';
  }

  bool get hasEnoughAmount {
    if (merchantStatus == '0' ||
        merchantStatus == '1' ||
        merchantStatus == '3') {
      return true;
    }
    if (assetInfo == null || double.tryParse(frozenAmount) == null) {
      return false;
    }
    return usdtAmount >= double.parse(frozenAmount);
  }

  Future<void> getLockAmount() async {
    try {
      final res = await CommonApi.getConfig(key: 'merchant_frozen_amount');
      setState(() {
        frozenAmount = res.data["merchant_frozen_amount"] ?? '';
      });
    } catch (e) {}
  }

  Future<void> getUSDTAmount() async {
    try {
      final res = await AccountApi.getDetailAccount('USDT');
      setState(() {
        usdtAmount = double.tryParse(res.availableAmount!) ?? 0;
      });
    } catch (e) {}
  }

  Future<void> getLatestIdentifyOrderList() async {
    try {
      final list = await UserApi.getIdentifyOrderList();

      setState(() {
        latestSubmittedInfo = list.isNotEmpty ? list.first : null;
      });
    } catch (e) {}
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> onRefresh() async {
    try {
      // final futures = [getBannerList()];
      // final isLogin = context.read<AuthProvider>().isLogin;
      // if (isLogin) {
      // futures.add(getHomeAsset());
      await getHomeAsset();
      await getLatestIdentifyOrderList();
      // }
      // await Future.wait<void>(futures);
      // if (isLogin) {
      //   await getAccountList();
      // }
    } catch (e) {
      print(e);
    }
    _controller.finishRefresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F9FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF6F9FF),
        surfaceTintColor: const Color(0xFFF6F9FF),
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: SvgPicture.asset(
            'assets/icons/merchant_details/arrow_left.svg',
            width: 24,
            height: 24,
            colorFilter: const ColorFilter.mode(
              Color(0xFF151E2F),
              BlendMode.srcIn,
            ),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Merchant Details",
          style: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: Color(0xFF151E2F),
          ),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        top: false,
        child: EasyRefresh(
          controller: _controller,
          onRefresh: onRefresh,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: _isLoading
                ? SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: const Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Color(0xFF1D5DE5),
                      ),
                    ),
                  )
                : Column(
                    children: [
                      const SizedBox(height: 24),
                      buildBecomeMerchantIcon(),
                      const SizedBox(height: 24),
                      const Text(
                        "Become a Merchant",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w700,
                          fontSize: 26,
                          color: Color(0xFF151E2F),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Start accepting crypto payments and grow your business",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: Color(0xFF454F63),
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 40),
                      // StepCard 1
                      StepCard(
                        title: "KYC Verification",
                        description:
                            "Your identity helps us keep the platform secure",
                        iconPath: "assets/icons/merchant_details/id_card.svg",
                        stepNumber: "1",
                        iconBackgroundColor: Color(0xFFE9F6FF),
                        secondaryIconPath: latestSubmittedInfo?.status == '2'
                            ? "assets/icons/merchant_details/close-square.svg"
                            : latestSubmittedInfo?.status == '1'
                            ? "assets/icons/merchant_details/tick-circle.svg"
                            : null,
                      ),
                      const SizedBox(height: 16),
                      // StepCard 2
                      StepCard(
                        title: "Deposit Fund",
                        // description:
                        //     "Deposit minimum 1000 USDT to activate merchant account",
                        description: "Deposit amount ${frozenAmount}USDT'",
                        iconPath: "assets/icons/merchant_details/money.svg",
                        stepNumber: "2",
                        iconBackgroundColor: Color(0xFFF4E9FE),
                        secondaryIconPath: hasEnoughAmount
                            ? "assets/icons/merchant_details/tick-circle.svg"
                            : null,
                      ),
                      const SizedBox(height: 24),
                      // Reminder card
                      ReminderCard(
                        merchantStatus: assetInfo?.merchantStatus ?? '',
                        identifyOrderLatestSubmittedInfoStatus:
                            latestSubmittedInfo?.status ?? '',
                      ),
                      const SizedBox(height: 40),
                      // Bottom button
                      _buildActionButton(
                        context,
                        assetInfo?.merchantStatus ?? '',
                        latestSubmittedInfo?.status ?? '',
                        handleMerchantApply,
                        onReturn: () async {
                          await getHomeAsset();
                          await getLatestIdentifyOrderList();
                        },
                      ),
                      const SizedBox(height: 24),
                      if (assetInfo?.merchantStatus == '1')
                        TextButton(
                          onPressed: () {
                            handleRemove(context);
                          },
                          child: const Text(
                            "Decertify as Merchant",
                            style: TextStyle(
                              color: Color(0xFFE54848),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      const SizedBox(height: 40),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Container buildBecomeMerchantIcon() {
    return Container(
      width: 100,
      height: 100,
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [Color(0xFF52B7FF), Color(0xFF1D5DE5)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SvgPicture.asset(
        'assets/icons/merchant_details/shield.svg',
        colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
      ),
    );
  }

  //! Decertify action
  void handleRemove(BuildContext context) {
    showDecertifyConfirmationBottomSheet(
      context,
      onProceed: () async {
        // already proceed? bottom sheet popped
        try {
          setState(() {
            _isLoading = true;
          });
          // ToastUtil.showLoading();

          final res = await UserApi.removeMerchantOrder();

          final String errorCode = res['errorCode'] ?? '';
          final String errorMsg = res['errorMsg'] ?? '';

          if (errorCode == 'Success') {
            //  SUCCESS Dialog
            showDecertificationResultDialog(
              context,
              result: DecertificationResult.success,
            );
          } else {
            // FAILURE Dialog
            showDecertificationResultDialog(
              context,
              result: DecertificationResult.failed,
              errorMsg: errorMsg,
              onCustomerCare: () {
                Navigator.pop(context);
                // TODO: Navigate to customer care
              },
            );
          }
        } catch (e) {
          showDecertificationResultDialog(
            context,
            result: DecertificationResult.failed,
            onCustomerCare: () {
              Navigator.pop(context);
              // TODO: Navigate to customer care
            },
          );
        } finally {
          // Refresh data AFTER success
          await getHomeAsset(); // mostly needed only after SUCCESS Dialog
          if (mounted) {
            // ToastUtil.dismiss();
            setState(() {
              _isLoading = false;
            });
          }
        }
      },
    );
  }

  Future<void> handleMerchantApply() async {
    try {
      setState(() {
        _isLoading = true;
      });
      //     ToastUtil.showLoading();
      await UserApi.createMerchantOrder();
      //todo:
      // EventBusUtil.fireUpdateMerchantStatus();
      await getHomeAsset();
    } catch (e) {}
    setState(() {
      _isLoading = false;
    });
    // ToastUtil.dismiss();
  }
}

Widget _buildActionButton(
  BuildContext context,
  String merchantStatus,
  String identifyOrderLatestSubmittedInfoStatus,
  Future<void> Function() onMerchantApply, {
  required Future<void> Function() onReturn,
}) {
  final config = _getActionConfig(
    context,
    merchantStatus,
    identifyOrderLatestSubmittedInfoStatus,
    onMerchantApply,
    onReturn,
  );

  if (config == null) {
    return const SizedBox.shrink();
  }

  return SizedBox(
    width: double.infinity,
    height: 56,
    child: ElevatedButton(
      onPressed: config.onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: config.backgroundColor,
        elevation: 0,
        disabledBackgroundColor: const Color(0xFFCBD5E1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            config.label,
            style: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: config.textColor,
            ),
          ),
          const SizedBox(width: 8),
          SvgPicture.asset(
            'assets/icons/merchant_details/arrow_right.svg',
            width: 20,
            height: 20,
            colorFilter: ColorFilter.mode(config.textColor, BlendMode.srcIn),
          ),
        ],
      ),
    ),
  );
}

_ActionButtonConfig? _getActionConfig(
  BuildContext context,
  String merchantStatus,
  String identifyOrderLatestSubmittedInfoStatus,
  Future<void> Function() onMerchantApply,
  Future<void> Function() onReturn,
) {
  // merchant KYC stil not applied
  if ((merchantStatus == '-1')) {
    if (identifyOrderLatestSubmittedInfoStatus == '') {
      return _ActionButtonConfig(
        label: "Start KYC Verification",
        backgroundColor: const Color(0xFF1D5DE5),
        textColor: Colors.white,
        onPressed: () async {
          final bool? shouldRefresh = await Navigator.push<bool>(
            context,
            MaterialPageRoute(
              builder: (context) => KycPersonalInformationPage(
                merchantStatus: merchantStatus,
                isEdit: false,
              ),
            ),
          );

          if (shouldRefresh == true) {
            await onReturn();
          }
        },
      );
    }

    if (identifyOrderLatestSubmittedInfoStatus == '0') {
      return _ActionButtonConfig(
        label: "Start KYC Verification",
        backgroundColor: const Color(0xFFB9C6E2),
        textColor: const Color(0xFF717F9A),
        onPressed: () {
          // null;
        },
      );
    }

    if (identifyOrderLatestSubmittedInfoStatus == '2') {
      return _ActionButtonConfig(
        label: "Retry KYC Verification",
        backgroundColor: const Color(0xFF1D5DE5),
        textColor: Colors.white,
        onPressed: () async {
          final bool? shouldRefresh = await Navigator.push<bool>(
            context,
            MaterialPageRoute(
              builder: (context) => KycPersonalInformationPage(
                merchantStatus: merchantStatus,
                isEdit: true,
              ),
            ),
          );

          if (shouldRefresh == true) {
            await onReturn();
          }
        },
      );
    }

    if (identifyOrderLatestSubmittedInfoStatus == '1') {
      return _ActionButtonConfig(
        label: "Apply for Merchant KYC",
        backgroundColor: const Color(0xFF1D5DE5),
        textColor: Colors.white,
        onPressed: () {
          onMerchantApply();
        },
      );
    }
  } else {
    switch (merchantStatus) {
      case '0':
        return null;
      // return _ActionButtonConfig(
      //   label: "Deposit Fund",
      //   backgroundColor: const Color(0xFFCBD5E1),
      //   textColor: const Color(0xFF64748B),
      //   onPressed: null,
      // );

      case '3':
        return _ActionButtonConfig(
          label: "Start KYC Verification",
          backgroundColor: const Color(0xFFCBD5E1),
          textColor: const Color(0xFF64748B),
          onPressed: null,
        );

      case '2':
        return _ActionButtonConfig(
          label: "Retry KYC Verification",
          backgroundColor: const Color(0xFF1D5DE5),
          textColor: Colors.white,
          onPressed: () {
            onMerchantApply();
          },
        );

      case '4':
        return _ActionButtonConfig(
          label: "Apply for Merchant KYC",
          backgroundColor: const Color(0xFF1D5DE5),
          textColor: Colors.white,
          onPressed: () {
            onMerchantApply();
          },
        );

      case '1':
        return null;
      // return _ActionButtonConfig(
      //   label: "Deposit Fund",
      //   backgroundColor: const Color(0xFF1D5DE5),
      //   textColor: Colors.white,
      //   onPressed: () {
      //     Navigator.push(
      //       context,
      //       MaterialPageRoute(builder: (context) => const DepositScreen()),
      //     );
      //   },
      // );
    }
  }
  return _ActionButtonConfig(
    label: "-",
    backgroundColor: const Color(0xFF1D5DE5),
    textColor: Colors.white,
    onPressed: () {},
  );
}

class _ActionButtonConfig {
  final String label;
  final Color backgroundColor;
  final Color textColor;
  final VoidCallback? onPressed;

  _ActionButtonConfig({
    required this.label,
    required this.backgroundColor,
    required this.textColor,
    required this.onPressed,
  });
}
