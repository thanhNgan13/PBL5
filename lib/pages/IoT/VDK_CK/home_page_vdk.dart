import 'package:fire_warning_app/pages/IoT/VDK_CK/BottomNavItem.dart';
import 'package:fire_warning_app/pages/IoT/VDK_CK/cotrol_door_motor.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'main_screen_vdk.dart';

class HomePageVDK extends StatelessWidget {
  const HomePageVDK({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: BodyWidget(),
    );
  }
}

class BodyWidget extends StatefulWidget {
  const BodyWidget({super.key});

  @override
  State<BodyWidget> createState() => _BodyWidgetState();
}

class _BodyWidgetState extends State<BodyWidget> {
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _tabs = [
    const MainScreen(),
    ControlPanelWebsocket(),
    const StatusWater()
  ];

  final List<BottomNavItem> bottomNavItems = [
    BottomNavItem(
        icon: const Icon(
          Icons.home_rounded,
        ),
        label: 'Trang chủ'),
    BottomNavItem(
        icon: const Icon(Icons.space_dashboard_rounded), label: 'Tùy chọn'),
    BottomNavItem(
        icon: const Icon(Icons.water_damage_rounded), label: 'Trạng thái')
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _tabs,
      ),
      bottomNavigationBar: BottomNavigationBar(
        fixedColor: const Color(0xffDC4A48),
        type: BottomNavigationBarType.fixed,
        unselectedFontSize: 15,
        selectedFontSize: 15,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          for (var i = 0; i < bottomNavItems.length; i++)
            BottomNavigationBarItem(
              icon: bottomNavItems.elementAt(i).icon,
              label: bottomNavItems.elementAt(i).label,
            )
        ],
      ),
    );
  }
}

class StatusWater extends StatefulWidget {
  const StatusWater({super.key});

  @override
  State<StatusWater> createState() => _StatusWaterState();
}

class _StatusWaterState extends State<StatusWater> {
  final DatabaseReference _database = FirebaseDatabase.instanceFor(
          app: Firebase.app(),
          databaseURL:
              "https://fire-warning-system-2d9c2-default-rtdb.asia-southeast1.firebasedatabase.app")
      .ref()
      .child('ESP8266_CK/Water_Level/');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trạng thái nước'),
      ),
      body: Column(
        children: <Widget>[
          const SizedBox(height: 20),
          _buildStatusCard(_database, 'DOOR1'),
          _buildStatusCard(_database, 'DOOR2'),
          _buildStatusCard(_database, 'DOOR3')
        ],
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
