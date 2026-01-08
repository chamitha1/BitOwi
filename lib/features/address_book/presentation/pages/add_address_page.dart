import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:BitOwi/api/account_api.dart';
import 'package:BitOwi/models/coin_list_res.dart';
import 'package:BitOwi/core/widgets/custom_snackbar.dart';

class AddAddressPage extends StatefulWidget {
  const AddAddressPage({super.key});

  @override
  State<AddAddressPage> createState() => _AddAddressPageState();
}

class _AddAddressPageState extends State<AddAddressPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  List<CoinListRes> _coins = [];
  CoinListRes? _selectedCoin;
  bool _isLoadingConfig = false;
  bool _isSaving = false;
  bool _hasSaved = false;

  @override
  void initState() {
    super.initState();
    _fetchCoins();
  }

  Future<void> _fetchCoins() async {
    setState(() {
      _isLoadingConfig = true;
    });
    try {
      final list = await AccountApi.getCoinList();
      setState(() {
        _coins = list;
        if (_coins.isNotEmpty) {
          final usdt = _coins.firstWhereOrNull(
            (e) => e.symbol?.toUpperCase() == 'USDT',
          );
          _selectedCoin = usdt ?? _coins.first;
        }
        _isLoadingConfig = false;
      });
      print("Fetched ${_coins.length} coins");
    } catch (e) {
      setState(() {
        _isLoadingConfig = false;
      });
      print("Error fetching coins: $e");
      CustomSnackbar.showError(
        title: "Error",
        message: "Failed to load currencies",
      );
    }
  }

  Future<void> _saveAddress() async {
    final name = _nameController.text.trim();
    final address = _addressController.text.trim();

    if (name.isEmpty) {
      CustomSnackbar.showError(
        title: "Error",
        message: "Please enter address name",
      );
      return;
    }
    if (_selectedCoin == null) {
      CustomSnackbar.showError(
        title: "Error",
        message: "Please select a currency",
      );
      return;
    }
    if (address.isEmpty) {
      CustomSnackbar.showError(title: "Error", message: "Please enter address");
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      await AccountApi.createAddress({
        "name": name,
        "address": address,
        "symbol": _selectedCoin!.symbol,
      });

      _nameController.clear();
      _addressController.clear();
      _hasSaved = true;
      
      CustomSnackbar.showSuccess(
        title: "Success",
        message: "Address saved successfully",
      );
      
      await Future.delayed(const Duration(milliseconds: 500));
      
      if (mounted) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      print("Save Address Error: $e");
      String errorMsg = e.toString();
      if (errorMsg.startsWith("Exception: ")) {
        errorMsg = errorMsg.replaceFirst("Exception: ", "");
      }
      CustomSnackbar.showError(title: "Error", message: errorMsg);
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F9FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF6F9FF),
        elevation: 0,
        automaticallyImplyLeading: false,
        titleSpacing: 20,
        leading: IconButton(
          icon: SvgPicture.asset(
            'assets/icons/merchant_details/arrow_left.svg',
            colorFilter: const ColorFilter.mode(
              Color(0xFF151E2F),
              BlendMode.srcIn,
            ),
          ),
          onPressed: () => Navigator.pop(context, _hasSaved),
        ),
        title: const Text(
          "Add Address",
          style: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w700,
            fontSize: 20,
            color: Color(0xFF151E2F),
          ),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Address Name
                    _buildLabel("Address Name"),
                    const SizedBox(height: 8),
                    _buildInputField(
                      controller: _nameController,
                      hintText: "Enter Address Name",
                    ),
                    const SizedBox(height: 20),

                    // Address symbol
                    _buildLabel("Address Currency"),
                    const SizedBox(height: 8),
                    _buildDropdownField(),
                    const SizedBox(height: 20),

                    // Address
                    _buildLabel("Address"),
                    const SizedBox(height: 8),
                    _buildInputField(
                      controller: _addressController,
                      hintText: "Enter Address",
                    ),
                  ],
                ),
              ),
            ),

            // Save address button
            Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                width: double.infinity,
                height: 58,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _saveAddress,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1D5DE5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: _isSaving
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          "Save Address",
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontFamily: 'Inter',
        fontWeight: FontWeight.w400,
        fontSize: 14,
        color: Color(0xFF2E3D5B),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hintText,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xffF6F9FF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFDAE0EE)),
      ),
      child: TextField(
        controller: controller,
        style: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 14,
          color: Color(0xFF151E2F),
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w400,
            fontSize: 16,
            color: Color(0xFF717F9A),
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownField() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return PopupMenuButton<CoinListRes>(
          enabled: !_isLoadingConfig,
          offset: const Offset(0, 50),
          constraints: BoxConstraints.tightFor(width: constraints.maxWidth),
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
          itemBuilder: (context) => _coins.map((coin) {
            return PopupMenuItem<CoinListRes>(
              value: coin,
              child: Text(
                coin.symbol ?? 'Unknown',
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  fontFamily: 'Inter',
                  color: Color(0xff151E2F),
                ),
              ),
            );
          }).toList(),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: Color(0xffF6F9FF),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFDAE0EE)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _isLoadingConfig
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(
                        _selectedCoin?.symbol ?? "Select Currency",
                        style: _selectedCoin == null
                            ? const TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                                color: Color(0xFF717F9A),
                              )
                            : const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 14,
                                color: Color(0xFF151E2F),
                              ),
                      ),
                SvgPicture.asset(
                  'assets/icons/profile_page/address/angle-down.svg',
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
