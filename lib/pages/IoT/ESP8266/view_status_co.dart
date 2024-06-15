import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class StatusCO extends StatefulWidget {
  const StatusCO({super.key});

  @override
  State<StatusCO> createState() => _StatusCOState();
}

class _StatusCOState extends State<StatusCO> {
  final String databaseURL =
      "https://fire-warning-system-2d9c2-default-rtdb.asia-southeast1.firebasedatabase.app";
  final String familyID = "Pbl50001";

  late final List<DatabaseReference> _databases;
  late final Map<String, DatabaseReference> _databaseMap;
  final Map<String, bool> _previousStatus = {};

  @override
  void initState() {
    super.initState();
    _databases = List.generate(
      4,
      (index) => FirebaseDatabase.instanceFor(
        app: Firebase.app(),
        databaseURL: databaseURL,
      ).ref().child('Sensor/$familyID/ESP8266_${index + 1}/'),
    );

    _databaseMap = {
      'Cảm biến 1': _databases[0],
      'Cảm biến 2': _databases[1],
      'Cảm biến 3': _databases[2],
      'Cảm biến 4': _databases[3],
    };

    for (var label in _databaseMap.keys) {
      _previousStatus[label] = false;
    }
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
                    label,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffDC4A48),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: const Text(
          'Tình trạng không khí',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: GridView.count(
          crossAxisCount: 2,
          childAspectRatio: MediaQuery.of(context).size.width /
              (MediaQuery.of(context).size.height - kToolbarHeight - 16.0),
          children: _databaseMap.entries
              .map((entry) => _buildStatusCard(entry.value, entry.key))
              .toList(),
        ),
      ),
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
