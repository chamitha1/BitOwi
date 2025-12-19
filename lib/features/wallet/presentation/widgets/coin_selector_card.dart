import 'package:flutter/material.dart';

class CoinSelectorCard extends StatefulWidget {
  const CoinSelectorCard({super.key});

  @override
  State<CoinSelectorCard> createState() => _CoinSelectorCardState();
}

class _CoinSelectorCardState extends State<CoinSelectorCard> {
  Map<String, String> _selectedCoin = {
    'name': 'BTC',
    'icon': 'assets/images/deposit/bitcoin.png'
  };

  final List<Map<String, String>> _currencies = [
    {'name': 'BTC', 'icon': 'assets/images/deposit/bitcoin.png'},
    {'name': 'USDT-TRC20', 'icon': 'assets/images/deposit/usdt.png'},
    {'name': 'ETH', 'icon': 'assets/images/deposit/ethereum.png'},
    {'name': 'Tron', 'icon': 'assets/images/deposit/tron.png'},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Coin Name",
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          PopupMenuButton<Map<String, String>>(
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
                _selectedCoin = value;
              });
            },
            itemBuilder: (context) => _currencies.map((currency) {
              return PopupMenuItem<Map<String, String>>(
                value: currency,
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
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Image.asset(
                    _selectedCoin['icon']!,
                    width: 24,
                    height: 24,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _selectedCoin['name']!,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff151E2F),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Image.asset(
                    "assets/icons/deposit/arrow_down.png",
                    width: 16,
                    height: 16,
                    color: const Color(0xff151E2F),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
