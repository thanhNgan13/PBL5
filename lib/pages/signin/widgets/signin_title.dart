import 'package:flutter/material.dart';

class SignInTitle extends StatelessWidget{
  const SignInTitle({super.key});
  Widget build(BuildContext context){
    return Text('Đăng ký tài khoản',style:TextStyle(
      fontSize: 30,
      fontWeight: FontWeight.bold,
      color: Colors.black,
      )
    );
  }
}
