  import 'package:firebase_auth/firebase_auth.dart';
  import 'package:flutter/material.dart';
  import 'package:fluttertoast/fluttertoast.dart';
import 'package:progressive_overload2/home_widget.dart';
  import 'package:progressive_overload2/views/logged_in_view.dart';
  import 'package:progressive_overload2/Screens/register_page.dart';
  import 'package:progressive_overload2/views/workout_view.dart';


  class LoginScreenPage extends StatefulWidget {
    const LoginScreenPage({Key? key}) : super(key: key);

    @override
    _LoginScreenPageState createState() => _LoginScreenPageState();
  }

  class _LoginScreenPageState extends State<LoginScreenPage> {
    //form key
    final _formKey = GlobalKey<FormState>();

    //editing controller
    final TextEditingController emailController = new TextEditingController();
    final TextEditingController passwordController = new TextEditingController();

    //firebase
    final _auth = FirebaseAuth.instance;

    @override
    Widget build(BuildContext context) {
      //email field
      final emailField = TextFormField(
        autofocus: false,
        controller: emailController,
        keyboardType: TextInputType.emailAddress,
        validator: (value) {
          if (value!.isEmpty) {
            return ("Please Enter Your Email");
          }
          //reg expression for email validation
          if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(
              value)) {
            return ("Please Enter a valid email");
          }
          return null;
        },
        onSaved: (value) {
          emailController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
            prefixIcon: Icon(Icons.mail),
            contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
            hintText: "Email",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            )
        ),
      );

      //password field
      final passwordField = TextFormField(
        autofocus: false,
        controller: passwordController,
        obscureText: true,
        validator: (value) {
          RegExp regex = new RegExp(r'^.{6,}$'); //regex for six chars
          if (value!.isEmpty) {
            return ("Password is required for log in");
          }
          if (!regex.hasMatch(value)) {
            return ("Enter valid password (Min. 6 Characters)");
          }
        },
        onSaved: (value) {
          passwordController.text = value!;
        },
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
            prefixIcon: Icon(Icons.vpn_key),
            contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
            hintText: "Password",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            )
        ),
      );

      final loginButton = Material(
        elevation: 5,
        borderRadius: BorderRadius.circular(30),
        color: Colors.redAccent,
        child: MaterialButton(
            padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
            minWidth: MediaQuery
                .of(context)
                .size
                .width,

            onPressed: () {
              signIn(emailController.text, passwordController.text);
            },
            child: Text("Login",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            )),
      );


      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: SingleChildScrollView(
            child: Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(36.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                          height: 200,
                          child: Image.asset(
                            "assets/redloho.png",
                            fit: BoxFit.contain,
                          )),
                      SizedBox(height: 45),

                      emailField,
                      SizedBox(height: 25),

                      passwordField,
                      SizedBox(height: 35),

                      loginButton,
                      SizedBox(height: 15),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text("Don't have an account? "),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(
                                    builder: (context) => RegisterPage()));
                              },
                              child: Text("Sign Up", style: TextStyle(
                                  color: Colors.redAccent,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15),
                              ),
                            )
                          ])
                    ],
                  ),
                ),
              ),

            ),
          ),
        ),
      );
    }


    //login function
    void signIn(String email, String password) async {
      if (_formKey.currentState!.validate()) {
        await _auth.signInWithEmailAndPassword(email: email, password: password)
            .then((uid) =>
            {
              Fluttertoast.showToast(msg: "Login Successful"),
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomeWidget())),

            }).catchError((e){
              Fluttertoast.showToast(msg: e!.message);
            });
      }
    }
  }