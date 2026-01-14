import 'package:BitOwi/core/theme/app_input_decorations.dart';
import 'package:BitOwi/core/widgets/common_appbar.dart';
import 'package:BitOwi/core/widgets/input_title_label.dart';
import 'package:BitOwi/core/widgets/primary_button.dart';
import 'package:BitOwi/core/widgets/soft_circular_loader.dart';
import 'package:BitOwi/features/profile/presentation/controllers/settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddBankCardPage extends StatefulWidget {
  const AddBankCardPage({super.key});

  @override
  State<AddBankCardPage> createState() => _AddBankCardPageState();
}

class _AddBankCardPageState extends State<AddBankCardPage> {
  final _formKey = GlobalKey<FormState>();

  /// 🔹 Local controllers (screen-owned)
  final _nameController = TextEditingController();
  final _accountNumberController = TextEditingController();
  final _bankController = TextEditingController();

  String? _selectedCoin;

  bool isAddBankCardFormValid = false;
  bool isLoading = false;

  void validateForm() {
    final isValid =
        _nameController.text.trim().isNotEmpty &&
        _accountNumberController.text.trim().isNotEmpty &&
        _bankController.text.trim().isNotEmpty;

    if (isAddBankCardFormValid != isValid) {
      setState(() {
        isAddBankCardFormValid = isValid;
      });
    }
  }

  Future<void> onSave() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    try {
      // 🔹 submit logic here
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _accountNumberController.dispose();
    _bankController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: CommonAppBar(title: "Add Bank Card", onBack: () => Get.back()),
      body: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 6),

                        InputTitleLable("Name"),
                        buildNameTextInput(), // 🧩

                        InputTitleLable("Bank Account Number"),
                        buildAccountNumberTextInput(), // 🧩

                        InputTitleLable("Opening Bank"),
                        buildBankTextInput(), // 🧩

                        InputTitleLable("Coin"),
                        buildCoinTextInput(), // 🧩
                      ],
                    ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(bottom: 40),
                child: PrimaryButton(
                  text: "Save",
                  enabled: isAddBankCardFormValid && !isLoading,
                  onPressed: onSave,
                  child: isLoading
                      ? const SoftCircularLoader(color: Colors.white)
                      : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ===============================
  // 🧩 Field Builders
  // ===============================

  TextFormField buildNameTextInput() {
    return TextFormField(
      controller: _nameController,
      onChanged: (_) => validateForm(),
      decoration: AppInputDecorations.textField(hintText: "Enter Your Name"),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return "Name is required";
        }
        return null;
      },
    );
  }

  TextFormField buildAccountNumberTextInput() {
    return TextFormField(
      controller: _accountNumberController,
      keyboardType: TextInputType.number,
      onChanged: (_) => validateForm(),
      decoration: AppInputDecorations.textField(
        hintText: "Enter Account Number",
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return "Account number is required";
        }
        return null;
      },
    );
  }

  TextFormField buildBankTextInput() {
    return TextFormField(
      controller: _bankController,
      onChanged: (_) => validateForm(),
      decoration: AppInputDecorations.textField(hintText: "Enter Bank Name"),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return "Bank name is required";
        }
        return null;
      },
    );
  }

  Widget buildCoinTextInput() {
    return DropdownButtonFormField<String>(
      value: _selectedCoin,
      hint: Text(
        'Select Currency',
        style: const TextStyle(
          fontFamily: 'Inter',
          fontWeight: FontWeight.w400,
          fontSize: 14,
          color: Color(0xFF717F9A),
        ),
      ),
      decoration: AppInputDecorations.textField(),
      items: const [
        DropdownMenuItem(value: "BTC", child: Text("Bitcoin (BTC)")),
        DropdownMenuItem(value: "ETH", child: Text("Ethereum (ETH)")),
        DropdownMenuItem(value: "USDT", child: Text("USDT")),
      ],
      onChanged: (value) {
        setState(() => _selectedCoin = value);
        validateForm();
      },
      validator: (value) =>
          (value == null || value.isEmpty) ? "Please select a coin" : null,
    );
  }
}
