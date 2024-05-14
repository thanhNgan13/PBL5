import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRScannerPage extends StatelessWidget {
  const QRScannerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BodyWidget(),
    );
  }
}
class BodyWidget extends StatefulWidget {
  const BodyWidget({super.key});

  @override
  State<BodyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<BodyWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text('Quét mã QR'),

      ),
      body: MobileScanner(
        controller: MobileScannerController(
          detectionSpeed: DetectionSpeed.noDuplicates,
          returnImage: true,
        ),
        onDetect: (capture){
          final List<Barcode> barcodes=capture.barcodes;
          final Uint8List? image=capture.image;
          for(final barcode in barcodes){
            print('Barcode found ${barcode.rawValue}' );
          }
          if(image!=null){
            showDialog(context: context, builder: (context){
              return AlertDialog(
                title: Text(barcodes.first.rawValue ?? ""),
                content: Image(image: MemoryImage(image),),
              );
            });
          }

        },
      ),

    );
  }
}