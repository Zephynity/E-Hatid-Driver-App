import 'dart:async';

import 'package:ehatid_driver_app/global.dart';
import 'package:ehatid_driver_app/update_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login.dart';


class ProfileTabPage extends StatefulWidget
{
  const ProfileTabPage({Key? key}) : super(key: key);

  @override
  State<ProfileTabPage> createState() => _ProfileTabPageState();
}

class _ProfileTabPageState extends State<ProfileTabPage>
{
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<void> _signOut() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.remove('initScreen');
    try {
      isDriverActive = false;
      statusText = "Go Online";
      buttonColor = Color(0xFF0CBC8B);
      passengerButtonColor = Color(0x4D0CBC8B);
      await _firebaseAuth.signOut();
      Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (_) => LoginScreen(),
      ),
      );
    } catch (e) {
      print(e.toString()) ;
    }
  }

  @override
  Widget build(BuildContext context)
  {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          "My Profile",
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
        backgroundColor: Color(0xFFFED90F),
      ),
      backgroundColor: Color(0xFFFFFCEA),
      body: SafeArea(
        child: Stack(
          children: <Widget> [
            Container(
              //padding: EdgeInsets.only(left: 15, top: 0, right: 15),
              child: Center(
                child: Stack(
                  children: [
                    Container(
                      height: size.height,
                      width: double.infinity,
                      child: Stack(
                        alignment: Alignment.center,
                        children: <Widget>[
                          Positioned(
                            top: 0,
                            child: Image.asset("assets/images/Vector 3.1.png",
                              width: size.width,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SingleChildScrollView(
                      child: Center(
                        child: Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.fromLTRB(10, 20, 10, 0),
                              width: 30.w,
                              height: 18.h,
                              decoration: BoxDecoration(
                                //border: Border.all(width: 4, color: Colors.white),
                                  boxShadow: [
                                    BoxShadow(
                                        spreadRadius: 2,
                                        blurRadius: 10,
                                        color: Colors.black.withOpacity(0.1))
                                  ],
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      fit: BoxFit.fitWidth,
                                      image: AssetImage("assets/images/profile.png"))),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  onlineDriverData.first_name!+ " " + onlineDriverData.last_name!,
                                  style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      color: Colors.black,
                                      fontSize: 19.sp,
                                      letterSpacing: -1,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                                SizedBox(width: 0.5.w,),
                                Icon(Icons.verified_rounded,
                                  color: Color(0xFF0CBC8B),),
                              ],
                            ),
                            Text("Username: @" + onlineDriverData.username!,
                              style: TextStyle(
                                  fontFamily: 'Montserrat', fontSize: 13, color: Color(0xff7D7D7D), letterSpacing: -0.5, fontWeight: FontWeight.w400
                              ),
                            ),

                            SizedBox(height: 1.h,),

                            Card(
                              elevation: 3, // the size of the shadow
                              color: Color(0XFFFFEE95),
                              shadowColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 15.0),
                                child: SizedBox(
                                  width: 75.w,
                                  height: 8.h,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Icon(Icons.email,  color: Color(0xFFFED90F)),
                                      SizedBox(width: 2.w,),
                                      Row(
                                        children: [
                                          Text(
                                            "Email: ",
                                            //overflow: TextOverflow.ellipsis,
                                            style: TextStyle( color: Color(0xbc000000),
                                              fontSize: 13,
                                              fontFamily: "Montserrat",
                                              fontWeight: FontWeight.w400,),
                                          ),
                                          Container(
                                            width: Adaptive.w(50),
                                            child: Text(
                                              onlineDriverData.email!,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle( color: Color(0xbc000000),
                                                fontSize: 13,
                                                fontFamily: "Montserrat",
                                                fontWeight: FontWeight.w400,),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(height: 1.h,),

                            Card(
                              elevation: 3, // the size of the shadow
                              color: Color(0XFFFFEE95),
                              shadowColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 15.0),
                                child: SizedBox(
                                  width: 75.w,
                                  height: 8.h,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Icon(Icons.phone_android, color: Color(0xFFFED90F)),
                                      SizedBox(width: 2.w,),
                                      Text(
                                        "Phone: " + onlineDriverData.phone!,
                                        style: TextStyle( color: Color(0xbc000000),
                                          fontSize: 13,
                                          fontFamily: "Montserrat",
                                          fontWeight: FontWeight.w400,),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(height: 1.h,),

                            Card(
                              elevation: 3, // the size of the shadow
                              color: Color(0XFFFFEE95),
                              shadowColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 15.0),
                                child: SizedBox(
                                  width: 75.w,
                                  height: 8.h,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Icon(Icons.numbers_rounded, color: Color(0xFFFED90F)),
                                      SizedBox(width: 2.w,),
                                      Text(
                                        "Plate Number: " + onlineDriverData.plateNum!,
                                        style: TextStyle( color: Color(0xbc000000),
                                          fontSize: 13,
                                          fontFamily: "Montserrat",
                                          fontWeight: FontWeight.w400,),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(height: 1.h,),

                            Card(
                              elevation: 3, // the size of the shadow
                              color: Color(0XFFFFEE95),
                              shadowColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 15.0),
                                child: SizedBox(
                                  width: 75.w,
                                  height: 8.h,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Icon(Icons.calendar_month, color: Color(0xFFFED90F)),
                                      SizedBox(width: 2.w,),
                                      Text(
                                        "Birthdate: " + onlineDriverData.birthdate!,
                                        style: TextStyle( color: Color(0xbc000000),
                                          fontSize: 13,
                                          fontFamily: "Montserrat",
                                          fontWeight: FontWeight.w400,),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(height: 1.h,),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    MaterialButton(
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(50)
                                        ),
                                        minWidth: Adaptive.w(40),
                                        child: Row(
                                          children: [
                                            Icon(Icons.edit,  color: Color(0xFFFFFCEA)),
                                            SizedBox(width: 2.w,),
                                            Text("Edit Profile", style: TextStyle( color: Colors.white,
                                              fontSize: 15,
                                              fontFamily: "Montserrat",
                                              fontWeight: FontWeight.w500,),),
                                          ],
                                        ),
                                        color:Color(0XFF63B389),
                                        onPressed: () {
                                          Navigator.pushReplacement(context, MaterialPageRoute(
                                            builder: (_) => UpdateRecord(),
                                          ),
                                          );
                                        }
                                    ),

                                    SizedBox(width: 1.w,),

                                    MaterialButton(
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(50)
                                      ),
                                      minWidth: Adaptive.w(40),
                                      child: Row(
                                        children: [
                                          Icon(Icons.exit_to_app,  color: Color(0xFFFFFCEA)),
                                          SizedBox(width: 2.w,),
                                          Text("Sign out", style: TextStyle( color: Colors.white,
                                            fontSize: 15,
                                            fontFamily: "Montserrat",
                                            fontWeight: FontWeight.w500,),),
                                        ],
                                      ),
                                      color:Color(0XFFCD4C3A),
                                      onPressed: () async => await _signOut(),
                                    ),
                                  ],
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
          ],
        ),
      ),
    );
  }
}
