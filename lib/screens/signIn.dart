import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../helpers/curvePainter.dart';
import 'howCanWeHelpYou.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'signUp.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _email, _password;
  bool _success, isLoading = false;
  bool empty = true, isValidated;
  int userLen = 0, passLen = 0;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser user;

  void _signInWithEmailAndPassword() async {
    try {
      user = (await _auth.signInWithEmailAndPassword(
        email: _email,
        password: _password,
      ))
          .user;

      if (user != null) {
        setState(() {
          _success = true;
        });
      } else {
        setState(() {
          _success = false;
        });
      }
    } catch (e) {
      _success = false;
    }
    if (user != null && user.isEmailVerified == false) {
      _success = false;
      showToastNotVerified();
    } else {
      showToast();
    }

    if (_success == false) {
      setState(() {
        this.isLoading = false;
      });
    }

    if (_success == true) {
      navigateToMainScreen();
    }
  }

  showToastNotVerified() {
    Fluttertoast.showToast(
        msg: "Email not verified",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.grey,
        timeInSecForIosWeb: 2,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  showToast() {
    Fluttertoast.showToast(
        msg: _success
            ? "$_email signed in successfully"
            : "User not found, try signing up",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.grey,
        timeInSecForIosWeb: 2,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  navigateToMainScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => HowCanWeHelpYou(),
      ),
    );
  }

  loginArrowColorChanger() {
    if (this.userLen != 0 && this.passLen != 0) {
      setState(() {
        this.empty = false;
      });
    } else {
      setState(() {
        this.empty = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Stack(
      children: <Widget>[
        // Backgeound Design
        CustomPaint(
          painter: CurvePainter(),
          size: Size.infinite,
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          // Main Screen Layout
          body: Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(top: height / 7),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: 5.0),
                      // LOGIN ICONBUTTON
                      child: GestureDetector(
                        child: isLoading
                            ? Container(
                                height: 70.0,
                                width: 70.0,
                                child: CupertinoActivityIndicator(
                                  radius: 20.0,
                                ),
                              )
                            : Icon(
                                Icons.arrow_forward,
                                size: 70.0,
                                color: empty ? Colors.white : Colors.cyan,
                              ),
                        // TODO: Navigate to date and month specific
                        onTap: () {
                          validator();

                          if (isValidated) {
                            setState(() {
                              isLoading = true;
                            });
                            _signInWithEmailAndPassword();
                          }
                        },
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 20.0),
                      alignment: Alignment.center,
                      child: Text(
                        "LOGIN",
                        style: TextStyle(
                          color: Colors.cyan[200],
                          fontSize: 35.0,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 40.0),
                    ),
                    Container(
                      padding: EdgeInsets.all(12.0),
                      child: TextFormField(
                        validator: (value) {
                          if (value.isEmpty == true) {
                            return "Enter email";
                          }
                        },
                        onChanged: (val) {
                          setState(() {
                            this.userLen = val.length;
                            loginArrowColorChanger();
                          });
                        },
                        onSaved: (val) {
                          val = val.trimRight();
                          _email = val;
                        },
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.person,
                            color: Colors.white,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.cyan[200],
                            ),
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.white,
                            ),
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.white,
                            ),
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.white,
                            ),
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          labelText: "EMAIL",
                          labelStyle: TextStyle(
                            color: Colors.white,
                          ),
                          hintText: "Enter your email",
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 23.0,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10.0),
                    ),
                    Container(
                      padding: EdgeInsets.all(12.0),
                      child: TextFormField(
                        validator: (value) {
                          if (value.isEmpty == true) {
                            return "Enter password";
                          }
                        },
                        onChanged: (val) {
                          setState(() {
                            this.passLen = val.length;
                            loginArrowColorChanger();
                          });
                        },
                        onSaved: (val) {
                          _password = val;
                        },
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.vpn_key,
                            color: Colors.white,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.cyan[200],
                            ),
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.white,
                            ),
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.white,
                            ),
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.white,
                            ),
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          labelText: "PASSWORD",
                          labelStyle: TextStyle(
                            color: Colors.white,
                          ),
                          hintText: "Enter password",
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 23.0,
                          ),
                        ),
                        obscureText: true,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(20.0, 40.0, 20.0, 0.0),
                      // child: Text(
                      //   "There is Weather and there is buisness Weather",
                      //   style: TextStyle(
                      //     fontSize: 20.0,
                      //     foreground: Paint()..shader = linearGradient,
                      //   ),
                      //   textScaleFactor: 1.5,
                      // ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 10.0),
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.only(top: 50.0),
                      child: Text(
                        "WANT TO JOIN?",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 35.0,
                          // fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 10.0),
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.only(top: 10.0),
                      child: FlatButton(
                        color: Colors.cyan[200],
                        //TODO: ONPRESSED MOVE TO NEXT PAGE
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SignUp(),
                            ),
                          );
                        },
                        padding: EdgeInsets.fromLTRB(30.0, 8.0, 30.0, 8.0),
                        child: Text(
                          "CLICK HERE",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 15.0),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  validator() {
    if (_formKey.currentState.validate()) {
      // saves to global key
      _formKey.currentState.save();
      isValidated = true;
    } else {
      isValidated = false;
    }
  }
}
