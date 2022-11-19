import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ehatid_driver_app/login.dart';
import 'package:ehatid_driver_app/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';

class Test extends StatefulWidget {
  // final VoidCallback showLoginPage;
  const Test({
    Key? key,
  }) : super(key: key);

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {

  //text controller
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmpasswordController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _userNameController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    //_confirmpasswordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _userNameController.dispose();
    super.dispose();
  }

  Future signUp() async {
    //authenticate or create user
    if (passwordConfirmed()) {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      //add user details
      addUserDetails(
        _firstNameController.text.trim(),
        _lastNameController.text.trim(),
        _emailController.text.trim(),
        _userNameController.text.trim(),
        _passwordController.text.trim(),
      );
    }
  }

  Future addUserDetails(String firstName, String lastName, String email, String username, String password) async {
    await FirebaseFirestore.instance.collection('drivers').add({
      'first_name': firstName,
      'last_name': lastName,
      'email' : email,
      'username' : username,
      'password' : password,

    });
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

  //final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFCEA),
      body: Form(
        key: formkey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Create your account",
                  style: TextStyle(fontFamily: 'Montserrat', fontSize: 28, letterSpacing: -2, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  "Please complete the following details.", textAlign: TextAlign.center,
                  style: TextStyle(fontFamily: 'Montserrat', fontSize: 13, color: Color(0xff272727), letterSpacing: -0.5, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: TextFormField(
                    controller: _firstNameController,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFFED90F),),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      hintText: "First Name",
                      hintStyle: TextStyle( color: Color(0xbc000000),
                        fontSize: 15,
                        fontFamily: "Montserrat",
                        fontWeight: FontWeight.w400,),
                      fillColor: Colors.white,
                      filled: true,
                    ),
                    validator: (value) {
                      if(value == null || value.isEmpty){
                        return 'Please enter your first name.';
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: TextFormField(
                    controller: _lastNameController,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFFED90F),),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      hintText: "Last Name",
                      hintStyle: TextStyle( color: Color(0xbc000000),
                        fontSize: 15,
                        fontFamily: "Montserrat",
                        fontWeight: FontWeight.w400,),
                      fillColor: Colors.white,
                      filled: true,
                    ),
                    validator: (value) {
                      if(value == null || value.isEmpty){
                        return 'Please enter your last name.';
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
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
                      hintStyle: TextStyle( color: Color(0xbc000000),
                        fontSize: 15,
                        fontFamily: "Montserrat",
                        fontWeight: FontWeight.w400,),
                      fillColor: Colors.white,
                      filled: true,
                    ),
                    validator: (email) =>
                    email != null && !EmailValidator.validate(email)
                        ? 'Enter a valid email'
                        : null,
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: TextFormField(
                    controller: _userNameController,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFFED90F),),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      hintText: "Username",
                      hintStyle: TextStyle( color: Color(0xbc000000),
                        fontSize: 15,
                        fontFamily: "Montserrat",
                        fontWeight: FontWeight.w400,),
                      fillColor: Colors.white,
                      filled: true,
                    ),
                    validator: (value) {
                      if(value == null || value.isEmpty){
                        return 'Please enter your username.';
                      } else if(value.length < 4) {
                        return "Choose a username with 4 or more characters.";
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
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
                    validator: (value) {
                      if(value == null || value.isEmpty){
                        return 'Please enter your password.';
                      } else if (value.length < 8) {
                        return "Length of password must be 8 or greater.";
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: TextFormField(
                    controller: _confirmpasswordController,
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
                      hintText: "Confirm Password",
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
                    validator: (value) {
                      if(value == null || value.isEmpty){
                        return 'Please re-enter your password.';
                      } else if (value.length < 8) {
                        return "Length of password must be 8 or greater.";
                      } else if(value != _passwordController.text) {
                        return "Password mismatch.";
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: MaterialButton(
                    onPressed: (){
                      if(formkey.currentState!.validate()){
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("Success"),
                        ));
                        signUp();
                        Navigator.pushReplacement(context, MaterialPageRoute(
                          builder: (_) => LoginScreen(),
                        ),
                        );
                      }
                    },
                    color: Color(0xFFFED90F),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 20),
                    minWidth: double.infinity,
                    child: Text(
                      "Sign up",
                      style: TextStyle(
                          color: Colors.white, fontFamily: 'Montserrat', fontSize: 16
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Have an account already?", style: TextStyle(
                        color: Color(0xFF494949), fontFamily: 'Montserrat', fontSize: 16, letterSpacing: -0.5, fontWeight: FontWeight.w500
                    ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(context, MaterialPageRoute(
                          builder: (_) => LoginScreen(),
                        ),
                        );
                      },
                      child: Text("Login", style: TextStyle(fontFamily: 'Montserrat', fontSize: 16,
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
      ),
    );
  }

  void _togglePasswordView() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }
}