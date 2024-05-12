import 'package:firebase_messaging/firebase_messaging.dart';

class TokenManager {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future<String> initToken() async {
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      String? token = await _messaging.getToken();
      print("Firebase Messaging Token: $token");
      if(token!=null)
        return token;
      else
        return "";

      // Optionally, you can save the token in your server or wherever it's needed
    } 
    else {
      print('User declined or has not accepted permission');
    }
    return "";
  }
}
