import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progressive_overload2/Screens/login_page.dart';
import 'package:progressive_overload2/home_widget.dart';
import 'package:progressive_overload2/models/user_model.dart';
import 'package:progressive_overload2/views/addsplit_view.dart';
import 'package:progressive_overload2/views/progress_view.dart';


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


  bool _isDisabled = false;
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
                            gravity: ToastGravity.BOTTOM);
                        return null;
                      } else {
                        // Put your code here, which you want to execute when Text Field is NOT Empty.
                        print('Not Empty, All Text Input is Filled.');
                      }
                      // ExerciseModel splitModel = ExerciseModel();
                      //
                      // splitModel.name = splitController.text;
                      // var list = [splitController.text];

                      //Creating the array here
                      var arrayRef = FirebaseFirestore.instance.collection("users")
                          .doc(user?.uid).collection("exercises").doc().set(
                          {
                            "exercise" : splitController.text,
                            "timestamp": FieldValue.serverTimestamp()
                          }
                      );
                      setState(() {
                        _isDisabled = true;
                      });
                      Fluttertoast.showToast(msg: "You can now enter your exercises!");
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
                //Initialize Array
                // ElevatedButton(onPressed: () async {
                //
                //   ExerciseModel splitModel = ExerciseModel();
                //
                //   splitModel.name = splitController.text;
                //   splitModel.exercise = exerciseController.text;
                //   splitModel.weight = weightController.text;
                //   splitModel.sets = setsController.text;
                //   splitModel.reps = repsController.text;
                //   var list = [splitController.text];
                //
                //   FirebaseFirestore.instance.collection("users").doc(user?.uid).collection("splits")
                //       .doc(user?.uid).set({"workout" : FieldValue.arrayUnion(list)});
                // }, child: Text("First"),
                // ),
                //Save workout
                ElevatedButton(
                  onPressed: () async {
                    if (exerciseController.text == '' ||
                        weightController.text == ''
                        || setsController.text == '' ||
                        repsController.text == '') {
                      // Put your code here which you want to execute when Text Field is Empty.
                      Fluttertoast.showToast(msg: "Enter exercise details!",
                          gravity: ToastGravity.BOTTOM);
                      return null;
                    } else {
                      // Put your code here, which you want to execute when Text Field is NOT Empty.
                      print('Not Empty, All Text Input is Filled.');
                    }

                    //Save Split
                    ExerciseModel splitModel = ExerciseModel();

                    splitModel.exercise = exerciseController.text;
                    splitModel.weight = weightController.text;
                    splitModel.sets = setsController.text;
                    splitModel.reps = repsController.text;

                    // FirebaseFirestore.instance
                    //     .collection("users")
                    //     .doc(user?.uid)
                    //     .collection("splits")
                    //     .doc()
                    //     .set(splitModel.toMap());

                    // FirebaseFirestore.instance.collection("users").doc(user!.uid).collection("splits").add(
                    //     {
                    //       "split" : splitController.text,
                    //     });


                    // var list = [splitModel.toMap()];

                    // FirebaseFirestore.instance.collection("users").doc(user?.uid).collection("splits")
                    // .doc(user?.uid).update({"workout" : FieldValue.arrayUnion(list)});

                    //Update Array
                    // FirebaseFirestore.instance.collection("users")
                    //     .doc(user?.uid).collection("splits").doc(user?.uid).
                    // update({"workout": FieldValue.arrayUnion(list)});

                    // workoutRef.update({"workout": FieldValue.arrayUnion([list]),
                    // });
                    // DocumentReference workoutRef = FirebaseFirestore.instance.collection("users")
                    // .doc(user?.uid).collection("splits").doc(user?.uid);

                    // workoutRef.set({"workout": FieldValue.arrayUnion(list)});

                   /* FirebaseFirestore.instance.collection("users").doc(user?.uid)
                   .collection("test").doc(user?.uid).set({"data" : FieldValue.arrayUnion(list)});*/

                    // FirebaseFirestore.instance.collection("users").doc(user!.uid).collection("splits").add(
                    //     {
                    //       "split" : splitController.text,
                    //     });
                    var list = ["\n" + exerciseController.text
                        + " - " + weightController.text
                        + " lbs (" + setsController.text
                        + " sets of " + repsController.text
                        + " reps)\n"];

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
                    //Print Splits
                    // splitList = [];
                    // FirebaseFirestore.instance.collection("users").doc(user!.uid).collection("splits").get()
                    //     .then((querySnapshot) {
                    //   print(querySnapshot);
                    //   querySnapshot.docs.forEach((element) {
                    //     //print(element);
                    //     print(element.data());
                    //     //print(element.data()['workout']);
                    //     splitList.add(element.data()['name']);
                    //   });
                    //   setState(() {
                    //     if(splitList.isEmpty){
                    //       Fluttertoast.showToast(msg: "No names saved!");
                    //     }
                    //   });
                    // }).catchError((error) {
                    //   print("Failed to load all the names.");
                    //   print(error);
                    // });
                    clearText();
                    Fluttertoast.showToast(msg: "Exercise Saved!",
                        gravity: ToastGravity.CENTER);
                    Fluttertoast.showToast(msg: "You may check progress if finished.",
                        gravity: ToastGravity.BOTTOM);
                  }, child: Text("Save")
                ),
                // ElevatedButton(onPressed: () {
                //   if (exerciseController.text != '' ||
                //       weightController.text != ''
                //       || setsController.text != '' ||
                //       repsController.text != '') {
                //     // Put your code here which you want to execute when Text Field is Empty.
                //     Fluttertoast.showToast(msg: "Save exercise before!",
                //         gravity: ToastGravity.BOTTOM);
                //     return null;
                //   } else {
                //     // Put your code here, which you want to execute when Text Field is NOT Empty.
                //     print('Not Empty, All Text Input is Filled.');
                //   }
                //   splitController.clear();
                //   Navigator.push(
                //     context,
                //     MaterialPageRoute(builder: (context) => HomeWidget()),
                //   );
                // },
                //
                //   child: Text("Done")
                // )

                // ElevatedButton(onPressed: () async {
                //   FirebaseFirestore.instance.collection("users")
                //       .doc(user?.uid).collection("saved").doc().setData()
                // },
                //   child: Text("Done"),
                // ),
                // Expanded(
                //   child: ListView.builder(
                //       padding: const EdgeInsets.all(8),
                //       itemCount: splitList.length,
                //       itemBuilder: (BuildContext context, int index) {
                //         return Container(
                //           height: 50,
                //           color: Colors.amber[500],
                //           child: Center(child: Text('${splitList[index]}')),
                //         );
                //       }
                //   ),
                // ),

              ],
      ),
          ),
      ),
    );
  }
}
