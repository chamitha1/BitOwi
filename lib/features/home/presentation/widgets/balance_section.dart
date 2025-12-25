import 'package:BitDo/features/wallet/presentation/pages/balance_history_page.dart';
import 'package:BitDo/features/wallet/presentation/pages/transaction_history_page.dart';
import 'package:flutter/material.dart';
import 'package:BitDo/api/account_api.dart';
import 'package:BitDo/models/account_detail_res.dart';
import 'package:BitDo/core/storage/storage_service.dart';

class BalanceSection extends StatefulWidget {
  const BalanceSection({super.key});

  @override
  State<BalanceSection> createState() => _BalanceSectionState();
}

class _BalanceSectionState extends State<BalanceSection> {
  bool _hideSmallAssets = false;
  AccountDetailAssetRes? _balanceData;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchBalance();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const BalanceHistoryPage(),
                  ),
                );
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

        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              if (_isLoading)
                const Center(child: CircularProgressIndicator())
              else if (_errorMessage != null)
                Center(
                  child: Column(
                    children: [
                      Text(
                        "Error: $_errorMessage",
                        style: const TextStyle(color: Colors.red),
                      ),
                      TextButton(
                        onPressed: _fetchBalance,
                        child: const Text("Retry"),
                      )
                    ],
                  ),
                )
              else if (_balanceData != null)
                ..._buildAssetList(),
            ],
          ),
        ),
      ],
    );
  }

  List<Widget> _buildAssetList() {
    if (_balanceData == null) return [];

    final list = _balanceData!.accountList.where((item) {
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
        )
      ];
    }

    return List.generate(list.length, (index) {
      final item = list[index];
      return Column(
        children: [
          _assetItem(
            icon: item.icon,
            name: item.currency,
            total: item.usableAmount,
            frozen: item.frozenAmount,
            usdtVal: item.totalAsset, 
          ),
          if (index < list.length - 1)
            const Divider(height: 32, color: Color(0xFFF1F5F9)),
        ],
      );
    });
  }

  Widget _buildNetworkImage(String url) {
    if (url.isEmpty) {
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

  Future<void> _fetchBalance() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final res = await AccountApi.getBalanceAccount(
        assetCurrency: await StorageService.getCurrency(),
      );

      _balanceData = res;
    } catch (e) {
      setState(() => _errorMessage = e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Widget _assetItem({
    required String icon,
    required String name,
    required String total,
    required String frozen,
    required String usdtVal,
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _assetDetailColumn("Assets", total),
            _assetDetailColumn("Frozen", frozen),
            _assetDetailColumn("USDT", usdtVal),
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
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xff151E2F),
          ),
        ),
      ],
    );
  }
}
