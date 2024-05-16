import 'dart:async';
import 'dart:convert';

import 'package:fire_warning_app/helper/local_notification_service.dart';
import 'package:fire_warning_app/main.dart';
import 'package:fire_warning_app/pages/warning_page.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

//when app is on background
Future<void> handleBackgroundMessage(RemoteMessage message) async{
  print('Title: ${message.notification?.title}');
  print('Body: ${message.notification?.body}');
  print('Payload: ${message.data}');

  await  Future.delayed(const Duration(milliseconds: 200), () =>globalNavigatorKey.currentState?.pushNamed(WarningPage.route));

  
  await LocalNotificationService.showNotificationWithPayload(
        id: 100, title: "Cảnh báo", body: "Cháy",payLoad: 'payload');
  
}


class FCMHelper {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

   final _androidChannel=const AndroidNotificationChannel(
    'high_importance_channel',
     'high importce notifications',
     description: 'this channel is used for important notification',
     importance: Importance.max,
     sound: RawResourceAndroidNotificationSound('notification'),
      playSound: false,
     );
     
  
  final _localNotification=FlutterLocalNotificationsPlugin();

  
  Future<void> handleMessageWithPayload(RemoteMessage? message) async {
    if(message==null) return ;

     await  Future.delayed(const Duration(milliseconds: 200), () =>globalNavigatorKey.currentState?.pushNamed(WarningPage.route));

    await LocalNotificationService.showNotificationWithPayload(
        id: 101, title: "Cảnh báo closed", body: "Hệ thống phát hiện có cháy",payLoad: 'papload');
  }
  
  //create local notification
  Future initLocalNotification()async{
    const android=AndroidInitializationSettings('@drawable/logo_app');
    const setting=InitializationSettings(android: android);

    await _localNotification.initialize(
      setting,
      onDidReceiveNotificationResponse:(payload){
      },
    );

    final platform=_localNotification.resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>();
    await platform?.createNotificationChannel(_androidChannel);
  }

  //when app is opened 
  Future initPushNotifications()async{
    await FirebaseMessaging.instance
      .setForegroundNotificationPresentationOptions(
        alert: false,
        badge: true,
        sound: true,
      );

   

    //handle message when app is closed
    FirebaseMessaging.instance.getInitialMessage().then(handleMessageWithPayload);

    //handle message when app is on background and user click on notification
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessageWithPayload);

    //handle message when app is on background 
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);

    //handle message when app is opened
    FirebaseMessaging.onMessage.listen((message){
      
      final notification=message.notification;
      if(notification==null) return;

       globalNavigatorKey.currentState?.pushNamed(WarningPage.route);    

      _localNotification.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            "idnoti",
            "namenoti",
            channelDescription: _androidChannel.description,
            icon:'@drawable/logo_app',
            importance: Importance.max,
            priority: Priority.high,
            playSound: true,
            sound: RawResourceAndroidNotificationSound('notification'),
          ),
        ),
        payload: jsonEncode(message.toMap()),
      );
      
    });
  }

  Future<void> initNotification() async {
      await _messaging.requestPermission();
      String? token = await _messaging.getToken();
      print("Firebase Messaging Token: $token");
      
      

      initPushNotifications();
      initLocalNotification();
    }

  Future<String> getToken() async {
    await _messaging.requestPermission();

    String? token = await _messaging.getToken();
    if(token!=null) {
      return token;
    }
    return "";
  }


}


