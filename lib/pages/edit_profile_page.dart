import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key, required this.userName, required this.userPhone}):super(key: key);

  @override
  State<EditProfilePage> createState() => _MyWidgetState();
  final String userName;
  final String userPhone;
}

class _MyWidgetState extends State<EditProfilePage> {
  late TextEditingController _nameController= TextEditingController();
  late TextEditingController _phoneController= TextEditingController();

  bool _isNameEdited=false;
  bool _isPhoneEdited=false;




  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          toolbarHeight: 90,
          leading: Container(),
          flexibleSpace: Padding(
              padding: EdgeInsets.only(left: 5, top: 20),
              child: Container(
                  decoration: BoxDecoration(
                      color: Color.fromARGB(255, 29, 29, 29),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15))),
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                  padding: EdgeInsets.only(left: 15),
                                  child: GestureDetector(
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text("Hủy",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w400)))),
                              Text(
                                "Thông tin cá nhân",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700),
                              ),
                              Padding(
                                padding: EdgeInsets.only(right: 15),
                                child: GestureDetector(
                                    onTap: (_isNameEdited||_isPhoneEdited)
                                      ? _clickEditButton
                                      :null,
                                    child: Text("Xong",
                                        style: TextStyle(
                                          color:(_isNameEdited||_isPhoneEdited)
                                            ?Color(0xffDC4A48)
                                            :Colors.grey,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w400))),
                              )
                            ],
                      )
                    ]
                  ),
                )
              ),
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: Padding(
            padding: EdgeInsets.only(top: 100),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    height: 300,
                    width: 330,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 25, 25, 25),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.grey, width: 0.5,),
                    ),
                    child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 200,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: 10,
                                        ),
                                        Text(
                                          "Họ và tên",
                                          style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600,fontSize: 18),
                                        ),
                                        CupertinoTextField(
                                          controller: _nameController,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18),
                                          placeholder:widget.userName,
                                          placeholderStyle: TextStyle(
                                              color: Colors.grey, fontSize: 18),
                                          padding: EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                        ),
                                        Container(
                                          height: 5,
                                        ),
                                        Container(
                                          width: 300,
                                          height: 0.5,
                                          color: Colors.grey,
                                        ),
                                        Container(
                                          height: 20,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: 30,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ))),
                    ],
            )));
  }
  Future<void> _clickEditButton() async {
    if (_nameController.text.length > 30) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(40), topRight: Radius.circular(40))),
        backgroundColor: Colors.white,
        content: Container(
            alignment: Alignment.center,
            height: 30,
            child: Text(
              'Max Len: 30 char',
              style: TextStyle(
                  fontFamily: "icons.ttf",
                  color: Colors.black,
                  fontSize: 25,
                  fontWeight: FontWeight.w900),
            )),
      ));
      return;
    }
    
  }
}