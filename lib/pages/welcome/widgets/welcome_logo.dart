import 'package:flutter/material.dart';

class WelcomeLogo extends StatelessWidget{
  const WelcomeLogo({super.key});
  Widget build(BuildContext context){
    Size screenSize=MediaQuery.sizeOf(context);
    return Container(
      width: screenSize.width/2.65,
      padding: const EdgeInsets.all(20.0),
      child: Image.asset('assets/icons/logo.png'),
    );
  }
}