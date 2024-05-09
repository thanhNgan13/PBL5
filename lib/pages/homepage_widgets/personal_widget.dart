import 'package:fire_warning_app/helper/log_out_helper.dart';
import 'package:flutter/material.dart';

import '../login_page.dart';
class PersonalWidget extends StatelessWidget {
  const PersonalWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BodyWidget(),
    ) ;
  }
}
class BodyWidget extends StatefulWidget {
  const BodyWidget({super.key});

  @override
  State<BodyWidget> createState() => _BodyWidgetState();
}

class _BodyWidgetState extends State<BodyWidget> {

  LogOutHelper logoutHelper = LogOutHelper();

  @override
  Widget build(BuildContext context) {
    Size screenSize=MediaQuery.sizeOf(context);
    return Scaffold(
      body:Padding(
        padding: const  EdgeInsets.fromLTRB(0, 50, 0, 0),
        child: Container(
          child: Column(
            children: [
              SizedBox(height:40),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 20),
                child: Container(
                  width: screenSize.width,
                  decoration: BoxDecoration(
                    color: Color(0xffDC4A48),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Image(image: AssetImage('assets/icons/edit.png'),),
                      Text("Thay đổi thông tin cá nhân",style:
                      TextStyle(fontSize: 20,color: Colors.white,fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 20),
                child: Container(
                  width: screenSize.width,
                  decoration: BoxDecoration(
                    color: Color(0xffDC4A48),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Image(image: AssetImage('assets/icons/share.png'),),
                      Text("Chia sẻ mã đăng ký",style:
                      TextStyle(fontSize: 20,color: Colors.white,fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              TextButton(
                onPressed:(){
                  logoutHelper.disposeAccountData();
                  Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()),);
                },
                child: Text("Đăng xuất",
                  style: TextStyle(fontSize: 24, color: Colors.white,),
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Color(0xffDC4A48)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10),),),
                ),
              ),
            ],
          ),
          ),
        ),
    );
  }
  
}
