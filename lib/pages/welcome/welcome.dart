import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'widgets/welcome_app_name.dart';
import 'widgets/welcome_logo.dart';
import 'widgets/welcome_slogan.dart';

class WelcomePage extends StatelessWidget{
  const WelcomePage({super.key});
  Widget build(BuildContext context){
    Size screenSize=MediaQuery.sizeOf(context);
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end:Alignment.bottomCenter,
            colors:[
            Color(0xffD84441),
            Color(0xffFF8581),
          ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            WelcomeLogo(),
            WelcomeAppName(),
            WelcomeSlogan(),
          ],
          ),
        ),
    );
  }
}