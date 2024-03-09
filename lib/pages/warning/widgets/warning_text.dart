import 'package:flutter/material.dart';

class WarningText extends StatelessWidget{
  const WarningText({super.key});
  Widget build(BuildContext context){
    return const Text(
      "Phát hiện có cháy tại khu vực gắn camera",
      style: TextStyle(
        color: Colors.white,
        fontSize: 12,
        fontWeight: FontWeight.bold,
      ),

    );
  }
}