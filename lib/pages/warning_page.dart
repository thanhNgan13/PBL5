import 'dart:async';

import 'package:fire_warning_app/pages/home_page.dart';
import 'package:fire_warning_app/presenters/alert_presenter.dart';
import 'package:flutter/material.dart';
import 'package:fire_warning_app/main.dart';
class WarningPage extends StatelessWidget {
  const WarningPage({super.key});
  static const route='/warning-screen';

  
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body:const BodyWidget(),
      );
  }
}
class BodyWidget extends StatefulWidget {
  const BodyWidget({super.key});



  @override
  State<BodyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<BodyWidget> {



   final AlertPresenter _alertPresenter=  AlertPresenter();

   double _progressValue=0.0;
  late Timer mt;

  letStartCircularProgress(){
  //  command="Press to Start";
    const oneSec=Duration(microseconds: 100000);
    mt= Timer.periodic(oneSec,(mt){
      setState(() {
      //  command="Holding...";
        _progressValue+=0.01;
        if(_progressValue.toStringAsFixed(1)=='1.01') {//finish 1 round
          //update isAlert in database
          _alertPresenter.updatePersonalAlertStatus();
          Navigator.push(context, MaterialPageRoute(builder: (context) => const HomePage()),);

          //set = 0
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
    return Center(
      child:Container(
         width: double.infinity, // Phủ kín chiều rộng màn hình
        height: double.infinity,
        decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xffD84441), 
            Color(0xff8F001E), 
          ],
        ),
      ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ImageIcon(AssetImage("assets/icons/bell.png"),size: 80,color: Colors.white,),
            SizedBox(height: 10,),
            Text("CẢNH BÁO",style:TextStyle(fontSize: 24, color: Colors.white,fontWeight: FontWeight.bold),),
            SizedBox(height: 20,),
            Text("Phát hiện có cháy tại khu vực gắn camera",style:TextStyle(fontSize: 14, color: Colors.white,fontWeight: FontWeight.bold),),
            SizedBox(height: 30,),
            
            //button
            Container(
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
                          strokeWidth: 5,
                          backgroundColor: Color(0xffF2E4E6),
                          valueColor: new AlwaysStoppedAnimation(Color.fromARGB(255, 13,181,97)),
                          value: _progressValue,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(160),
                      image:  DecorationImage(
                        image: AssetImage('assets/icons/insurance.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),

            ),
          ),
      ),

      SizedBox(height: 10,),

            Text("Chạm và giữ 10s để tắt cảnh báo",style: TextStyle(color: Colors.white,fontSize: 14,fontWeight: FontWeight.bold,),)
          ],
        ),
      ),
    );
  }
}
