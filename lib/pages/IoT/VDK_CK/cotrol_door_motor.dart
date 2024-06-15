import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';

class ControlPanelWebsocket extends StatefulWidget {
  const ControlPanelWebsocket({super.key});

  @override
  _ControlPanelWebsocketState createState() => _ControlPanelWebsocketState();
}

class _ControlPanelWebsocketState extends State<ControlPanelWebsocket> {
  final TextEditingController _controller = TextEditingController();
  WebSocket? socket;

  @override
  void initState() {
    super.initState();

    _connectToWebSocket(
        socketUrl: 'wss://hrl4vkc2-8999.asse.devtunnels.ms/control');
  }

  Future<void> _connectToWebSocket({required String socketUrl}) async {
    try {
      final webSocket = await WebSocket.connect(socketUrl);
      if (kDebugMode) {
        print('Connected to WebSocket server');
      }
      setState(() {
        socket = webSocket;
      });
    } catch (e) {
      if (kDebugMode) {
        print('Failed to connect to WebSocket server: $e');
      }
    }
  }

  void _sendMessage(String message) {
    if (socket != null) {
      String code = "Pbl50001";
      final command = jsonEncode({"type": "aaa", "data": message, "id": code});
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

  @override
  void dispose() {
    socket?.close();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter WebSocket Demo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _controller,
              decoration: InputDecoration(labelText: 'Send a message'),
            ),
            ButtonBar(
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    _sendMessage(_controller.text);
                  },
                  child: Text('Send Message'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
