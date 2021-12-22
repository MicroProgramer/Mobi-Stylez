import 'package:firebase_auth_practice/helpers/constants.dart';
import 'package:firebase_auth_practice/screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appName,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'MetroPolis',
        colorScheme:
            ColorScheme.fromSwatch().copyWith(primary: Colors.redAccent),
      ),
      home: SplashScreen(),
    );
  }
}
