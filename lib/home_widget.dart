import 'package:flutter/material.dart';
import 'package:progressive_overload2/views/addsplit_view.dart';
import 'package:progressive_overload2/views/logged_in_view.dart';
import 'package:progressive_overload2/views/progress_view.dart';
import 'package:progressive_overload2/views/workout_view.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({Key? key}) : super(key: key);

  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  @override

  int currentIndex = 0;
  final screens = [
    LoggedInView(),
    WorkoutPage(),
    ProgressPage(),
  ];


  @override
  Widget build(BuildContext context) => Scaffold(
    body: screens[currentIndex],
    bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.red,
        unselectedItemColor: Colors.white,
        selectedItemColor: Colors.white,
        currentIndex: currentIndex,
        selectedFontSize: 20,
        unselectedFontSize: 15,
        onTap: (index) => setState(() => currentIndex = index),
        items: [
          BottomNavigationBarItem(
            icon: new Icon(Icons.home),
            label: ("Home"),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.fitness_center),
            label: ("Workout"),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.timelapse),
            label: ("Progress"),
          ),
        ]
    ),
  );
}






