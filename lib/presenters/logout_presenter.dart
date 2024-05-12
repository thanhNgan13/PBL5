import 'package:fire_warning_app/helper/log_out_helper.dart';
import 'package:fire_warning_app/model/logout_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LogOutPresenter{
  LogoutModel logOutModel= LogoutModel();

  LogOutHelper logOutHelper=LogOutHelper();

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? _phone = prefs.getString('USER_PHONE');
    if(_phone!=null)
    {
      logOutModel.removeTokenInDB(_phone);

      logOutHelper.disposeAccountData();
    }
      
  }
}