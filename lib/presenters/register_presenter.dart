import 'dart:async';
import 'package:rxdart/rxdart.dart';
import '../model/Account.dart';
import '../model/register_model.dart';
import 'validators/register_valid.dart';

abstract class RegisterInterface{
  void registerSuccess();
  void registerError(dynamic error);
}

class RegisterPresenter
{
  RegisterInterface? interface;

  final RegisterModel _model = RegisterModel();

  final _nameSubject=BehaviorSubject<String>();//contains data for name field
  final _phoneSubject=BehaviorSubject<String>();
  final _codeSubject=BehaviorSubject<String>();
  final _btnSubject=BehaviorSubject<bool>();

  var nameValidation=StreamTransformer<String,String>.fromHandlers(//check validation of name field
    handleData: (name,sink){
      sink.add(RegisterValidation.validateName(name));
    }
  );
  var phoneValidation=StreamTransformer<String,String>.fromHandlers(
      handleData: (phone,sink){
        sink.add(RegisterValidation.validatePhone(phone));
      }
  );
  var codeValidation=StreamTransformer<String,String>.fromHandlers(
      handleData: (code,sink){
        sink.add(RegisterValidation.validateCode(code));
      }
  );

  Stream<String> get nameStream => _nameSubject.stream.transform(nameValidation).skip(1);//contains error notifications if name field is not valid
  Sink<String> get nameSink => _nameSubject.sink;//contains input data using for check validation

  Stream<String> get phoneStream => _phoneSubject.stream.transform(phoneValidation).skip(1);
  Sink<String> get phoneSink => _phoneSubject.sink;

  Stream<String> get codeStream => _codeSubject.stream.transform(codeValidation).skip(1);
  Sink<String> get codeSink => _codeSubject.sink;

  Stream<bool> get btnStream => _btnSubject.stream;
  Sink<bool> get btnSink => _btnSubject.sink;

  RegisterPresenter(RegisterInterface interface) {
    this.interface=interface;

    Rx.combineLatest3(_nameSubject,_phoneSubject,_codeSubject,(name,phone,code){
      return RegisterValidation.validateName(name)=="" &&
          RegisterValidation.validatePhone(phone)=="" &&
          RegisterValidation.validateCode(code)=="";
    }).listen((enable) {
      btnSink.add(enable);
    });

  }
  Future<bool> checkValidInfor(String phone,String code) async {
    if(await _model.isExistingPhone(phone) == true){
        interface?.registerError("Số điện thoại đã được đăng ký");
        return false; 
    }else{
      if(await _model.isExistingCode(code) == false){
        interface?.registerError("Mã đăng ký không tồn tại");
        return false;
      }
    }
    return true;
  }
  Future<void> register(Account account) async {
    if(await _model.addAccount(account)==true ){
      interface?.registerSuccess();
    }
    else{
      interface?.registerError("Lỗi trong quá trình đăng ký");
    }
  }

  dispose()
  {
    _nameSubject.close();
    _phoneSubject.close();
    _codeSubject.close();
    _btnSubject.close();
  }

}
