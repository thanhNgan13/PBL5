import 'package:fire_warning_app/pages/homepage_widgets/home_widget.dart';
import 'package:fire_warning_app/pages/homepage_widgets/notification_widget.dart';
import 'package:fire_warning_app/pages/homepage_widgets/option_widget.dart';
import 'package:fire_warning_app/pages/homepage_widgets/personal_widget.dart';
import 'package:flutter/material.dart';
import 'homepage_widgets/contact_widget.dart';

class HomePage extends StatelessWidget {
   const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
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

  int _currentIndex=0;
  final tabs=[
    HomeWidget(),
    ContactWidget(),
    OptionWidget(),
    NotificationWidget(),
    PersonalWidget(),
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        fixedColor: Color(0xffDC4A48),
        type: BottomNavigationBarType.fixed,
          iconSize: 30,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Trang chủ',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_box),
              label: 'Danh bạ',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.space_dashboard),
              label: 'Tùy chọn',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications),
              label: 'Thông báo',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Cá nhân',
            ),
          ],
          currentIndex: _currentIndex,
          onTap:(index){
            setState((){
              _currentIndex=index;
            });
          }
      ),
    );
  }
}
