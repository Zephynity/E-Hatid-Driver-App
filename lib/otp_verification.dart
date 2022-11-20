import 'package:ehatid_driver_app/otp_verified.dart';
import 'package:ehatid_driver_app/register_page.dart';
import 'package:ehatid_driver_app/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class OtpBody extends StatefulWidget {
  final String phone;
  final String codeDigits;

  OtpBody({required this.phone, required this.codeDigits});

  @override
  _OtpBodyState createState() => _OtpBodyState();
}

class _OtpBodyState extends State<OtpBody> {
  final GlobalKey<ScaffoldState> _scaffolkey = GlobalKey<ScaffoldState>();
  final TextEditingController _pinOTPCodeController = TextEditingController();
  final FocusNode _pinOTPCodeFocus = FocusNode();
  String? verificationCode;
  String pin = " ";

  final defaultPinTheme = PinTheme(
    width: 56.w,
    height: 4.h,
    textStyle: GoogleFonts.poppins(
      fontSize: 22,
      color: Color.fromRGBO(30, 60, 87, 1),
    ),
    decoration: BoxDecoration(),
  );

  final cursor = Column(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      Container(
        width: 56.w,
        height: Adaptive.h(.5),
        decoration: BoxDecoration(
          color: Color.fromRGBO(137, 146, 160, 1),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ],
  );

  final preFilledWidget = Column(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      Container(
        width: 56.w,
        height: .5.h,
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 140, 204, 255),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ],
  );

  @override
  void initState() {
    super.initState();

    verifyPhoneNumber();
  }

  verifyPhoneNumber() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: "${widget.codeDigits + widget.phone}",
      verificationCompleted: (PhoneAuthCredential credential) async{
        await FirebaseAuth.instance.signInWithCredential(credential).then((value){
          if(value.user != null){
            Navigator.of(context).push(MaterialPageRoute(builder: (c) => OtpVerified(
              phone: "0" + widget.phone,
            )));
          }
        });
      },
      verificationFailed: (FirebaseAuthException e){
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.message.toString()),
            duration: Duration(seconds: 3),
          ),
        );
      },
      codeSent: (String vID, int? resendToken){
        setState(() {
          verificationCode = vID;
        });
      },
      codeAutoRetrievalTimeout: (String vID){
        setState(() {
          verificationCode = vID;
        });
      },
      timeout: Duration(seconds: 60),
    );
  }

  Future<void> verifyOTP() async {
    await FirebaseAuth.instance.signInWithCredential(
      PhoneAuthProvider.credential(
        verificationId: verificationCode!,
        smsCode: pin,
      ),
    ).whenComplete(() {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => OtpVerified(
            phone: "0" + widget.phone,
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;
    //total height and width
    return Scaffold(
      key: _scaffolkey,
      backgroundColor: Color.fromARGB(255, 245, 245, 245),
      body: SingleChildScrollView(
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
            Container(
              margin: const EdgeInsets.fromLTRB(30, 60, 30, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[

                  Image.asset("assets/images/verifyPhone.png",
                    width: Adaptive.w(60),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 5, top: 10),
                    child: Text(
                      "Verify Phone Number",
                      overflow: TextOverflow.visible,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        height: .15.h,
                        fontSize: 22.0.sp,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w700,
                        color: Color.fromARGB(255, 32, 32, 32),
                        letterSpacing: -1.6800000000000002,
                      ),
                    ),
                  ),
                  Text(
                    "Please enter the 6 digit code sent to",
                    overflow: TextOverflow.visible,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      height: .15.h,
                      fontSize: 16.5.sp,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w500,
                      color: Color.fromARGB(255, 126, 126, 126),
                      letterSpacing: -0.48,
                    ),
                  ),
                  Text(
                    "${widget.codeDigits}${widget.phone}",
                    overflow: TextOverflow.visible,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      height: .15.h,
                      fontSize: 17.sp,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w500,
                      color: Color.fromARGB(255, 53, 53, 53),
                      letterSpacing: -0.48,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(40),
                    child: Pinput(
                        length: 6,
                        pinAnimationType: PinAnimationType.slide,
                        controller: _pinOTPCodeController,
                        focusNode: _pinOTPCodeFocus,
                        defaultPinTheme: defaultPinTheme,
                        showCursor: true,
                        cursor: cursor,
                        preFilledWidget: preFilledWidget,
                        onChanged: (value) {
                          setState(() {
                            pin = value;
                          });
                        },
                        onSubmitted: (pin) async {
                          try{
                            await FirebaseAuth.instance
                                .signInWithCredential(PhoneAuthProvider
                                .credential(verificationId: verificationCode!, smsCode: pin))
                                .then((value) {
                              if(value.user != null){
                                Navigator.of(context).push(MaterialPageRoute(builder: (c) => OtpVerified(
                                  phone: "0" + widget.phone,
                                )));
                              }
                            });
                          }
                          catch(e){
                            FocusScope.of(context).unfocus();
                            Fluttertoast.showToast(msg: "Invalid OTP. Try again.");
                          }
                        }
                    ),
                  ),
                  SizedBox(height: 2.h,),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "Didn't receive the code? ",
                          style: TextStyle(
                            height: .15.h,
                            fontSize: 17.sp,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w600,
                            color: Color.fromARGB(255, 126, 126, 126),
                            letterSpacing: -0.56,
                          ),
                        ),
                        WidgetSpan(
                          child: GestureDetector(
                            onTap: () {
                              verifyPhoneNumber();
                            },
                            child: Text(
                              "Resend SMS",
                              style: TextStyle(
                                height: 1.171875,
                                fontSize: 16.0,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w600,
                                color: Color(0XFFFED90F),
                                letterSpacing: -0.56,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 30, top: 15),
                    child: GestureDetector(
                      child: Text("Change Mobile Number",
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          height: .15.h,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w700,
                          color: Color.fromARGB(255, 39, 39, 39),
                          decoration: TextDecoration.underline,
                          letterSpacing: -0.48,
                        ),
                      ),
                      onTap: () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (BuildContext context) => SignUpPage()));
                      },
                    ),
                  ),
                  SizedBox(height: 2.h),
                  MaterialButton(
                    onPressed: (){
                      if(pin.length >= 6) {
                        verifyOTP();
                      } else {
                        Fluttertoast.showToast(msg: "Invalid OTP.");
                      }
                    },
                    color: Colors.black,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50)
                    ),
                    padding: EdgeInsets.symmetric(vertical: 20),
                    minWidth: double.infinity,
                    child: Text("Verify number",
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Montserrat',
                        fontSize: 17.sp,
                      ),
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text("By continuing you’re indicating that you accept our Terms of Use and our Privacy Policy",
                    maxLines: 2,
                    style: TextStyle(
                      height: .2.h,
                      fontSize: 15.sp,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w500,
                      color: Color.fromARGB(255, 126, 126, 126),
                      letterSpacing: -0.48,
                    ),
                    textAlign: TextAlign.center,
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