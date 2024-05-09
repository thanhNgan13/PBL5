import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

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
            decoration: BoxDecoration(color: Color(0xffF5F6F8)),
            child: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10.0),
                          child: Image.asset('assets/icons/camera_2.png'),
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              const Text(
                                "Xem camera",
                                style: TextStyle(
                                    fontSize: 20, color: Colors.black),
                              ),
                              const Spacer(),
                              Container(
                                  child: IconButton(
                                      onPressed: () {},
                                      icon:
                                          Image.asset('assets/icons/next.png')))
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10.0),
                          child: Image.asset('assets/icons/history.png'),
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              Container(
                                width: 230,
                                child: Text(
                                  "Lịch sử cảnh báo",
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.black),
                                ),
                              ),
                              Container(
                                  child: IconButton(
                                      onPressed: () {},
                                      icon:
                                          Image.asset('assets/icons/next.png')))
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10.0),
                          child: Image.asset('assets/icons/call.png'),
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              Container(
                                width: 230,
                                child: Text(
                                  "Hỗ trợ khẩn cấp",
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.black),
                                ),
                              ),
                              Container(
                                  child: IconButton(
                                      onPressed: () {},
                                      icon:
                                          Image.asset('assets/icons/next.png')))
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
