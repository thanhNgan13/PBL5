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
      appBar: AppBar(
          backgroundColor: Color(0xffDC4A48),
          automaticallyImplyLeading: false, //not showing button back
          title: const Text(
            "Trang chủ",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          )),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Có cháy?",
              style: TextStyle(
                  fontSize: 24,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 50,
            ),
            ButtonAlertWidget(),
            SizedBox(
              height: 30,
            ),
            Text(
              "Chạm và giữ 10 giây",
              style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              "để phát cảnh báo cho người thân",
              style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
            /*
              ElevatedButton(onPressed: (){},
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                  ),
                  child: Text("Hủy",style: TextStyle(color: Color(0xffD9002D),fontSize: 20,fontWeight: FontWeight.bold),)
              )*/
          ],
        ),
      ),
    );
  }
}
