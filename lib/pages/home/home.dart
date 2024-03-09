import 'package:flutter/material.dart';
class HomePage extends StatelessWidget{
  const HomePage({super.key});
  Widget build(BuildContext context){
    Size screenSize=MediaQuery.sizeOf(context);
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          color: Color(0xffF5F6F8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            
          ],
          ),
        ),
    );
  }
}