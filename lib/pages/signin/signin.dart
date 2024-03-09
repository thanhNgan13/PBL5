import 'package:flutter/material.dart';

import 'widgets/signin_btnSignin.dart';
import 'widgets/signin_form.dart';
import 'widgets/signin_logo.dart';
import 'widgets/signin_title.dart';

class SignInPage extends StatelessWidget{

  const SignInPage({super.key});
  Widget build(BuildContext context){
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Column(
          children: [
            SignInTitle(),
            SignInLogo(),
            SignInForm(),
            BtnSignIn(),
          ],
        ),
      ),
    );
  }
}