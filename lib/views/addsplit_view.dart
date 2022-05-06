import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progressive_overload2/Screens/login_page.dart';
import 'package:progressive_overload2/views/workout_view.dart';
import 'package:progressive_overload2/models/user_model.dart';

import '../models/exercise_model.dart';



class AddSplitPage extends StatefulWidget {
  const AddSplitPage({Key? key}) : super(key: key);

  @override
  _AddSplitPageState createState() => _AddSplitPageState();
}


class _AddSplitPageState extends State<AddSplitPage> {

  TextEditingController splitController = TextEditingController();

  void clearText() {
    splitController.clear();
  }
  // void clearText() {
  //   exerciseNameController.clear();
  //
  // }
  var splitList = [];

/*  int splitCount = 0;*/

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: Text("Start your workout"), centerTitle: true,),
      body: Center(child: Padding(padding: EdgeInsets.all(20),
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

              ElevatedButton(
                  onPressed: () async {
                    if(splitController.text == ''){
                      Fluttertoast.showToast(msg: "Fill out all data!",
                          gravity: ToastGravity.BOTTOM);
                      return null;
                    } else {
                      // Put your code here, which you want to execute when Text Field is NOT Empty.
                      print('Not Empty, All Text Input is Filled.');
                    }
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => WorkoutPage()),
                    );

                    // ExerciseModel splitModel = ExerciseModel();
                    //
                    // splitModel.name = splitController.text;
                    // var list = [splitController.text];

                    //Creating the array here
                    var arrayRef = FirebaseFirestore.instance.collection("users")
                        .doc(user?.uid).collection("splits").doc().set(
                        {
                          "name" : splitController.text
                        }
                    );
                    clearText();
                  }, child: Text("Start"),
              ),


              //Show Splits
             /* ElevatedButton(
                  onPressed: (){
                    splitList = [];
                    FirebaseFirestore.instance.collection("users").doc(user!.uid).collection("splits").get()
                        .then((querySnapshot) {
                      print(querySnapshot);
                      querySnapshot.docs.forEach((element) {
                        //print(element);
                        print(element.data());
                        //print(element.data()['workout']);
                        splitList.add(element.data()['split']);
                      });
                      setState(() {
                        if(splitList.isEmpty){
                          Fluttertoast.showToast(msg: "No splits saved!");
                        }
                      });
                    }).catchError((error) {
                      print("Failed to load all the splits.");
                      print(error);
                    });
                  }, child: Text("List Splits")
              ),*/

              // ElevatedButton(
              //   child: const Text(
              //     'Splits',
              //   ),
              //   onPressed: () {
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(builder: (context) => WorkoutPage()),
              //     );
              //   },
              // ),

              Expanded(
                child: ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: splitList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        height: 50,
                        color: Colors.amber[500],
                        child: Center(child: Text('${splitList[index]}')),
                      );
                    }
                ),
              ),
              ActionChip(label: Text("Log out"), onPressed: () {
                logout(context);
              }
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

// var docRef = FirebaseFirestore.instance.collection("users").doc(user?.uid).collection("splits")
//     .doc();
// String count = docRef.id;
