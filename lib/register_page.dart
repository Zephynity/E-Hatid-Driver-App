import 'dart:async';

import 'package:ehatid_driver_app/login.dart';
import 'package:ehatid_driver_app/navigation_bar.dart';
import 'package:ehatid_driver_app/progress_dialog.dart';
import 'package:ehatid_driver_app/terms_and_conditions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'package:intl/intl.dart';

import 'constants.dart';

class RegisterPage extends StatefulWidget {
  // final VoidCallback showLoginPage;
  final String phone;

  RegisterPage({required this.phone});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final FirebaseAuth fAuth = FirebaseAuth.instance;
  User? currentFirebaseUser;
  bool agree = false;
  String? earnings = "0.00";
  String? ratings = "0";

  late FocusNode focusFname;
  late FocusNode focusLname;
  late FocusNode focusPhone;
  late FocusNode focusBirth;
  late FocusNode focusPlateNum;
  late FocusNode focusLicenseNum;
  late FocusNode focusEmail;
  late FocusNode focusUsername;
  late FocusNode focusPass;
  late FocusNode focusConfirmPass;

  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _birthdateController = TextEditingController();
  TextEditingController _plateNumController = TextEditingController();
  TextEditingController _licenseNumController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _userNameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmpasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();

    focusFname = FocusNode();
    focusLname = FocusNode();
    focusPhone = FocusNode();
    focusBirth = FocusNode();
    focusPlateNum = FocusNode();
    focusLicenseNum = FocusNode();
    focusEmail = FocusNode();
    focusUsername = FocusNode();
    focusPass = FocusNode();
    focusConfirmPass = FocusNode();
  }

  validateForm() {
    if(_firstNameController.text == null || _firstNameController.text.isEmpty)
    {
      focusFname.requestFocus();
      Fluttertoast.showToast(msg: "Please enter your first name.");
    }

    else if(_lastNameController.text == null || _lastNameController.text.isEmpty)
    {
      focusLname.requestFocus();
      Fluttertoast.showToast(msg: "Please enter your last name.");
    }

    else if(_birthdateController.text == null || _birthdateController.text.isEmpty)
    {
      focusBirth.requestFocus();
      Fluttertoast.showToast(msg: "Please enter your birthday.");
    }

    else if(_plateNumController.text == null || _plateNumController.text.isEmpty)
    {
      focusPlateNum.requestFocus();
      Fluttertoast.showToast(msg: "Please enter your plate number.");
    }

    else if(_plateNumController.text.length != 7)
    {
      focusPlateNum.requestFocus();
      Fluttertoast.showToast(msg: "Please enter your valid plate number.");
    }

    else if(_licenseNumController.text == null || _licenseNumController.text.isEmpty)
    {
      focusLicenseNum.requestFocus();
      Fluttertoast.showToast(msg: "Please enter your license number.");
    }

    else if (_licenseNumController.text.length != 13)
    {
      focusLicenseNum.requestFocus();
      Fluttertoast.showToast(msg: "Please enter your valid license number.");
    }

    else if(_phoneController.text == null || _phoneController.text.isEmpty)
    {
      focusPhone.requestFocus();
      Fluttertoast.showToast(msg: "Please enter your phone number.");
    }

    else if(_phoneController.text.length != 11)
    {
      focusPhone.requestFocus();
      Fluttertoast.showToast(msg: "Invalid phone number.");
    }

    else if(_phoneController.text != widget.phone.toString())
    {
      focusPhone.requestFocus();
      Fluttertoast.showToast(msg: "Phone number does not match.");
    }

    else if(_emailController.text != null && !_emailController.text.contains("@"))
    {
      focusEmail.requestFocus();
      Fluttertoast.showToast(msg: "Please enter a valid email.");
    }

    else if (_userNameController.text == null || _userNameController.text.isEmpty)
    {
      focusUsername.requestFocus();
      Fluttertoast.showToast(msg: "Please enter your username.");
    }

    else if (_userNameController.text.length < 4)
    {
      focusUsername.requestFocus();
      Fluttertoast.showToast(msg: "Choose a username with 4 or more characters.");
    }

    else if(_passwordController.text.isEmpty)
    {
      focusPass.requestFocus();
      Fluttertoast.showToast(msg: "Please enter your password.");
    }

    else if(_passwordController.text.length < 8)
    {
      focusPass.requestFocus();
      Fluttertoast.showToast(msg: "Password must be atleast 8 Characters.");
    }

    else if (_confirmpasswordController.text == null || _confirmpasswordController.text.isEmpty)
    {
      focusConfirmPass.requestFocus();
      Fluttertoast.showToast(msg: "Please re-enter your password.");
    }

    else if (_confirmpasswordController.text != _passwordController.text)
    {
      focusConfirmPass.requestFocus();
      Fluttertoast.showToast(msg: "Password mismatch.");
    }

    else if (agree != true)
    {
      Fluttertoast.showToast(msg: "Please read and accept the Terms and Conditions before registration.");
    }

    else
    {
      signUp();
    }
  }

  @override

  Future signUp() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context)=> ProgressDialog(
        message: "Processing, Please wait...",
      ),
    );

    final User? firebaseUser = (
        await fAuth.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        ).catchError((msg){
          Navigator.pop(context);
          Fluttertoast.showToast(msg: "Error: " + msg.toString());
        })
    ).user;

    if(firebaseUser != null)
    {
      Map userMap =
      {
        "id": firebaseUser.uid,
        "first_name": _firstNameController.text.trim(),
        "last_name": _lastNameController.text.trim(),
        "plateNum": _plateNumController.text.trim(),
        "licenseNum": _licenseNumController.text.trim(),
        "email": _emailController.text.trim(),
        "phone": _phoneController.text.trim(),
        "username": _userNameController.text.trim(),
        "password": _passwordController.text.trim(),
        "birthdate": _birthdateController.text.trim(),
        "earnings": earnings,
        "ratings": ratings,
      };

      DatabaseReference driversRef = FirebaseDatabase.instance.ref().child("drivers");
      driversRef.child(firebaseUser.uid).set(userMap);

      currentFirebaseUser = firebaseUser;
      Fluttertoast.showToast(msg: "Account has been Created.");
      Timer(const Duration(seconds: 3),(){
        Navigator.push(context, MaterialPageRoute(builder: (c)=> Navigation(index: 0,)));
      });
    }
    else
    {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: "Account has not been Created.");
    }
  }

  @override
  void dispose() {
    focusFname.dispose();
    focusLname.dispose();
    focusPhone.dispose();
    focusBirth.dispose();
    focusPlateNum.dispose();
    focusLicenseNum.dispose();
    focusEmail.dispose();
    focusUsername.dispose();
    focusPass.dispose();
    focusConfirmPass.dispose();

    super.dispose();
  }

  bool passwordConfirmed() {
    if (_passwordController.text.trim() ==
        _confirmpasswordController.text.trim()) {
      return true;
    } else {
      return false;
    }
  }

  final formkey = GlobalKey<FormState>();
  bool _isHidden = true;
  bool _isHidden2 = true;

  //final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    print("Phone: " + widget.phone);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color(0xFFFFFCEA),
      body: SafeArea(
        child: Container(
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
              Form(
                key: formkey,
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 5.h),

                        Align(
                          alignment: Alignment(-1, 0),
                          child: Row(
                            children: <Widget> [
                              SizedBox(width: 20.sp),
                              Text(
                                "Drive for E-Hatid", textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize: 24,
                                    color: Color.fromARGB(255, 33, 33, 33),
                                    letterSpacing: -0.5,
                                    fontWeight: FontWeight.w700),
                              ),
                              SizedBox(width: 10.sp),
                              Icon(
                                Icons.account_circle_rounded,
                                size: 25.sp,
                                color: Colors.black,
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 0.3.h),

                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.sp),
                          child: Text(
                            "Sign up as a tricycle driver partner from TODA G5 in Lourdes Terminal by providing us some information below.",
                            style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 11,
                                color: Color.fromARGB(255, 33, 33, 33),
                                letterSpacing: -0.5,
                                fontWeight: FontWeight.w500),
                          ),
                        ),

                        SizedBox(height: 2.h),

                        Divider(
                          color: Colors.black,
                          height: 0,
                          thickness: 2,
                          indent: 20.sp,
                          endIndent: 20.sp,
                        ),

                        SizedBox(height: 2.h),

                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: Adaptive.w(5)),
                          child: TextFormField(
                            controller: _firstNameController,
                            focusNode: focusFname,
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xFFFED90F),
                                ),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              hintText: "First Name",
                              hintStyle: TextStyle(
                                color: Color(0xbc000000),
                                fontSize: 15,
                                fontFamily: "Montserrat",
                                fontWeight: FontWeight.w400,
                              ),
                              fillColor: Colors.white,
                              filled: true,
                              contentPadding: EdgeInsets.symmetric(vertical: 8.sp, horizontal: 10.sp),
                            ),
                          ),
                        ),

                        SizedBox(height: 1.5.h),

                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: Adaptive.w(5)),
                          child: TextFormField(
                            controller: _lastNameController,
                            focusNode: focusLname,
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xFFFED90F),
                                ),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              hintText: "Last Name",
                              hintStyle: TextStyle(
                                color: Color(0xbc000000),
                                fontSize: 15,
                                fontFamily: "Montserrat",
                                fontWeight: FontWeight.w400,
                              ),
                              fillColor: Colors.white,
                              filled: true,
                              contentPadding: EdgeInsets.symmetric(vertical: 8.sp, horizontal: 10.sp),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your last name.';
                              } else {
                                return null;
                              }
                            },
                          ),
                        ),

                        SizedBox(height: 1.5.h),

                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: Adaptive.w(5)),
                          child: TextFormField(
                            controller: _birthdateController,
                            focusNode: focusBirth,
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xFFFED90F),
                                ),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              hintText: "Birthday",
                              hintStyle: TextStyle(
                                color: Color(0xbc000000),
                                fontSize: 15,
                                fontFamily: "Montserrat",
                                fontWeight: FontWeight.w400,
                              ),
                              fillColor: Colors.white,
                              filled: true,
                              contentPadding: EdgeInsets.symmetric(vertical: 8.sp, horizontal: 10.sp),
                              prefixIcon: Icon(Icons.calendar_month),
                            ),
                            onTap: () async
                            {
                              DateTime? pickedDate = await showDatePicker(context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(1950),
                                  lastDate: DateTime(2101));

                              if(pickedDate !=null)
                              {
                                setState(() {
                                  _birthdateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
                                });
                              }
                            },
                          ),
                        ),

                        SizedBox(height: 1.5.h),

                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: Adaptive.w(5)),
                          child: TextFormField(
                            controller: _plateNumController,
                            focusNode: focusPlateNum,
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xFFFED90F),
                                ),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              hintText: "Plate Number (ABC-123)",
                              hintStyle: TextStyle(
                                color: Color(0xbc000000),
                                fontSize: 15,
                                fontFamily: "Montserrat",
                                fontWeight: FontWeight.w400,
                              ),
                              fillColor: Colors.white,
                              filled: true,
                              contentPadding: EdgeInsets.symmetric(vertical: 8.sp, horizontal: 10.sp),
                            ),
                          ),
                        ),

                        SizedBox(height: 1.5.h),

                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: Adaptive.w(5)),
                          child: TextFormField(
                            controller: _licenseNumController,
                            focusNode: focusLicenseNum,
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xFFFED90F),
                                ),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              hintText: "License Number (D01-12-123456)",
                              hintStyle: TextStyle(
                                color: Color(0xbc000000),
                                fontSize: 15,
                                fontFamily: "Montserrat",
                                fontWeight: FontWeight.w400,
                              ),
                              fillColor: Colors.white,
                              filled: true,
                              contentPadding: EdgeInsets.symmetric(vertical: 8.sp, horizontal: 10.sp),
                            ),
                          ),
                        ),

                        SizedBox(height: 3.h),

                        Align(
                          alignment: Alignment(-1, 0),
                          child: Row(
                            children: <Widget> [
                              SizedBox(width: 20.sp),
                              Text(
                                "Contact Details", textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize: 24,
                                    color: Color.fromARGB(255, 33, 33, 33),
                                    letterSpacing: -0.5,
                                    fontWeight: FontWeight.w700),
                              ),
                              SizedBox(width: 10.sp),
                              Icon(
                                Icons.email_outlined,
                                size: 25.sp,
                                color: Colors.black,
                              ),
                            ],
                          ),
                        ),

                        Divider(
                          color: Colors.black,
                          height: 0,
                          thickness: 2,
                          indent: 20.sp,
                          endIndent: 20.sp,
                        ),

                        SizedBox(height: 2.h),

                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: Adaptive.w(5)),
                          child: TextFormField(
                            controller: _phoneController,
                            focusNode: focusPhone,
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xFFFED90F),
                                ),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              hintText: "Phone Number",
                              hintStyle: TextStyle(
                                color: Color(0xbc000000),
                                fontSize: 15,
                                fontFamily: "Montserrat",
                                fontWeight: FontWeight.w400,
                              ),
                              fillColor: Colors.white,
                              filled: true,
                              contentPadding: EdgeInsets.symmetric(vertical: 8.sp, horizontal: 10.sp),
                            ),
                          ),
                        ),

                        SizedBox(height: 1.5.h),

                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: Adaptive.w(5)),
                          child: TextFormField(
                            controller: _emailController,
                            focusNode: focusEmail,
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xFFFED90F),
                                ),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              hintText: "Email",
                              hintStyle: TextStyle(
                                color: Color(0xbc000000),
                                fontSize: 15,
                                fontFamily: "Montserrat",
                                fontWeight: FontWeight.w400,
                              ),
                              fillColor: Colors.white,
                              filled: true,
                              contentPadding: EdgeInsets.symmetric(vertical: 8.sp, horizontal: 10.sp),
                            ),
                            validator: (email) =>
                            email != null && !EmailValidator.validate(email)
                                ? 'Enter a valid email'
                                : null,
                          ),
                        ),

                        SizedBox(height: 3.h),

                        Align(
                          alignment: Alignment(-1, 0),
                          child: Row(
                            children: <Widget> [
                              SizedBox(width: 20.sp),
                              Text(
                                "Account Details", textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize: 24,
                                    color: Color.fromARGB(255, 33, 33, 33),
                                    letterSpacing: -0.5,
                                    fontWeight: FontWeight.w700),
                              ),
                              SizedBox(width: 10.sp),
                              Icon(
                                Icons.contact_mail_outlined,
                                size: 25.sp,
                                color: Colors.black,
                              ),
                            ],
                          ),
                        ),

                        Divider(
                          color: Colors.black,
                          height: 0,
                          thickness: 2,
                          indent: 20.sp,
                          endIndent: 20.sp,
                        ),

                        SizedBox(height: 2.h),

                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: Adaptive.w(5)),
                          child: TextFormField(
                            controller: _userNameController,
                            focusNode: focusUsername,
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xFFFED90F),
                                ),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              hintText: "Username",
                              hintStyle: TextStyle(
                                color: Color(0xbc000000),
                                fontSize: 15,
                                fontFamily: "Montserrat",
                                fontWeight: FontWeight.w400,
                              ),
                              fillColor: Colors.white,
                              filled: true,
                              contentPadding: EdgeInsets.symmetric(vertical: 8.sp, horizontal: 10.sp),
                            ),
                          ),
                        ),

                        SizedBox(height: 1.5.h),

                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: Adaptive.w(5)),
                          child: TextFormField(
                            controller: _passwordController,
                            focusNode: focusPass,
                            obscureText: _isHidden,
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xFFFED90F),
                                ),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              hintText: "Password",
                              suffixIcon: InkWell(
                                onTap: _togglePasswordView,
                                child: Icon(
                                  _isHidden ? Icons.visibility : Icons.visibility_off,
                                  color: Color(0xffCCCCCC),
                                ),
                              ),
                              hintStyle: TextStyle(
                                color: Color(0xbc000000),
                                fontSize: 15,
                                fontFamily: "Montserrat",
                                fontWeight: FontWeight.w400,
                              ),
                              fillColor: Colors.white,
                              filled: true,
                              contentPadding: EdgeInsets.symmetric(vertical: 8.sp, horizontal: 10.sp),
                            ),
                          ),
                        ),

                        SizedBox(height: 1.5.h),

                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: Adaptive.w(5)),
                          child: TextFormField(
                            controller: _confirmpasswordController,
                            focusNode: focusConfirmPass,
                            obscureText: _isHidden2,
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xFFFED90F),
                                ),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              hintText: "Confirm Password",
                              suffixIcon: InkWell(
                                onTap: _toggleConfirmPasswordView,
                                child: Icon(
                                  _isHidden2 ? Icons.visibility : Icons.visibility_off,
                                  color: Color(0xffCCCCCC),
                                ),
                              ),
                              hintStyle: TextStyle(
                                color: Color(0xbc000000),
                                fontSize: 15,
                                fontFamily: "Montserrat",
                                fontWeight: FontWeight.w400,
                              ),
                              fillColor: Colors.white,
                              filled: true,
                              contentPadding: EdgeInsets.symmetric(vertical: 8.sp, horizontal: 10.sp),
                            ),
                          ),
                        ),

                        SizedBox(height: 1.h),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Checkbox(
                              value: agree,
                              onChanged: (value) {
                                setState(() {
                                  agree = value ?? false;
                                });
                              },
                            ),
                            Column(
                              children: [
                                Text(
                                  "I have read and accept the ",
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(fontFamily: 'Montserrat', fontSize: 13, color: Color(0xff272727), letterSpacing: -0.5, fontWeight: FontWeight.w500),
                                ),
                                GestureDetector(
                                  onTap: (){
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext c)
                                        {
                                          return PrivacyNotice();
                                        }
                                    );
                                  },
                                  child: Text(
                                    "Terms and Conditions of E-Hatid Driver App",
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(fontFamily: 'Montserrat', fontSize: 13, color: Color(0xff272727), letterSpacing: -0.5, fontWeight: FontWeight.w500,
                                      decoration: TextDecoration.underline,),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        SizedBox(
                          height: 30.sp,
                          width: 50.w,
                          child: MaterialButton(
                            onPressed: (){
                              validateForm();
                            },
                            color: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Text(
                              "Sign up",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Montserrat',
                                  fontSize: 14),
                            ),
                          ),
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Have an account already?",
                              style: TextStyle(
                                  color: Color(0xFF494949),
                                  fontFamily: 'Montserrat',
                                  fontSize: 14,
                                  letterSpacing: -0.5,
                                  fontWeight: FontWeight.w500),
                            ),
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
                                  fontSize: 15,
                                  letterSpacing: -0.5,
                                  fontWeight: FontWeight.w600,
                                  decoration: TextDecoration.underline,
                                  color: kPrimaryColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
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

  void _toggleConfirmPasswordView() {
    setState(() {
      _isHidden2 = !_isHidden2;
    });
  }
}