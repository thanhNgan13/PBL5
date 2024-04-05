import 'dart:async';

import 'package:flutter/material.dart';

class ButtonAlertWidget extends StatelessWidget {
  const ButtonAlertWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: BodyWidget(),
    );
  }
}
class BodyWidget extends StatefulWidget {
  const BodyWidget({super.key});

  @override
  State<BodyWidget> createState() => _BodyWidgetState();
}

class _BodyWidgetState extends State<BodyWidget> {
  //String? command="Start";
  double _progressValue=0.0;
  late Timer mt;

  letStartCircularProgress(){
  //  command="Press to Start";
    const oneSec=const Duration(microseconds: 100000);
    mt= Timer.periodic(oneSec,(mt){
      setState(() {
      //  command="Holding...";
        _progressValue+=0.01;
        if(_progressValue.toStringAsFixed(1)=='1.1') {
          setState(() {
            _progressValue = 0.0;
        //    command = "Start";
            mt.cancel();
          });
        }
      });
    });
  }
  cancelTimer(){
    setState(() {
      _progressValue = 0.0;
   //   command = "Start";
      mt.cancel();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
          child: SizedBox(
            height: 240,
            child: GestureDetector(
              onLongPressStart: (_){letStartCircularProgress();},
              onLongPressEnd: (_){cancelTimer();},
              child:Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  Container(
                    height: 240,
                    width: 240,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(160),
                    ),
                    child: Center(
                      child: SizedBox(
                        height: 240,
                        width: 240,
                        child: CircularProgressIndicator(
                          strokeWidth: 10,
                          backgroundColor: Color(0xffF2E4E6),
                          valueColor: new AlwaysStoppedAnimation(Color(0xffD9002D)),
                          value: _progressValue,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 240,
                    width: 240,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(160),
                      image:  DecorationImage(
                        image: AssetImage('assets/icons/button_alert.png'), // Đường dẫn đến hình ảnh
                        fit: BoxFit.cover, // Cách sắp xếp hình ảnh trong container
                      ),
                    ),
                  ),
                  /*
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(command!,textAlign: TextAlign.center,style: TextStyle(fontSize: 20,color: Colors.black),),
                    ],
                  ),*/
                ],
              ),

            ),
          ),
      );
  }
}

