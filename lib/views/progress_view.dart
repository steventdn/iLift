import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progressive_overload2/Screens/login_page.dart';
import 'package:progressive_overload2/views/logged_in_view.dart';
import 'package:progressive_overload2/views/workout_view.dart';
import 'package:progressive_overload2/models/user_model.dart';


class ProgressPage extends StatefulWidget {
  const ProgressPage({Key? key}) : super(key: key);

  @override
  _ProgressPageState createState() => _ProgressPageState();
}


class _ProgressPageState extends State<ProgressPage> {

  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value){
      this.loggedInUser = UserModel.fromMap(value.data());
      setState(() {
      });
    });
  }

  int currentIndex = 0;
  final screens = [
    LoggedInView(),
    WorkoutPage(),
    ProgressPage(),
  ];

  var workoutList = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: Text("Progress"), centerTitle: true,),
      body: Center(child: Padding(padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                  onPressed: () async {
                    workoutList = [];
                    FirebaseFirestore.instance.collection("users").doc(user!.uid).collection("exercises").orderBy("timestamp", descending: false).get()
                        .then((querySnapshot) {
                      print(querySnapshot);
                      querySnapshot.docs.forEach((element) {
                        //print(element);
                        print(element.data());
                        //print(element.data()['workout']);
                        workoutList.add(element.data()['exercise']);
                      });
                      setState(() {
                        if(workoutList.isEmpty){
                          Fluttertoast.showToast(msg: "No exercises saved!");
                        }
                      });
                    }).catchError((error) {
                      print("Failed to load all the workouts.");
                      print(error);
                    });
                    // clearText();
                  }, child: Text("View Progress")
              ),
              Expanded(
                child: ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: workoutList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        height: 50,
                        color: Colors.black26,
                        child: Center(child: Text('${workoutList[index]}'),
                        ),
                      );
                    }
                ),
              ),





            ],
          )
      ),
      ),
    );
  }


  Future<void> logout(BuildContext context) async
  {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginScreenPage()));
  }

}
