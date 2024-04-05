import 'package:fire_warning_app/pages/homepage_widgets/button_alert_widget.dart';
import 'package:flutter/material.dart';
class HomeWidget extends StatelessWidget {
  const HomeWidget({super.key});

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
    return Scaffold(
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /*
              //top bar
              Container(
                color: Colors.blue,
                height: 80,
                child: Stack(
                  alignment: AlignmentDirectional.bottomCenter,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            ImageIcon(AssetImage("assets/icons/hello.png"),),
                            Text("Xin chào,",style:TextStyle(fontSize: 13, color: Colors.black),)
                          ],
                        ),
                        Text("Linda",style:TextStyle(fontSize: 17, color: Colors.black, fontWeight: FontWeight.bold),)
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30,),

               */
              Text("Có cháy?",style:TextStyle(fontSize: 24, color: Colors.black,fontWeight: FontWeight.bold),),
              SizedBox(height: 50,),
              Text("Chạm và giữ 10 giây để gửi cảnh báo đến người thân",style:TextStyle(fontSize: 14, color: Colors.black,fontWeight: FontWeight.bold),),
              SizedBox(height: 10,),
              ButtonAlertWidget(),
              SizedBox(height: 30,),
              ElevatedButton(onPressed: (){},
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                  ),
                  child: Text("Hủy",style: TextStyle(color: Color(0xffD9002D),fontSize: 20,fontWeight: FontWeight.bold),)
              )

            ],
          ),
        ),
    );
  }
}

