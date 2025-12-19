import 'package:flutter/material.dart';

class BalanceSection extends StatefulWidget {
  const BalanceSection({super.key});

  @override
  State<BalanceSection> createState() => _BalanceSectionState();
}

class _BalanceSectionState extends State<BalanceSection> {
  bool _hideSmallAssets = false;

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
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xffE8EFFF),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Image.asset(
                'assets/icons/home/clock.png',
                width: 24,
                height: 24,
                color: Color(0xff151E2F),
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
              _assetItem(
                icon: "assets/images/home/bitcoin.png",
                name: "Bit Coin",
                total: "1,378,378,489",
                frozen: "1,273,473,438",
                usdtVal: "1,133,483,432",
              ),
              const Divider(height: 32, color: Color(0xFFF1F5F9)),
              _assetItem(
                icon: "assets/images/home/eth.png",
                name: "Ethereum",
                total: "3,378,483,426",
                frozen: "2,435,489,238",
                usdtVal: "2,178,754,326",
              ),
              const Divider(height: 32, color: Color(0xFFF1F5F9)),
              _assetItem(
                icon: "assets/images/home/binance.png",
                name: "Binance",
                total: "4,437,483,483",
                frozen: "2,782,739,293",
                usdtVal: "2,657,594,358",
              ),
            ],
          ),
        ),
      ],
    );
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
            Image.asset(icon, width: 24, height: 24),
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
