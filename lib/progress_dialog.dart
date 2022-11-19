import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ProgressDialog extends StatelessWidget {
  String? message;
  ProgressDialog({this.message});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(vertical: Adaptive.h(36)),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(19)
      ),
      child: Container(
        width: Adaptive.w(10),
        height: Adaptive.h(20),
        child: Column(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: Adaptive.h(4),),
                SpinKitFadingCircle(
                  color: Colors.black,
                  size: 50,
                ),
                Container(
                  width: Adaptive.w(60),
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Column(
                        children: [
                          SizedBox(height: Adaptive.h(1),),
                          Text(message!,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              color: Colors.black,
                              fontSize: 15,
                              letterSpacing: -0.5,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],),
      ),
    );
  }
}
