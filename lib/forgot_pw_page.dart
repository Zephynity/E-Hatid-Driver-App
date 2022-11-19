import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future passwordReset() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: _emailController.text.trim());
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text("Password reset link sent. Please check your email."),
          );
        },
      );
    } on FirebaseAuthException catch (e) {
      print(e);
      showDialog(
          context: context,
          builder: (context) {
        return AlertDialog(
          content: Text(e.message.toString()),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFCEA),
      appBar: AppBar(
        backgroundColor: Colors.yellow,
        elevation: 0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Text("Please enter your email and we will send you a password reset link.",
          textAlign: TextAlign.center,
          style: TextStyle( color: Color(0xbc000000),
            fontSize: 15,
            fontFamily: "Montserrat",
            fontWeight: FontWeight.w400,
          ),
          ),
        ),
          SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
          child: TextField(
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
              prefixIcon: Icon(Icons.person, color: Color(0xffCCCCCC)),
              hintStyle: TextStyle( color: Color(0xbc000000),
                fontSize: 15,
                fontFamily: "Montserrat",
                fontWeight: FontWeight.w400,),
              fillColor: Colors.white,
              filled: true,
            ),
          ),
        ),
        SizedBox(height: 10),
        MaterialButton(
          onPressed: passwordReset,
          child: Text("Reset Password", style: TextStyle( color: Color(0xbc000000),
            fontSize: 15,
            fontFamily: "Montserrat",
            fontWeight: FontWeight.w600,),),
          color: Colors.yellow,
          ),
        ],
      ),
    );
  }
}
