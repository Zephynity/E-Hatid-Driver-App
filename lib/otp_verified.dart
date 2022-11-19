import 'dart:async';

import 'package:ehatid_driver_app/register_page.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class OtpVerified extends StatefulWidget {
  final String phone;

  OtpVerified({required this.phone});

  @override
  _OtpVerified createState() => _OtpVerified();
}
class _OtpVerified extends State<OtpVerified> {

  @override
  void initState() {
    //seconds of wait for loading screen
    Timer(const Duration(seconds: 3), (){
      //after 5 seconds
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
        return RegisterPage(
          phone: widget.phone,
        );
      }));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;
    return Scaffold(
      backgroundColor: Color(0XFFFFFCEA),
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget> [
            Container(
              height: size.height,
              width: double.infinity,
              child: Stack(
                children: <Widget>[
                  Positioned(
                    top: 0,
                    child: Image.asset("assets/images/Vector 15.png",
                      width: Adaptive.w(100),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Image.asset("assets/images/Vector 16.png",
                      width: Adaptive.w(80),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget> [
                      Image.asset(
                        "assets/images/verified.png",
                        width: Adaptive.w(50),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Phone Verified!", textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 24,
                                color: Color.fromARGB(255, 33, 33, 33),
                                letterSpacing: -0.5,
                                fontWeight: FontWeight.w700
                            ),
                          ),
                          SizedBox(width: Adaptive.w(2),),
                          Icon(Icons.verified_rounded,
                            color: Color(0XFF0CBC8B),),
                        ],
                      ),
                      Text(
                        "Well done! Shortly, You may proceed\n to your account registration.",
                        overflow: TextOverflow.visible,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          height: 1.171875,
                          fontSize: 14,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w500,
                          color: Color.fromARGB(255, 126, 126, 126),
                          letterSpacing: -0.48,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}