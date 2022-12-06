import 'dart:async';
import 'package:ehatid_driver_app/constants.dart';
import 'package:ehatid_driver_app/navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'main.dart';

class BookingComplete extends StatefulWidget {
  const BookingComplete({Key? key}) : super(key: key);

  @override
  _BookingComplete createState() => _BookingComplete();
}
class _BookingComplete extends State<BookingComplete> {

  @override
  void initState() {
    //seconds of wait for loading screen
    Timer(const Duration(seconds: 6), (){
      //after 6 seconds
      RestartWidget.restartApp(context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: kYellowWhite,
      body: SafeArea(
        child: Center(
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Container(
                height: size.height,
                width: double.infinity,
                child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    Positioned(
                      top: 0,
                      child: Image.asset("assets/images/Vector 1.png",
                        width: size.width,
                      ),
                    ),
                  ],
                ),
              ),
              SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget> [
                    Center(
                      child: Image.asset("assets/images/ehatid logo.png",
                      ),
                    ),
                    SizedBox(height: Adaptive.h(1.5)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Booking Completed!",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontFamily: 'Montserrat', fontSize: 20.sp, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: Adaptive.w(2)),
                        Icon(
                          Icons.verified_rounded,
                          size: 25.sp,
                          color: Color(0xFF0CBC8B),
                        ),
                      ],
                    ),
                    Text(
                      "Redirecting you back to home screen...", textAlign: TextAlign.center,
                      style: TextStyle(fontFamily: 'Montserrat', fontSize: 15.sp, color: Color(0xff272727), letterSpacing: 1, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}