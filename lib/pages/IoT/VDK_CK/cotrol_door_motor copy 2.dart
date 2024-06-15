import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'MyHttp_vdk.dart';

class ControlPanelWebsocket extends StatefulWidget {
  const ControlPanelWebsocket({super.key});

  @override
  _ControlPanelWebsocketState createState() => _ControlPanelWebsocketState();
}

class _ControlPanelWebsocketState extends State<ControlPanelWebsocket> {
  late WebSocketChannel channel1;

  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    channel1 = IOWebSocketChannel.connect('ws://192.168.154.96:8999/control');
  }

  @override
  void dispose() {
    channel1.sink.close();
    super.dispose();
  }

  void _sendMessage(String path) {
    String code = "Pbl50001";
    final command = jsonEncode({"type": "aaa", "data": "aaaaaa", "id": code});
    channel1.sink.add(command);
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
                  onPressed: () => _sendMessage('path1'),
                  child: Text('Send to Path 1'),
                ),
                ElevatedButton(
                  onPressed: () => _sendMessage('path2'),
                  child: Text('Send to Path 2'),
                ),
                ElevatedButton(
                  onPressed: () => _sendMessage('path3'),
                  child: Text('Send to Path 3'),
                ),
              ],
            ),
            StreamBuilder(
              stream: channel1.stream,
              builder: (context, snapshot) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24.0),
                  child:
                      Text(snapshot.hasData ? 'Path1: ${snapshot.data}' : ''),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
