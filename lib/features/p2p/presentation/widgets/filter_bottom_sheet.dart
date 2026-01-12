import 'package:flutter/material.dart';

class FilterBottomSheet extends StatefulWidget {
  const FilterBottomSheet({super.key});

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  String _selectedMultiplier = "10X";
  String _selectedCurrency = "NGN";

  final List<String> _multipliers = ["1X", "5X", "10X", "20X", "50X", "100X"];
  final List<String> _currencies = ["NGN", "USD", "CHA"];

  late TextEditingController _amountController;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController(text: "700");
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      // Rounded top corners (approx 32px)
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Modal bottom sheet behavior
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 2. Header Section
          _buildHeader(context),
          const SizedBox(height: 24),

          //Amount Input
          _buildLabel("Amount"),
          const SizedBox(height: 8),
          _buildAmountInput(),
          const SizedBox(height: 24),

          //Multiplier
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _multipliers.map((m) {
                final isSelected = _selectedMultiplier == m;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedMultiplier = m),
                    child: _buildMultiplierChip(m, isSelected),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 24),

          //Currency Select
          _buildLabel("Currency"),
          const SizedBox(height: 8),
          Row(
            children: _currencies.map((c) {
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    right: c != _currencies.last ? 8.0 : 0,
                  ),
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedCurrency = c),
                    child: _buildCurrencyButton(c, _selectedCurrency == c),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 32),

          //Buttons
          _buildFooterButtons(),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Filter",
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Color(0xFF000000),
          ),
        ),
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.close, color: Colors.black, size: 24),
        ),
      ],
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

  Widget _buildAmountInput() {
    return TextField(
      controller: _amountController,
      keyboardType: TextInputType.number,
      style: const TextStyle(
        fontFamily: 'Inter',
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: Color(0xFF151E2F),
      ),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        isDense: true,
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFDAE0EE), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF1D5DE5), width: 1),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFDAE0EE), width: 1),
        ),
      ),
    );
  }

  Widget _buildMultiplierChip(String text, bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF151E2F) : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: isActive
            ? null
            : Border.all(color: const Color(0xFFECEFF5), width: 1),
        boxShadow: [
          if (!isActive)
            BoxShadow(
              color: const Color(0xFF2E3D5B).withOpacity(0.07),
              offset: const Offset(0, 4),
              blurRadius: 3,
            ),
        ],
      ),
      child: Text(
        text,
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: isActive ? Colors.white : const Color(0xFF717F9A),
        ),
      ),
    );
  }

  Widget _buildCurrencyButton(String text, bool isActive) {
    return Container(
      height: 48,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF151E2F) : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFECEFF5), width: 1),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF000000).withOpacity(0.11),
            offset: const Offset(0, 4),
            blurRadius: isActive ? 7 : 4,
          ),
        ],
      ),
      child: Text(
        text,
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: isActive ? Colors.white : const Color(0xFF717F9A),
        ),
      ),
    );
  }

  Widget _buildFooterButtons() {
    return Row(
      children: [
        // Reset Button
        Expanded(
          child: SizedBox(
            height: 54,
            child: OutlinedButton(
              onPressed: () {
                // Reset logic
                setState(() {
                  _selectedMultiplier = "";
                  _selectedCurrency = "NGN";
                });
              },
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFF1D5DE5), width: 2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                backgroundColor: Colors.white,
              ),
              child: const Text(
                "Reset",
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
        // Filter Button
        Expanded(
          child: Container(
            height: 54,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF1D5DE5), Color(0xFF28A6FF)],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: ElevatedButton(
              onPressed: () {
                // Filter action
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "Filter",
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
