import 'package:flutter/material.dart';

class DepositNetworkBottomSheet extends StatelessWidget {
  final List<String> networks;
  final String selectedNetwork;
  final Function(String) onNetworkSelected;

  const DepositNetworkBottomSheet({
    super.key,
    required this.networks,
    required this.selectedNetwork,
    required this.onNetworkSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Please Select Deposit Network",
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(Icons.close, color: Colors.black),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Warning Banner
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFFFFBF6),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFFFE2C1)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.info_outline,
                  color: Color(0xFFC9710D),
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "Deposit Network Confirmation",
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFFC9710D),
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "Please ensure that the deposit network you select matches the network you chose when withdrawing. Otherwise, it may result in financial losses.",
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
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Network List
          Flexible(
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: networks.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final network = networks[index];
                final isSelected = network == selectedNetwork;
                return NetworkOptionTile(
                  networkName: network,
                  isSelected: isSelected,
                  onTap: () {
                    onNetworkSelected(network);
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class NetworkOptionTile extends StatelessWidget {
  final String networkName;
  final bool isSelected;
  final VoidCallback onTap;

  const NetworkOptionTile({
    super.key,
    required this.networkName,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFE8EFFF) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF1D5DE5)
                : const Color(0xFFECEFF5),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              networkName,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color(0xFF151E2F),
              ),
            ),
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFF1D5DE5)
                      : const Color(0xFFDAE0EE),
                  width: isSelected ? 6 : 1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
