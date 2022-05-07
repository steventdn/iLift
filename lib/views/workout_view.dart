import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progressive_overload2/models/user_model.dart';
import 'package:intl/intl.dart';



import '../models/exercise_model.dart';

class WorkoutPage extends StatefulWidget {
  const WorkoutPage({Key? key}) : super(key: key);

  @override
  _WorkoutPageState createState() => _WorkoutPageState();
}


class _WorkoutPageState extends State<WorkoutPage> {

  TextEditingController exerciseController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController setsController = TextEditingController();
  TextEditingController repsController = TextEditingController();
  TextEditingController splitController = TextEditingController();

  late List<String> dayLog;


  void clearText() {
    exerciseController.clear();
    weightController.clear();
    setsController.clear();
    repsController.clear();

  }
  String time = '?';
  var workoutList = [];
  var splitList = [];
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

  bool _isReadonly = false;
  bool _isDisabled = false;
  int start = 0;
  var category;
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: Text("Get Started"), centerTitle: true,),
      body:
          SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(36.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,

              children: <Widget>[
                TextField(
                  controller: splitController,
                  readOnly: _isReadonly,
                  obscureText: false,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.face),
                    contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                    hintText: "What are you working out today?",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),

                //Save Split Name


              ElevatedButton(
                    onPressed: _isDisabled ? null : () async {
                      if(splitController.text == ''){
                        Fluttertoast.showToast(msg: "Fill out first field!",
                            gravity: ToastGravity.CENTER);
                        return null;
                      } else {
                        // Put your code here, which you want to execute when Text Field is NOT Empty.
                        print('Not Empty, All Text Input is Filled.');
                      }

                      start++;
                      final now = DateTime.now();
                      time = DateFormat('MM-dd-yyyy').format(now);
                      //Creating the array here
                      var arrayRef = FirebaseFirestore.instance.collection("users")
                          .doc(user?.uid).collection("exercises").doc().set(
                          {
                            "exercise" : splitController.text + " (" + time + ")",
                            "timestamp": FieldValue.serverTimestamp(),
                          }
                      );
                      setState(() {
                        _isDisabled = true;
                        _isReadonly = true;
                      });
                      Fluttertoast.showToast(msg: "You can now enter your exercises! (Minimum : 1)",
                      gravity: ToastGravity.CENTER);
                    }, child: Text("Start"),
                  ),



                SizedBox(
                  height: 65,
                  child: TextField(
                    controller: exerciseController,
                    obscureText: false,
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.fitness_center),
                        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                        hintText: "Exercise",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                    )
                  ),
                  ),
                ),
                SizedBox(
                  height: 65,
                  child: TextField(
                      controller: weightController,
                      obscureText: false,
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.numbers),
                          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                          hintText: "Weight Used",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                      )
                  ),
                  ),
                ),

                SizedBox(
                  height: 65,
                  child: TextField(
                      controller: setsController,
                      obscureText: false,
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.numbers),
                          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                          hintText: "Enter number of sets",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                      )
                  ),
                  ),
                ),
                SizedBox(
                  height: 65,
                  child: TextField(
                      controller: repsController,
                      obscureText: false,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.numbers),
                        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                        hintText: "Enter number of reps",
                        border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                  ),
                  ),
                ),

                //Save workout
                ElevatedButton(
                  onPressed: () async {
                    if(start == 0)
                      {
                        Fluttertoast.showToast(msg: "Press the start button first!",
                            gravity: ToastGravity.CENTER);
                        return null;
                      } else {
                      // Put your code here, which you want to execute when Text Field is NOT Empty.
                      print('Not Empty, All Text Input is Filled.');
                    }

                    if(splitController.text == '')
                      {
                        Fluttertoast.showToast(msg: "First field may not be empty!",
                            gravity: ToastGravity.CENTER);
                        return null;
                      } else {
                      // Put your code here, which you want to execute when Text Field is NOT Empty.
                      print('Not Empty, All Text Input is Filled.');
                    }
                    if (exerciseController.text == '' ||
                        weightController.text == ''
                        || setsController.text == '' ||
                        repsController.text == '') {
                      // Put your code here which you want to execute when Text Field is Empty.
                      Fluttertoast.showToast(msg: "Enter all exercise details!",
                          gravity: ToastGravity.CENTER);
                      return null;
                    } else {
                      // Put your code here, which you want to execute when Text Field is NOT Empty.
                      print('Not Empty, All Text Input is Filled.');
                    }

                    FirebaseFirestore.instance.collection("users").doc(user!.uid).collection("exercises").add(
                        {
                          "exercise" : exerciseController.text
                              + " - " + weightController.text
                              + " lbs (" + setsController.text
                              + " sets of " + repsController.text
                              + " reps)",
                          "timestamp": FieldValue.serverTimestamp()
                        }
                    );

                    clearText();
                    Fluttertoast.showToast(msg: "Exercise Saved!",
                        gravity: ToastGravity.CENTER);
                    Fluttertoast.showToast(msg: "You may check progress if finished.",
                        gravity: ToastGravity.BOTTOM);
                  }, child: Text("Save")
                ),

              ],
      ),
          ),
      ),
    );
  }
}
