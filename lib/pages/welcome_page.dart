import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home_page.dart';
import 'login_page.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BodyWidget(),
    );
  }
}
class BodyWidget extends StatefulWidget {
  const BodyWidget({super.key});

  @override
  State<BodyWidget> createState() => _BodyWidgetState();
}

class _BodyWidgetState extends State<BodyWidget> {

  void timeToShowSplashScreenOnScreen() async {
    Timer(Duration(seconds: 3), () async {
      if (!mounted) return;
      SharedPreferences _prefs = await SharedPreferences.getInstance();
      bool? isLoggedIn = _prefs.getBool("loggedIn");
      if (isLoggedIn != null && isLoggedIn) {
      //  Navigator.of(context).pushNamedAndRemoveUntil(HomePage.homePageRoute, (route) => false);
        Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()),);
      } else {
        //Navigator.of(context).pushNamedAndRemoveUntil(LoginPage.loginRoute, (route) => false);
        Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()),);
      }
    });
  }


  @override
  void initState() {
    super.initState();
    timeToShowSplashScreenOnScreen();
   // WidgetsBinding.instance.addPostFrameCallback((_) {
  //    checkUserIsLogged();
  //  });
  //  new Future.delayed(const Duration(seconds: 1), () => checkUserIsLogged());


  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.sizeOf(context);
    return Container(
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
          Text('Fire Alert', style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          )
          ),
          Text('Giải pháp cảnh báo cháy cho gia đình bạn', style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          ),
        ],
      ),
    );
  }

  void checkUserIsLogged() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool("USER_IS_LOGGED") == null){
    //  new Future.delayed(const Duration(seconds: 1), () =>
          Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()),);
    //);
    }
    else {
      bool? logIn = prefs.getBool("USER_IS_LOGGED");
      if (logIn == true) {
        Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()),);
      }
      else{
        Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()),);
      }
    }
  }
}
