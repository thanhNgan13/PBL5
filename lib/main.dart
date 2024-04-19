import 'package:fire_warning_app/component/BottomNavItem.dart';
import 'package:fire_warning_app/firebase_options.dart';
import 'package:fire_warning_app/pages/IoT/ESP32/view_status_fire.dart';
import 'package:fire_warning_app/pages/IoT/VideoPages/VideoPlay.dart';
import 'package:fire_warning_app/pages/IoT/VideoPages/hom_live_video_from_esp32cam%20copy.dart';
import 'package:fire_warning_app/pages/IoT/home_v2.dart';
import 'package:fire_warning_app/pages/IoT/ESP8266/view_status_co.dart';
import 'package:fire_warning_app/pages/IoT/test_control_servo.dart';
import 'package:fire_warning_app/pages/IoT/vidieukhien.dart';
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
      home: HomePage(),
    );
  }
}
