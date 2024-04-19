import 'package:flutter/material.dart';

import 'login_page.dart';

class RegisterSuccessPage extends StatelessWidget {
  const RegisterSuccessPage({super.key});

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
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ImageIcon(AssetImage("assets/icons/success.png"),),
            SizedBox(height: 40,),
            Text("Xong",style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),),
            SizedBox(height: 20,),
            Text("Đăng ký tài khoản thành công"),
            TextButton(
              onPressed:() {Navigator.push(context,MaterialPageRoute(builder: (context) => LoginPage()),);
            },
            child: Text("Đăng nhập",style: TextStyle(fontSize: 24, color: Colors.white,),),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Color(0xffDC4A48)),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10),),),
            ),
            ),
          ],
        ),
    );
  }
}

