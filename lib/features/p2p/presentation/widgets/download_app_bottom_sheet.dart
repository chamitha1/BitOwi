import 'package:BitOwi/api/common_api.dart';
import 'package:BitOwi/config/config.dart';
import 'package:BitOwi/core/widgets/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DownloadAppBottomSheet extends StatefulWidget {
  const DownloadAppBottomSheet({super.key});

  @override
  State<DownloadAppBottomSheet> createState() => _DownloadAppBottomSheetState();
}

class _DownloadAppBottomSheetState extends State<DownloadAppBottomSheet> {
  bool _isLoading = false;

  Future<void> _onDownload() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Fetch config with type 'android-c'
      final res = await CommonApi.getConfig(type: 'android-c');
      final url = res.data["downloadUrl"] ?? '';

      if (url.isNotEmpty) {
        final Uri launchUri = Uri.parse(url);
        if (await canLaunchUrl(launchUri)) {
          await launchUrl(launchUri, mode: LaunchMode.externalApplication);
        } else {
          CustomSnackbar.showError(
            title: "Error",
            message: "Could not launch download URL",
          );
        }
      } else {
        CustomSnackbar.showError(
          title: "Error",
          message: "Download URL not found",
        );
      }
    } catch (e) {
      debugPrint("Download error: $e");
      CustomSnackbar.showError(
        title: "Error",
        message: "Failed to get download information",
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        Navigator.pop(context);
      }
    }
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
          padding: const EdgeInsets.all(10),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              _buildHeader(context),
              const SizedBox(height: 7),
              const Text.rich(
                TextSpan(
                  children: [
                    const TextSpan(
                      text: "The Function requires Downloading\n",
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: Color(0xFF717F9A),
                        height: 1.5,
                      ),
                    ),
                    TextSpan(
                      text: "${AppConfig.appName} App",
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: Color(0xFF151E2F),
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              _buildDownloadButton(),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Go Download",
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color(0xff151E2F),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildDownloadButton() {
    return Container(
      height: 54,
      // color: Color(0xff1D5DE5),
      width: double.infinity,
      decoration: BoxDecoration(
        // gradient: const LinearGradient(
        //   begin: Alignment.topCenter,
        //   end: Alignment.bottomCenter,
        //   colors: [Color(0xFF1D5DE5), Color(0xFF28A6FF)],
        // ),
        color: Color(0xff1D5DE5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ElevatedButton(
        onPressed: _isLoading ? null : _onDownload,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: _isLoading
            ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : const Text(
                "Download",
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }
}
