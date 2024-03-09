import 'package:flutter/material.dart';

class WelcomeAppName extends StatelessWidget{
  const WelcomeAppName({super.key});
  Widget build(BuildContext context){
    return Text('Fire Alert',style:TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: Colors.white,
      )
    );
  }
}