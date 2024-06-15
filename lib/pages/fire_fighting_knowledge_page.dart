import 'package:flutter/material.dart';

class FireFightingKnowledgePage extends StatelessWidget {
  const FireFightingKnowledgePage({super.key});

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
  State<BodyWidget> createState() => _MyBodyWidgetState();
}

class _MyBodyWidgetState extends State<BodyWidget> {
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size; 

    return Scaffold(
      appBar: AppBar(
        title: Text("CÁC KIẾN THỨC CƠ BẢN",style: TextStyle(color: Colors.white,fontSize: 18),),
        backgroundColor: Color(0xffDC4A48),
      ),
      body: Container(
        width: screenSize.width, // Chiều rộng bằng với chiều rộng màn hình
        height: screenSize.height, 
        child:SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20,),
                Center(
                  child:Text('QUY TRÌNH XỬ LÝ KHI CÓ CHÁY',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Color(0xffDC4A48)),),
                ),
                SizedBox(height: 20,),
                Text('Bước 1: Báo động cho mọi người xung quanh biết bằng cách nhanh nhất: hô hoán, ấn chuông báo cháy, đánh kẻng,...',style: TextStyle(fontWeight: FontWeight.bold,)),
                SizedBox(height: 10,),
                Text('Bước 2: Lập tức ngắt điện toàn khu vực bị cháy',style: TextStyle(fontWeight: FontWeight.bold,)),
                SizedBox(height: 10,),
                Text('Bước 3: Nhanh chóng đưa ra các giải pháp để chữa cháy và chống cháy lan',style: TextStyle(fontWeight: FontWeight.bold,)),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                  child:Text('+ Nếu đám cháy nhỏ cần tìm cách chữa cháy bằng nước, bình chữa cháy, cát, chăn ướt'), ),
                SizedBox(height: 5,),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                  child:Text('+ Nếu cháy quá lớn không thể dập lửa phải nhanh chóng tìm cách thoát hiểm'), ),
                SizedBox(height: 10,),
                Text('Bước 4: Gọi điện báo cháy theo số 114',style: TextStyle(fontWeight: FontWeight.bold,)),
                SizedBox(height: 10,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset('assets/images/fire_knowledge.jpg'),
                ],),
            
                SizedBox(height: 30,),
                Center(
                  child:Text('KỸ NĂNG BẢO VỆ CƠ THỂ',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Color(0xffDC4A48)),),
                ),
                Center(
                  child:Text('KHI CÓ CHÁY',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Color(0xffDC4A48)),),
                ),
                SizedBox(height: 20,),
                Text('1. Tránh hít phải khói, khí độc bằng cách lấy khăn ướt bịt vào mũi, miệng và luôn giữ cơ thể ở vị trí thấp khi tìm đường thoát hiểm',style: TextStyle(fontStyle: FontStyle.italic,)),
                SizedBox(height: 20,),
                Text('2. Nếu quần áo của bạn bị cháy, hãy nằm xuống và lăn vòng quanh để giúp dập lửa',style: TextStyle(fontStyle: FontStyle.italic,)),
                SizedBox(height: 10,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset('assets/images/fire_knowledge_2.jpg'),
                ],),
                
              ],
            ),
          ),
        )
      ),
    );
  }
}
