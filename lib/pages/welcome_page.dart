import 'package:fire_warning_app/helper/check_login_helper.dart';
import 'package:fire_warning_app/pages/home_page.dart';
import 'package:fire_warning_app/pages/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:const BodyWidget(),
      );
  }
}

class BodyWidget extends StatefulWidget {
  const BodyWidget({super.key});

  @override
  State<BodyWidget> createState() => _BodyWidgetState();
}

class _BodyWidgetState extends State<BodyWidget> {
  CheckLoginHelper checkloginHelper= CheckLoginHelper();
  bool isLogin=false;

  @override
  void initState() {
    super.initState();
    checkUserLoginStatus();
    Future.delayed(const Duration(seconds: 3), () {
    navigateScreen();
  });

  }
  Future<void> navigateScreen() async {
    
     if (isLogin) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomePage()));
    } else {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LoginPage()));
    }
  }

   void checkUserLoginStatus() async {
    isLogin = await checkloginHelper.checkUserLogin();
    print("***********************************Đã đăng nhập? $isLogin");
  }  

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.sizeOf(context);
    return Stack(
      alignment: Alignment.center,
      children: [
        
        Container(
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xffD84441),
              Color(0xffFF8581),
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: screenSize.width / 2.65,
              padding: const EdgeInsets.all(20.0),
              child: Image.asset('assets/icons/logo.png'),
            ),
            Text('Fire Alert',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                )),
            Text(
              'Giải pháp cảnh báo cháy cho gia đình bạn',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      ]
    );
  }


}
