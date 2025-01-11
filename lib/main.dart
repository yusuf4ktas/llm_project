import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:llm_project/screens/authenticate/authenticate.dart';
import 'package:llm_project/screens/chat_screen.dart';
import 'package:llm_project/screens/home/settings_form.dart';
import 'package:llm_project/screens/landing_screen.dart';
import 'package:llm_project/screens/wrapper.dart';
import 'package:llm_project/services/notification_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:llm_project/services/auth.dart';
import 'package:llm_project/models/user.dart';
import 'dart:io';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final envPath = File('.env').absolute.path;
  print('Env path: $envPath');

  try {
    await dotenv.load(fileName: "assets/.env");
    print("Environment file loaded successfully.");
  } catch (e) {
    print("Failed to load .env file: $e");
  }

  if (await Permission.notification.isDenied) {
    await Permission.notification.request();
  }

  await NotificationService.init();
  NotificationService.scheduleNotification();

  /*NotificationService.showNotification(
    "Test Immediate Notification",
    "Immediate notification triggered successfully!",
  );*/

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (await Permission.scheduleExactAlarm.isDenied) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Enable exact alarms in settings for timely notifications."),
            action: SnackBarAction(
              label: 'Open Settings',
              onPressed: () {
                openAppSettings();
              },
            ),
          ),
        );
      }
    });

    return StreamProvider<MyUser?>.value(
      value: AuthService().user,
      initialData: null,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: LandingScreen(),
        routes: {
          '/chat': (context) => ChatScreen(),
          '/settings': (context) => SettingsForm(),
          '/authenticate': (context) => Authenticate(),
          '/wrapper' : (context) => Wrapper(),
        },
      ),
    );
  }
}
