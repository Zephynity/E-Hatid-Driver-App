import 'package:ehatid_driver_app/bookingcomplete.dart';
import 'package:ehatid_driver_app/global.dart';
import 'package:ehatid_driver_app/main.dart';
import 'package:ehatid_driver_app/main_page.dart';
import 'package:ehatid_driver_app/navigation_bar.dart';
import 'package:ehatid_driver_app/user_ride_request_information.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class PassengerCancelledDialog extends StatefulWidget
{
  double? totalFareAmount;
  UserRideRequestInformation? userRideRequestDetails;
  String? chosenPassengerId;

  PassengerCancelledDialog({this.totalFareAmount, this.userRideRequestDetails, this.chosenPassengerId});

  @override
  State<PassengerCancelledDialog> createState() => _PassengerCancelledDialogState();
}

class _PassengerCancelledDialogState extends State<PassengerCancelledDialog>
{
  final currentFirebaseUser = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context)
  {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(19),
      ),
      child: Container(
        height: 35.h,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            Container(
              height: 9.h,
              decoration: BoxDecoration(
                color: Color(0XFFE74338),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(width: 3.w,),

                  Text(
                    "Booking Cancelled",
                    style: TextStyle(
                      fontFamily: "Montserrat",
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 20.sp,
                      letterSpacing: -0.5,
                    ),
                  ),

                  SizedBox(width: 1.w,),

                  Icon(
                    Icons.block_rounded,
                    size: 25.sp,
                    color: Colors.white,
                  ),
                ],
              ),
            ),

            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 2.5.h,),
                Text("Sorry, the passenger has cancelled their\nbooking. Their life points has been\n automatically deducted due to this\n activity. Please select another\n nearby passenger in the area.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    color: Colors.black,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),

            //confirm button
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 2.h,),
                MaterialButton(
                  onPressed: (){
                    FirebaseDatabase.instance.ref()
                        .child("All Ride Requests")
                        .child(chosenPassengerId.toString())
                        .remove();
                    RestartWidget.restartApp(context);
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50)
                  ),
                  minWidth: Adaptive.w(30),
                  child: Text("Try Again", style: TextStyle( color: Colors.white,
                    fontSize: 15,
                    fontFamily: "Montserrat",
                    fontWeight: FontWeight.w600,),),
                  color: Color(0XFF0CBB8A),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
