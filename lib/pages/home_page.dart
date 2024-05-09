import 'package:fire_warning_app/component/BottomNavItem.dart';
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
