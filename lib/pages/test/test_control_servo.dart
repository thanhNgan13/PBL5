import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ControlServo extends StatefulWidget {
  const ControlServo({super.key});

  @override
  State<ControlServo> createState() => _ControlServoState();
}

class _ControlServoState extends State<ControlServo> {
  double _servo1Pos = 90;
  double _servo2Pos = 90;

  final String esp8266Ip =
      '192.168.1.6'; // Thay đổi IP tương ứng với ESP8266 của bạn

  void _updateServo(int servoNum, double position) async {
    var url = Uri.http(esp8266Ip, '/servo',
        {'num': servoNum.toString(), 'pos': position.round().toString()});
    try {
      var response = await http.get(url);
      print('Server response: ${response.body}');
    } catch (e) {
      print("Failed to connect to ESP8266: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Control Servo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: Scaffold(
          appBar: AppBar(
            title: const Text('Control Servo'),
          ),
          body: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            Text('Servo 1: ${_servo1Pos.round()}'),
            Slider(
              min: 0,
              max: 180,
              value: _servo1Pos,
              onChanged: (value) {
                setState(() {
                  _servo1Pos = value;
                });
                _updateServo(1, value);
              },
            ),
            const SizedBox(height: 30),
            Text('Servo 2: ${_servo2Pos.round()}'),
            Slider(
              min: 0,
              max: 180,
              value: _servo2Pos,
              onChanged: (value) {
                setState(() {
                  _servo2Pos = value;
                });
                _updateServo(2, value);
              },
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _servo1Pos = 90;
                  _servo2Pos = 90;
                });
                _updateServo(1, 90);
                _updateServo(2, 90);
              },
              child: const Text('Reset'),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // tạo 2 button quay sang trái và phải
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _servo1Pos = 0;
                    });
                    _updateServo(1, _servo1Pos);
                  },
                  child: const Text('Up'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _servo1Pos = 180;
                    });
                    _updateServo(1, _servo1Pos);
                  },
                  child: const Text('Down'),
                ),
              ],
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // tạo 2 button quay sang trái và phải
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _servo2Pos = 71;
                    });
                    _updateServo(2, _servo2Pos);
                  },
                  child: const Text('Left'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _servo2Pos = 95;
                    });
                    _updateServo(2, _servo2Pos);
                  },
                  child: const Text('Right'),
                ),
              ],
            ),
          ]),
        ));
  }
}
