import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceHelper{
  Future<String> getUserCode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? _code = prefs.getString('USER_CODE');

    if(_code != null  && _code.isNotEmpty ){
      return _code;
    }
    return "";
  }
   Future<String> getUserPhone() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? _phone = prefs.getString('USER_PHONE');


    if(_phone != null  && _phone.isNotEmpty ){
      return _phone;
    }
    return "";
  }
}