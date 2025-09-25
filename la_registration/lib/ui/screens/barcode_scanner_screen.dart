import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:provider/provider.dart';
import '../../data/volunteer.dart';
import 'package:la_registration/viewmodels/groups_and_volunteers_viewmodel.dart';
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
      appBar: AppBar(title: const Text('Сканирование QR-кода')),
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
                result ?? "Отсканируйте QR-код",
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
      List<String> scanResultArray = scanResult.split("\n");

      String fullName = scanResultArray[0];
      String callSign = scanResultArray[1];
      String nickName = scanResultArray[2];
      String region = scanResultArray[3];
      String phoneNumber = scanResultArray[4];
      String car = scanResultArray[5] ?? "";

      final volunteer = Volunteer(
        uniqueId: DateTime.now().millisecondsSinceEpoch,
        index: 0,
        fullName: fullName,
        phoneNumber: phoneNumber,
        callSign: callSign,
        nickName: nickName,
        region: region,
        car: car,
        status: "Активный",
        isSent: false,
        notifyThatLeft: "false",
        timeForSearch: "",
        groupId: null,
      );

      context.read<VolunteersViewModel>().insertVolunteer(volunteer);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Волонтер $fullName успешно добавлен!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ошибка обработки QR-кода')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
