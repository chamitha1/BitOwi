import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';

class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({super.key});

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR_SIMPLE');
  QRViewController? _controller;
  bool _done = false;

  @override
  void reassemble() {
    super.reassemble();
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
      if (_done) return;

      final code = scanData.code;
      if (code == null || code.isEmpty) return;

      _done = true;
      try {
        await _controller?.pauseCamera();
      } catch (_) {}

      Get.back(result: code);
    });
  }

  void _onPermissionSet(
    BuildContext context,
    QRViewController ctrl,
    bool granted,
  ) {
    if (!granted) {
      Get.snackbar(
        "Camera Permission",
        "Camera permission is required to scan QR codes.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFFDF4F5),
        colorText: const Color(0xFFCF4436),
        borderColor: const Color(0xFFF5B7B1),
        borderWidth: 1,
        icon: const Icon(Icons.error_outline, color: Color(0xFFCF4436)),
      );
      Future.delayed(const Duration(milliseconds: 300), () {
        if (Get.isOverlaysOpen) Get.back();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan QR Code'), toolbarHeight: 56),
      body: QRView(
        key: qrKey,
        onQRViewCreated: _onQRViewCreated,
        onPermissionSet: (ctrl, granted) =>
            _onPermissionSet(context, ctrl, granted),
        overlay: QrScannerOverlayShape(
          borderRadius: 10,
          borderWidth: 6,
          borderLength: 28,
          cutOutSize: 260,
        ),
      ),
    );
  }
}
