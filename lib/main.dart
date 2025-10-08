import 'package:flutter/material.dart';
import 'package:individual_assignment_1/screens/calendar_screen.dart';
import 'package:individual_assignment_1/screens/settings_screen.dart';
import 'package:individual_assignment_1/screens/today_screen.dart';

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
      home: Scaffold(
        body: Center(child: _widgetOptions.elementAt(_selectedItem)),

        bottomNavigationBar: BottomNavigationBar(
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
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
