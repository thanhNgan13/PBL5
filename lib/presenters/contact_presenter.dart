import 'package:fire_warning_app/model/Contact.dart';
import 'package:fire_warning_app/model/contact_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ContactPresenter{
  ContactModel contactModel=ContactModel();

  Future<List<Contact>> getListContacts() async {
    List<Contact> list=[];

    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? _code = prefs.getString('USER_CODE');
    final String? _phone = prefs.getString('USER_PHONE');

    if(_code != null  && _code.isNotEmpty &&_phone!=null && _phone.isNotEmpty){
      print("Số điện thoại của người dùng: $_phone");
      print("Ma code của người dùng: $_code");
     list=await contactModel.getListContacts(_code,_phone);
    }
    return list;
  }
}