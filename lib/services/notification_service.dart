import 'dart:math';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;

List<String> notificationMessages = [
  "Your next LLM chat is ready – dive in now!",
  "An LLM is waiting to assist you. Let's chat!",
  "Need insights? An LLM is ready to brainstorm with you!",
  "Explore new possibilities – an LLM is ready for you!",
  "Time for a quick AI-powered session. Let’s go!",
  "Boost your productivity – LLMs are ready to assist!",
  "Unlock fresh ideas – start your LLM conversation now!",
  "AI insights await – ready to jump in?",
  "Your AI companion is online – get started now!",
];

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
  FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    tz.initializeTimeZones();

    const AndroidInitializationSettings androidInitSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initSettings =
    InitializationSettings(android: androidInitSettings);

    final bool? initialized =
    await _notificationsPlugin.initialize(initSettings);

    if (initialized == true) {
      print("Notification plugin initialized successfully.");
    } else {
      print("Notification plugin failed to initialize.");
    }

    // Request exact alarm permission
    await _requestExactAlarmPermission();
  }

  // Request Exact Alarm Permission
  static Future<void> _requestExactAlarmPermission() async {
    if (await Permission.scheduleExactAlarm.isDenied) {
      final status = await Permission.scheduleExactAlarm.request();
      if (status.isGranted) {
        print("Exact alarm permission granted.");
      } else {
        print("Exact alarm permission denied. Opening settings...");
      }
    }
  }

  // Show Immediate Notification
  static Future<void> showNotification(String title, String body) async {
    const AndroidNotificationDetails androidDetails =
    AndroidNotificationDetails(
      'channel_id',
      'ModelVerse',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails notificationDetails =
    NotificationDetails(android: androidDetails);

    await _notificationsPlugin.show(
      0,
      title,
      body,
      notificationDetails,
    );
  }

  // Schedule Repeating Notifications
  static Future<void> scheduleNotification() async {
    for (int i = 1; i <= 5; i++) {
      final scheduledTime = _nextInstanceOfNotification(i * 3);
      final String randomMessage = _getRandomMessage();

      print("Scheduling notification for $scheduledTime: $randomMessage");

      try {
        await _notificationsPlugin.zonedSchedule(
          i,
          "ModelVerse",
          randomMessage,
          scheduledTime,
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'channel_id',
              'ModelVerse',
              importance: Importance.max,
            ),
          ),
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
        );
      } catch (e) {
        print("Failed to schedule exact alarm: $e");
      }
    }
  }

  // Get a random message from the list
  static String _getRandomMessage() {
    final random = Random();
    return notificationMessages[random.nextInt(notificationMessages.length)];
  }

  // Calculate the Next Notification Time
  static tz.TZDateTime _nextInstanceOfNotification(int minutes) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    return now.add(Duration(minutes: minutes));
  }
}
