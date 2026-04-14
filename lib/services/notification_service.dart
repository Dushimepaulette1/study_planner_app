import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final _plugin = FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  static const _channelId = 'study_reminders';
  static const _channelName = 'Study Reminders';
  static const _channelDesc = 'Reminders for upcoming study tasks';

  Future<void> initialize() async {
    if (_initialized) return;

    tz.initializeTimeZones();
    final tzInfo = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(tzInfo.identifier));

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    await _plugin.initialize(const InitializationSettings(android: android));

    final androidImpl = _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    await androidImpl?.requestNotificationsPermission();
    await androidImpl?.requestExactAlarmsPermission();

    _initialized = true;
  }

  Future<void> scheduleReminder({
    required String taskId,
    required String taskTitle,
    required DateTime reminderTime,
  }) async {
    if (reminderTime.isBefore(DateTime.now())) return;

    await _plugin.zonedSchedule(
      _idFrom(taskId),
      'Study Reminder',
      taskTitle,
      tz.TZDateTime.from(reminderTime, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          _channelName,
          channelDescription: _channelDesc,
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  Future<void> cancelReminder(String taskId) async {
    await _plugin.cancel(_idFrom(taskId));
  }

  // Converts the string millisecond timestamp to a valid 32-bit notification ID.
  int _idFrom(String taskId) => int.parse(taskId) % 2147483647;
}
