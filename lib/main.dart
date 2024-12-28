import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:llm_project/screens/authenticate/authenticate.dart';
import 'package:llm_project/screens/chat_screen.dart';
import 'package:llm_project/screens/home/settings_form.dart';
import 'package:llm_project/screens/wrapper.dart';
import 'package:llm_project/services/auth.dart';
import 'package:provider/provider.dart';
import 'package:llm_project/models/user.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure binding is initialized
  await Firebase.initializeApp();
    FirebaseFirestore.instance.collection('test').add({'test': 'test'}).then((value) {
      print('Firebase connected: ${value.id}');
    }).catchError((error) {
      print('Firebase connection error: $error');
    });
    runApp(MyApp());
  }



class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<MyUser?>.value(
      value: AuthService().user, // Ensure this matches the user stream in auth.dart
      initialData: null,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Wrapper(),
        routes: {
          '/chat': (context) => ChatScreen(),
          '/settings': (context) => SettingsForm(),
          '/authenticate':(context) => Authenticate(),
        },
      ),
    );
  }
}