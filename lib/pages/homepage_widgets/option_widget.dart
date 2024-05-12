import 'package:fire_warning_app/component/OptionButton.dart';
import 'package:fire_warning_app/pages/IoT/VideoPages/VideoFromServer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../IoT/ESP32/view_status_fire.dart';
import '../IoT/ESP8266/view_status_co.dart';

class OptionWidget extends StatelessWidget {
  const OptionWidget({super.key});

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
              "Dịch vụ hỗ trợ",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            )),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
          child: Container(
            decoration: const BoxDecoration(color: Color(0xffF5F6F8)),
            child: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  OptionButton(
                      title: 'Xem camera',
                      iconUrl: 'assets/icons/camera_2.png',
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MJPEGStream()));
                      }),
                  const SizedBox(height: 20),
                  OptionButton(
                      title: 'Lịch sử cảnh báo',
                      iconUrl: 'assets/icons/history.png',
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => FireStatusPage()));
                      }),
                  const SizedBox(height: 20),
                  OptionButton(
                      title: 'Gọi hỗ trợ',
                      iconUrl: 'assets/icons/call.png',
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MJPEGStream()));
                      }),
                  const SizedBox(height: 20),
                  OptionButton(
                      title: 'Theo dõi tình trạng không khí',
                      iconUrl: 'assets/icons/call.png',
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => StatusCO()));
                      }),
                ],
              ),
            ),
          ),
        ));
  }
}
