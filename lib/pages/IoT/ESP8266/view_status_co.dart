import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class StatusCO extends StatefulWidget {
  const StatusCO({super.key});

  @override
  State<StatusCO> createState() => _StatusCOState();
}

class _StatusCOState extends State<StatusCO> {
  final DatabaseReference _database = FirebaseDatabase.instanceFor(
          app: Firebase.app(),
          databaseURL: "https://your-database-url.firebasedatabase.app")
      .ref();

  DatabaseReference getDeviceRef(String deviceId) {
    return _database.child('$deviceId/Outputs/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trạng Thái Khí CO'),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        children: List.generate(4, (index) {
          String deviceId = 'ESP8266_${index + 1}';
          return _buildCOStatus(deviceId);
        }),
      ),
    );
  }

  Widget _buildCOStatus(String deviceId) {
    return StreamBuilder(
      stream: getDeviceRef(deviceId).onValue,
      builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
        if (snapshot.hasData &&
            !snapshot.hasError &&
            snapshot.data!.snapshot.value != null) {
          Map data = snapshot.data!.snapshot.value as Map;
          String statusCO = data['Status_CO'];
          String valCO = data['Val_CO'];
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Thiết bị $deviceId',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Text('Status CO: $statusCO', style: TextStyle(fontSize: 14)),
                  SizedBox(height: 5),
                  Text('Val CO: $valCO ppm', style: TextStyle(fontSize: 14)),
                ],
              ),
            ),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
