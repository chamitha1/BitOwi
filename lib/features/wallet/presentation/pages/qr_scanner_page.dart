import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';


class QrScannerPage extends StatefulWidget {
  const QrScannerPage({super.key});

  @override
  State<QrScannerPage> createState() => _QrScannerPageState();
}

class _QrScannerPageState extends State<QrScannerPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? _controller;

  bool _isFlashOn = false;
  bool _isProcessing = false;

  @override
  void reassemble() {
    super.reassemble();
    // Hot reload handling
    if (Platform.isAndroid) {
      _controller?.pauseCamera();
    }
    _controller?.resumeCamera();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _onQRViewCreated(QRViewController controller) {
    _controller = controller;

    controller.scannedDataStream.listen((scanData) async {
      if (_isProcessing) return;

      final code = scanData.code;
      if (code == null || code.isEmpty) return;

      _isProcessing = true;

      try {
        await _controller?.pauseCamera();
      } catch (_) {}

      // Return scanned result
      if (mounted) Get.back(result: code);

      // prevent multiple triggers
      await Future.delayed(const Duration(milliseconds: 250));
      _isProcessing = false;
    });
  }

  Future<void> _toggleFlash() async {
    if (_controller == null) return;
    await _controller!.toggleFlash();
    final status = await _controller!.getFlashStatus();
    setState(() => _isFlashOn = status ?? false);
  }

  Future<void> _flipCamera() async {
    if (_controller == null) return;
    await _controller!.flipCamera();
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool granted) {
    if (!granted) {
      Get.snackbar(
        "Camera Permission",
        "Camera permission is required to scan QR codes.",
        snackPosition: SnackPosition.BOTTOM,
      );
      Future.delayed(const Duration(milliseconds: 300), () {
        if (Get.isOverlaysOpen) Get.back();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Camera view
          QRView(
            key: qrKey,
            onQRViewCreated: _onQRViewCreated,
            onPermissionSet: (ctrl, granted) => _onPermissionSet(context, ctrl, granted),
            overlay: QrScannerOverlayShape(
              borderRadius: 10,
              borderWidth: 4,
              borderLength: 30,
              cutOutSize: 300,
            ),
          ),

          // Your dim overlay style (optional)
          ColorFiltered(
            colorFilter: const ColorFilter.mode(
              Color.fromRGBO(0, 0, 0, 0.5),
              BlendMode.srcOut,
            ),
            child: Stack(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    backgroundBlendMode: BlendMode.dstOut,
                  ),
                ),
                Center(
                  child: Container(
                    width: 300,
                    height: 300,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Blue border box (as your UI)
          Center(
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xff1D5DE5), width: 4),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),

          // Top bar (back + title)
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.black),
                      onPressed: () => Get.back(),
                    ),
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        "Scan QR Code",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 40),
                ],
              ),
            ),
          ),

          // Bottom actions (flash + flip)
          Positioned(
            left: 0,
            right: 0,
            bottom: 24,
            child: SafeArea(
              top: false,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: _toggleFlash,
                    icon: Icon(
                      _isFlashOn ? Icons.flash_on : Icons.flash_off,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 18),
                  IconButton(
                    onPressed: _flipCamera,
                    icon: const Icon(
                      Icons.cameraswitch,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
