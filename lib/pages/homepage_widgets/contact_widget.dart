import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../model/Contact.dart';
class ContactWidget extends StatelessWidget {
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
  List<Contact> listContact=[];
  @override
  void initState() {
    super.initState();
    addData();
  }
  void addData()
  {
    Contact contact0=Contact("Chữa cháy","114");
    Contact contact1=Contact("Bố","0321456321");
    Contact contact2=Contact("Mẹ","0363604563");
    listContact.add(contact0);
    listContact.add(contact1);
    listContact.add(contact2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
            children: [
              SizedBox(height: 30,),
              Text("Liên hệ khẩn cấp",style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold,color: Colors.black),),
              Row(
                children: [
                  IconButton(onPressed: (){
                  },
                      icon: Image.asset("assets/icons/add.png"),
                  ),
                  Text("Thêm liên hệ mới",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Color(0xffDC4A48)),)
                ],
              ),
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
        leading: CircleAvatar(
          child: Text(listContact[index].name[0]),
          backgroundColor: Color(0xffD9002D),
          foregroundColor: Colors.white,
        ),
        title: Container(
          child: GestureDetector(
            onTap: (){
              print("Ontap");
              String phoneNumber="";
              phoneNumber=listContact[index].phone.toString();
              launch('tel:$phoneNumber');
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(listContact[index].name),
                Text(listContact[index].phone),
              ],
            ),
          ),
        ),
        trailing: IconButton(
          icon: Icon(Icons.more_vert),
          onPressed:(){
          },
        ),
      ),
    );
  }
}


