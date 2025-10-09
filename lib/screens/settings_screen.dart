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
  late String _storageMethod;

  @override
  void initState() {
    super.initState();
    _notificationsEnabled = _storageService.getNotificationsEnabled();
    _storageMethod = _storageService.getStorageMethod();
  }

  void _onNotificationsChanged(bool value) {
    _storageService.setNotificationsEnabled(value).then((_) {
      setState(() {
        _notificationsEnabled = Future.value(value);
      });
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
            // Notifications Settings
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
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
                        color: AppColors.primaryBackground,
                      ),
                    ),
                    const SizedBox(height: 16),
                    FutureBuilder<bool>(
                      future: _notificationsEnabled,
                      builder: (context, snapshot) {
                        final enabled = snapshot.data ?? true;
                        return Row(
                          children: [
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
                color: Colors.white,
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
                        color: AppColors.primaryBackground,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
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
                            color: AppColors.primaryBackground,
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
          ],
        ),
      ),
    );
  }
}
