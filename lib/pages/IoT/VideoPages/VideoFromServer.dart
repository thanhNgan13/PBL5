import 'dart:async';
import 'dart:convert';
 
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
 
class MJPEGStream extends StatefulWidget {
  MJPEGStream();
 
  @override
  _MJPEGStreamState createState() => _MJPEGStreamState();
}
 
class _MJPEGStreamState extends State<MJPEGStream> {
  late http.Response response;
  late http.Client client;
  late StreamController<Image> streamController;
  final String URL_Server_Flask = '192.168.154.96';
  final String URL_STREAM = 'http://192.168.154.96:8999/client/videos';
 
  late InAppWebViewController webViewController;
 
  int pos = 90;
 
  void sendData(int steps) async {
    var response = await http.post(
      Uri.parse('http://192.168.154.96:5000/update_stepper'),
      headers: {"Content-Type": "application/json"},
      body: json.encode({"stepper": steps}),
    );
  }
 
  void sendDataServo(int pos) async {
    var response = await http.post(
      Uri.parse('http://192.168.154.96:5000/update_servo'),
      headers: {"Content-Type": "application/json"},
      body: json.encode({"servo": pos}),
    );
  }
 
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
 
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  // loadStream();
                },
                child: const Text('Load Stream'),
              ),
              ElevatedButton(
                onPressed: () {
                  // client.close();
                },
                child: const Text('Close Stream'),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                    onPressed: () {
                      setState(() {
                        pos -= 10;
                        if (pos < 0) {
                          pos = 0;
                        }
                        sendDataServo(pos);
                      });
                    },
                    icon: const Icon(Icons.arrow_upward_rounded)),
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
                    onPressed: () {
                      sendData(-100);
                    },
                    icon: const Icon(Icons.arrow_back)),
                const SizedBox(width: 10),
                IconButton(
                    onPressed: () {
                      sendData(100);
                    },
                    icon: const Icon(Icons.arrow_forward))
              ],
            ),
          ),
 
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                    onPressed: () {
                      setState(() {
                        pos += 10;
                        if (pos > 180) {
                          pos = 180;
                        }
                        sendDataServo(pos);
                      });
                    },
                    icon: const Icon(Icons.arrow_downward)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
 