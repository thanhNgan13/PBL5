import 'package:fire_warning_app/model/alert_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AlertPresenter{
  AlertModel alertModel=AlertModel();
  Future<void> sendAlertToFamily() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? _code = prefs.getString('USER_CODE');
    final String? _phone = prefs.getString('USER_PHONE');

    if(_code != null  && _code.isNotEmpty && _phone != null  && _phone.isNotEmpty){
      alertModel.sendAlertToFamily(_code,_phone);
    }
  }

  Future<void> updatePersonalAlertStatus() async {
     SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? _phone = prefs.getString('USER_PHONE');

    if( _phone != null  && _phone.isNotEmpty){
      alertModel.changePersonalAlertStatus(_phone);
    }
  }
  
    
}