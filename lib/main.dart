import 'package:fire_warning_app/helper/fcm_helper.dart';
import 'package:fire_warning_app/helper/local_notification_service.dart';
import 'package:fire_warning_app/model/get_fire_status_db.dart';
import 'package:fire_warning_app/pages/fire_fighting_knowledge_page.dart';
import 'package:fire_warning_app/pages/register_success_page.dart';
import 'package:fire_warning_app/pages/warning_page.dart';
import 'package:fire_warning_app/pages/welcome_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'presenters/alert_status_presenter.dart';

final globalNavigatorKey =GlobalKey<NavigatorState>();


/*
@pragma('vm:entry-point')
Future<void> checkAlertStatus() async {
  print(
      "***********************************************AndroidAlarmManager work checkAlertStatus fucntion");

  //check alert status from DB
  AlertStatusPresenter alertStatusPresenter = AlertStatusPresenter();
  bool isAlert = await alertStatusPresenter.getAlertStatus();

  if (isAlert) {
    // create and show Notification Service
    NotificationService notificationService = NotificationService();
    await notificationService.initNotification();
    await notificationService.showNotification(
        id: 5, title: "Cảnh báo", body: "Hệ thống phát hiện có cháy");
    print("*******************************************Send noti ");
    //    }
  }
}
*/
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
/*
   //khởi tạo alarm manager
  await AndroidAlarmManager.initialize();

  await AndroidAlarmManager.periodic(
    const Duration(seconds: 10),
    0,
    checkAlertStatus,
    wakeup: true, // Đánh thức thiết bị nếu nó đang trong chế độ ngủ
    exact: true,
  );
  
*/
await LocalNotificationService.initNotification();


await FCMHelper().initNotification();




runApp(const MyApp());

/*
FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    navigatorKey: globalNavigatorKey,
    home: MyApp(),
  ));*/
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
/*
  @override
  void initState() {
    // TODO: implement initState

    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        onMessageOpenedAppHandler(context, message);
      }
    });

    FirebaseMessaging.onMessage.listen((message) {
      onMessageHandler(context, message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      onMessageOpenedAppHandler(context, message);
    });
  }
*/
 bool didNotificationLaunchApp = false;

@override
void initState(){
  listenToNotification();
  checkIfAppLaunchedViaNotification();
  super.initState();
}
Future<void> checkIfAppLaunchedViaNotification() async {
    final NotificationAppLaunchDetails? notificationAppLaunchDetails =
        await LocalNotificationService.localNotificationService.getNotificationAppLaunchDetails();
    if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
      setState(() {
        didNotificationLaunchApp = true;
      });
      // You can navigate to desired page based on notification details
    }
  }
listenToNotification(){
  print("Listening to notification");
  LocalNotificationService.onClickNotification.stream.listen((event){
    globalNavigatorKey.currentState?.pushNamed(WarningPage.route);
  });
}

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 255, 68, 68)),
        useMaterial3: true,
      ),
      navigatorKey: globalNavigatorKey,
      home: didNotificationLaunchApp?WarningPage(): WelcomePage(),
      //home: FireFightingKnowledgePage(),
      routes: { 
        WarningPage.route:(context) =>const WarningPage(),
      },
    );
  }
}
/*
1. chuyển từ màn hình hiện tại sang một màn hình mới. 
Màn hình mới sẽ được đẩy vào đầu ngăn xếp của navigator. 
Khi bạn quay lại, bạn sẽ trở về màn hình trước đó.
Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => NewScreen()),
);

2. quay lại màn hình trước đó trong ngăn xếp
Navigator.pop(context);

3.thay thế màn hình hiện tại với một màn hình mới trong ngăn xếp. 
Màn hình cũ sẽ không còn trong ngăn xếp, 
do đó không thể quay lại màn hình đó
Navigator.pushReplacement(
  context,
  MaterialPageRoute(builder: (context) => ReplacementScreen()),
);

4. Đẩy một màn hình mới vào ngăn xếp 
và xóa tất cả các màn hình khác cho đến khi gặp điều kiện nhất định
Navigator.pushAndRemoveUntil(
  context,
  MaterialPageRoute(builder: (context) => NewScreen()),
  (Route<dynamic> route) => false,
);

5. loại bỏ (pop) màn hình hiện tại khỏi ngăn xếp, 
sau đó đẩy (push) một màn hình mới được định danh bằng tên vào ngăn xếp
Navigator.popAndPushNamed(context, '/newScreen');
 */
