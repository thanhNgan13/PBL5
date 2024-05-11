import 'package:fire_warning_app/helper/local_notification_service.dart';
import 'package:fire_warning_app/model/get_fire_status_db.dart';
import 'package:fire_warning_app/pages/welcome_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';

import 'presenters/alert_status_presenter.dart';


final GlobalKey<NavigatorState> globalNavigatorKey = GlobalKey<NavigatorState>();

@pragma('vm:entry-point')
Future<void> checkAlertStatus() async {
    print("***********************************************AndroidAlarmManager work checkAlertStatus fucntion");

    //check alert status from DB
      AlertStatusPresenter alertStatusPresenter = AlertStatusPresenter();
      bool isAlert= await alertStatusPresenter.getAlertStatus();

      if(isAlert){
        // create and show Notification Service
        NotificationService notificationService = NotificationService();
        await notificationService.initNotification();
        await notificationService.showNotification(id: 5, title: "Cảnh báo", body: "Hệ thống phát hiện có cháy");
        print("*******************************************Send noti ");
  //    }
  }
 
    
}

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

   //khởi tạo alarm manager
  await AndroidAlarmManager.initialize();

  
  await AndroidAlarmManager.periodic(
    const Duration(seconds: 10), 
    0, 
    checkAlertStatus,
    wakeup: true, // Đánh thức thiết bị nếu nó đang trong chế độ ngủ
    exact: true,
  );
  

  runApp(MaterialApp(
    navigatorKey: globalNavigatorKey,
    home: MyApp(),
  ));
  
}



class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  

  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home:const WelcomePage(),
    //    home:const WarningPage(),
    );
  }
}
