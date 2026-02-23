import 'package:BitOwi/api/account_api.dart';
import 'package:BitOwi/core/theme/app_input_decorations.dart';
import 'package:BitOwi/core/theme/app_text_styles.dart';
import 'package:BitOwi/core/widgets/app_text.dart';
import 'package:BitOwi/core/widgets/common_appbar.dart';
import 'package:BitOwi/core/widgets/custom_snackbar.dart';
import 'package:BitOwi/core/widgets/input_title_label.dart';
import 'package:BitOwi/core/widgets/primary_button.dart';
import 'package:BitOwi/core/widgets/soft_circular_loader.dart';
import 'package:BitOwi/features/auth/presentation/controllers/user_controller.dart';
import 'package:BitOwi/models/bankcard_channel_list_res.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;

class AddMobileMoneyPage extends StatefulWidget {
  const AddMobileMoneyPage({super.key});

  @override
  State<AddMobileMoneyPage> createState() => _AddMobileMoneyPageState();
}

class _AddMobileMoneyPageState extends State<AddMobileMoneyPage> {
  final userController = Get.find<UserController>();

  final _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;

  final _realNameController = TextEditingController();
  final _mobileNumberController = TextEditingController();

  String? _selectedProvider;
  List<BankcardChannelListRes> providerList = [];

  String mobilecardId = '';

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    mobilecardId = Get.parameters["id"] ?? '';
    getInitData();
  }

  Future<void> getInitData() async {
    try {
      setState(() {
        isLoading = true;
      });

      final list = await AccountApi.getBankChannelList();
      providerList = list;

      if (mobilecardId.isNotEmpty) {
        final res = await AccountApi.getBankCardDetail(mobilecardId);
        _realNameController.text = res.realName;
        _mobileNumberController.text = res.bindMobile ?? '';
        final index = providerList.indexWhere(
          (element) => element.bankName == res.bankName,
        );
        if (index != -1) {
          _selectedProvider = providerList[index].id;
        }
      } else {
        _realNameController.text = userController.userRealName.value;
      }
    } catch (e) {
      CustomSnackbar.showError(title: "Error", message: "Something went wrong");
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _realNameController.dispose();
    _mobileNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: CommonAppBar(title: "Add Mobile Money", onBack: () => Get.back()),
      body: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Expanded(
                child: isLoading
                    ? const SoftCircularLoader()
                    : SingleChildScrollView(
                        child: Form(
                          key: _formKey,
                          autovalidateMode: _autoValidate
                              ? AutovalidateMode.onUserInteraction
                              : AutovalidateMode.disabled,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 10),

                              /// 🔹 Name
                              InputTitleLable("Name"),
                              buildNameInput(),

                              /// 🔹 Service Provider
                              InputTitleLable("Service Provider"),
                              buildProviderDropdown(),

                              /// 🔹 Mobile Number
                              InputTitleLable("Mobile Number"),
                              buildMobileInput(),

                              const SizedBox(height: 16),

                              /// 🔹 Alert Box
                              buildTradingAlert(),
                            ],
                          ),
                        ),
                      ),
              ),

              /// 🔹 Save Button
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 20),
                child: PrimaryButton(
                  text: mobilecardId.isNotEmpty ? "Update" : "Save",
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

  TextFormField buildNameInput() {
    return TextFormField(
      controller: _realNameController,
      style: AppTextStyles.p2Regular,
      decoration: AppInputDecorations.textField(hintText: "Enter Your Name"),
      validator: (value) =>
          value == null || value.trim().isEmpty ? "Name is required" : null,
    );
  }

  TextFormField buildMobileInput() {
    return TextFormField(
      controller: _mobileNumberController,
      keyboardType: TextInputType.phone,
      style: AppTextStyles.p2Regular,
      decoration: AppInputDecorations.textField(
        hintText: "Enter Mobile Number",
      ),
      validator: (value) => value == null || value.trim().isEmpty
          ? "Mobile number is required"
          : null,
    );
  }

  Widget buildProviderDropdown() {
    return Theme(
      data: Theme.of(context).copyWith(
        shadowColor: const Color(0x331D5DE5),
        hoverColor: Colors.transparent,
        focusColor: const Color(0XFFF6F9FF),
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
      ),
      child: DropdownButtonFormField<String>(
        value: _selectedProvider,
        style: AppTextStyles.p2Regular,
        hint: AppText.p2Regular(
          'Select Provider',
          color: const Color(0xFF717F9A),
        ),
        decoration: AppInputDecorations.textField(),
        dropdownColor: Colors.white,
        borderRadius: BorderRadius.circular(12),
        elevation: 8,
        icon: const Icon(
          Icons.keyboard_arrow_down_rounded,
          color: Color(0xFF2E3D5B),
          size: 20,
        ),
        items: providerList.map((BankcardChannelListRes item) {
          return DropdownMenuItem<String>(
            value: item.id,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Text(
                item.bankName,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  color: Color(0xff151E2F),
                ),
              ),
            ),
          );
        }).toList(),
        selectedItemBuilder: (BuildContext context) {
          return providerList.map<Widget>((BankcardChannelListRes item) {
            return Align(
              alignment: Alignment.centerLeft,
              child: AppText.p2Regular(item.bankName),
            );
          }).toList();
        },
        onChanged: (value) => setState(() => _selectedProvider = value),
        validator: (value) => value == null ? "Please select a provider" : null,
      ),
    );
  }

  Widget buildTradingAlert() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF7ED),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFFD7A8)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SvgPicture.asset(
            'assets/icons/profile_page/lightbulb-alt.svg',
            width: 20,
            height: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText.p1Medium(
                  "Trading Alert",
                  color: const Color(0xFFC9710D),
                ),
                const SizedBox(height: 10),
                AppText.p3Regular(
                  "During trade details of the added payment method will be shown to the buyer to make due payment, whereas sellers will see the buyer's real name. Please ensure that the information is correct, real, and matches your KYC information on Bitowi Mobile Money, Nigerian Naira (NGN) currency is set by default.",
                  color: const Color(0xFFC9710D),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ===============================
  // 🚀 Submit
  // ===============================

  Future<void> onSubmit() async {
    if (!_formKey.currentState!.validate()) {
      setState(() => _autoValidate = true);
      return;
    }

    try {
      setState(() => isLoading = true);

      final payload = {
        "realName": _realNameController.text.trim(),
        "bindMobile": _mobileNumberController.text.trim(),
        "bankChannelId": int.tryParse(_selectedProvider ?? ''),
      };

      late final dio.Response<dynamic> response;
      if (mobilecardId.isNotEmpty) {
        response = await AccountApi.editeMobileBankCard({
          "id": mobilecardId,
          ...payload,
        });
      } else {
        response = await AccountApi.createMobileBankCard(payload);
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
