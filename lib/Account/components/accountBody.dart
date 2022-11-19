import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class accountBody extends StatelessWidget {
  bool isObscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 15, top: 20, right: 15),
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: ListView(
          children: [
            SizedBox(height: Adaptive.h(2)),
            Center(
              child: Stack(
                children: [
                  Container(
                    width: 130,
                    height: 130,
                    decoration: BoxDecoration(
                        border: Border.all(width: 4, color: Colors.white),
                        boxShadow: [
                          BoxShadow(
                              spreadRadius: 2,
                              blurRadius: 10,
                              color: Colors.black.withOpacity(0.1))
                        ],
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(
                                'https://cdn.pixabay.com/photo/2021/12/29/18/28/animal-6902459_1280.jpg'))),
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
            buildTextField("Name", "Martin Nevira", false),
            buildTextField("Email", "Nevira_Mar@gmail.com", true),
            buildTextField("Contact Number", "09127890912", false),
            buildTextField("Password", "**********", true),
            SizedBox(height: 30),
            Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MaterialButton(
                    onPressed: () {},
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
                    onPressed: () {},
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
            )
          ],
        ),
      ),
    );
  }

  Widget buildTextField(
      String labelText, String placeholder, bool isPasswordTextField) {
    return Padding(
      padding: EdgeInsets.only(bottom: 2.h),
      child: TextField(
        obscureText: isPasswordTextField ? isObscurePassword : false,
        decoration: InputDecoration(
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFFED90F)),
            ),
            labelText: labelText,
            labelStyle: TextStyle(
              color: Colors.black,
              fontSize: 26,
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
            hintText: placeholder,
            hintStyle: TextStyle(
                fontSize: 16,
                fontFamily: 'Montserrat',
                //fontWeight: FontWeight.bold,
                color: Colors.grey)),
      ),
    );
  }
}