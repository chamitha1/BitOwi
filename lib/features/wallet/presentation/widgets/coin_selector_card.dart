import 'package:BitOwi/models/chain_symbol_list_res.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CoinSelectorCard extends StatelessWidget {
  final List<ChainSymbolListRes> coinList;
  final ChainSymbolListRes? selectedCoin;
  final Function(ChainSymbolListRes) onCoinSelected;
  final bool isLoading;

  const CoinSelectorCard({
    super.key,
    required this.coinList,
    required this.selectedCoin,
    required this.onCoinSelected,
    this.isLoading = false,
  });

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
          if (isLoading || coinList.isEmpty)
             const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
          else
            _buildDropdown(context),
        ],
      ),
    );
  }

  Widget _buildDropdown(BuildContext context) {
     final displayCoin = selectedCoin ?? coinList.first;

    return PopupMenuButton<ChainSymbolListRes>(
      offset: const Offset(0, 40),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFFF1F1F8), width: 1),
      ),
      elevation: 8,
      shadowColor: const Color(0x0F555555),
      color: Colors.white,
      onSelected: onCoinSelected,
      itemBuilder: (context) => coinList.map((currency) {
        return PopupMenuItem<ChainSymbolListRes>(
          value: currency,
          child: Row(
            children: [
              if (currency.icon != null && currency.icon!.isNotEmpty)
                Image.network(
                  currency.icon!,
                  width: 24,
                  height: 24,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.error, size: 24),
                )
              else
                Image.asset(
                  'assets/images/deposit/bitcoin.png',
                  width: 24,
                  height: 24,
                ),
              const SizedBox(width: 8),
              Text(
                currency.chainTag != null &&
                        currency.chainTag != currency.symbol
                    ? "${currency.symbol}-${currency.chainTag}"
                    : "${currency.symbol}",
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
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            if (displayCoin.icon != null &&
                displayCoin.icon!.isNotEmpty)
              Image.network(
                displayCoin.icon!,
                width: 24,
                height: 24,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.error, size: 24),
              )
            else
              Image.asset(
                'assets/images/deposit/bitcoin.png',
                width: 24,
                height: 24,
              ),
            const SizedBox(width: 8),
            Text(
              displayCoin.chainTag != null &&
                      displayCoin.chainTag != displayCoin.symbol
                  ? "${displayCoin.symbol}-${displayCoin.chainTag}"
                  : "${displayCoin.symbol}",
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
    );
  }
}
