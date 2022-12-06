import 'dart:async';

import 'package:ehatid_driver_app/forgot_pw_page.dart';
import 'package:ehatid_driver_app/homescreen.dart';
import 'package:ehatid_driver_app/intro_slider.dart';
import 'package:ehatid_driver_app/navigation_bar.dart';
import 'package:ehatid_driver_app/progress_dialog.dart';
import 'package:ehatid_driver_app/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
//text controller
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final FirebaseAuth fAuth = FirebaseAuth.instance;
  User? currentFirebaseUser;

  Future<void> _signOut() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.remove('initScreen');
    try {
      await fAuth.signOut();
    } catch (e) {
      print(e.toString()) ;
    }
  }

  validateForm() {
    if(_emailController.text != null && !_emailController.text.contains("@"))
    {
      Fluttertoast.showToast(msg: "Enter a valid email.");
    }
    else if(_passwordController.text.isEmpty)
    {
      Fluttertoast.showToast(msg: "Please enter your password.");
    }
    else if(_passwordController.text.length < 8)
    {
      Fluttertoast.showToast(msg: "Password must be atleast 8 Characters.");
    }
    else
    {
      signIn();
    }
  }

  Future signIn() async
  {
    final User? firebaseUser = (
        await fAuth.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        ).catchError((msg){
          //Navigator.pop(context);
          Fluttertoast.showToast(msg: "Error: " + msg.toString());
        })
    ).user;

    if(firebaseUser != null)
    {
      DatabaseReference driversRef = FirebaseDatabase.instance.ref().child("drivers");
      driversRef.child(firebaseUser.uid).once().then((driverKey)
      {
        final snap = driverKey.snapshot;
        if(snap.value != null)
        {
          currentFirebaseUser = firebaseUser;
          Fluttertoast.showToast(msg: "Login Successful.");
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext c)
              {
                return ProgressDialog(message: "Logging in, Please wait...",);
              }
          );
          Timer(const Duration(seconds: 3),(){
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (c)=>  Navigation(index: 0,)));
          });
        }
        else
        {
          Fluttertoast.showToast(msg: "No record exist with this email.");
          _signOut();
          //Navigator.push(context, MaterialPageRoute(builder: (c)=>  SignUp()));
        }
      });
    }
    else
    {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: "Error Occurred during Login.");
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  final loginform = GlobalKey<FormState>();
  bool _isHidden = true;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color(0xFFFFFCEA),
      body: Form(
        key: loginform,
        child: Center(
          child: Stack(
            children: <Widget>[
              Container(
                height: size.height,
                width: double.infinity,
                child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    Positioned(
                      top: 0,
                      child: Image.asset("assets/images/Vector 4.png",
                        width: size.width,
                      ),
                    ),
                  ],
                ),
              ),
              SingleChildScrollView(
                child: Container(
                  margin: const EdgeInsets.fromLTRB(10, 60, 10, 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset("assets/images/illus14.png",
                        width: Adaptive.h(50),
                        height: Adaptive.h(30),
                      ),
                      Text(
                        "Sign in to your account",
                        style: TextStyle(fontFamily: 'Montserrat', fontSize: 28, letterSpacing: -2, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Welcome Back! Ready for your next ride?", textAlign: TextAlign.center,
                        style: TextStyle(fontFamily: 'Montserrat', fontSize: 13, color: Color(0xff272727), letterSpacing: -0.5, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(height: Adaptive.h(3)),
                      SizedBox(
                        width: Adaptive.w(85),
                        child: TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFFFED90F),),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            hintText: "Email",
                            prefixIcon: Icon(Icons.person, color: Color(0xffCCCCCC)),
                            hintStyle: TextStyle( color: Color(0xbc000000),
                              fontSize: 15,
                              fontFamily: "Montserrat",
                              fontWeight: FontWeight.w400,),
                            fillColor: Colors.white,
                            filled: true,
                          ),
                        ),
                      ),
                      SizedBox(height: Adaptive.h(1.5)),
                      SizedBox(
                        width: Adaptive.w(85),
                        child: TextFormField(
                          controller: _passwordController,
                          obscureText: _isHidden,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFFFED90F),),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            hintText: "Password",
                            prefixIcon: Icon(Icons.lock, color: Color(0xffCCCCCC)),
                            suffixIcon: InkWell(
                              onTap: _togglePasswordView,
                              child: Icon(
                                _isHidden
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Color(0xffCCCCCC),
                              ),
                            ),
                            hintStyle: TextStyle( color: Color(0xbc000000),
                              fontSize: 15,
                              fontFamily: "Montserrat",
                              fontWeight: FontWeight.w400,),
                            fillColor: Colors.white,
                            filled: true,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context) {
                                  return  ForgotPasswordPage();
                                },
                                ),
                                );
                              },
                              child: Text("Forgot Password?", style: TextStyle(fontFamily: 'Montserrat', fontSize: 14,
                                letterSpacing: -0.5, fontWeight: FontWeight.w600,
                                decoration: TextDecoration.underline, color:Color(0xFFFEDF3F),
                              ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      MaterialButton(
                        onPressed: (){
                          validateForm();
                        },
                        color: Color(0xFFFED90F),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50)
                        ),
                        padding: EdgeInsets.symmetric(vertical: 20),
                        minWidth: Adaptive.w(85),
                        child: Text("Sign in",
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Montserrat',
                            fontSize: 16,
                          ),
                        ),
                      ),
                      SizedBox(height: Adaptive.h(2)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Don't have an account yet?", style: TextStyle(
                              color: Color(0xFF494949), fontFamily: 'Montserrat', fontSize: 15, letterSpacing: -0.5, fontWeight: FontWeight.w500
                          ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushReplacement(context, MaterialPageRoute(
                                builder: (_) => SignUpPage(),
                              ),
                              );
                            },
                            child: Text("Register", style: TextStyle(fontFamily: 'Montserrat', fontSize: 16,
                              letterSpacing: -0.5, fontWeight: FontWeight.w600,
                              decoration: TextDecoration.underline, color:Color(0xFFFEDF3F),
                            ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _togglePasswordView() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }
}
