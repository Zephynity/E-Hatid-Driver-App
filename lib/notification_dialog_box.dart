import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:ehatid_driver_app/assistant_methods.dart';

import 'package:ehatid_driver_app/navigation_bar.dart';
import 'package:ehatid_driver_app/new_trip_screen.dart';
import 'package:ehatid_driver_app/user_ride_request_information.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'global.dart';

class NotificationDialogBox extends StatefulWidget
{
  UserRideRequestInformation? userRideRequestDetails;

  NotificationDialogBox({this.userRideRequestDetails});

  @override
  State<NotificationDialogBox> createState() => _NotificationDialogBoxState();
}


class _NotificationDialogBoxState extends State<NotificationDialogBox>
{
  final currentFirebaseUser = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context)
  {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      backgroundColor: Colors.transparent,
      elevation: 2,
      child: Container(
        margin: const EdgeInsets.all(8),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            SizedBox(height: 2.h),

            Image.asset(
              "assets/images/ehatid logo1.png",
              width: 50.w,
            ),

            SizedBox(height: 1.h),

            const Text(
              "New Ride Request",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: "Montserrat",
                fontSize: 22,
              ),
            ),

            SizedBox(height: 2.h),

            Divider(
              thickness: 0.5.w,
              color: Colors.black,
              indent: 4.w,
              endIndent: 4.w,
            ),

            //origin & destination address
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  //origin location with icon
                  Row(
                    children: [
                      Image.asset(
                        "assets/images/origin.png",
                        width: 10.w,
                        height: 10.w,
                      ),
                      const SizedBox(width: 22),
                      Expanded(
                        child: Container(
                          child: Text(
                            widget.userRideRequestDetails!.originAddress!,
                            style: const TextStyle(
                              fontFamily: "Montserrat",
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 5.h),

                  //destination location with icon
                  Row(
                    children: [
                      Image.asset(
                        "assets/images/destination.png",
                        width: 10.w,
                        height: 10.w,
                      ),
                      const SizedBox(width: 22),
                      Expanded(
                        child: Container(
                          child: Text(
                            widget.userRideRequestDetails!.destinationAddress!,
                            style: const TextStyle(
                              fontFamily: "Montserrat",
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Divider(
              thickness: 0.5.w,
              color: Colors.black,
              indent: 4.w,
              endIndent: 4.w,
            ),

            //buttons
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: StadiumBorder(),
                    ),
                    onPressed: ()
                    {
                      audioPlayer.pause();
                      audioPlayer.stop();
                      audioPlayer = AssetsAudioPlayer();

                      //cancel the rideRequest
                      FirebaseDatabase.instance.ref()
                          .child("All Ride Requests")
                          .child(widget.userRideRequestDetails!.rideRequestId!)
                          .remove().then((value)
                      {
                        FirebaseDatabase.instance.ref()
                            .child("drivers")
                            .child(currentFirebaseUser.uid)
                            .child("newRideStatus")
                            .set("idle");
                      }).then((value)
                      {
                        FirebaseDatabase.instance.ref()
                            .child("drivers")
                            .child(currentFirebaseUser.uid)
                            .child("tripsHistory")
                            .child(widget.userRideRequestDetails!.rideRequestId!);
                      }).then((value)
                      {
                        Fluttertoast.showToast(msg: "Ride Request has been Cancelled Successfully.");
                      });

                      Navigator.pushReplacement(context, MaterialPageRoute(
                          builder: (_) => Navigation(index: 0,),
                      ),
                      );
                    },
                    child: Text(
                      "Cancel".toUpperCase(),
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: "Montserrat",

                      ),
                    ),
                  ),

                  SizedBox(width: 4.w),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xFF0CBC8B),
                      shape: StadiumBorder(),
                    ),
                    onPressed: ()
                    {
                      audioPlayer.pause();
                      audioPlayer.stop();
                      audioPlayer = AssetsAudioPlayer();

                      //accept the rideRequest
                      acceptRideRequest(context);
                    },
                    child: Text(
                      "Accept".toUpperCase(),
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: "Montserrat",

                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  acceptRideRequest(BuildContext context)
  {
    String getRideRequestId="";
    FirebaseDatabase.instance.ref()
        .child("drivers")
        .child(currentFirebaseUser.uid)
        .child("newRideStatus")
        .once()
        .then((snap)
    {
      if(snap.snapshot.value != null)
      {
        getRideRequestId = snap.snapshot.value.toString();
      }
      else
      {
        Fluttertoast.showToast(msg: "This ride request do not exists.");
      }

      if(getRideRequestId == widget.userRideRequestDetails!.rideRequestId)
      {
        FirebaseDatabase.instance.ref()
            .child("drivers")
            .child(currentFirebaseUser.uid)
            .child("newRideStatus")
            .set("accepted");

        AssistantMethods.pauseLiveLocationUpdates();

        //trip started now - send driver to new tripScreen
        Navigator.push(context, MaterialPageRoute(builder: (c)=> NewTripScreen(
          userRideRequestDetails: widget.userRideRequestDetails,
        )));
      }
      else
      {
        Fluttertoast.showToast(msg: "This Ride Request do not exists.");
      }
    });
  }
}
