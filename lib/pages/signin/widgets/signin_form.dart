import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SignInForm extends StatelessWidget{
  const SignInForm({super.key});
  Widget build(BuildContext context){
    return Container(
     // color:Colors.deepOrangeAccent,
      padding: EdgeInsets.only(top:15.0,bottom:15.0),
      child:Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
              // Column 1
              Expanded( // Sử dụng Expanded để widget con chiếm đủ không gian có thể
                child: Container(
                 // color: Colors.red, 
                  padding: EdgeInsets.only(left: 20.0,top:15.0),
                  child: Column(
                   crossAxisAlignment: CrossAxisAlignment.start, 
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    
                    children: <Widget>[
                      title("Tên"),
                      SizedBox(height: 30),
                      title("Họ"),
                      SizedBox(height: 30),
                      title("Số điện thoại"),
                      SizedBox(height: 30),
                      title("Mã đăng ký"),
                    ],
                  ),
                ),
              ),

              // Column 2
              Expanded(
                child: Container(
                //  color: Colors.pink,
                  padding: EdgeInsets.only(right: 50.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      textField("Linda"),
                      SizedBox(height: 10),
                      textField("Nguyen"),
                      SizedBox(height: 10),
                      textField("09865123"),
                      SizedBox(height: 10),
                      Container(
                       // color: Colors.yellow,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                            child: Container(
                             // color: Colors.purple,
                              padding: EdgeInsets.only(right: 20.0),
                              child: 
                                textField("0dnarrvd")
                            ),
                            ),
                            Container(
                            //  color: Colors.green,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                      Image.asset("assets/icons/qr_code.png"),
                                      Text("Quét QR",style:TextStyle(
                                        fontSize: 10,
                                        color: Color(0xff3C3C3C),
                                        fontStyle: FontStyle.italic,
                                      )
                                      )
                                ],
                                ),
                            )
                          ],
                        )
                        
                      )
                    ],
                    ),
                ),
                )
            ],
      ),  
    );
  }

  Text title(String txt)
  {
    return Text(txt,style: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    ),
    );
  }
  TextField textField(String txt)
  {
    return TextField(
      decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 5), // Thiết lập độ rộng ở đây
          hintText: txt,
          hintStyle: TextStyle(color:Color(0xff5C6268)),
          border: OutlineInputBorder(),
    ),
    );
  }
}