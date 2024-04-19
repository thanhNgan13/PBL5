import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MJPEGStream extends StatefulWidget {
  MJPEGStream();

  @override
  _MJPEGStreamState createState() => _MJPEGStreamState();
}

class _MJPEGStreamState extends State<MJPEGStream> {
  late http.Response response;
  late http.Client client;
  late StreamController<Image> streamController;
  final String esp32camIP = '192.168.91.224';

  void _updateStepper(int steps) async {
    var url = Uri.http(esp32camIP, '/stepper', {'steps': steps.toString()});
    try {
      var response = await http.get(url);
      print('Server response: ${response.body}');
    } catch (e) {
      print("Failed to connect to ESP32-CAM: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    //streamController = StreamController<Image>();
    //loadStream();
  }

  // void loadStream() {
  //   client = http.Client();
  //   client.get(Uri.parse(url)).then((response) {
  //     streamController.add(Image.memory(response.bodyBytes));
  //   }).catchError((error) {
  //     print(error.toString());
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stream ESP32-CAM'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: StreamBuilder<Image>(
          //     stream: streamController.stream,
          //     builder: (context, snapshot) {
          //       if (snapshot.connectionState == ConnectionState.waiting) {
          //         return const Center(child: CircularProgressIndicator());
          //       }
          //       if (snapshot.hasError) {
          //         return Center(child: Text('Lỗi: ${snapshot.error}'));
          //       }
          //       return Center(child: snapshot.data ?? Container());
          //     },
          //   ),
          // ),

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
                    onPressed: () {},
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
                      _updateStepper(-100);
                    },
                    icon: const Icon(Icons.arrow_back)),
                const SizedBox(width: 10),
                IconButton(
                    onPressed: () {
                      _updateStepper(100);
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
                    onPressed: () {}, icon: const Icon(Icons.arrow_downward)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    client.close();
    streamController.close();
    super.dispose();
  }
}
