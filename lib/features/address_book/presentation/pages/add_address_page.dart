import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class AddAddressPage extends StatefulWidget {
  const AddAddressPage({super.key});

  @override
  State<AddAddressPage> createState() => _AddAddressPageState();
}

class _AddAddressPageState extends State<AddAddressPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  String? _selectedCurrency;

  // Placeholder list
  final List<String> _currencies = ['USDT', 'BTC'];

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
        title: Row(
          children: [
            GestureDetector(
              onTap: () => Get.back(),
              child: SvgPicture.asset(
                'assets/icons/merchant_details/arrow_left.svg',
                colorFilter: const ColorFilter.mode(
                  Color(0xFF151E2F),
                  BlendMode.srcIn,
                ),
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              "Add Address",
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w700,
                fontSize: 20,
                color: Color(0xFF151E2F),
              ),
            ),
          ],
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
                    //  Address Name
                    _buildLabel("Address Name"),
                    const SizedBox(height: 8),
                    _buildInputField(
                      controller: _nameController,
                      hintText: "Enter Address",
                    ),
                    const SizedBox(height: 20),

                    //Address currency(symbol)
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

            // save address btn
            Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                width: double.infinity,
                height: 58,
                child: ElevatedButton(
                  onPressed: () {
                    // Save Address Logic
                    Get.back();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1D5DE5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
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
        color: Colors.white,
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
        return PopupMenuButton<String>(
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
              _selectedCurrency = value;
            });
          },
          itemBuilder:
              (context) =>
                  _currencies.map((currency) {
                    return PopupMenuItem<String>(
                      value: currency,
                      child: Text(
                        currency,
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
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFDAE0EE)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _selectedCurrency ?? "Select Currency",
                  style:
                      _selectedCurrency == null
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
