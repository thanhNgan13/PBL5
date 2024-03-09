import 'package:flutter/material.dart';

class WarningTitle extends StatelessWidget{
  const WarningTitle({super.key});
  Widget build(BuildContext context){
    return Column(
      children: [
        Image.asset("assets/icons/bell.png"),
        const SizedBox(height: 10),
        const Text("CẢNH BÁO TỪ HỆ THỐNG",style: TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        )
    ],
    );
  }
}