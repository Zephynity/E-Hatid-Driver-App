import 'dart:async';
import 'package:ehatid_driver_app/constants.dart';
import 'package:ehatid_driver_app/intro_slider.dart';
import 'package:ehatid_driver_app/navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  _WelcomeScreen createState() => _WelcomeScreen();
}
class _WelcomeScreen extends State<WelcomeScreen> {

  @override
  void initState() {
    //seconds of wait for loading screen
    Timer(const Duration(seconds: 6), (){
      //after 6 seconds
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
        return IntroSliderPage();
      }));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      body: SingleChildScrollView(
        child: Container(
          height: size.height,
          width: double.infinity,
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Center(
                child: Image.asset("assets/images/ehatid logo1.png",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}