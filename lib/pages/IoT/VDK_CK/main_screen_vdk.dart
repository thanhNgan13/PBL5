import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'MyHttp_vdk.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final DatabaseReference _database = FirebaseDatabase.instanceFor(
          app: Firebase.app(),
          databaseURL:
              "https://fire-warning-system-2d9c2-default-rtdb.asia-southeast1.firebasedatabase.app")
      .ref()
      .child('ESP8266_CK/Water_Level/');
  final MyHttpClient httpClient = MyHttpClient(
    baseUrlStepper: "https://hrl4vkc2-5555.asse.devtunnels.ms/controlDoor/",
    baseUrlMotor: "https://hrl4vkc2-5555.asse.devtunnels.ms/",
  );

  List<bool> isEnabledList = [true, false];

  bool isReset = false;

  bool _valve1SwitchValue = false;
  bool _valve1Enable = true;
  bool _valve1Toggled = false;
  bool _door1Enable = false;
  bool _door1SwitchValue = false;
  bool _door1Toggled = false;

  bool _valve2SwitchValue = false;
  bool _valve2Enable = true;
  bool _valve2Toggled = false;
  bool _door2Enable = false;
  bool _door2SwitchValue = false;
  bool _door2Toggled = false;
  void handleSwitchChanged(int index) {
    isEnabledList[index] = false;
    if (index != 1) {
      isEnabledList[index + 1] = true;
    }
  }

  void resetAll() {
    if (isReset) {
      isReset = false;
      setState(() {
        isEnabledList = [true, false];

        _valve1SwitchValue = false;
        _valve1Enable = true;
        _valve1Toggled = false;
        _door1Enable = false;
        _door1SwitchValue = false;
        _door1Toggled = false;

        _valve2SwitchValue = false;
        _valve2Enable = true;
        _valve2Toggled = false;
        _door2Enable = false;
        _door2SwitchValue = false;
        _door2Toggled = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50.0),
        child: Column(
          children: [
            const SizedBox(height: 50),
            const Center(
                child: Text(
              'HỆ THỐNG ĐIỀU KHIỂN KÊNH ĐÀO PANAMA',
              style: TextStyle(
                  color: Colors.green,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            )),
            const SizedBox(height: 20),
            Column(
              children: [
                ///////////////////TẦNG 1///////////////
                const Text('Tầng 1',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Van: '),
                    Switch(
                      value: _valve1SwitchValue,
                      onChanged: (_valve1Enable && isEnabledList[0])
                          ? (value) {
                              setState(() {
                                _valve1SwitchValue = value;
                                if (value) {
                                  //bật switch
                                  _valve1Toggled = true;
                                  //////////////HÀM THỰC HIỆN KHI BẬT SWITCH VAN TẦNG 1/////////////////
                                  httpClient.turnOnMotor("ESP8266_DOOR1");
                                } else if (_valve1Toggled) {
                                  //tắt switch và trước đó đã bật
                                  _door1Enable =
                                      true; //có thể thay đổi switch van
                                  _valve1Enable =
                                      false; //không thể thay đổi switch van
                                  //////////////HÀM THỰC HIỆN KHI TẮT SWITCH VAN TẦNG 1/////////////////
                                  httpClient.turnOffMotor("ESP8266_DOOR1");
                                }
                              });
                            }
                          : null,
                      activeColor: Colors.green, // Màu khi switch bật
                      inactiveThumbColor:
                          Colors.black, // Màu của nút khi switch tắt
                      inactiveTrackColor: const Color.fromARGB(
                          255, 211, 205, 205), // Màu của track khi switch tắt
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Cửa: '),
                    Switch(
                      value: _door1SwitchValue,
                      onChanged: (_door1Enable && isEnabledList[0])
                          ? (value) {
                              setState(() {
                                _door1SwitchValue = value;
                                if (value) {
                                  //switch cửa bật
                                  _door1Toggled = true;
                                  //////////////HÀM THỰC HIỆN KHI BẬT SWITCH CỬA TẦNG 1/////////////////

                                  httpClient.connectStepper(
                                      "ESP8266_DOOR1", 9000);
                                } else if (_door1Toggled) {
                                  //switch cửa tắt và trước đó đã bật
                                  _door1Enable =
                                      false; //không thể thay đổi switch cửa
                                  handleSwitchChanged(0);
                                  //////////////HÀM THỰC HIỆN KHI TẮT SWITCH CỬA TẦNG 1/////////////////

                                  httpClient.connectStepper(
                                      "ESP8266_DOOR1", -9000);
                                }
                              });
                            }
                          : null,
                      activeColor: Colors.green, // Màu khi switch bật
                      inactiveThumbColor:
                          Colors.black, // Màu của nút khi switch tắt
                      inactiveTrackColor: const Color.fromARGB(
                          255, 211, 205, 205), // Màu của track khi switch tắt
                    ),
                  ],
                ),
                ///////////////////TẦNG 2///////////////
                const Text('Tầng 2',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Van: '),
                    Switch(
                      value: _valve2SwitchValue,
                      onChanged: (_valve2Enable && isEnabledList[1])
                          ? (value) {
                              setState(() {
                                _valve2SwitchValue = value;
                                if (value) {
                                  //bật switch
                                  _valve2Toggled = true;
                                  //////////////HÀM THỰC HIỆN KHI BẬT SWITCH VAN TẦNG 2/////////////////

                                  httpClient.turnOnMotor("ESP8266_DOOR2");
                                } else if (_valve2Toggled) {
                                  //tắt switch và trước đó đã bật
                                  _door2Enable =
                                      true; //có thể thay đổi switch van
                                  _valve2Enable =
                                      false; //không thể thay đổi switch van
                                  //////////////HÀM THỰC HIỆN KHI TẮT SWITCH VAN TẦNG 2////////////////

                                  httpClient.turnOffMotor("ESP8266_DOOR2");
                                }
                              });
                            }
                          : null,
                      activeColor: Colors.green, // Màu khi switch bật
                      inactiveThumbColor:
                          Colors.black, // Màu của nút khi switch tắt
                      inactiveTrackColor: const Color.fromARGB(
                          255, 211, 205, 205), // Màu của track khi switch tắt
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Cửa: '),
                    Switch(
                      value: _door2SwitchValue,
                      onChanged: (_door2Enable && isEnabledList[1])
                          ? (value) {
                              setState(() {
                                _door2SwitchValue = value;
                                if (value) {
                                  //switch cửa bật
                                  _door2Toggled = true;
                                  //////////////HÀM THỰC HIỆN KHI BẬT SWITCH CỬA TẦNG 2/////////////////
                                  ///
                                  httpClient.connectStepper(
                                      "ESP8266_DOOR2", 9000);
                                } else if (_door2Toggled) {
                                  //switch cửa tắt và trước đó đã bật
                                  _door2Enable =
                                      false; //không thể thay đổi switch cửa
                                  handleSwitchChanged(1);
                                  //////////////HÀM THỰC HIỆN KHI TẮT SWITCH CỬA TẦNG 2/////////////////
                                  ///
                                  httpClient.connectStepper(
                                      "ESP8266_DOOR2", -9000);
                                  isReset = true;
                                }
                              });
                            }
                          : null,
                      activeColor: Colors.green, // Màu khi switch bật
                      inactiveThumbColor:
                          Colors.black, // Màu của nút khi switch tắt
                      inactiveTrackColor: const Color.fromARGB(
                          255, 211, 205, 205), // Màu của track khi switch tắt
                    ),
                  ],
                ),

                Center(
                  child: ElevatedButton(
                    onPressed: isReset ? resetAll : null,
                    child: const Text(
                      'Đặt lại',
                      style: TextStyle(color: Colors.green),
                    ),
                    style: ElevatedButton.styleFrom(
                      side: const BorderSide(
                          color: Color.fromARGB(255, 38, 37, 36), width: 2),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(40), // Đường viền bo tròn
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 16), // Padding
                    ),
                  ),
                ),

                _buildStatusCard(_database, 'DOOR1'),
                _buildStatusCard(_database, 'DOOR2'),
                _buildStatusCard(_database, 'DOOR3')
              ],
            ),
          ],
        ),
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
