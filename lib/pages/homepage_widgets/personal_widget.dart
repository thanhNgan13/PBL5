import 'package:fire_warning_app/helper/log_out_helper.dart';
import 'package:fire_warning_app/helper/shared_preference_helper.dart';
import 'package:fire_warning_app/pages/qr_generate_page.dart';
import 'package:fire_warning_app/presenters/logout_presenter.dart';
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

  SharedPreferenceHelper sharedPreferenceHelper= SharedPreferenceHelper();
  String data="";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
   
  }

  LogOutPresenter logOutPresenter = LogOutPresenter();
  
  @override
  Widget build(BuildContext context) {
    Size screenSize=MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffDC4A48),
        automaticallyImplyLeading: false,//not showing button back
      title: Row(
        children: [
          ImageIcon(AssetImage("assets/icons/hello.png"),color: Colors.white),
          SizedBox(width: 20,),
          Column(
            children: [
              Text('Xin chào',style:TextStyle(fontSize: 15, color: Colors.white)),
            ],
          ),
        ]

      ),
      ),

      body:Padding(
        padding: const  EdgeInsets.fromLTRB(0, 20, 0, 0),
        child: Container(
          child: Column(
            children: [/*
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 20),
                child: Container(
                  width: screenSize.width,
                  decoration: BoxDecoration(
                    color: Color(0xffFF8581),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 10, 0, 10),
                    child: Row(
                      children: [
                        Image(image: AssetImage('assets/icons/edit.png'),),
                        SizedBox(width: 10,),
                        Text("Thay đổi thông tin cá nhân",style:TextStyle(fontSize: 20,color: Colors.white,fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ),*/
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 20),
                child: InkWell(
                  onTap: () async {
                    String userCode = await sharedPreferenceHelper.getUserCode();
                    Navigator.push(context,
                      MaterialPageRoute(builder: (context) => QRGeneratePage(userCode: userCode,)),
                    );
/*
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return FutureBuilder<String>(
                          future: sharedPreferenceHelper.getUserCode(), // Future cần được giải quyết
                          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                            if (snapshot.connectionState == ConnectionState.done) {
                              if (snapshot.hasError) {
                                // Xử lý lỗi từ Future
                                return AlertDialog(
                                  title: Text('Lỗi'),
                                  content: Text('Lỗi khi lấy mã người dùng'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('OK'),
                                    ),
                                  ],
                                );
                              } else if (snapshot.hasData) {
                                // Khi dữ liệu được lấy thành công
                                return MyAlertDialog(content: snapshot.data ?? ""); // Sử dụng snapshot.data
                              }
                            }
                            // Hiển thị chỉ báo tải cho đến khi Future được giải quyết
                            return AlertDialog(
                              title: Text('Đang tải...'),
                              content: CircularProgressIndicator(),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('OK'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    );
*/
                  },
                  child: Container(
                    width: screenSize.width,
                    decoration: BoxDecoration(
                      color: Color(0xffFF8581),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                       padding: const EdgeInsets.fromLTRB(10, 10, 0, 10),
                      child: Row(
                        children: [
                          Image(image: AssetImage('assets/icons/share.png'),),
                           SizedBox(width: 10,),
                          Text("Chia sẻ mã đăng ký",style:
                          TextStyle(fontSize: 20,color: Colors.white,fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Spacer(),
              TextButton(
                onPressed:(){
                  
                   logOutPresenter.logout();

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
              SizedBox(height: 20,),
            ],
          ),
          ),
        ),
    );
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
      title: Text('Mã đăng ký của bạn là:',style: TextStyle(fontSize: 20),),
      content: Text(content,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold)),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Đóng thông báo nổi
          },
          child: Text('OK'),
        ),
      ],
    );
  }
}
