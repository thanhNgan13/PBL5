import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class WarningBtn extends StatelessWidget{
  const WarningBtn({super.key});
  Widget build(BuildContext context){
    Size screenSize=MediaQuery.sizeOf(context);
    return Column(
      children: [
        Container(
          height: screenSize.width/2.13,
          width: screenSize.width/2.13,
          alignment: Alignment.center,
          decoration:const  BoxDecoration(
          color: Color(0xffF5F6F8),
          shape:BoxShape.circle,
        ),
        child: const Text("Tôi an toàn",style: TextStyle(
          color: Color(0xffDE1842),
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),),
        ),
        const SizedBox(height: 20),
        const Text("Chạm và giữ 10s để tắt cảnh báo",style: TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),),
      ],
    );
  }
}