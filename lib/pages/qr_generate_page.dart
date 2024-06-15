import 'package:flutter/material.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

class QRGeneratePage extends StatefulWidget {
  final String userCode;
   QRGeneratePage({Key? key,required this.userCode}):super(key: key);

  @override
  State<QRGeneratePage> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<QRGeneratePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chia sẻ mã'),
      ),
      body:Container(
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Text('Mã code của bạn: '+widget.userCode,style: TextStyle(fontSize: 20),),
            SizedBox(height: 20,),
            PrettyQrView.data(data: widget.userCode),
          ],),
        ),
    )
    )
      ;
  }
}