import 'package:BitOwi/features/wallet/presentation/controllers/transaction_detail_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class TransactionDetailPage extends StatelessWidget {
  const TransactionDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TransactionDetailController());

    return Scaffold(
      backgroundColor: const Color(0xFFF6F9FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF6F9FF),
        elevation: 0,
        centerTitle: true,
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: const Icon(Icons.arrow_back, color: Colors.black),
        ),
        title: const Text(
          "Transaction Details",
          style: TextStyle(
            color: Color(0xFF151E2F),
            fontSize: 18,
            fontWeight: FontWeight.w600,
            fontFamily: 'Inter',
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final detail = controller.detail.value;
        if (detail == null) {
          return const Center(
            child: Text("Transaction details not found."),
          );
        }

        double amount = double.tryParse(detail.transAmount) ?? 0.0;
        final bool isDeposit = amount >= 0; 
        
        final Color statusTextColor =
            isDeposit ? const Color(0xFF40A372) : const Color(0xFFE74C3C);
        final Color statusBgColor =
            isDeposit ? const Color(0xFFEAF9F0) : const Color(0xFFFDF4F5);
        final String statusLabel = isDeposit ? "Deposit" : "Charge";

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Status Header
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 24,
                    horizontal: 20,
                  ),
                  decoration: BoxDecoration(
                    color: statusBgColor,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        statusLabel,
                        style: const TextStyle(
                          color: Color(0xFF717F9A),
                          fontSize: 14,
                          fontFamily: 'Inter',
                        ),
                      ),
                      const SizedBox(height: 8),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text:
                                  "${amount > 0 ? '+' : ''}${detail.transAmount} ",
                              style: TextStyle(
                                color: statusTextColor,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Inter',
                              ),
                            ),
                            TextSpan(
                              text: detail.currency ?? '',
                              style: TextStyle(
                                color: statusTextColor,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Inter',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Fields
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      _buildInfoRow(
                        label: "Previous Balance",
                        value: "${detail.preAmount ?? '0'} ${detail.currency ?? ''}",
                      ),
                      const SizedBox(height: 24),
                      _buildInfoRow(
                        label: "New Balance",
                        value: "${detail.postAmount ?? '0'} ${detail.currency ?? ''}",
                      ),
                      const SizedBox(height: 24),
                      _buildInfoRow(
                        label: "Address",
                        value: detail.accountNumber ?? '',
                        allowCopy: true,
                      ),
                      const SizedBox(height: 24),
                      _buildInfoRow(
                        label: "Transaction Hash",
                        value: detail.refNo ?? '',
                        allowCopy: true,
                        isUnderline: true,
                      ),
                      const SizedBox(height: 24),
                      _buildInfoRow(
                        label: "Fees", 
                        value: "0.00 ${detail.currency ?? ''}",
                      ),
                      const SizedBox(height: 24),
                      _buildInfoRow(
                        label: "Transaction Time",
                        value: _formatDate(detail.createDatetime),
                      ),
                      const SizedBox(height: 24),
                       _buildInfoRow(
                        label: "Remark",
                        value: detail.remark ?? '',
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  String _formatDate(dynamic date) {
    if (date == null) return "";
    int timestamp = 0;
    if (date is int) {
      timestamp = date;
    } else if (date is String) {
      timestamp = int.tryParse(date) ?? 0;
    }
    if (timestamp == 0) return "";
    return DateTime.fromMillisecondsSinceEpoch(timestamp).toString().split('.')[0];
  }

  Widget _buildInfoRow({
    required String label,
    required String value,
    bool allowCopy = false,
    bool isUnderline = false,
  }) {
    if (value.isEmpty) return const SizedBox.shrink();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: Color(0xFF717F9A),
                  fontSize: 12,
                  fontFamily: 'Inter',
                ),
              ),
              const SizedBox(height: 8),
              Text(
                value,
                style: TextStyle(
                  color: const Color(0xFF151E2F),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Inter',
                  decoration: isUnderline ? TextDecoration.underline : null,
                ),
              ),
            ],
          ),
        ),
        if (allowCopy)
          GestureDetector(
            onTap: () {
              Clipboard.setData(ClipboardData(text: value));
              Get.showSnackbar(
                const GetSnackBar(
                  message: "Copied to clipboard",
                  duration: Duration(seconds: 2),
                  backgroundColor: Colors.black87,
                  borderRadius: 8,
                  margin: EdgeInsets.all(16),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(0),
              decoration: BoxDecoration(
                color: const Color(0xFFE9F6FF),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Image.asset(
                "assets/icons/deposit/copy.png",
                width: 40,
                height: 40,
                color: const Color(0xFF2495E5),
              ),
            ),
          ),
      ],
    );
  }
}
