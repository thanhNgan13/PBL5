import 'package:shared_preferences/shared_preferences.dart';

class LogOutHelper{
  Future<void> disposeAccountData() async {
    await Future.delayed(Duration(seconds: 2));
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? _phone = prefs.getString('USER_PHONE');
    final String? _code = prefs.getString('USER_CODE');
    if (_phone != null) {
      print("Số điện thoại của người dùng: $_phone");
      await prefs.remove('USER_PHONE');
      prefs.reload();
      print("Đã xóa số điện thoại được lưu trữ");
    } else {
      print("Không có số điện thoại nào được lưu trữ.");
    }
    if (_code != null) {
      print("Mã code của người dùng: $_code");
      await prefs.remove('USER_CODE');
      prefs.reload();
      print("Đã xóa mã code được lưu trữ");
    } else {
      print("Không có mã nào nào được lưu trữ.");
    }
    
    
    

  }

  
}