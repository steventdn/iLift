import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progressive_overload2/views/addsplit_view.dart';
import 'package:progressive_overload2/Screens/login_page.dart';
import 'package:progressive_overload2/views/progress_view.dart';
import 'package:progressive_overload2/views/workout_view.dart';
import 'package:progressive_overload2/models/user_model.dart';

class HomeViewPage extends StatefulWidget {
  const HomeViewPage({Key? key}) : super(key: key);

  @override
  _HomeViewPageState createState() => _HomeViewPageState();
}


class _HomeViewPageState extends State<HomeViewPage> {

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: Text("Home"), centerTitle: true,),
      body: Center(child: Padding(padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[

              //Start Workout
              ElevatedButton(
                child: const Text(
                  'Splits',
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => WorkoutPage()),
                  );
                },
              ),

              //Add a new Split
              ElevatedButton(
                child: const Text(
                  '+ New Split',
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddSplitPage()),
                  );
                },
              ),

              //Go to Progress Page
              ElevatedButton(
                child: const Text(
                  'View Progress',
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProgressPage()),
                  );
                },
              ),

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
