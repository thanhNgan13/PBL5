import 'package:flutter/material.dart';

class WelcomeSlogan extends StatelessWidget{
  const WelcomeSlogan({super.key});
  Widget build(BuildContext context){
    return Text('Giải pháp cảnh báo cháy cho gia đình bạn',style: TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.bold,
      color: Colors.white,
      ),
    );
  }
}