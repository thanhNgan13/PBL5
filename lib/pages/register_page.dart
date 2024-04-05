import 'package:flutter/material.dart';
import 'package:fire_warning_app/blocs/register_bloc.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

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

class _BodyWidgetState extends State<BodyWidget> {
  final nameController=TextEditingController();
  final phoneController=TextEditingController();
  final codeController=TextEditingController();

  final registerBloc=RegisterBloc();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //listen textchange of TextFormField
    nameController.addListener(() {
      registerBloc.nameSink.add(nameController.text);
    });

    phoneController.addListener(() {
      registerBloc.phoneSink.add(phoneController.text);
    });

    codeController.addListener(() {
      registerBloc.codeSink.add(codeController.text);
    });
  }

  @override
  void dispose() {
    super.dispose();
    registerBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //tite
            Text('Đăng ký tài khoản', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black,)),
          //logo
            Container(width: 200, padding: const EdgeInsets.all(20.0), child: Image.asset('assets/icons/logo_red.png'),), //Container
          //form
            Container(padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(40, 0, 40, 20),
                    child: StreamBuilder<String>( //user StreamBuilder to set valid to errorText from bloc
                      stream: registerBloc.nameStream,
                      builder: (context, snapshot) {
                        return TextFormField(
                          controller: nameController,
                          style: TextStyle(fontSize: 18, color: Colors.black),
                          decoration: InputDecoration(labelText: "Họ và tên", labelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xff5C6268)),
                          errorText:snapshot.data ),
                        );
                      }
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(40, 0, 40, 20),
                    child: StreamBuilder<String>(
                      stream: registerBloc.phoneStream,
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
                          stream: registerBloc.codeStream,
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
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(icon: Image.asset("assets/icons/qr_code.png"),
                              onPressed:(){
                              },
                            ),
                            Text("Quét QR", style: TextStyle(fontSize: 13, color: Color(0xff3C3C3C), fontStyle: FontStyle.italic,fontWeight: FontWeight.bold),),
                          ],
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
                        stream: registerBloc.btnStream,
                        builder: (context, snapshot) {
                          Color backgroundColor = snapshot.data == true ? Color(0xffDC4A48) : Colors.grey;
                          return TextButton(
                            onPressed: snapshot.data==true?() {
                              print("click button");
                            }:null,
                            child: Text("Đăng ký",
                              style: TextStyle(fontSize: 24, color: Colors.white,),
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
                      child: Text("Đã có tài khoản?", style: TextStyle(fontSize: 14, color: Color(0xffDC4A48), fontStyle: FontStyle.italic,),),
                    ),
                  ],
                )
            ),
          ],
      ),
    );
  }
}
