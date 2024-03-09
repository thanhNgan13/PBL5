import 'package:flutter/material.dart';

class BtnSignIn extends StatelessWidget{
  const BtnSignIn({super.key});
  Widget build(BuildContext context){
    Size screenSize=MediaQuery.sizeOf(context);
    return Container(
      padding: EdgeInsets.only(top:20,bottom: 20,left: screenSize.width/4.4,right: screenSize.width/4.4),
      child: Column(
        children: [
          Container(     
          alignment: Alignment.center,
          constraints: BoxConstraints(
              minWidth: 0,
              minHeight: 0,
              maxWidth: double.infinity,
              maxHeight: double.infinity,
          ),
          decoration: BoxDecoration(
            color: Color(0xffD84441),
            borderRadius:  BorderRadius.circular(10),
          ),
          child: 
            Text("Đăng ký",style: TextStyle(
              fontSize: 24,
              color: Colors.white,
              ),
            ),
          ),

          SizedBox(height: 10),

          Text("Đã có tài khoản?",style: TextStyle(
              fontSize: 14,
              color: Color(0xffDC4A48),
              fontStyle: FontStyle.italic,
            ),
          )
        ],
    )
    );
  }
}