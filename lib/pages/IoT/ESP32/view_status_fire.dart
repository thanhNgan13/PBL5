import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class FireStatusPage extends StatefulWidget {
  const FireStatusPage({super.key});

  @override
  State<FireStatusPage> createState() => _FireStatusPageState();
}

class _FireStatusPageState extends State<FireStatusPage> {
  final DatabaseReference _database = FirebaseDatabase.instanceFor(
          app: Firebase.app(),
          databaseURL:
              "https://fire-warning-system-2d9c2-default-rtdb.asia-southeast1.firebasedatabase.app")
      .ref()
      .child('Fire/');

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cảnh Báo Cháy'),
      ),
      body: StreamBuilder(
        stream: _database.onValue,
        builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
          if (snapshot.hasData &&
              !snapshot.hasError &&
              snapshot.data!.snapshot.value != null) {
            // Chuyển dữ liệu nhận được thành Map
            Map data = snapshot.data!.snapshot.value as Map;
            String status = data['Status'];

            // Hiển thị dữ liệu lên màn hình
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(height: 20),
                  Text('Fire status: $status',
                      style: const TextStyle(fontSize: 18)),
                  const SizedBox(height: 20),
                  if (status == 'true')
                    ElevatedButton(
                        onPressed: () async {
                          await _database.update({'Status': 'false'});
                        },
                        child: const Text('Tắt Báo Cháy',
                            style: TextStyle(fontSize: 18)))
                ],
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
