import 'package:ehatid_driver_app/Screens/Welcome/components/background.dart';
import 'package:ehatid_driver_app/signup.dart';
import 'package:flutter/material.dart';

class Body extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    //total height and width
    return Background(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget> [
          Image.asset("assets/images/ehatid logo.png",
            height: size.height * 0.3,
          ),
          Text(
            "Accept a job",
            style: TextStyle(fontFamily: 'Montserrat', fontSize: 32, letterSpacing: -2, fontWeight: FontWeight.bold),
          ),
          Text(
            "Work with convenience, and \n get more passengers along your way!", textAlign: TextAlign.center,
            style: TextStyle(fontFamily: 'Montserrat', fontSize: 15, color: Color(0xff646262), letterSpacing: -0.5, fontWeight: FontWeight.w500),
          ),
          GestureDetector(
            child: Text("Skip",
              style: TextStyle(fontFamily: 'Montserrat', fontSize: 20, color: Color(0xff8C8C8C)),
            ),
            onTap: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context)=>SignUpPage()));
            },
          ),
        ],
      ),
    );
  }
}