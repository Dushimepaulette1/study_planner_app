import 'package:flutter/material.dart';
import 'package:study_planner_app/screens/today_screen.dart';
import 'package:study_planner_app/screens/calendar_screen.dart';
import 'package:study_planner_app/screens/settings_screen.dart';
import 'package:study_planner_app/utils/colors.dart';

void main() {
  runApp(const StudyPlannerApp());
}

class StudyPlannerApp extends StatefulWidget {
  const StudyPlannerApp({super.key});

  @override
  State<StudyPlannerApp> createState() => _StudyPlannerAppState();
}

class _StudyPlannerAppState extends State<StudyPlannerApp> {
  int _selectedIndex = 0;
  final List<Widget> _screens = [
    const TodayScreen(),
    const CalendarScreen(),
    const SettingsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Study Planner',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: AppColors.primaryBackground,
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.appBarColor,
          foregroundColor: Colors.white,
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: AppColors.appBarColor,
          selectedItemColor: AppColors.accentColor,
          unselectedItemColor: Colors.white70,
        ),
        useMaterial3: true,
      ),
      home: Scaffold(
        body: _screens[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.today), label: 'Today'),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today),
              label: 'Calendar',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
