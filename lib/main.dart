import 'package:fire_warning_app/component/BottomNavItem.dart';
import 'package:fire_warning_app/helper/local_notification_service.dart';
import 'package:fire_warning_app/pages/home/ESP32/view_status_fire.dart';
import 'package:fire_warning_app/pages/home/VideoPages/hom_live_video_from_esp32cam%20copy.dart';
import 'package:fire_warning_app/pages/home/ESP8266/view_status_co.dart';
import 'package:fire_warning_app/pages/test/vidieukhien.dart';
import 'package:fire_warning_app/pages/warning_page.dart';
import 'package:fire_warning_app/pages/welcome_page.dart';
import 'package:fire_warning_app/presenters/alert_status_presenter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';


final GlobalKey<NavigatorState> globalNavigatorKey = GlobalKey<NavigatorState>();

@pragma('vm:entry-point')
Future<void> checkAlertStatus() async {
    print("***********************************************AndroidAlarmManager work checkAlertStatus fucntion");
 // CheckLoginHelper checkLoginHelper= CheckLoginHelper();
 // bool isLogin=await checkLoginHelper.checkUserLogin();
  //if(isLogin){
     print("***********************************************Check data function");
    // Your code here
    //check alert status from DB
      AlertStatusPresenter alertStatusPresenter = AlertStatusPresenter();
      bool isAlert= await alertStatusPresenter.getAlertStatus();
      if(isAlert){
        // create and show Notification Service
        NotificationService notificationService = NotificationService();
        await notificationService.initNotification();
        await notificationService.showNotification(id: 4, title: "Cảnh báo", body: "Hệ thống phát hiện có cháy");
        print("*******************************************Send noti ");
  //    }
  }
 
    
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Platform.isAndroid
      ? await Firebase.initializeApp(
          options: const FirebaseOptions(
              apiKey: 'AIzaSyCSiBTRnU7u3aQee9-b2MhzCS6_dlHJsfE',
              appId: '1:138271755735:android:bf37f0d5f22c300e2e8f92',
              messagingSenderId: '138271755735',
              projectId: 'fire-warning-system-2d9c2'))
      : await Firebase.initializeApp();

   //khởi tạo alarm manager
  await AndroidAlarmManager.initialize();

  
  await AndroidAlarmManager.periodic(
    const Duration(seconds: 10), 
    0, 
    checkAlertStatus,
    wakeup: true, // Đánh thức thiết bị nếu nó đang trong chế độ ngủ
    exact: true,
  );
  

  runApp(MaterialApp(
    navigatorKey: globalNavigatorKey,
    home: MyApp(),
  ));
  
}



class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  

  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home:const WelcomePage(),
    //    home:const WarningPage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _pages = [
    const FireStatusPage(),
    MJPEGStream(),
    const Home_v3(),
   const MyHome()
  ];

  final List<BottomNavItem> bottomNavItems = [
    BottomNavItem(
        icon: const Icon(
          Icons.newspaper_rounded,
        ),
        label: 'Warning'),
    BottomNavItem(icon: const Icon(Icons.person_outline), label: 'Control'),
    BottomNavItem(icon: const Icon(Icons.webhook_rounded), label: 'ESP8266'),
    BottomNavItem(icon: const Icon(Icons.home_rounded), label: 'My Home')
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: IndexedStack(
          index: _selectedIndex,
          children: _pages,
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.black,
          unselectedItemColor: Colors.grey,
          selectedItemColor: Colors.red,
          unselectedFontSize: 15,
          selectedFontSize: 15,
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: [
            for (var i = 0; i < bottomNavItems.length; i++)
              if (i == 0 && _selectedIndex != 0)
                const BottomNavigationBarItem(
                  icon: Icon(Icons.newspaper_rounded),
                  label: 'Home',
                )
              else
                BottomNavigationBarItem(
                  icon: bottomNavItems.elementAt(i).icon,
                  label: bottomNavItems.elementAt(i).label,
                )
          ],
        ));
  }
}
