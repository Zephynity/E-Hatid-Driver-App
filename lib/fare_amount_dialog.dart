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

class FareAmountCollectionDialog extends StatefulWidget
{
  double? totalFareAmount;
  UserRideRequestInformation? userRideRequestDetails;

  FareAmountCollectionDialog({this.totalFareAmount, this.userRideRequestDetails});

  @override
  State<FareAmountCollectionDialog> createState() => _FareAmountCollectionDialogState();
}

class _FareAmountCollectionDialogState extends State<FareAmountCollectionDialog>
{
  final currentFirebaseUser = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context)
  {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            Stack(
              alignment: Alignment.center,
              children: [

                Container(
                  height: 9.h,
                  decoration: BoxDecoration(
                    color: Color(0XFF0CBB8A),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                ),

                Text(
                  "Trip Fare Amount",
                  style: const TextStyle(
                    fontFamily: "Montserrat",
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 18,
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),

            SizedBox(height: 5.h),

            Text(
              "₱" + widget.totalFareAmount!.toStringAsFixed(2),
              style: const TextStyle(
                fontFamily: "Montserrat",
                fontWeight: FontWeight.bold,
                color: Color(0xFF0CBC8B),
                fontSize: 50,
              ),
            ),

            SizedBox(height: 1.h),

            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "This is the total trip amount.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: "Montserrat",
                ),
              ),
            ),

            SizedBox(height: 2.h),

            //confirm button
            SizedBox(
              width: 50.w,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: MaterialButton(
                  onPressed: ()
                  {
                    Future.delayed(const Duration(seconds: 2), ()
                    {
                      FirebaseDatabase.instance.ref()
                          .child("drivers")
                          .child(currentFirebaseUser.uid)
                          .child("newRideStatus")
                          .set("idle");

                      isDriverActive = false;
                      statusText = "Go Online";
                      buttonColor = Color(0xFF0CBC8B);
                      passengerButtonColor = Color(0x4D0CBC8B);

                      Navigator.pushReplacement(context, MaterialPageRoute(
                        builder: (_) => BookingComplete(),
                      ),
                      );
                    });
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50)
                  ),
                  minWidth: Adaptive.w(60),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Confirm", style: TextStyle( color: Colors.white,
                        fontSize: 15,
                        fontFamily: "Montserrat",
                        fontWeight: FontWeight.w600,),),
                      Icon(
                        Icons.check_circle_outline_rounded,
                        color: Colors.white,
                        size: 22.sp,
                      ),
                    ],
                  ),
                  color: Color(0XFF0CBC8B),
                ),
              ),
            ),

            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }
}
