import 'dart:async';
import 'package:fire_warning_app/blocs/validators/login_valid.dart';
import 'package:rxdart/rxdart.dart';

class LoginBloc
{
  final _phoneSubject=BehaviorSubject<String>();
  final _codeSubject=BehaviorSubject<String>();
  final _btnSubject=BehaviorSubject<bool>();

  var phoneValidation=StreamTransformer<String,String>.fromHandlers(
      handleData: (phone,sink){
        sink.add(LoginValidation.validatePhone(phone));
      }
  );
  var codeValidation=StreamTransformer<String,String>.fromHandlers(
      handleData: (code,sink){
        sink.add(LoginValidation.validateCode(code));
      }
  );

  Stream<String> get phoneStream => _phoneSubject.stream.transform(phoneValidation).skip(1);//contains error notifications if phone field is not valid
  Sink<String> get phoneSink => _phoneSubject.sink;//contains input data using for check validation

  Stream<String> get codeStream => _codeSubject.stream.transform(codeValidation).skip(1);
  Sink<String> get codeSink => _codeSubject.sink;

  Stream<bool> get btnStream => _btnSubject.stream;
  Sink<bool> get btnSink => _btnSubject.sink;

  LoginBloc() {
    Rx.combineLatest2(_phoneSubject,_codeSubject,(phone,code){
      return LoginValidation.validatePhone(phone)=="" &&
          LoginValidation.validateCode(code)=="";
    }).listen((enable) {
      btnSink.add(enable);
    });

  }
  dispose()
  {
    _phoneSubject.close();
    _codeSubject.close();
    _btnSubject.close();
  }

}