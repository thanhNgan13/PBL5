import 'package:fire_warning_app/pages/IoT/ESP8266/co_model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class Home_v3 extends StatefulWidget {
  const Home_v3({super.key});

  @override
  State<Home_v3> createState() => _Home_v3State();
}

class _Home_v3State extends State<Home_v3> {
  final DatabaseReference _database = FirebaseDatabase.instanceFor(
          app: Firebase.app(),
          databaseURL:
              "https://fire-warning-system-2d9c2-default-rtdb.asia-southeast1.firebasedatabase.app")
      .ref()
      .child('ESP8266_1/Outputs/');

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trạng Thái Khí CO'),
      ),
      body: StreamBuilder(
        stream: _database.onValue,
        builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
          if (snapshot.hasData &&
              !snapshot.hasError &&
              snapshot.data!.snapshot.value != null) {
            // Chuyển dữ liệu nhận được thành Map
            Map data = snapshot.data!.snapshot.value as Map;
            String statusCO = data['Status_CO'];
            String valCO = data['Val_CO'];

            // Hiển thị dữ liệu lên màn hình
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Trạng Thái Khí CO:',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  SizedBox(height: 20),
                  Text('Status CO: $statusCO', style: TextStyle(fontSize: 18)),
                  SizedBox(height: 10),
                  Text('Val CO: $valCO ppm', style: TextStyle(fontSize: 18)),
                ],
              ),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
