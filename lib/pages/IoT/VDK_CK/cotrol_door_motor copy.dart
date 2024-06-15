import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'MyHttp_vdk.dart';

class ControlPanel extends StatefulWidget {
  const ControlPanel({super.key});

  @override
  _ControlPanelState createState() => _ControlPanelState();
}

class _ControlPanelState extends State<ControlPanel> {
  final MyHttpClient httpClient = MyHttpClient(
    baseUrlStepper: "https://hrl4vkc2-5555.asse.devtunnels.ms/controlDoor/",
    baseUrlMotor: "https://hrl4vkc2-5555.asse.devtunnels.ms/",
  );
  final DatabaseReference _database = FirebaseDatabase.instanceFor(
          app: Firebase.app(),
          databaseURL:
              "https://fire-warning-system-2d9c2-default-rtdb.asia-southeast1.firebasedatabase.app")
      .ref()
      .child('ESP8266_CK/Water_Level/');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bảng điều khiển'),
      ),
      body: Column(
        children: <Widget>[
          const Text(
            'Cửa 1',
            style: TextStyle(fontSize: 20),
          ),
          const SizedBox(height: 20),
          _buildControlRow('Mở cửa', 'Đóng cửa', 'Mở máy bơm', 'Tắt máy bơm',
              'ESP8266_DOOR1'),
          const SizedBox(height: 20),
          const Text(
            'Cửa 2',
            style: TextStyle(fontSize: 20),
          ),
          const SizedBox(height: 20),
          _buildControlRow('Mở cửa', 'Đóng cửa', 'Mở máy bơm', 'Tắt máy bơm',
              'ESP8266_DOOR2'),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildControlRow(String open, String close, String startPump,
      String stopPump, String doorId) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          ElevatedButton(
            onPressed: () {
              httpClient.connectStepper(doorId, 9000);
            },
            child: Text(open),
          ),
          ElevatedButton(
            onPressed: () {
              httpClient.connectStepper(doorId, -9000);
            },
            child: Text(close),
          ),
          ElevatedButton(
            onPressed: () {
              httpClient.turnOnMotor(doorId);
            },
            child: Text(startPump),
          ),
          ElevatedButton(
            onPressed: () {
              httpClient.turnOffMotor(doorId);
            },
            child: Text(stopPump),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard(DatabaseReference database, String nameDoor) {
    return StreamBuilder(
      stream: database.onValue,
      builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
        if (snapshot.hasData &&
            !snapshot.hasError &&
            snapshot.data!.snapshot.value != null) {
          Map data = snapshot.data!.snapshot.value as Map;
          String valWater = data[nameDoor];

          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            margin: const EdgeInsets.all(8.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    nameDoor,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 5),
                  Text('Val water: $valWater cm',
                      style: TextStyle(fontSize: 18)),
                ],
              ),
            ),
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

void main() => runApp(MaterialApp(home: ControlPanel()));
