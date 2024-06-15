import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class StatusCO extends StatefulWidget {
  const StatusCO({super.key});

  @override
  State<StatusCO> createState() => _StatusCOState();
}

class _StatusCOState extends State<StatusCO> {
  final DatabaseReference _database1 = FirebaseDatabase.instanceFor(
          app: Firebase.app(),
          databaseURL:
              "https://fire-warning-system-2d9c2-default-rtdb.asia-southeast1.firebasedatabase.app")
      .ref()
      .child('Sensor/Pbl50001/ESP8266_1/');
  final DatabaseReference _database2 = FirebaseDatabase.instanceFor(
          app: Firebase.app(),
          databaseURL:
              "https://fire-warning-system-2d9c2-default-rtdb.asia-southeast1.firebasedatabase.app")
      .ref()
      .child('Sensor/Pbl50001/ESP8266_2/');
  final DatabaseReference _database3 = FirebaseDatabase.instanceFor(
          app: Firebase.app(),
          databaseURL:
              "https://fire-warning-system-2d9c2-default-rtdb.asia-southeast1.firebasedatabase.app")
      .ref()
      .child('Sensor/Pbl50001/ESP8266_3/');
  final DatabaseReference _database4 = FirebaseDatabase.instanceFor(
          app: Firebase.app(),
          databaseURL:
              "https://fire-warning-system-2d9c2-default-rtdb.asia-southeast1.firebasedatabase.app")
      .ref()
      .child('Sensor/Pbl50001/ESP8266_4/');

  // Track previous status
  Map<String, bool> _previousStatus = {
    'ESP8266_1': false,
    'ESP8266_2': false,
    'ESP8266_3': false,
    'ESP8266_4': false,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trạng Thái Khí CO'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: GridView.count(
          crossAxisCount: 2,
          childAspectRatio: MediaQuery.of(context).size.width /
              (MediaQuery.of(context).size.height - kToolbarHeight - 16.0),
          children: [
            _buildStatusCard(_database1, 'ESP8266_1'),
            _buildStatusCard(_database2, 'ESP8266_2'),
            _buildStatusCard(_database3, 'ESP8266_3'),
            _buildStatusCard(_database4, 'ESP8266_4'),
          ],
        ),
      ),
    );
  }

  void _showAlertDialog(String sensor) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Alert"),
          content: Text("Smoke detected in $sensor!"),
          actions: [
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatusCard(DatabaseReference database, String label) {
    return StreamBuilder(
      stream: database.onValue,
      builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
        if (snapshot.hasData &&
            !snapshot.hasError &&
            snapshot.data!.snapshot.value != null) {
          Map data = snapshot.data!.snapshot.value as Map;
          String statusCO = data['Status'];
          String valCO = data['SMOKE'];

          if (statusCO == 'true' && !_previousStatus[label]!) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _showAlertDialog(label);
            });
            _previousStatus[label] = true;
          } else if (statusCO != 'true') {
            _previousStatus[label] = false;
          }

          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            margin: EdgeInsets.all(8.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '$label',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10),
                  Text('Status smoke: $statusCO',
                      style: TextStyle(fontSize: 18)),
                  SizedBox(height: 5),
                  Text('Smoke: $valCO ppm', style: TextStyle(fontSize: 18)),
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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    home: StatusCO(),
  ));
}
