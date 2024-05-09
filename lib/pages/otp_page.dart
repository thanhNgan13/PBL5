import 'package:fire_warning_app/model/Account.dart';
import 'package:fire_warning_app/pages/register_success_page.dart';
import 'package:fire_warning_app/presenters/register_presenter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

class OTPPage extends StatefulWidget {
 // const OTPPage({super.key});
  final String verify;
  final Account userAccount;

  OTPPage({Key? key,required this.verify,required this.userAccount}):super(key:key);

  @override
  State<OTPPage> createState() => _MyOTPWidgetState();
}

class _MyOTPWidgetState extends State<OTPPage>  implements RegisterInterface{
  final FirebaseAuth auth= FirebaseAuth.instance;

  var codeInput="";

   late RegisterPresenter registerPresenter;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    registerPresenter=RegisterPresenter(this);
  }

  @override
    void dispose() {
      // TODO: implement dispose
      super.dispose();
      registerPresenter.dispose();
    }


  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: TextStyle(
          fontSize: 20,
          color: Color(0xffFF8581),
          fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        border: Border.all(color: Color.fromRGBO(234, 239, 243, 1)),
        borderRadius: BorderRadius.circular(20),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: Color.fromRGBO(114, 178, 238, 1)),
      borderRadius: BorderRadius.circular(8),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: Color.fromRGBO(234, 239, 243, 1),
      ),
    );


    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.black,
          ),
        ),
        elevation: 0,
      ),
      body: Container(
        margin: EdgeInsets.only(left: 25, right: 25),
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 25,
              ),
              Text(
                "Xác thực số điện thoại",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Nhập mã OTP được gửi về số điện thoại đã đăng ký",
                style: TextStyle(fontSize: 16,),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 30,),
              Pinput(
                length: 6,
                // defaultPinTheme: defaultPinTheme,
                // focusedPinTheme: focusedPinTheme,
                // submittedPinTheme: submittedPinTheme,

                showCursor: true,

                onChanged: (value){
                    codeInput=value;
                }
              ),
              SizedBox(height: 20, ),
              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                       // primary: Color(0xffDC4A48),
                       backgroundColor: Color(0xffDC4A48),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    onPressed: () async{
                      try{
                        
                        PhoneAuthCredential credential=PhoneAuthProvider.credential(
                        verificationId: widget.verify, 
                        smsCode: codeInput);

                        await auth.signInWithCredential(credential);

                        //đăng ký tai khoan và chuyển màn hình 
                        registerPresenter.register(widget.userAccount);
                        
                      }
                      catch(e){
                        print("***************************Lỗi xác thực");
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Vui lòng kiểm tra lại mã xác thực")) );
                      }
                    },
                    child: Text("Xác thực",style: TextStyle(color: Colors.white),)),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  @override
  void registerError(error) {
    // TODO: implement registerError
    if (error is String) {
        showDialog(context: context,
            builder: (BuildContext context) {
              return MyAlertDialog(content: error.toString());
            },
        );
    }
  }
  
  @override
  void registerSuccess() {
    // TODO: implement registerSuccess
    Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterSuccessPage()),);

  }
}
class MyAlertDialog extends StatelessWidget {
  final String content;
  MyAlertDialog({
    required this.content,
  });
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Đăng ký tài khoản không thành công'),
      content: Text(content),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('OK'),
        ),
      ],
    );
  }
}
