import 'package:BitOwi/api/account_api.dart';
import 'package:BitOwi/api/common_api.dart';
import 'package:BitOwi/core/theme/app_input_decorations.dart';
import 'package:BitOwi/core/theme/app_text_styles.dart';
import 'package:BitOwi/core/widgets/app_text.dart';
import 'package:BitOwi/core/widgets/common_appbar.dart';
import 'package:BitOwi/core/widgets/custom_snackbar.dart';
import 'package:BitOwi/core/widgets/input_title_label.dart';
import 'package:BitOwi/core/widgets/primary_button.dart';
import 'package:BitOwi/core/widgets/soft_circular_loader.dart';
import 'package:BitOwi/features/auth/presentation/controllers/user_controller.dart';
import 'package:BitOwi/models/dict.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;

class AddBankCardPage extends StatefulWidget {
  const AddBankCardPage({super.key});

  @override
  State<AddBankCardPage> createState() => _AddBankCardPageState();
}

class _AddBankCardPageState extends State<AddBankCardPage> {
  final userController = Get.find<UserController>();

  final _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;

  /// 🔹 Local controllers (screen-owned)
  final _realNameController = TextEditingController();
  final _accountNumberController = TextEditingController();
  final _bankAccountNoController = TextEditingController();
  String? _selectedCoin;

  /// Currency
  List<Dict> coinList = [];

  String bankcardId = '';

  // bool isAddBankCardFormValid = false;
  bool isLoading = false;

  // void validateForm() {
  //   final isValid =
  //       _realNameController.text.trim().isNotEmpty &&
  //       _accountNumberController.text.trim().isNotEmpty &&
  //       _bankAccountNoController.text.trim().isNotEmpty &&
  //       _selectedCoin != null;

  //   if (isAddBankCardFormValid != isValid) {
  //     setState(() => isAddBankCardFormValid = isValid);
  //   }
  // }

  Future<void> getInitData() async {
    try {
      setState(() {
        isLoading = true;
      });
      final list = await CommonApi.getDictList(parentKey: 'ads_trade_currency');
      coinList = list;

      if (bankcardId.isNotEmpty) {
        debugPrint("🚀🙆🏼‍♀️ ${bankcardId}");
        final res = await AccountApi.getBankCardDetail(bankcardId);
        _realNameController.text = res.realName;
        _accountNumberController.text = res.bankcardNumber ?? '';
        _bankAccountNoController.text = res.bankName ?? '';
        final index = coinList.indexWhere(
          (element) => element.key == res.currency,
        );
        if (index != -1) {
          _selectedCoin = coinList[index].key;
        }
      } else {
        _realNameController.text = userController.userRealName.value;
      }

      // setState(() {});

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      CustomSnackbar.showError(title: "Error", message: "Something went wrong");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    bankcardId = Get.parameters["id"] ?? '';
    getInitData();
  }

  @override
  void dispose() {
    _realNameController.dispose();
    _accountNumberController.dispose();
    _bankAccountNoController.dispose();
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
                child: isLoading
                    ? SoftCircularLoader()
                    : SingleChildScrollView(
                        child: Form(
                          key: _formKey,
                          autovalidateMode: _autoValidate
                              ? AutovalidateMode.onUserInteraction
                              : AutovalidateMode.disabled,
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
                              buildCoinDropdownSelection(), // 🧩
                            ],
                          ),
                        ),
                      ),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 20),
                child: PrimaryButton(
                  text: bankcardId.isNotEmpty ? "Update" : "Save",
                  enabled: !isLoading,
                  onPressed: onSubmit,
                ),
              ),
              if (MediaQuery.of(context).viewInsets.bottom == 0)
                const SizedBox(height: 20),
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
      controller: _realNameController,
      style: AppTextStyles.p2Regular,
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
      style: AppTextStyles.p2Regular,
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
      controller: _bankAccountNoController,
      style: AppTextStyles.p2Regular,
      decoration: AppInputDecorations.textField(hintText: "Enter Bank Name"),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return "Bank name is required";
        }
        return null;
      },
    );
  }

  Widget buildCoinDropdownSelection() {
    return DropdownButtonFormField<String>(
      value: _selectedCoin,
      style: AppTextStyles.p2Regular,
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
      items: coinList.map((Dict coin) {
        return DropdownMenuItem<String>(
          value: coin.key,
          child: Text(coin.value),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedCoin = value;
        });
      },
      icon: const Icon(
        Icons.keyboard_arrow_down_rounded,
        color: Color(0xFF717F9A),
        size: 24,
      ),
      validator: (value) =>
          (value == null || value.isEmpty) ? "Please select a currency" : null,
    );
  }

  Future<void> onSubmit() async {
    if (!_formKey.currentState!.validate()) {
      setState(() => _autoValidate = true);
      return;
    }
    try {
      setState(() => isLoading = true);

      final payload = {
        "realName": _realNameController.text.trim(),
        "bankcardNumber": _accountNumberController.text.trim(),
        "bankName": _bankAccountNoController.text.trim(),
        "currency": _selectedCoin,
      };

      debugPrint("🚀👀 ${payload}");

      late final dio.Response<dynamic> response;
      if (bankcardId.isNotEmpty) {
        response = await AccountApi.editBankCard({
          "id": bankcardId,
          ...payload,
        });
      } else {
        response = await AccountApi.createBankCard(payload);
      }

      final data = response.data;
      if (data is Map && (data['code'] == '200' || data['code'] == '201')) {
        Get.back(result: true);
      } else {
        CustomSnackbar.showError(
          title: "Error",
          message: data['errorMsg'] ?? "Something went wrong",
        );
      }
    } catch (e) {
      CustomSnackbar.showError(title: "Error", message: "Something went wrong");
    } finally {
      setState(() => isLoading = false);
    }
  }
}
