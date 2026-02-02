import 'package:flutter/material.dart';
import 'package:BitOwi/api/common_api.dart';
import 'package:BitOwi/models/dict.dart';

class FilterBottomSheet extends StatefulWidget {
  final String? initialAmount;
  final String? initialCurrency;

  const FilterBottomSheet({
    super.key,
    this.initialAmount,
    this.initialCurrency,
  });

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  String? _selectedMultiplier;
  final List<String> _multipliers = const [
    "1X",
    "5X",
    "10X",
    "20X",
    "50X",
    "100X",
  ];
  List<Dict> _currencyList = [];
  Dict? _selectedCurrency;
  bool _loadingCurrencies = true;

  late final TextEditingController _amountController;

  String _rawAmount = ""; // what user typed (base amount)
  bool _updatingAmount = false; // prevent listener loop

  @override
  void initState() {
    super.initState();

    _amountController = TextEditingController(text: widget.initialAmount ?? "");
    _rawAmount = _amountController.text.trim();
    _amountController.addListener(() {
      if (_updatingAmount) return; // ignore programmatic updates
      _rawAmount = _amountController.text.trim();
    });

    _fetchCurrencies();
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _fetchCurrencies() async {
    try {
      final list = await CommonApi.getDictList(parentKey: 'ads_trade_currency');
      if (!mounted) return;
      final filtered = list
          .where((e) => e.key == 'NGN' || e.key == 'USD')
          .toList();

      Dict? selected;

      // prefer initial currency if exists
      final initKey = (widget.initialCurrency ?? "").trim();
      if (initKey.isNotEmpty) {
        try {
          selected = filtered.firstWhere((e) => e.key == initKey);
        } catch (_) {}
      }

      // else default NGN, else first
      selected ??= filtered.isNotEmpty
          ? filtered.firstWhere(
              (e) => e.key == 'NGN',
              orElse: () => filtered.first,
            )
          : null;

      setState(() {
        _currencyList = filtered;
        _selectedCurrency = selected;
        _loadingCurrencies = false;
        debugPrint(
          "FilterBottomSheet: initKey=$initKey, selected=${selected?.key}, list=${filtered.map((e) => e.key).toList()}",
        );
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _currencyList = [
          Dict(key: 'NGN', value: 'NGN'),
          Dict(key: 'USD', value: 'USD'),
        ];
        _selectedCurrency = Dict(key: 'NGN', value: 'NGN');
        _loadingCurrencies = false;
      });

      debugPrint("Error fetching currencies: $e");
    }
  }

  int _multiplierValue(String m) {
    return int.tryParse(m.replaceAll("X", "")) ?? 1;
  }

  void _applyMultiplier(String m) {
    setState(() => _selectedMultiplier = m);

    final base = double.tryParse(_rawAmount);
    if (base == null) return; // user can type any amount

    final mul = _multiplierValue(m);
    final updated = base * mul;

    final text = (updated % 1 == 0)
        ? updated.toInt().toString()
        : updated.toString();

    _updatingAmount = true;
    _amountController.text = text;
    _amountController.selection = TextSelection.fromPosition(
      TextPosition(offset: _amountController.text.length),
    );
    _updatingAmount = false;
  }

  void _onReset() {
    setState(() {
      _selectedMultiplier = null;

      _updatingAmount = true;
      _amountController.clear();
      _updatingAmount = false;

      _rawAmount = "";

      // default NGN if exists
      _selectedCurrency = _currencyList.firstWhere(
        (e) => e.key == 'NGN',
        orElse: () => _currencyList.isNotEmpty
            ? _currencyList.first
            : Dict(key: 'NGN', value: 'NGN'),
      );
    });

    Navigator.pop(context, {'type': 'reset'});
  }

  void _onFilter() {
    Navigator.pop(context, {
      'type': 'filter',
      'amount': _amountController.text.trim(),
      'currency': _selectedCurrency,
      'multiplier': _selectedMultiplier,
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: AnimatedPadding(
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
          ),
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 24),

                _buildLabel("Amount"),
                const SizedBox(height: 8),
                _buildAmountInput(),
                const SizedBox(height: 16),

                _buildMultiplierRow(),
                const SizedBox(height: 18),

                _buildLabel("Currency"),
                const SizedBox(height: 8),
                _buildCurrencySection(),
                const SizedBox(height: 24),

                _buildFooterButtons(),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
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
      scrollPadding: const EdgeInsets.only(bottom: 140),
      style: const TextStyle(
        fontFamily: 'Inter',
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: Color(0xFF151E2F),
      ),
      decoration: InputDecoration(
        hintText: "Enter amount",
        hintStyle: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: Color(0xFF717F9A),
        ),
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

  Widget _buildMultiplierRow() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _multipliers.map((m) {
          final isSelected = _selectedMultiplier == m;
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: GestureDetector(
              onTap: () => _applyMultiplier(m),
              child: _buildMultiplierChip(m, isSelected),
            ),
          );
        }).toList(),
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

  Widget _buildCurrencySection() {
    if (_loadingCurrencies) {
      return Container(
        height: 48,
        alignment: Alignment.centerLeft,
        child: const SizedBox(
          height: 18,
          width: 18,
          child: Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation(Color(0xff1D5DE5)),
            ),
          ),
        ),
      );
    }

    final currencies = <String>[
      if (_currencyList.any((e) => e.key == 'NGN')) 'NGN',
      if (_currencyList.any((e) => e.key == 'USD')) 'USD',
    ];

    // safety fallback
    final safeCurrencies = currencies.isEmpty
        ? <String>['NGN', 'USD']
        : currencies;

    final selectedKey = _selectedCurrency?.key;
    final activeKey = (selectedKey == 'NGN' || selectedKey == 'USD')
        ? selectedKey
        : 'NGN';

    return Row(
      children: safeCurrencies.map((c) {
        final isActive = activeKey == c;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: c != safeCurrencies.last ? 12 : 0),
            child: GestureDetector(
              onTap: () =>
                  setState(() => _selectedCurrency = Dict(key: c, value: c)),
              child: _buildCurrencyButtonSmall(c, isActive),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCurrencyButtonSmall(String text, bool isActive) {
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
          fontWeight: FontWeight.w600,
          color: isActive ? Colors.white : const Color(0xFF717F9A),
        ),
      ),
    );
  }

  Widget _buildFooterButtons() {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 54,
            child: OutlinedButton(
              onPressed: _onReset,
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
              onPressed: _onFilter,
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
