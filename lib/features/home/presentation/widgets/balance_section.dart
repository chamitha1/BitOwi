import 'package:BitOwi/features/home/presentation/controllers/balance_controller.dart';
import 'package:BitOwi/features/wallet/presentation/pages/balance_history_page.dart';
import 'package:BitOwi/config/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BalanceSection extends StatefulWidget {
  const BalanceSection({super.key});

  @override
  State<BalanceSection> createState() => _BalanceSectionState();
}

class _BalanceSectionState extends State<BalanceSection> {
  final BalanceController controller = Get.put(BalanceController());

  bool _hideSmallAssets = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Balance",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff151E2F),
                      fontFamily: 'Inter',
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Text(
                        "Hide Small Assets",
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xff454F63),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Transform.scale(
                        scale: 0.7,
                        child: Switch(
                          value: _hideSmallAssets,
                          onChanged: (v) => setState(() => _hideSmallAssets = v),
                          activeColor: const Color(0xff2ECC71),
                          activeTrackColor: const Color(
                            0xFF2ECC71,
                          ).withOpacity(0.2),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  final asset =
                      controller.selectedAsset ??
                      (controller.balanceData.value?.accountList.isNotEmpty ==
                              true
                          ? controller.balanceData.value!.accountList.first
                          : null);

                  if (asset != null) {
                    Get.to(
                      () => const BalanceHistoryPage(),
                      arguments: {
                        'accountNumber': asset.accountNumber,
                        'symbol': asset.currency,
                      },
                    );
                  } else {
                    Get.snackbar("Error", "No asset selected");
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xffE8EFFF),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Image.asset(
                    'assets/icons/home/clock.png',
                    width: 24,
                    height: 24,
                    color: const Color(0xff151E2F),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            } else if (controller.errorMessage.value.isNotEmpty) {
              return Center(
                child: Column(
                  children: [
                    Text(
                      "Error: ${controller.errorMessage.value}",
                      style: const TextStyle(color: Colors.red),
                    ),
                    TextButton(
                      onPressed: controller.fetchBalance,
                      child: const Text("Retry"),
                    ),
                  ],
                ),
              );
            } else if (controller.balanceData.value != null) {
              return Column(children: _buildAssetList());
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
    );
  }

  List<Widget> _buildAssetList() {
    if (controller.balanceData.value == null) return [];

    final list = controller.balanceData.value!.accountList.where((item) {
      if (_hideSmallAssets) {
        return item.microFlag != '1';
      }
      return true;
    }).toList();

    if (list.isEmpty) {
      return [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Center(
            child: Text(
              "No assets found",
              style: TextStyle(color: Color(0xff454F63)),
            ),
          ),
        ),
      ];
    }

    return List.generate(list.length, (index) {
      final item = list[index];
      return Column(
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              if (item.currency != null && item.accountNumber != null) {
                Get.toNamed(Routes.walletDetail, parameters: {
                  'symbol': item.currency!,
                  'accountNumber': item.accountNumber!,
                });
              }
            },
            child: _assetItem(
              icon: item.icon,
              name: item.currency,
              total: item.usableAmount,
              frozen: item.frozenAmount,
              usdtVal: item.totalAsset,
              currencyLabel: item.totalAssetCurrency,
            ),
          ),
          if (index < list.length - 1)
            const Divider(height: 32, color: Color(0xFFF1F5F9)),
        ],
      );
    });
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

  Widget _assetItem({
    required String icon,
    required String name,
    required String total,
    required String frozen,
    required String usdtVal,
    required String currencyLabel,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _buildNetworkImage(icon),
            const SizedBox(width: 8),
            Text(
              name,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xff151E2F),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _assetDetailColumn("Assets", total)),
            SizedBox(width: 2),
            Expanded(child: _assetDetailColumn("Frozen", frozen)),
            SizedBox(width: 2),
            Expanded(child: _assetDetailColumn(currencyLabel, usdtVal)),
          ],
        ),
      ],
    );
  }

  Widget _assetDetailColumn(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xff454F63),
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 4),
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xff151E2F),
            ),
          ),
        ),
      ],
    );
  }
}
