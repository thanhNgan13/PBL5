import 'package:fire_warning_app/main.dart';
import 'package:fire_warning_app/pages/warning_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';


class NotificationService{
  final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();
  
  Future<void> initNotification() async{
    AndroidInitializationSettings initializationSettingsAndroid=const AndroidInitializationSettings('logo_app');

    var initializationSettingsIOS=DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification: (id, title, body, payload) async {} );

    var initializationSettings=InitializationSettings(
      android: initializationSettingsAndroid, iOS: initializationSettingsIOS
    );
    await _notificationsPlugin.initialize(initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse notificationResponse) async{
        if (notificationResponse.actionId == 'open') {
      //open warning page
         // Ensure the context is available or use a global navigator key
        Navigator.of(globalNavigatorKey.currentContext!).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => WarningPage()),
          (route) => false,
        );
        }
        else{
          print("lỗi click");
        }
      }
    );
  }

  notificationDetails(){
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'id', 
        "name",
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        sound: RawResourceAndroidNotificationSound('notification'),
        actions: <AndroidNotificationAction>[
        AndroidNotificationAction('open', 'Mở ứng dụng', showsUserInterface: true,),
      ],
      
        ),
      iOS: DarwinNotificationDetails(),
    );
  }
  Future showNotification(
    {int id=0,String?title,String? body,String? payLoad} ) async {
      return _notificationsPlugin.show(id, title, body,await notificationDetails());
    }
  
}


 