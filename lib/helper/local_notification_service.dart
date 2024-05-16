import 'package:fire_warning_app/main.dart';
import 'package:fire_warning_app/pages/warning_page.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';


class LocalNotificationService{
 static final FlutterLocalNotificationsPlugin _localNotificationService = FlutterLocalNotificationsPlugin();
static FlutterLocalNotificationsPlugin get localNotificationService => _localNotificationService;
  static final onClickNotification=BehaviorSubject<String>();

  //on tap on notification
static void onTapNotification(NotificationResponse details) async {
    onClickNotification.add(details.payload!);
  }


 static Future<void> initNotification() async{
    AndroidInitializationSettings initializationSettingsAndroid=const AndroidInitializationSettings('logo_app');

    var initializationSettingsIOS=DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification: (id, title, body, payload) async {} );

    var initializationSettings=InitializationSettings(
      android: initializationSettingsAndroid, 
      iOS: initializationSettingsIOS
    );

    await _localNotificationService.initialize(
      initializationSettings,
      onDidReceiveBackgroundNotificationResponse: onTapNotification,
      onDidReceiveNotificationResponse: onTapNotification,
      
    );
  }

 static notificationDetails(){
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'myidchannel', 
        "mynamechannel",
        channelDescription: 'mydescription',
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        sound: RawResourceAndroidNotificationSound('notification'),
        ),
      iOS: DarwinNotificationDetails(),
    );
  }
  
 static Future showNotificationWithPayload(
    {int id=0,String?title,String? body, String? payLoad} ) async {
      final details=await notificationDetails();
      return _localNotificationService.show(id, title, body,details,payload: payLoad);
    }
  
}


 