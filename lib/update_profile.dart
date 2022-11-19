import 'dart:async';

import 'package:ehatid_driver_app/navigation_bar.dart';
import 'package:ehatid_driver_app/progress_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'package:intl/intl.dart';

class UpdateRecord extends StatefulWidget {
  UpdateRecord({Key? key}) : super(key: key);


  @override
  State<UpdateRecord> createState() => _UpdateRecordState();
}

class _UpdateRecordState extends State<UpdateRecord> {
  final currentFirebaseUser = FirebaseAuth.instance.currentUser!;

  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _userNameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _plateNumController = TextEditingController();
  TextEditingController _licenseNumController = TextEditingController();
  TextEditingController _birthdateController = TextEditingController();

  late DatabaseReference dbRef;
  bool _isHidden = true;

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

  @override
  void initState() {
    super.initState();
    dbRef = FirebaseDatabase.instance.ref().child("drivers");
    getDriverData();

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

  void getDriverData() async
  {
    DataSnapshot snapshot = await dbRef.child(currentFirebaseUser.uid).get();

    Map driver = snapshot.value as Map;

    _firstNameController.text = driver['first_name'];
    _lastNameController.text = driver['last_name'];
    _emailController.text = driver['email'];
    _userNameController.text = driver['username'];
    _passwordController.text = driver['password'];
    _phoneController.text = driver['phone'];
    _plateNumController.text = driver['plateNum'];
    _licenseNumController.text = driver['licenseNum'];
    _birthdateController.text = driver['birthdate'];
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

    // else if (_confirmpasswordController.text == null || _confirmpasswordController.text.isEmpty)
    // {
    //   focusConfirmPass.requestFocus();
    //   Fluttertoast.showToast(msg: "Please re-enter your password.");
    // }
    //
    // else if (_confirmpasswordController.text != _passwordController.text)
    // {
    //   focusConfirmPass.requestFocus();
    //   Fluttertoast.showToast(msg: "Password mismatch.");
    // }

    else
    {
      update();
    }
  }

  Future update() async
  {
    Map<String, String> driver = {
      "first_name": _firstNameController.text.trim(),
      "last_name": _lastNameController.text.trim(),
      "email": _emailController.text.trim(),
      "username": _userNameController.text.trim(),
      "password": _passwordController.text.trim(),
      "phone": _phoneController.text.trim(),
      "plateNum": _plateNumController.text.trim(),
      "licenseNum": _licenseNumController.text.trim(),
      "birthdate": _birthdateController.text.trim(),
    };

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext c)
        {
          return ProgressDialog(message: "Updating, Please wait...",);
        }
    );
    Timer(const Duration(seconds: 2),(){
      dbRef.child(currentFirebaseUser.uid).update(driver)
          .then((value) => {

        Fluttertoast.showToast(msg: "Updated Successfully."),

        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (_) => Navigation(),
        ),
        ),
      });
    });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Color(0xFFFED90F),
        title: Text('Edit My Profile',
            style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 18,
                fontWeight: FontWeight.bold)),
        elevation: 0,
      ),
      body: Container(
        padding: EdgeInsets.only(left: 15, top: 20, right: 15),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: ListView(
            children: [
              SizedBox(height: Adaptive.h(0.5)),
              Center(
                child: Stack(
                  children: [
                    Container(
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
                              image: AssetImage("assets/images/icon.png"))),
                    ),
                    Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(width: 4, color: Colors.white),
                              color: Color(0xFFFED90F)),
                          child: Icon(
                            Icons.edit,
                            color: Colors.white,
                          ),
                        ))
                  ],
                ),
              ),
              SizedBox(height: Adaptive.h(.5)),
              Padding(
                padding: EdgeInsets.only(bottom: 2.h),
                child: TextField(
                  controller: _firstNameController,
                  focusNode: focusFname,
                  obscureText: false,
                  decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFFED90F)),
                      ),
                      labelText: "First Name",
                      labelStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      floatingLabelStyle: TextStyle(
                        color: Color(0xFFFED90F),
                        fontSize: 20,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                      ),
                      hintText: "Enter your first name",
                      hintStyle: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Montserrat',
                          //fontWeight: FontWeight.bold,
                          color: Colors.grey)),
                  style: TextStyle(fontSize: 16, fontFamily: 'Montserrat'),
                ),
              ),

              Padding(
                padding: EdgeInsets.only(bottom: 2.h),
                child: TextField(
                  controller: _lastNameController,
                  focusNode: focusLname,
                  obscureText: false,
                  decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFFED90F)),
                      ),
                      labelText: "Last Name",
                      labelStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      floatingLabelStyle: TextStyle(
                        color: Color(0xFFFED90F),
                        fontSize: 20,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                      ),
                      hintText: "Enter your last name",
                      hintStyle: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Montserrat',
                          //fontWeight: FontWeight.bold,
                          color: Colors.grey)),
                  style: TextStyle(fontSize: 16, fontFamily: 'Montserrat'),
                ),
              ),

              Padding(
                padding: EdgeInsets.only(bottom: 2.h),
                child: TextField(
                  controller: _userNameController,
                  focusNode: focusUsername,
                  obscureText: false,
                  decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFFED90F)),
                      ),
                      labelText: "Username",
                      labelStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      floatingLabelStyle: TextStyle(
                        color: Color(0xFFFED90F),
                        fontSize: 20,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                      ),
                      hintText: "Enter your username",
                      hintStyle: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Montserrat',
                          //fontWeight: FontWeight.bold,
                          color: Colors.grey)),
                  style: TextStyle(fontSize: 16, fontFamily: 'Montserrat'),
                ),
              ),

              Padding(
                padding: EdgeInsets.only(bottom: 2.h),
                child: TextField(
                  controller: _birthdateController,
                  focusNode: focusBirth,
                  obscureText: false,
                  decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFFED90F)),
                    ),
                    labelText: "Birthdate",
                    labelStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    floatingLabelStyle: TextStyle(
                      color: Color(0xFFFED90F),
                      fontSize: 20,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                    ),
                    hintText: "Enter your birthdate",
                    hintStyle: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Montserrat',
                      //fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
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
                  style: TextStyle(fontSize: 16, fontFamily: 'Montserrat'),
                ),
              ),

              Padding(
                padding: EdgeInsets.only(bottom: 2.h),
                child: TextField(
                  controller: _phoneController,
                  focusNode: focusPhone,
                  obscureText: false,
                  decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFFED90F)),
                      ),
                      labelText: "Phone Number",
                      labelStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      floatingLabelStyle: TextStyle(
                        color: Color(0xFFFED90F),
                        fontSize: 20,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                      ),
                      hintText: "Enter your phone number",
                      hintStyle: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Montserrat',
                          //fontWeight: FontWeight.bold,
                          color: Colors.grey)),
                  style: TextStyle(fontSize: 16, fontFamily: 'Montserrat'),
                ),
              ),

              Padding(
                padding: EdgeInsets.only(bottom: 2.h),
                child: TextField(
                  controller: _plateNumController,
                  focusNode: focusPlateNum,
                  obscureText: false,
                  decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFFED90F)),
                      ),
                      labelText: "Plate Number",
                      labelStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      floatingLabelStyle: TextStyle(
                        color: Color(0xFFFED90F),
                        fontSize: 20,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                      ),
                      hintText: "Enter your plate number",
                      hintStyle: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Montserrat',
                          //fontWeight: FontWeight.bold,
                          color: Colors.grey)),
                  style: TextStyle(fontSize: 16, fontFamily: 'Montserrat'),
                ),
              ),

              Padding(
                padding: EdgeInsets.only(bottom: 2.h),
                child: TextField(
                  controller: _licenseNumController,
                  focusNode: focusLicenseNum,
                  obscureText: false,
                  decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFFED90F)),
                      ),
                      labelText: "License Number",
                      labelStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      floatingLabelStyle: TextStyle(
                        color: Color(0xFFFED90F),
                        fontSize: 20,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                      ),
                      hintText: "Enter your license number",
                      hintStyle: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Montserrat',
                          //fontWeight: FontWeight.bold,
                          color: Colors.grey)),
                  style: TextStyle(fontSize: 16, fontFamily: 'Montserrat'),
                ),
              ),

              Padding(
                padding: EdgeInsets.only(bottom: 2.h),
                child: TextField(
                  controller: _emailController,
                  focusNode: focusEmail,
                  obscureText: false,
                  decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFFED90F)),
                      ),
                      labelText: "Email",
                      labelStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      floatingLabelStyle: TextStyle(
                        color: Color(0xFFFED90F),
                        fontSize: 20,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                      ),
                      hintText: "Enter your email",
                      hintStyle: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Montserrat',
                          //fontWeight: FontWeight.bold,
                          color: Colors.grey)),
                  style: TextStyle(fontSize: 16, fontFamily: 'Montserrat'),
                ),
              ),

              Padding(
                padding: EdgeInsets.only(bottom: 2.h),
                child: TextField(
                  controller: _passwordController,
                  focusNode: focusPass,
                  obscureText: _isHidden,
                  decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFFED90F)),
                    ),
                    labelText: "Password",
                    labelStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    floatingLabelStyle: TextStyle(
                      color: Color(0xFFFED90F),
                      fontSize: 20,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                    ),
                    hintText: "Enter your password",
                    hintStyle: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Montserrat',
                      //fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                    suffixIcon: InkWell(
                      onTap: _togglePasswordView,
                      child: Icon(
                        _isHidden ? Icons.visibility : Icons.visibility_off,
                        color: Color(0xffCCCCCC),
                      ),
                    ),
                  ),
                  style: TextStyle(fontSize: 16, fontFamily: 'Montserrat'),
                ),
              ),

              SizedBox(height: 1.5.h),
              Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MaterialButton(
                      onPressed: () {
                        Navigator.pushReplacement(context, MaterialPageRoute(
                          builder: (_) => Navigation(),
                        ),
                        );
                      },
                      minWidth: Adaptive.w(40),
                      child: Text("Cancel",
                          style: TextStyle(
                              fontSize: 15,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w600,
                              color: Colors.white)),
                      color: Color(0XFFC5331E),
                      //padding: EdgeInsets.symmetric(horizontal: 50),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                    ),
                    SizedBox(width: 7.w),
                    MaterialButton(
                      onPressed: ()
                      {
                        validateForm();
                      },
                      minWidth: Adaptive.w(40),
                      child: Text("Save",
                          style: TextStyle(
                              fontSize: 15,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w600,
                              color: Colors.white)),
                      color: Color(0xFF0CBC8B),
                      padding: EdgeInsets.symmetric(horizontal: 50),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 1.5.h),
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