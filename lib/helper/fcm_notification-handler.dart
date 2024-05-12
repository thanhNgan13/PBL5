import 'package:fire_warning_app/helper/local_notification_service.dart';
import 'package:fire_warning_app/pages/warning_page.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

// Hàm xử lý thông báo khi ứng dụng đang chạy ngầm
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("thông báo khi ứng dụng đang chạy ngầm: ${message.messageId}");
  /*
  final notification = message.notification;
  final android = message.notification?.android;
  if (notification != null && android != null) {
    NotificationService notificationService = NotificationService();
        await notificationService.initNotification();
        await notificationService.showNotification(id: 5, title: "Cảnh báo", body: "Hệ thống phát hiện có cháy");
        print("*******************************************Send noti ");
  }*/
}

// Hàm hiển thị thông báo khi ứng dụng đang mở
Future<void> onMessageHandler(BuildContext context, RemoteMessage message) async {
   print("thông báo khi khi ứng dụng đang mở: ${message.messageId}");
   /*
  final notification = message.notification;
  final android = message.notification?.android;
  if (notification != null && android != null) {
    NotificationService notificationService = NotificationService();
        await notificationService.initNotification();
        await notificationService.showNotification(id: 5, title: "Cảnh báo", body: "Hệ thống phát hiện có cháy");
        print("*******************************************Send noti ");
  }*/
  
}

// Hàm xử lý khi người dùng tập vào thông báo để mở ứng dụng
void onMessageOpenedAppHandler(BuildContext context, RemoteMessage message) {
  print("thông báo khi người dùng tập vào thông báo: ${message.messageId}");
  Navigator.push(context, MaterialPageRoute(builder: (context) => WarningPage()),);
}
