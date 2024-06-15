import 'package:fire_warning_app/model/MyNotification.dart';
import 'package:fire_warning_app/model/notification_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationPresenter{
  NotificationModel notificationModel= NotificationModel();
  Future<List<MyNotification>> getListNotifications() async {
    List<MyNotification> list=[];
    List<MyNotification>? reversedList=[];

    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? _code = prefs.getString('USER_CODE');

    if(_code != null  && _code.isNotEmpty ){
      list= await notificationModel.getListNotifications(_code);
      reversedList=list.reversed.toList();
    }
    return reversedList;
  }
}