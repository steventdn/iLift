import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:progressive_overload2/Screens/login_page.dart';
import 'package:progressive_overload2/models/user_model.dart';


class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
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
      appBar: AppBar(automaticallyImplyLeading : false, title: Text("iLift"), centerTitle: true,),
      body: Center(child: Padding(padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[

            //Home Logo
            CircleAvatar(
              radius: 120,
              backgroundColor: Colors.black26,
              child: Image.asset("assets/redloho.png", fit: BoxFit.contain),
              ),

            SizedBox(height:10),
            Text("Welcome", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            //User Information
            Text("${loggedInUser.firstName} ${loggedInUser.secondName}",
              style: TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.w500
              ),
            ),
            Text("${loggedInUser.email}",
              style: TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 15,),
            //Log Out button
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

  //Log out function
  Future<void> logout(BuildContext context) async
  {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginScreenPage()));
  }
}
