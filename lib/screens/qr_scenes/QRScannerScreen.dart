import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import 'Student_qr_scene.dart';

class QRScannerScreen extends StatefulWidget {
  @override
  _QRScannerScreenState createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  final qrKey = GlobalKey(debugLabel: 'QR');
  late QRViewController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: QRView(
        key: qrKey,
        onQRViewCreated: _onQRViewCreated,
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      // code used to determine what to do with the scanned data
      final studentId = scanData.code;
      if (studentId != null) {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => StudentDataScreen(studentId: studentId)),
        );
      } else {
        // incase the student id is null. we just print it out for now should maybe throw a snackbar instead?
        print("QR code scan returned null");
      }
    });
  }


  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}

