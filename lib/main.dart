import 'package:flutter/material.dart';
import 'package:study_planner_app/screens/today_screen.dart';
import 'package:study_planner_app/screens/calendar_screen.dart';
import 'package:study_planner_app/screens/settings_screen.dart';
import 'package:study_planner_app/screens/new_task_screen.dart';
import 'package:study_planner_app/utils/colors.dart';
import 'package:study_planner_app/services/storage_service.dart';

// Global theme notifier that can be accessed throughout the app
class ThemeNotifier extends ChangeNotifier {
  bool _isDarkMode = true; // Default to dark mode
  final StorageService _storageService = StorageService();

  ThemeNotifier() {
    _loadThemePreference();
  }

  bool get isDarkMode => _isDarkMode;

  void _loadThemePreference() async {
    final isDarkMode = await _storageService.getThemeMode();
    _isDarkMode = isDarkMode;
    notifyListeners();
  }

  void toggleTheme(bool isDarkMode) {
    _isDarkMode = isDarkMode;
    _storageService.setThemeMode(isDarkMode);
    notifyListeners();
  }
}

final themeNotifier = ThemeNotifier();

void main() {
  runApp(const StudyPlannerApp());
}

class StudyPlannerApp extends StatefulWidget {
  const StudyPlannerApp({super.key});

  @override
  State<StudyPlannerApp> createState() => _StudyPlannerAppState();
}

class _StudyPlannerAppState extends State<StudyPlannerApp> {
  @override
  void initState() {
    super.initState();
    // Listen to theme changes
    themeNotifier.addListener(_onThemeChanged);
  }

  void _onThemeChanged() {
    setState(() {}); // Rebuild the app when theme changes
  }

  @override
  void dispose() {
    themeNotifier.removeListener(_onThemeChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Study Planner',
      theme: _buildLightTheme(),
      darkTheme: _buildDarkTheme(),
      themeMode: themeNotifier.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: const MainNavigationScreen(),
    );
  }

  ThemeData _buildLightTheme() {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: AppColors.lightPrimary,
      scaffoldBackgroundColor: AppColors.lightBackground,
      cardColor: AppColors.lightSurface,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.lightPrimary,
        foregroundColor: Colors.white,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.lightSurface,
        selectedItemColor: AppColors.accentColor,
        unselectedItemColor: Colors.grey,
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: AppColors.lightText),
        bodyMedium: TextStyle(color: AppColors.lightText),
      ),
      useMaterial3: true,
    );
  }

  ThemeData _buildDarkTheme() {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: AppColors.darkPrimary,
      scaffoldBackgroundColor: AppColors.darkBackground,
      cardColor: AppColors.darkSurface,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.darkSurface,
        foregroundColor: AppColors.darkText,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.darkSurface,
        selectedItemColor: AppColors.accentColor,
        unselectedItemColor: Colors.grey,
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: AppColors.darkText),
        bodyMedium: TextStyle(color: AppColors.darkText),
        titleLarge: TextStyle(color: AppColors.darkText),
      ),
      useMaterial3: true,
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;
  bool _showNewTaskScreen = false;

  late List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _initializeScreens();
  }

  void _initializeScreens() {
    _screens = [
      const TodayScreen(),
      const CalendarScreen(),
      const SettingsScreen(),
    ];
  }

  void _refreshScreens() {
    setState(() {
      _initializeScreens();
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _showNewTaskScreen = false;
    });
  }

  void _showAddTask() {
    setState(() {
      _showNewTaskScreen = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _showNewTaskScreen
          ? NewTaskScreen(
              onTaskSaved: () {
                setState(() {
                  _showNewTaskScreen = false;
                });
                _refreshScreens();
              },
            )
          : _screens[_selectedIndex],
      floatingActionButton: !_showNewTaskScreen
          ? FloatingActionButton(
              onPressed: _showAddTask,
              backgroundColor: AppColors.accentColor,
              child: const Icon(Icons.add, color: Colors.black),
            )
          : null,
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
    );
  }
}
