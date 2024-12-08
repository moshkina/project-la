import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:provider/provider.dart';
import '../../data/volunteer.dart';
import '../../listeners/volunteers_viewmodel.dart';
import 'package:flutter/foundation.dart';

class BarCodeScannerScreen extends StatefulWidget {
  const BarCodeScannerScreen({super.key});

  @override
  BarCodeScannerScreenState createState() => BarCodeScannerScreenState();
}

class BarCodeScannerScreenState extends State<BarCodeScannerScreen> {
  final GlobalKey qrKey = GlobalKey();
  QRViewController? controller;
  String? result;
  bool barcodeScanned = false;

  @override
  void reassemble() {
    super.reassemble();
    if (controller != null) {
      if (defaultTargetPlatform == TargetPlatform.android) {
        controller!.pauseCamera();
      }
      controller!.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan QR Code')),
      body: Column(
        children: [
          Expanded(
            flex: 4,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: Text(
                result ?? "Scan a QR Code",
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController qrController) {
    controller = qrController;
    controller!.scannedDataStream.listen((scanData) {
      if (!barcodeScanned) {
        setState(() {
          barcodeScanned = true;
          result = scanData.code;
        });
        processQRCode(scanData.code);
      }
    });
  }

  void processQRCode(String? scanResult) {
    if (scanResult == null) return;

    try {
      // Пример данных: "John Doe\n1234567890"
      List<String> scanResultArray = scanResult.split("\n");

      String fullName = scanResultArray[0];
      String phoneNumber = scanResultArray[scanResultArray.length - 1];

      final volunteer = Volunteer(
        uniqueId: DateTime.now().millisecondsSinceEpoch, // Уникальный ID
        fullName: fullName,
        phoneNumber: phoneNumber,
        callSign: "Default",
        nickName: "Default",
        region: "Unknown",
        car: "None",
        status: "Active",
        size: 0,
      );

      context.read<VolunteersViewModel>().insertVolunteer(volunteer);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Volunteer $fullName added successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to process QR Code')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
