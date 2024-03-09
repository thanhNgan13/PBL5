import 'package:flutter/material.dart';
import 'widgets/warning_btn.dart';
import 'widgets/warning_btn_function.dart';
import 'widgets/warning_text.dart';
import 'widgets/warning_title.dart';

class WarningPage extends StatelessWidget{
  const WarningPage({super.key});
  Widget build(BuildContext context){
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end:Alignment.bottomCenter,
            colors:[
            Color(0xffD84441),
            Color(0xff8F001E),
          ],
          ),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            WarningTitle(),
            WarningText(),
            WarningBtn(),
            WarningBtnFunction(),
          ],
          ),
        ),
    );
  }
}