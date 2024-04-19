import 'package:fire_warning_app/component/BottomNavItem.dart';
import 'package:fire_warning_app/firebase_options.dart';
import 'package:fire_warning_app/pages/home/ESP32/view_status_fire.dart';
import 'package:fire_warning_app/pages/home/VideoPages/VideoPlay.dart';
import 'package:fire_warning_app/pages/home/VideoPages/hom_live_video_from_esp32cam%20copy.dart';
import 'package:fire_warning_app/pages/home/home_v2.dart';
import 'package:fire_warning_app/pages/home/ESP8266/view_status_co.dart';
import 'package:fire_warning_app/pages/test/test_control_servo.dart';
import 'package:fire_warning_app/pages/test/vidieukhien.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:io';

import 'package:fire_warning_app/pages/home_page.dart';
import 'package:fire_warning_app/pages/login_page.dart';
import 'package:fire_warning_app/pages/welcome/welcome.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Platform.isAndroid
      ? await Firebase.initializeApp(
          options: const FirebaseOptions(
              apiKey: 'AIzaSyCSiBTRnU7u3aQee9-b2MhzCS6_dlHJsfE',
              appId: '1:138271755735:android:bf37f0d5f22c300e2e8f92',
              messagingSenderId: '138271755735',
              projectId: 'fire-warning-system-2d9c2'))
      : await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _pages = [
    FireStatusPage(),
    MJPEGStream(),
    Home_v3(),
    MyHome()
  ];

  final List<BottomNavItem> bottomNavItems = [
    BottomNavItem(
        icon: const Icon(
          Icons.newspaper_rounded,
        ),
        label: 'Warning'),
    BottomNavItem(icon: const Icon(Icons.person_outline), label: 'Control'),
    BottomNavItem(icon: const Icon(Icons.webhook_rounded), label: 'ESP8266'),
    BottomNavItem(icon: const Icon(Icons.home_rounded), label: 'My Home')
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: IndexedStack(
          index: _selectedIndex,
          children: _pages,
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.black,
          unselectedItemColor: Colors.grey,
          selectedItemColor: Colors.red,
          unselectedFontSize: 15,
          selectedFontSize: 15,
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: [
            for (var i = 0; i < bottomNavItems.length; i++)
              if (i == 0 && _selectedIndex != 0)
                const BottomNavigationBarItem(
                  icon: Icon(Icons.newspaper_rounded),
                  label: 'Home',
                )
              else
                BottomNavigationBarItem(
                  icon: bottomNavItems.elementAt(i).icon,
                  label: bottomNavItems.elementAt(i).label,
                )
          ],
        ));
  }
}
