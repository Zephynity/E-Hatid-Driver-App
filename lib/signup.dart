import 'package:animate_do/animate_do.dart';
import 'package:ehatid_driver_app/login.dart';
import 'package:ehatid_driver_app/otp_verification.dart';
import 'package:ehatid_driver_app/register_page.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:responsive_sizer/responsive_sizer.dart';


class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController phoneController = TextEditingController();
  String dialCodeDigits = "+63";
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Color(0XFFF8D516),
      body: SafeArea(
        child: Center(
          child: Stack(
            children: <Widget>[
              Container(
                child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    Positioned(
                      top: 0,
                      child: Image.asset("assets/images/Vector 3.png",
                        width: size.width,
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      child: Image.asset("assets/images/Vector 2.png",
                        width: size.width,
                      ),
                    ),
                  ],
                ),
              ),
              SingleChildScrollView(
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget> [
                      SizedBox(height: Adaptive.h(8)),
                      Image.asset("assets/images/illus12.png",
                        width: Adaptive.h(50),
                        height: Adaptive.h(30),
                      ),
                      Text(
                        "Sign-up to E-Hatid",
                        style: TextStyle(fontFamily: 'Montserrat', fontSize: 28, letterSpacing: -2, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: Adaptive.h(1)),
                      Text(
                        "Be part of the TODA G5 Lourdes Terminal", textAlign: TextAlign.center,
                        style: TextStyle(fontFamily: 'Montserrat', fontSize: 13, color: Color(0xff272727), letterSpacing: -0.5, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(height: Adaptive.h(2.5)),
                      FadeInDown(
                        child: Container(
                          width: Adaptive.w(85),
                          margin: const EdgeInsets.symmetric(vertical: 15),
                          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                    color: Color(0xffeeeeee),
                                    blurRadius: 10,
                                    offset: Offset(0,4)
                                )
                              ],
                              borderRadius: BorderRadius.circular(50),
                              border: Border.all(color: Colors.black.withOpacity(0.13))
                          ),
                          child: Stack(
                            children: [
                              InternationalPhoneNumberInput(
                                onInputChanged: (country) {
                                  setState(() {
                                    dialCodeDigits = country.dialCode!;
                                  });
                                },
                                cursorColor: Colors.black,
                                formatInput: false,
                                textFieldController: phoneController,
                                maxLength: 10,
                                initialValue: PhoneNumber(
                                    isoCode: 'PH', dialCode: '+63'),
                                selectorConfig: SelectorConfig(
                                    selectorType: PhoneInputSelectorType
                                        .BOTTOM_SHEET
                                ),
                                inputDecoration: InputDecoration(
                                  contentPadding: EdgeInsets.only(bottom: 15, left: 0),
                                  border: InputBorder.none,
                                  hintText: 'Phone Number',
                                  hintStyle: TextStyle(
                                      color: Colors.grey.shade500, fontFamily: 'Montserrat', fontSize: 16, fontWeight: FontWeight.w400
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 85,
                                top: 8,
                                bottom:8,
                                child: Container(
                                  height: 40,
                                  width: 1,
                                  color: Colors.black.withOpacity(0.13),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: Adaptive.h(1.2)),
                      FadeInDown(
                        child: MaterialButton(
                          onPressed: (){
                            if(phoneController.text.isEmpty)
                            {
                              Fluttertoast.showToast(msg: "Phone number is still empty.");
                            } else if(phoneController.text.length != 10)
                            {
                              Fluttertoast.showToast(msg: "Invalid phone number.");
                            } else {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) => OtpBody(
                                    phone: phoneController.text,
                                    codeDigits: dialCodeDigits,
                                  )));
                            }
                          },
                          color: Colors.black,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50)
                          ),
                          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                          minWidth: Adaptive.w(85),
                          child: Text("Sign up with Phone", style: TextStyle(
                              color: Colors.white, fontFamily: 'Montserrat', fontSize: 14
                          ),),
                        ),
                      ),
                      FadeInDown(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Already have an account?", style: TextStyle(
                              color: Color(0xFF494949), fontFamily: 'Montserrat', fontSize: 16, letterSpacing: -0.5, fontWeight: FontWeight.w500,
                            ),),
                            TextButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => LoginScreen(),
                                  ),
                                );
                              },
                              child: Text(
                                "Login",
                                style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 16,
                                  letterSpacing: -0.5,
                                  fontWeight: FontWeight.w600,
                                  decoration: TextDecoration.underline,
                                  color: Color(0xFF494949),
                                ),
                              ),
                            )
                          ],
                        ),
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
}