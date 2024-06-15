import 'package:fire_warning_app/model/Account.dart';
import 'package:fire_warning_app/model/account_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountPresenter{
  AccountModel accountModel=AccountModel();
  Future<Account?> getCurrentUserAccount() async {
    String? _userName;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? _code = prefs.getString('USER_CODE');
    final String? _phone = prefs.getString('USER_PHONE');

    if(_code != null  && _code.isNotEmpty &&_phone!=null && _phone.isNotEmpty){
     _userName=await accountModel.getCurrentUserAccount(_phone);

     if(_userName!=""){
      return Account(_userName, _phone, _code);
     }
    }
    return null;
  }
}