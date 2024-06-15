import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffDC4A48),
        automaticallyImplyLeading: false, //not showing button back
        title: const Text(
          "Quan sát thiết bị IoT",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicator: BoxDecoration(
              borderRadius: BorderRadius.circular(50), // Creates border
              color: Colors.greenAccent), //Change backgro
          tabs: [
            Tab(icon: Icon(Icons.flight)),
            Tab(icon: Icon(Icons.directions_transit)),
          ],
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                SensorsPage(),
                CamerasPage(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SensorsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.count(
        crossAxisCount: 2,
        childAspectRatio: 1,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        children: [
          SensorCard(title: 'Front Door', status: 'Closed', color: Colors.red),
          SensorCard(title: 'Back Door', status: 'Opened', color: Colors.blue),
          SensorCard(
              title: 'Emergency Stair', status: 'Closed', color: Colors.red),
          AddSensorCard(),
        ],
      ),
    );
  }
}

class SensorCard extends StatelessWidget {
  final String title;
  final String status;
  final Color color;

  SensorCard({required this.title, required this.status, required this.color});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: Colors.grey[900],
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.sensor_door, size: 50, color: color),
            SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(color: Colors.white, fontSize: 18),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 5),
            Text(
              status,
              style: TextStyle(color: color, fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class AddSensorCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: Colors.grey[800],
      child: Center(
        child: IconButton(
          icon: Icon(Icons.add, size: 50, color: Colors.white),
          onPressed: () {
            // Add Sensor Action
          },
        ),
      ),
    );
  }
}

class CamerasPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        CameraCard(
            title: '7 section',
            location: '1st floor',
            status: 'Closed',
            imageUrl:
                'https://example.com/image1.jpg'), // Replace with actual image URL
        CameraCard(
            title: '7 section',
            location: '2nd floor (courtyard)',
            status: 'Opened',
            imageUrl:
                'https://example.com/image2.jpg'), // Replace with actual image URL
      ],
    );
  }
}

class CameraCard extends StatelessWidget {
  final String title;
  final String location;
  final String status;
  final String imageUrl;

  CameraCard(
      {required this.title,
      required this.location,
      required this.status,
      required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
              image: DecorationImage(
                image: NetworkImage(imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Text(location, style: TextStyle(fontSize: 16)),
                SizedBox(height: 5),
                Text(status,
                    style: TextStyle(
                        color: status == 'Closed' ? Colors.red : Colors.green,
                        fontSize: 16)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: MyHomePage(),
  ));
}
