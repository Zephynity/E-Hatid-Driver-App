import 'dart:async';

import 'package:ehatid_driver_app/assistant_methods.dart';

import 'package:ehatid_driver_app/new_trip_screen.dart';
import 'package:ehatid_driver_app/progress_dialog.dart';
import 'package:ehatid_driver_app/user_ride_request_information.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'global.dart';

class ConfirmDialogBox extends StatefulWidget
{
  UserRideRequestInformation? userRideRequestDetails;

  ConfirmDialogBox({this.userRideRequestDetails});

  @override
  State<ConfirmDialogBox> createState() => _ConfirmDialogBoxState();
}


class _ConfirmDialogBoxState extends State<ConfirmDialogBox>
{
  final currentFirebaseUser = FirebaseAuth.instance.currentUser!;

  var geoLocator = Geolocator();
  Position? onlineDriverCurrentPosition;

  @override
  void dispose() {
    print("disposing stuff");
    super.dispose();
    pList = [];
  }

  @override
  Widget build(BuildContext dialogContext)
  {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(40),
      ),
      backgroundColor: Colors.transparent,
      elevation: 2,
      child: Container(
        height: 80.h,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
        ),
        child: Column(
          children: [
            Container(
              height: 8.5.h,
              decoration: BoxDecoration(
                color: Color(0XFF0CBB8A),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: SizedBox.expand(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Passengers Near You",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        color: Colors.white,
                        fontSize: 20.sp,
                        letterSpacing: -0.5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Expanded(
              child: ListView.builder(
                itemCount: pList.length,
                itemBuilder: (BuildContext context, int index)
                {
                  return GestureDetector(
                    onTap: ()
                    {
                      showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext c)
                          {
                            return ProgressDialog(message: "Processing, Please wait...",);
                          }
                      );
                      setState(() {
                        chosenPassengerId = pList[index]["requestId"].toString();
                        chosenPassengerStatus = pList[index]["newRideStatus"].toString();
                        chosenPassengerDriverId = pList[index]["driverId"].toString();
                        chosenPassengerUsername = pList[index]["username"].toString();
                        chosenPassengerOriginAddress = pList[index]["originAddress"].toString();
                        chosenPassengerDestinationAddress = pList[index]["destinationAddress"].toString();
                        double chosenPassengerOriginLat = double.parse(pList[index]["origin"]["latitude"]);
                        double chosenPassengerOriginLng = double.parse(pList[index]["origin"]["longitude"]);
                        chosenPassengerOriginLatLng = LatLng(chosenPassengerOriginLat, chosenPassengerOriginLng);
                        double chosenPassengerDestinationLat = double.parse(pList[index]["destination"]["latitude"]);
                        double chosenPassengerDestinationLng = double.parse(pList[index]["destination"]["longitude"]);
                        chosenPassengerDestinationLatLng = LatLng(chosenPassengerDestinationLat, chosenPassengerDestinationLng);
                        print("Passenger Id: " + chosenPassengerId.toString());
                        print("Passenger LatLng: " + chosenPassengerOriginLatLng.toString());
                        print("pList Value: " + pList[index]["requestId"].toString());
                        print("Passenger State: " + chosenPassengerStatus!);

                        FirebaseDatabase.instance.ref()
                            .child("All Ride Requests")
                            .child(chosenPassengerId.toString())
                            .once()
                            .then((snap)
                        {
                          print("Snap: " + snap.snapshot.value.toString());
                          if(snap.snapshot.value != null)
                          {
                            Map<dynamic, dynamic> values = snap.snapshot.value as Map<dynamic, dynamic>;
                            if(values['newRideStatus'] == null)
                            {
                              print("Success");

                              // Response from the driver
                              FirebaseDatabase.instance.ref()
                                  .child("All Ride Requests")
                                  .child(chosenPassengerId.toString())
                                  .child("newRideStatus")
                                  .set("accepted");

                              FirebaseDatabase.instance.ref()
                                  .child("All Ride Requests")
                                  .child(chosenPassengerId.toString())
                                  .child("newRideStatus")
                                  .onValue.listen((eventSnapshot)
                              {

                                //accept the ride request push notification
                                //(newRideStatus = accepted)
                                if(eventSnapshot.snapshot.value == "accepted")
                                {
                                  //design and display ui for displaying driver information
                                  rideRequest(context);
                                  print("accepted");
                                }
                              });
                            }
                            else
                            {
                              print("Something went wrong");
                              Fluttertoast.showToast(msg: "This passenger is already taken. Try again.");
                            }
                          }
                        });
                      });
                      // Navigator.pop(context, "passengerChoosed");
                    },

                    child: Card(
                      color: Color(0xFFFFFCEA),
                      elevation: 3,
                      shadowColor: Colors.green,
                      margin: EdgeInsets.all(8.0),
                      child: ListTile(
                        title: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [

                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 6.0),
                                  child: Container(
                                    child: Text(
                                      pList[index]["username"],
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontSize: 14,
                                        color: Color(0xFF272727),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),

                                Icon(
                                  Icons.verified_rounded,
                                  color: Color(0xFF0CBC8B),
                                ),

                                Spacer(),

                                Padding(
                                  padding: const EdgeInsets.only(right: 6.0),
                                  child: Container(
                                    child: Text(
                                      pList[index]["distance"],
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontSize: 15,
                                        color: Color(0xFF0CBC8B),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: 1.h,),

                            //icon + pickup
                            Container(
                              width: 90.w,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [

                                  Image.asset(
                                    "assets/images/origin.png",
                                    height: 26,
                                    width: 26,
                                  ),

                                  const SizedBox(width: 12,),

                                  Expanded(
                                    child: Container(
                                      child: Text(
                                        pList[index]["originAddress"],
                                        style: const TextStyle(
                                          fontFamily: 'Montserrat',
                                          fontSize: 14,
                                          color: Color(0xFF272727),
                                        ),
                                      ),
                                    ),
                                  ),

                                ],
                              ),
                            ),

                            SizedBox(height: 1.h,),

                            Container(
                              width: 90.w,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [

                                  Image.asset(
                                    "assets/images/destination.png",
                                    height: 26,
                                    width: 26,
                                  ),

                                  const SizedBox(width: 12,),

                                  Expanded(
                                    child: Container(
                                      child: Text(
                                        pList[index]["destinationAddress"],
                                        style: const TextStyle(
                                          fontFamily: 'Montserrat',
                                          fontSize: 14,
                                          color: Color(0xFF272727),
                                        ),
                                      ),
                                    ),
                                  ),

                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            Container(
              height: 10.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 17, horizontal: 20),
                child: MaterialButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50)
                  ),
                  minWidth: Adaptive.w(60),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Cancel", style: TextStyle( color: Colors.white,
                        fontSize: 15,
                        fontFamily: "Montserrat",
                        fontWeight: FontWeight.w600,),),
                    ],
                  ),
                  color: Color(0XFFCD4C3A),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  rideRequest(BuildContext context)
  {
    String getRideRequestId="";
    FirebaseDatabase.instance.ref()
        .child("drivers")
        .child(currentFirebaseUser.uid)
        .child("newRideStatus")
        .set(chosenPassengerId.toString());

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
        Fluttertoast.showToast(msg: "Passenger already taken.");
      }

      if(getRideRequestId == chosenPassengerId.toString())
      {
        FirebaseDatabase.instance.ref()
            .child("drivers")
            .child(currentFirebaseUser.uid)
            .child("newRideStatus")
            .set("accepted");

        Fluttertoast.showToast(msg: "Accepted Successfully.");
        //trip started now - send driver to new tripScreen
        Timer(const Duration(seconds: 2),(){
          Navigator.push(context, MaterialPageRoute(builder: (c)=> NewTripScreen()));
        });
      }
      else
      {
        Fluttertoast.showToast(msg: "This Ride Request do not exists.");
      }
    });
  }

  getPassengerDistanceFromDriver()
  async {
    print("Testing");
    Position cPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    onlineDriverCurrentPosition = cPosition;

    var originLatLng = LatLng(
      onlineDriverCurrentPosition!.latitude,
      onlineDriverCurrentPosition!.longitude,
    );

    var directionInformation = await AssistantMethods.obtainOriginToDestinationDirectionDetails(originLatLng, chosenPassengerOriginLatLng!);

    if(directionInformation != null)
    {
      setState(() {
        distanceFromDriverToPassenger = directionInformation.distance_text!;
      });
    }
  }
}
