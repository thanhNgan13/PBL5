import 'package:fire_warning_app/presenters/contact_presenter.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../model/Contact.dart';
class ContactWidget extends StatelessWidget {
  //final Account accountData;
  const ContactWidget({super.key});

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
  State<BodyWidget> createState() => _BodyWidgetState();
}

class _BodyWidgetState extends State<BodyWidget> {
  ContactPresenter contactPresenter=ContactPresenter();
  List<Contact> listContact=[];
  bool isLoading = true; // Biến theo dõi tiến trình tải dữ liệu
  
  Future<void> addData()
  async {

    Contact contact0=Contact("Chữa cháy","114");
    listContact.add(contact0);

    List<Contact> listContactFromDB= await contactPresenter.getListContacts();
    if(listContactFromDB.isNotEmpty){
       setState(() {
      listContact.addAll(listContactFromDB);
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
      :Container(
        child: Column(
            children: [
              SizedBox(height: 30,),
              Text("Danh sách thành viên",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Color(0xffDC4A48)),),
              /*
              Row(
                children: [
                  IconButton(onPressed: (){
                  },
                      icon: Image.asset("assets/icons/add.png"),
                  ),
                  Text("Thêm liên hệ mới",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Color(0xffDC4A48)),)
                ],
              ),
              */
              Expanded(
                child: ListView.builder(
                  itemCount:listContact.length,
                  itemBuilder: (context,index)=>getRow(index),
                ),
              )
            ]
        ),
      )

    );
  }
  Widget getRow(int index){
    return Card(
      child: ListTile(
        onTap: (){
          String phoneNumber="";
          phoneNumber=listContact[index].phone.toString();
          launch('tel:$phoneNumber');
        },
        leading: CircleAvatar(
          child: Text(listContact[index].name[0]),
          backgroundColor: Color(0xffD9002D),
          foregroundColor: Colors.white,
        ),
        title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(listContact[index].name),
                Text(listContact[index].phone),
              ],
            ),
      ),
    );
  }
}


