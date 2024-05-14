import 'dart:async';
import 'dart:convert';

import 'package:fire_warning_app/main.dart';
import 'package:fire_warning_app/pages/warning_page.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

//when app is on background
Future<void> handleBackgroundMessage(RemoteMessage message) async{
  print('Title: ${message.notification?.title}');
  print('Body: ${message.notification?.body}');
  print('Payload: ${message.data}');
}

class FCMHelper {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

   final _androidChannel=const AndroidNotificationChannel(
    '1',
     'high importce notifications',
     description: 'this channel is used for important notification',
     importance: Importance.max,
     sound: RawResourceAndroidNotificationSound('notification'),
     );

  final _localNotification=FlutterLocalNotificationsPlugin();

  //open WarningPage
  void handleMessage(RemoteMessage? message){
    if(message==null) return ;


    globalNavigatorKey.currentState?.pushNamed(
      WarningPage.route,
    );
  }

  //create local notification
  Future initLocalNotification()async{
    const android=AndroidInitializationSettings('@drawable/logo_app');
    const setting=InitializationSettings(android: android);

    await _localNotification.initialize(
      setting,
      onDidReceiveNotificationResponse:(payload){
        final message=RemoteMessage.fromMap(jsonDecode(payload as String));
        handleMessage(message);
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
        alert: true,
        badge: true,
        sound: true,
      );
    //handle message when app is closed
    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);

    //handle message when app is on background and user click on notification
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);

    //handle message when app is on background 
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);

    //handle message when app is opened
    FirebaseMessaging.onMessage.listen((message){
      final notification=message.notification;
      if(notification==null) return;

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
      ).then((_) => handleMessage(message));

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
