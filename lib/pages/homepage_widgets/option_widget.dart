import 'package:fire_warning_app/component/OptionButton.dart';
import 'package:fire_warning_app/pages/IoT/VideoPages/VideoFromServer.dart';
import 'package:fire_warning_app/pages/fire_fighting_knowledge.dart';
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
        body: Container(
           decoration: const BoxDecoration(color: Color.fromARGB(255, 255, 255, 255)),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
            child: Container(
             
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
                        title: 'Theo dõi tình trạng không khí',
                        iconUrl: 'assets/icons/air_flow.png',
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => StatusCO()));
                        }),
                    const SizedBox(height: 20),
                        OptionButton(
                        title: 'Kiến thức xử lý khi có cháy',
                        iconUrl: 'assets/icons/firefighting.png',
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => FireFightingKnowledgePage()));
                        }),
                    const SizedBox(height: 20),
                    
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
