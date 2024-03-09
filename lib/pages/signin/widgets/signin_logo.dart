import 'package:flutter/material.dart';

class SignInLogo extends StatelessWidget{
  const SignInLogo({super.key});
  Widget build(BuildContext context){
    Size screenSize=MediaQuery.sizeOf(context);
    return Container(
      width: screenSize.width/3.76,
      padding: const EdgeInsets.all(20.0),
      child: Image.asset('assets/icons/logo_red.png'),
    );
  }
}