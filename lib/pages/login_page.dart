import 'package:fire_warning_app/pages/register_page.dart';
import 'package:fire_warning_app/pages/home_page.dart';
import 'package:flutter/material.dart';
import '../presenters/login_presenter.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BodyWidget(),
    );
  }
}
class BodyWidget extends StatefulWidget {
  const BodyWidget({super.key});

  @override
  State<BodyWidget> createState() => _BodyWidgetState();
}

class _BodyWidgetState extends State<BodyWidget> implements LoginInterface{
  late LoginPresenter loginPresenter;

  final phoneController=TextEditingController();
  final codeController=TextEditingController();



  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    loginPresenter=LoginPresenter(this);

    //listen textchange of TextFormField
    phoneController.addListener(() {
      loginPresenter.phoneSink.add(phoneController.text);
    });

    codeController.addListener(() {
      loginPresenter.codeSink.add(codeController.text);
    });
  }
  @override
  void dispose() {
    super.dispose();
    loginPresenter.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size; 
    return Container(
      width: screenSize.width, // Chiều rộng bằng với chiều rộng màn hình
      height: screenSize.height, 
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height:50),
            //tite
            Text('ĐĂNG NHẬP TÀI KHOẢN', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black,)),
            //logo
            Container(width: 200, padding: const EdgeInsets.all(20.0), child: Image.asset('assets/icons/logo_red.png'),), //Container
            //form
            Container(padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(40, 0, 40, 20),
                    child: StreamBuilder<String>(
                        stream: loginPresenter.phoneStream,
                        builder: (context, snapshot) {
                          return TextFormField(
                            controller: phoneController,
                            style: TextStyle(fontSize: 18, color: Colors.black),
                            decoration: InputDecoration(
                                labelText: "Số điện thoại",
                                labelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xff5C6268),),
                                errorText: snapshot.data
                            ),
                          );
                        }
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(40, 0, 40, 20),
                    child: Stack(
                      alignment: AlignmentDirectional.centerEnd,
                      children: [
                        StreamBuilder<String>(
                            stream: loginPresenter.codeStream,
                            builder: (context, snapshot) {
                              return TextFormField(
                                controller:codeController,
                                style: TextStyle(fontSize: 18, color: Colors.black),
                                decoration: InputDecoration(
                                  labelText: "Mã đăng ký",
                                  labelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xff5C6268)),
                                  errorText: snapshot.data,
                                ),
                              );
                            }
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(icon: Image.asset("assets/icons/qr_code.png"),
                                onPressed:(){
                                  
                                },
                              ),
                              Text("Quét QR", style: TextStyle(fontSize: 13, color: Color(0xff3C3C3C), fontStyle: FontStyle.italic,fontWeight: FontWeight.bold),),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        
            //button Register
            Container(
                child: Column(
                  children: [
                    SizedBox(
                      width: 200,
                      child: StreamBuilder<bool>(
                          stream: loginPresenter.btnStream,
                          builder: (context, snapshot) {
                            Color backgroundColor = snapshot.data == true ? Color(0xffDC4A48) : Colors.grey;
                            return TextButton(
                              onPressed: snapshot.data==true?() {
                                clickLogin(phoneController.text.toString(),codeController.text.toString());
                              }:null,
                              child: Text("Đăng nhập",style: TextStyle(fontSize: 24, color: Colors.white,),
                              ),
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all<Color>(backgroundColor),
                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10),),),
                              ),
                            );
                          }
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: GestureDetector
                        (
                        onTap: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => RegisterPage()),
                          );
                        },
                          child: Text("Chưa có tài khoản?", style: TextStyle(fontSize: 14, color: Color(0xffDC4A48), fontStyle: FontStyle.italic,),)
                      ),
                    ),
                  ],
                )
            ),
          ],
        ),
      ),
    );
  }

  @override
  void loginError(error) {
    // TODO: implement loginError
    if (error is String) {
      showDialog(context: context,
        builder: (BuildContext context) {
          return MyAlertDialog(content: error.toString());
        },
      );
    }
  }

  @override
  Future<void> loginSuccess() async {
    Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()),);
  }

  void clickLogin(String phone, String code) {
    loginPresenter.login(phone,code);
  }
}
