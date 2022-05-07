import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:progressive_overload2/Screens/login_page.dart';
import 'package:progressive_overload2/Screens/register_page.dart';
import 'package:progressive_overload2/home_widget.dart';
import 'package:progressive_overload2/views/home_view.dart';
import 'package:progressive_overload2/views/workout_view.dart';


Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Email And Password Login',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: LoginScreenPage(), //Bottom Nav Logged in view is set to the default
    );
  }
}

