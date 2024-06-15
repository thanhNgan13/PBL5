import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class MyHttpClient {
  final String baseUrlServo;
  final String baseUrlStepper;
  final String baseUrlLight;
  final String baseUrlTurnOffLight;
  final String baseUrlTurnOnBuzzer;
  final String baseUrlTurnOffBuzzer;

  MyHttpClient(
      {required this.baseUrlServo,
      required this.baseUrlStepper,
      required this.baseUrlLight,
      required this.baseUrlTurnOffLight,
      required this.baseUrlTurnOnBuzzer,
      required this.baseUrlTurnOffBuzzer});

  Future<void> connectServo(int pos) async {
    final url = '$baseUrlServo?pos=$pos';
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        // Nếu kết nối thành công, xử lý dữ liệu tại đây
        print('Success: ${response.body}');
      } else {
        // Nếu kết nối thất bại, xử lý lỗi tại đây
        print('Failed to connect. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Nếu có lỗi ngoại lệ, xử lý lỗi tại đây
      print('Error: $e');
    }
  }

  Future<void> connectStepper(int step) async {
    final url = '$baseUrlStepper?step=$step';
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        // Nếu kết nối thành công, xử lý dữ liệu tại đây
        print('Success: ${response.body}');
      } else {
        // Nếu kết nối thất bại, xử lý lỗi tại đây
        print('Failed to connect. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Nếu có lỗi ngoại lệ, xử lý lỗi tại đây
      print('Error: $e');
    }
  }

  Future<void> connectLight() async {
    try {
      final response = await http.get(Uri.parse(baseUrlLight));

      if (response.statusCode == 200) {
        // Nếu kết nối thành công, xử lý dữ liệu tại đây
        print('Success: ${response.body}');
      } else {
        // Nếu kết nối thất bại, xử lý lỗi tại đây
        print('Failed to connect. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Nếu có lỗi ngoại lệ, xử lý lỗi tại đây
      print('Error: $e');
    }
  }

  Future<void> turnOffLight() async {
    try {
      final response = await http.get(Uri.parse(baseUrlTurnOffLight));

      if (response.statusCode == 200) {
        // Nếu kết nối thành công, xử lý dữ liệu tại đây
        print('Success: ${response.body}');
      } else {
        // Nếu kết nối thất bại, xử lý lỗi tại đây
        print('Failed to connect. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Nếu có lỗi ngoại lệ, xử lý lỗi tại đây
      print('Error: $e');
    }
  }

  Future<void> turnOnBuzzer() async {
    try {
      final response = await http.get(Uri.parse(baseUrlTurnOnBuzzer));

      if (response.statusCode == 200) {
        // Nếu kết nối thành công, xử lý dữ liệu tại đây
        print('Success: ${response.body}');
      } else {
        // Nếu kết nối thất bại, xử lý lỗi tại đây
        print('Failed to connect. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Nếu có lỗi ngoại lệ, xử lý lỗi tại đây
      print('Error: $e');
    }
  }

  Future<void> turnOffBuzzer() async {
    try {
      final response = await http.get(Uri.parse(baseUrlTurnOffBuzzer));

      if (response.statusCode == 200) {
        // Nếu kết nối thành công, xử lý dữ liệu tại đây
        print('Success: ${response.body}');
      } else {
        // Nếu kết nối thất bại, xử lý lỗi tại đây
        print('Failed to connect. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Nếu có lỗi ngoại lệ, xử lý lỗi tại đây
      print('Error: $e');
    }
  }
}

class MJPEGStream extends StatefulWidget {
  MJPEGStream();

  @override
  _MJPEGStreamState createState() => _MJPEGStreamState();
}

class _MJPEGStreamState extends State<MJPEGStream> {
  late http.Response response;
  late http.Client client;
  late StreamController<Image> streamController;
  final String URL_STREAM = 'http://192.168.154.96:8999/client/videos/Pbl50001';

  final MyHttpClient httpClient = MyHttpClient(
    baseUrlServo: 'http://192.168.2.49:8999/client/servo/Pbl50001',
    baseUrlStepper: 'http://192.168.2.49:8989/stepper',
    baseUrlLight: 'http://192.168.154.96:8999/client/openLed/Pbl50001',
    baseUrlTurnOffLight: 'http://192.168.154.96:8999/client/closeLed/Pbl50001',
    baseUrlTurnOnBuzzer: 'http://192.168.2.49:8989/buzzer/turnOn',
    baseUrlTurnOffBuzzer: 'http://192.168.2.49:8989/buzzer/turnOff',
  );

  late InAppWebViewController webViewController;

  bool isLightOn = false;

  int pos = 90;
  int steps = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stream ESP32-CAM'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // show a webview to display the video stream
          Expanded(
            child: Container(
                child: InAppWebView(
              initialUrlRequest:
                  URLRequest(url: WebUri.uri(Uri.parse(URL_STREAM))),
              onWebViewCreated: (controller) {
                webViewController = controller;
              },
              onLoadStart: (controller, url) {
                print('Load Start: $url');
              },
              onLoadStop: (controller, url) {
                print('Load Stop: $url');
              },
              onProgressChanged: (controller, progress) {
                print('Progress: $progress');
              },
              onConsoleMessage: (controller, consoleMessage) {
                print('Console: ${consoleMessage.message}');
              },
              onLoadError: (controller, url, code, message) {
                print('Error: $message');
              },
            )),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        webViewController.reload(); // Thêm sự kiện reload
                      },
                      child: const Text('Reload'),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        httpClient.turnOnBuzzer();
                      },
                      child: const Text('Turn On Buzzer'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        httpClient.turnOffBuzzer();
                      },
                      child: const Text('Turn Off Buzzer'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 50),

          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: pos >= 180
                      ? null
                      : () {
                          setState(() {
                            pos += 10;
                            if (pos > 180) {
                              pos = 180;
                            }
                          });
                          httpClient.connectServo(pos);
                        },
                  icon: const Icon(Icons.arrow_upward),
                  color: pos >= 180 ? Colors.grey : Colors.black,
                ),
              ],
            ),
          ),
          // Control stepper motor
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: steps <= -4096
                      ? null
                      : () {
                          setState(() {
                            steps -= 256;
                          });
                          httpClient.connectStepper(-256);
                        },
                  icon: const Icon(Icons.arrow_back),
                  color: steps <= -4096 ? Colors.grey : Colors.black,
                ),
                IconButton(
                  icon: Icon(
                    isLightOn ? Icons.lightbulb : Icons.lightbulb_outline,
                    color: isLightOn
                        ? const Color.fromARGB(255, 240, 217, 7)
                        : Colors.grey,
                  ),
                  iconSize: 50.0,
                  onPressed: () {
                    setState(() {
                      isLightOn = !isLightOn;
                      if (isLightOn) {
                        httpClient.connectLight();
                      } else {
                        httpClient.turnOffLight();
                      }
                    });
                  },
                ),
                IconButton(
                  onPressed: steps >= 4096
                      ? null
                      : () {
                          setState(() {
                            steps += 256;
                          });
                          httpClient.connectStepper(256);
                        },
                  icon: const Icon(Icons.arrow_forward),
                  color: steps >= 4096 ? Colors.grey : Colors.black,
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: pos <= 0
                      ? null
                      : () {
                          setState(() {
                            pos -= 10;
                            if (pos < 0) {
                              pos = 0;
                            }
                          });
                          httpClient.connectServo(pos);
                        },
                  icon: const Icon(Icons.arrow_downward),
                  color: pos <= 0 ? Colors.grey : Colors.black,
                ),
              ],
            ),
          ),

          const SizedBox(height: 50),
        ],
      ),
    );
  }
}
