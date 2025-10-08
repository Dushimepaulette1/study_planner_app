import 'package:flutter/material.dart';
import 'package:individual_assignment_1/screens/calendar_screen.dart';
import 'package:individual_assignment_1/screens/settings_screen.dart';
import 'package:individual_assignment_1/screens/today_screen.dart';

class CustomColors {
  static const Color primaryBackground = Color(0xFF011339); // Your dark blue
  static const Color appBarColor = Color(0xFF011339); // Same color for app bar
}

void main() {
  runApp(const StudyPlanner());
}

class StudyPlanner extends StatefulWidget {
  const StudyPlanner({super.key});

  @override
  State<StudyPlanner> createState() => _StudyPlannerState();
}

class _StudyPlannerState extends State<StudyPlanner> {
  int _selectedItem = 0;
  static const List<Widget> _widgetOptions = <Widget>[
    TodayScreen(),
    CalendarScreen(),
    SettingsScreen(),
  ];
  void _onItemTapped(int index) {
    setState(() {
      _selectedItem = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Study Planner',
      theme: ThemeData(
        scaffoldBackgroundColor: CustomColors.primaryBackground,
        appBarTheme: AppBarTheme(backgroundColor: CustomColors.appBarColor),
        textTheme: TextTheme(bodyLarge: TextStyle(color: Colors.white)),
      ),
      home: Scaffold(
        body: Center(child: _widgetOptions.elementAt(_selectedItem)),

        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: CustomColors.primaryBackground,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Today"),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today),
              label: "Calendar",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.notification_important),
              label: "Notifications",
            ),
          ],
          currentIndex: _selectedItem,
          selectedItemColor: Colors.amber,
          unselectedItemColor: Colors.grey,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
