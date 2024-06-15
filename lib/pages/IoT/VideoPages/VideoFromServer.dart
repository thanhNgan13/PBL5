import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';

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

  late InAppWebViewController webViewController;

  bool isLightOn = false;
  int pos = 90;
  int steps = 0;
  bool isLoading = false;

  WebSocket? socket;
  bool isSocketConnected = false;

  @override
  void initState() {
    super.initState();
    _connectToWebSocket(
        socketUrl: 'wss://hrl4vkc2-8999.asse.devtunnels.ms/control');
  }

  Future<void> _connectToWebSocket({required String socketUrl}) async {
    setState(() {
      isLoading = true;
    });

    try {
      final webSocket = await WebSocket.connect(socketUrl);
      if (kDebugMode) {
        print('Connected to WebSocket server');
      }
      setState(() {
        socket = webSocket;
        isSocketConnected = true;
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Connected to WebSocket server')),
      );
    } catch (e) {
      if (kDebugMode) {
        print('Failed to connect to WebSocket server: $e');
      }
      setState(() {
        isLoading = false;
        isSocketConnected = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to connect to WebSocket server')),
      );
    }
  }

  void _sendCommand(String type, Map<String, dynamic> data) {
    if (socket != null) {
      String code = "Pbl50001";
      final command = jsonEncode({"type": type, "data": data, "id": code});
      socket!.add(command);
      if (kDebugMode) {
        print('Sent message: $command');
      }
    } else {
      if (kDebugMode) {
        print('WebSocket is not connected.');
      }
    }
  }

  Future<void> _refresh() async {
    webViewController.reload();
    await _connectToWebSocket(
        socketUrl: 'wss://hrl4vkc2-8999.asse.devtunnels.ms/control');
  }

  @override
  void dispose() {
    socket?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stream ESP32-CAM'),
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Show a webview to display the video stream
            Expanded(
              child: Container(
                child: isLoading
                    ? Center(child: CircularProgressIndicator())
                    : InAppWebView(
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
                      ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _refresh();
                  },
                  child: const Text('Reload'),
                ),
              ],
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
                          _sendCommand("buzzer", {"action": "on"});
                        },
                        child: const Text('Turn On Buzzer'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          _sendCommand("buzzer", {"action": "off"});
                        },
                        child: const Text('Turn Off Buzzer'),
                      ),
                    ],
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
                                    _sendCommand("servo", {"position": pos});
                                  });
                                },
                          icon: const Icon(Icons.arrow_upward),
                          color: pos >= 180 ? Colors.grey : Colors.black,
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
                          onPressed: steps <= -4096
                              ? null
                              : () {
                                  setState(() {
                                    steps -= 256;
                                    _sendCommand("Stepper", {"step": -256});
                                  });
                                },
                          icon: const Icon(Icons.arrow_back),
                          color: steps <= -4096 ? Colors.grey : Colors.black,
                        ),
                        IconButton(
                          icon: Icon(
                            isLightOn
                                ? Icons.lightbulb
                                : Icons.lightbulb_outline,
                            color: isLightOn
                                ? const Color.fromARGB(255, 240, 217, 7)
                                : Colors.grey,
                          ),
                          iconSize: 50.0,
                          onPressed: () {
                            setState(() {
                              isLightOn = !isLightOn;
                              _sendCommand(
                                  "light", {"state": isLightOn ? "on" : "off"});
                            });
                          },
                        ),
                        IconButton(
                          onPressed: steps >= 4096
                              ? null
                              : () {
                                  setState(() {
                                    steps += 256;
                                    _sendCommand("Stepper", {"step": 256});
                                  });
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
                                    _sendCommand("servo", {"position": pos});
                                  });
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
            )
          ],
        ),
      ),
    );
  }
}
