import 'package:fire_warning_app/model/MyNotification.dart';
import 'package:fire_warning_app/presenters/notification_presenter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class NotificationWidget extends StatelessWidget {
  const NotificationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BodyWidget(),
    ) ;
  }
}
class BodyWidget extends StatefulWidget {
  const BodyWidget({super.key});

  @override
  State<BodyWidget> createState() => _MyBodyWidgetState();
}

class _MyBodyWidgetState extends State<BodyWidget> {
  NotificationPresenter notificationPresenter=NotificationPresenter();
  List<MyNotification> listNoti=[];
  bool isLoading = true; // Biến theo dõi tiến trình tải dữ liệu
  bool notHavingData = false; // Biến theo dõi du lieu tu DB

  Future<void> addData() async {
    List<MyNotification> listNotiFromDB=await notificationPresenter.getListNotifications();
     if(listNotiFromDB.isEmpty){
      setState(() {
      isLoading = false; // tiến trình tải hoàn thành
      notHavingData = true;
    });
    }
    else{
       setState(() {
        listNoti.addAll(listNotiFromDB);
        isLoading = false; //tiến trình tải hoàn thành
      });
      
    }
  }

  @override
  void initState() {
    super.initState();
    addData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
      ? Center (child: CircularProgressIndicator())
      : ( Scaffold(
          body: notHavingData
          ? Center(child: Text("Không có lịch sử cảnh báo",style:TextStyle(color: Colors.grey)))
          : Container(
            child: Column(
              children: [
                SizedBox(height: 30,),
                Text("Lịch sử cảnh báo",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Color(0xffDC4A48)),),
                Expanded(
                      child: ListView.builder(
                        itemCount:listNoti.length,
                        itemBuilder: (context,index)=>getRow(index),
                      ),
                    )
              ],
              ),
          ),
        )
      )
    );
  }

   Widget getRow(int index){
    return Card(
      child: Container(
       color: (Color(0xffFF8581)),
        child: ListTile(
          leading: ImageIcon(AssetImage('assets/icons/bell.png'), size: 40,color: Colors.white,),
          title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(listNoti[index].alertBy + " đã gửi cảnh báo cháy", style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: Colors.white),),
                Text(listNoti[index].alertAt.toString(),style: TextStyle(fontSize: 15,color: Colors.white),),
              ],
            ),
      ),
      ),
      
    );
  }
}