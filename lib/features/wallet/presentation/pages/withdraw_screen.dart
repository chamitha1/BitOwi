import 'package:BitOwi/features/wallet/presentation/controllers/withdraw_controller.dart';
import 'package:BitOwi/features/wallet/presentation/pages/qr_scanner_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class WithdrawScreen extends StatelessWidget {
  const WithdrawScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(WithdrawController());

    return Scaffold(
      appBar: AppBar(
        title: Text('Withdraw'.tr),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 20.h),

              // Address Section
              Text(
                'Withdraw Address',
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8.h),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller.addrController,
                      decoration: InputDecoration(
                        hintText: 'Enter address',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 14.h,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  IconButton(
                    icon: const Icon(Icons.qr_code_scanner),
                    onPressed: () async {
                      // Navigate to scanner
                      final result = await Get.to(
                        () => const QrScannerScreen(),
                      );
                      if (result != null && result is String) {
                        controller.setAddress(result);
                      }
                    },
                  ),
                ],
              ),

              SizedBox(height: 20.h),

              // Amount Section
              Text(
                'Amount',
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8.h),
              Obx(
                () => TextField(
                  controller: controller.amountController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: InputDecoration(
                    hintText:
                        'Min ${controller.ruleInfo.value?.minAmount ?? '0'}',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    suffixIcon: TextButton(
                      onPressed: controller.setMaxAmount,
                      child: Text(
                        'ALL',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 4.h),
              Obx(
                () => Text(
                  'Available: ${controller.availableAmount} ${controller.symbol.value}',
                  style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                ),
              ),

              SizedBox(height: 20.h),

              Obx(
                () => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Fee',
                      style: TextStyle(fontSize: 14.sp, color: Colors.grey),
                    ),
                    Text(
                      '${controller.ruleInfo.value?.withdrawFee ?? '0'} ${controller.symbol.value}',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20.h),

              // Trade Password
              Text(
                'Transaction Password',
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8.h),
              TextField(
                controller: controller.tradeController,
                obscureText: true,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Enter transaction password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
              ),

              SizedBox(height: 20.h),

              // Email Code
              Text(
                'Email Verification Code',
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8.h),
              TextField(
                controller: controller.emailController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Enter email code',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
              ),

              // SizedBox(height: 20.h),

              // // Google Code
              // Text('Google Authenticator Code (Optional)', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold)),
              // SizedBox(height: 8.h),
              // TextField(
              //   controller: controller.googleController,
              //   keyboardType: TextInputType.number,
              //   decoration: InputDecoration(
              //     hintText: 'Enter Google auth code',
              //     border: OutlineInputBorder(
              //       borderRadius: BorderRadius.circular(12.r),
              //     ),
              //   ),
              // ),
              SizedBox(height: 40.h),

              // Submit Button
              Obx(
                () => ElevatedButton(
                  onPressed: controller.isLoading.value
                      ? null
                      : () async {
                          if (await controller.beforeSend()) {
                            controller.onApplyTap();
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: controller.isLoading.value
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                          'Withdraw',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),

              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }
}
