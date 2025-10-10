import 'package:flutter/material.dart';
import 'package:study_planner_app/services/storage_service.dart';
import 'package:study_planner_app/utils/colors.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final StorageService _storageService = StorageService();
  late Future<bool> _notificationsEnabled;
  late Future<bool> _isDarkMode;
  late String _storageMethod;

  @override
  void initState() {
    super.initState();
    _notificationsEnabled = _storageService.getNotificationsEnabled();
    _isDarkMode = _storageService.getThemeMode();
    _storageMethod = _storageService.getStorageMethod();
  }

  void _onNotificationsChanged(bool value) {
    _storageService.setNotificationsEnabled(value).then((_) {
      setState(() {
        _notificationsEnabled = Future.value(value);
      });
    });
  }

  void _onThemeChanged(bool value) {
    _storageService.setThemeMode(value).then((_) {
      setState(() {
        _isDarkMode = Future.value(value);
      });
      // Notify the main app to rebuild with new theme
      // This will be handled by the callback we'll add
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Theme Settings
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Appearance',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    FutureBuilder<bool>(
                      future: _isDarkMode,
                      builder: (context, snapshot) {
                        final isDarkMode = snapshot.data ?? false;
                        return Row(
                          children: [
                            const Icon(
                              Icons.dark_mode,
                              color: AppColors.accentColor,
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              'Dark Mode',
                              style: TextStyle(fontSize: 16),
                            ),
                            const Spacer(),
                            Switch(
                              value: isDarkMode,
                              onChanged: _onThemeChanged,
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Notifications Settings
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Notifications',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    FutureBuilder<bool>(
                      future: _notificationsEnabled,
                      builder: (context, snapshot) {
                        final enabled = snapshot.data ?? true;
                        return Row(
                          children: [
                            const Icon(
                              Icons.notifications,
                              color: AppColors.accentColor,
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              'Enable Reminders',
                              style: TextStyle(fontSize: 16),
                            ),
                            const Spacer(),
                            Switch(
                              value: enabled,
                              onChanged: _onNotificationsChanged,
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Storage Information
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Storage Information',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Icon(Icons.storage, color: AppColors.accentColor),
                        const SizedBox(width: 12),
                        const Text(
                          'Storage Method:',
                          style: TextStyle(fontSize: 16),
                        ),
                        const Spacer(),
                        Text(
                          _storageMethod,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.accentColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Tasks are stored locally on your device and will persist after closing the app.',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),

            // App Info
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'App Info',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Icon(Icons.info, color: AppColors.accentColor),
                        SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Study Planner v1.0',
                              style: TextStyle(fontSize: 16),
                            ),
                            Text(
                              'Flutter Assignment App',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
