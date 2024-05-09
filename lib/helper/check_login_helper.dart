import 'package:shared_preferences/shared_preferences.dart';

class CheckLoginHelper{
  Future<bool> checkUserLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? _code = prefs.getString('USER_CODE');
    final String? _phone = prefs.getString('USER_PHONE');

    bool isLogin=true;

    if(_code != null  && _code.isNotEmpty ){
      print("Mã code của người dùng: $_code");
      isLogin=true;
    }
    else{
      print("Không có mã nào nào được lưu trữ.");
      isLogin=false;
    }

    if( _phone != null  && _phone.isNotEmpty){
        print("Số điện thoại của người dùng: $_phone");
        isLogin=true;
    }
    else{
      print("Không có số điện thoại nào được lưu trữ.");
      isLogin=false;
    }
    return isLogin;
  }
  }
  