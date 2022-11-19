import 'dart:async';

import 'package:ehatid_driver_app/accept_decline.dart';
import 'package:ehatid_driver_app/assistant_methods.dart';
import 'package:ehatid_driver_app/fare_amount_dialog.dart';
import 'package:ehatid_driver_app/global.dart';
import 'package:ehatid_driver_app/passenger_cancelled.dart';
import 'package:ehatid_driver_app/progress_dialog.dart';
import 'package:ehatid_driver_app/user_ride_request_information.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:supercharged/supercharged.dart';

class NewTripScreen extends StatefulWidget
{
  UserRideRequestInformation? userRideRequestDetails;
  NewTripScreen({
    this.userRideRequestDetails,
  });

  @override
  State<NewTripScreen> createState() => _NewTripScreenState();
}

class _NewTripScreenState extends State<NewTripScreen>
{
  final currentFirebaseUser = FirebaseAuth.instance.currentUser!;
  Completer<GoogleMapController> _controllerGoogleMap = Completer();
  GoogleMapController? newTripGoogleMapController;

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(13.7731, 121.0484),
    zoom: 16,
  );

  String? buttonTitle = "Arrived";
  Color? buttonColor = Color(0xFF0CBC8B);
  bool buttonPress = false;

  Set<Marker> setOfMarkers = Set<Marker>();
  Set<Circle> setOfCircle = Set<Circle>();
  Set<Polyline> setOfPolyline = Set<Polyline>();
  List<LatLng> polyLinePositionCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();

  double mapPadding = 0;
  double? rotate;
  BitmapDescriptor? iconAnimatedMarker;
  var geoLocator = Geolocator();
  Position? onlineDriverCurrentPosition;

  String rideRequestStatus = "accepted";

  String durationFromOriginToDestination = "";

  bool isRequestDirectionDetails = false;


  //Step 1. When driver accepts the user ride request
  // originLatLng = driverCurrentPosition
  // destinationLatLng = userPickUpLocation

  //Step 2. driver already picked up the user in his/her car.
  // originLatLng = userPickUpLocation
  // destinationLatLng = userDropOffLocation
  Future<void> drawPolyLineFromSourceToDestination(LatLng originLatLng, LatLng destinationLatLng) async
  {
    BookingSuccessDialog();

    var directionDetailsInfo = await AssistantMethods.obtainOriginToDestinationDirectionDetails(originLatLng, destinationLatLng);

    //Navigator.of(context, rootNavigator: true).pop(context);

    print("These are points: ");
    print(directionDetailsInfo!.e_points!);

    //Decoding of points

    PolylinePoints pPoints = PolylinePoints();
    List<PointLatLng> decodedPolyLinePointsResultList = pPoints.decodePolyline(directionDetailsInfo.e_points!);

    polyLinePositionCoordinates.clear();

    if(decodedPolyLinePointsResultList.isNotEmpty)
    {
      decodedPolyLinePointsResultList.forEach((PointLatLng pointLatLng)
      {
        polyLinePositionCoordinates.add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
      });
    }

    setOfPolyline.clear();

    setState(() {
      Polyline polyline = Polyline(
        color: Color(0xFF0CBC8B),
        polylineId: const PolylineId("PolylineID"),
        jointType: JointType.round,
        points: polyLinePositionCoordinates,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        geodesic: true,
        width: 6,
      );

      setOfPolyline.add(polyline);
    });

    LatLngBounds boundsLatLng;
    if(originLatLng.latitude > destinationLatLng.latitude && originLatLng.longitude > destinationLatLng.longitude)
    {
      boundsLatLng = LatLngBounds(southwest: destinationLatLng, northeast: originLatLng);
    }
    else if(originLatLng.longitude > destinationLatLng.longitude)
    {
      boundsLatLng = LatLngBounds(
        southwest: LatLng(originLatLng.latitude, destinationLatLng.longitude),
        northeast: LatLng(destinationLatLng.latitude, originLatLng.longitude),
      );
    }
    else if(originLatLng.latitude > destinationLatLng.latitude)
    {
      boundsLatLng = LatLngBounds(
        southwest: LatLng(destinationLatLng.latitude, originLatLng.longitude),
        northeast: LatLng(originLatLng.latitude, destinationLatLng.longitude),
      );
    }
    else
    {
      boundsLatLng = LatLngBounds(southwest: originLatLng, northeast: destinationLatLng);
    }

    newTripGoogleMapController!.animateCamera(CameraUpdate.newLatLngBounds(boundsLatLng, 65));

    setState(() async {
      BitmapDescriptor originIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(),
        "assets/images/originMarker.png",
      );

      BitmapDescriptor destinationIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(),
        "assets/images/destinationMarker.png",
      );

      Marker originMarker = Marker(
        markerId: MarkerId("originID"),
        position: originLatLng,
        icon: originIcon,
        infoWindow: const InfoWindow(title: "Starting Point"),
      );

      Marker destinationMarker = Marker(
        markerId: MarkerId("destinationID"),
        position: destinationLatLng,
        icon: destinationIcon,
        infoWindow: const InfoWindow(title: "Destination"),
      );

      setState(() {
        setOfMarkers.add(originMarker);
        setOfMarkers.add(destinationMarker);
      });
    });

    Circle originCircle = Circle(
      circleId: const CircleId("originID"),
      fillColor: Colors.green,
      radius: 5,
      strokeWidth: 3,
      strokeColor: Colors.white,
      center: originLatLng,
    );

    Circle destinationCircle = Circle(
      circleId: const CircleId("destinationID"),
      fillColor: Colors.red,
      radius: 5,
      strokeWidth: 3,
      strokeColor: Colors.white,
      center: destinationLatLng,
    );

    setState(() {
      setOfCircle.add(originCircle);
      setOfCircle.add(destinationCircle);
    });
  }

  @override
  void initState() {
    super.initState();

    saveAssignedDriverDetailsToUserRideRequest();
  }

  createDriverIconMarker()
  {
    if(iconAnimatedMarker == null)
    {
      ImageConfiguration imageConfiguration = createLocalImageConfiguration(context, size: const Size(1, 1));
      BitmapDescriptor.fromAssetImage(imageConfiguration, "assets/images/car1.png").then((value)
      {
        iconAnimatedMarker = value;
      });
    }
  }

  getDriversLocationUpdatesAtRealTime()
  {
    LatLng oldLatLng = LatLng(0, 0);

    streamSubscriptionDriverLivePosition = Geolocator.getPositionStream()
        .listen((Position position)
    {
      driverCurrentPosition = position;
      onlineDriverCurrentPosition = position;

      LatLng latLngLiveDriverPosition = LatLng(
        onlineDriverCurrentPosition!.latitude,
        onlineDriverCurrentPosition!.longitude,
      );

      Marker animatingMarker = Marker(
        markerId: const MarkerId("AnimatedMarker"),
        position: latLngLiveDriverPosition,
        icon: iconAnimatedMarker!,
        infoWindow: const InfoWindow(title: "This is your Position"),
        rotation: onlineDriverCurrentPosition!.heading,
      );

      setState(() {
        CameraPosition cameraPosition = CameraPosition(target: latLngLiveDriverPosition, zoom: 16);
        newTripGoogleMapController!.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

        setOfMarkers.removeWhere((element) => element.markerId.value == "AnimatedMarker");
        setOfMarkers.add(animatingMarker);
      });

      oldLatLng = latLngLiveDriverPosition;
      updateDurationTimeAtRealTime();

      //updating driver location at real time database
      Map driverLatLngDataMap =
      {
        "latitude": onlineDriverCurrentPosition!.latitude.toString(),
        "longitude": onlineDriverCurrentPosition!.longitude.toString(),
      };
      FirebaseDatabase.instance.ref()
          .child("All Ride Requests")
          .child(chosenPassengerId.toString())
          .child("driverLocation")
          .set(driverLatLngDataMap);
    });
  }

  updateDurationTimeAtRealTime() async
  {
    if(isRequestDirectionDetails == false)
    {
      isRequestDirectionDetails = true;

      if(onlineDriverCurrentPosition == null)
      {
        return;
      }

      var originLatLng = LatLng(
        onlineDriverCurrentPosition!.latitude,
        onlineDriverCurrentPosition!.longitude,
      ); //Driver current Location

      var destinationLatLng;

      if(rideRequestStatus == "accepted")
      {
        destinationLatLng = chosenPassengerOriginLatLng; //user PickUp Location
      }
      else //arrived
      {
        destinationLatLng = chosenPassengerDestinationLatLng; //user DropOff Location
      }

      var directionInformation = await AssistantMethods.obtainOriginToDestinationDirectionDetails(originLatLng, destinationLatLng);

      if(directionInformation != null)
      {
        setState(() {
          durationFromOriginToDestination = directionInformation.duration_text!;
        });
      }

      isRequestDirectionDetails = false;

      FirebaseDatabase.instance.ref()
          .child("All Ride Requests")
          .child(chosenPassengerId.toString())
          .child("status")
          .once().then((snap)
      {
        if(snap.snapshot.value != null)
        {
          rideRequestStatus = snap.snapshot.value.toString();
          if(rideRequestStatus == "cancelled")
          {
            FirebaseDatabase.instance.ref()
                .child("All Ride Requests")
                .child(chosenPassengerId.toString())
                .remove();
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) => PassengerCancelledDialog(),
            );
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context)
  {
    createDriverIconMarker();

    return Scaffold(
      body: Stack(
        children: [

          //google map
          GoogleMap(
            padding: EdgeInsets.only(bottom: mapPadding),
            mapType: MapType.normal,
            myLocationEnabled: true,
            zoomGesturesEnabled: true,
            zoomControlsEnabled: true,
            initialCameraPosition: _kGooglePlex,
            markers: setOfMarkers,
            // circles: setOfCircle,
            polylines: setOfPolyline,
            onMapCreated: (GoogleMapController controller) {
              _controllerGoogleMap.complete(controller);
              newTripGoogleMapController = controller;

              setState(() {
                mapPadding = 43.h;
              });

              var driverCurrentLatLng = LatLng(
                  driverCurrentPosition!.latitude,
                  driverCurrentPosition!.longitude
              );

              var userPickUpLatLng = chosenPassengerOriginLatLng;

              drawPolyLineFromSourceToDestination(driverCurrentLatLng, userPickUpLatLng!);

              getDriversLocationUpdatesAtRealTime();
            },
          ),

          //UI
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFFFEDF3F),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(18),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white30,
                    blurRadius: 18,
                    spreadRadius: .5,
                    offset: Offset(0.6, 0.6),
                  ),
                ],
              ),
              child: Column(
                children: [

                  //duration
                  Container(
                    width: 100.w,
                    decoration: BoxDecoration(
                      color: Color(0xFFFFF4B9),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        durationFromOriginToDestination,
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            color: Color(0xFF272727),
                            fontSize: 18.sp,
                            letterSpacing: -1,
                            fontWeight: FontWeight.bold
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),

                  SizedBox(height: 3.h),

                  //user name - icon
                  Container(
                    width: 90.w,
                    decoration: BoxDecoration(
                      color: Color(0xFFFFF0D8),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 1.5.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Passenger: ",
                            style: const TextStyle(
                              fontFamily: "Montserrat",
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF272727),
                            ),
                          ),
                          Text(
                            chosenPassengerUsername.toString(),
                            style: const TextStyle(
                              fontFamily: "Montserrat",
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0CBC8B),
                            ),
                          ),
                          Icon(
                            Icons.verified_rounded,
                            color: Color(0xFF0CBC8B),
                            size: 22.sp,
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 2.h),

                  //user PickUp Address with icon
                  Container(
                    width: 90.w,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                      child: Row(
                        children: [
                          SizedBox(width: 2.w,),

                          Expanded(
                            child: Container(
                              child: Text(
                                chosenPassengerOriginAddress.toString(),
                                style: const TextStyle(
                                  fontFamily: "Montserrat",
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),

                          SizedBox(width: 5.w,),

                          Image.asset(
                            "assets/images/origin.png",
                            width: 11.w,
                            height: 11.w,
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 1.5.h),

                  //user DropOff Address with icon
                  Container(
                    width: 90.w,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                      child: Row(
                        children: [
                          SizedBox(width: 2.w,),

                          Expanded(
                            child: Container(
                              child: Text(
                                chosenPassengerDestinationAddress.toString(),
                                style: const TextStyle(
                                  fontFamily: "Montserrat",
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),

                          SizedBox(width: 5.w,),

                          Image.asset(
                            "assets/images/destination.png",
                            width: 11.w,
                            height: 11.w,
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 1.h),

                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: ElevatedButton.icon(
                      onPressed: () async
                      {
                        //[driver has arrived at user PickUp Location] - Arrived Button
                        if(rideRequestStatus == "accepted")
                        {
                          rideRequestStatus = "arrived";
                          FirebaseDatabase.instance.ref()
                              .child("All Ride Requests")
                              .child(chosenPassengerId.toString())
                              .child("status")
                              .set(rideRequestStatus);

                          setState(() {
                            buttonTitle = "Let's Go"; //start the trip
                            buttonColor = Colors.lightGreen;


                            showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext c)=> ProgressDialog(
                                  message: "Loading...",
                                ),
                            );

                            Navigator.pop(context);
                          });

                          await drawPolyLineFromSourceToDestination(
                            chosenPassengerOriginLatLng!,
                            chosenPassengerDestinationLatLng!,
                          );
                        }
                        //[user has already sit inside the tricycle. Driver start trip] - Lets Go Button
                        else if(rideRequestStatus == "arrived")
                        {
                          rideRequestStatus = "ontrip";
                          FirebaseDatabase.instance.ref()
                              .child("All Ride Requests")
                              .child(chosenPassengerId.toString())
                              .child("status")
                              .set(rideRequestStatus);

                          setState(() {
                            buttonTitle = "End Trip";
                            buttonColor = Color(0xFF525252);
                            Timer(const Duration(seconds: 5), (){
                              setState(() {
                                buttonColor = Color(0xFFC5331E);
                                buttonPress = true;
                              });
                            });//end the trip
                          });
                        }
                        //driver clicking on end trip immediately
                        else if(rideRequestStatus == "ontrip" && buttonPress != true)
                        {
                          Fluttertoast.showToast(msg: "You can't end yet, Please wait.");
                        }
                        //[user/driver reached to the dropOff Destination Location] - End Trip Button
                        else if(rideRequestStatus == "ontrip" && buttonPress == true)
                        {
                          endTripNow();
                        }
                      },
                      icon: Icon(
                        Icons.directions_car,
                        color: Colors.white,
                        size: 8.w,
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: buttonColor,
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(26),
                        ),
                      ),
                      label: Text(
                        buttonTitle!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: "Montserrat",
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  endTripNow() async
  {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context)=> ProgressDialog(
        message: "Ending trip...",
      ),
    );

    //get the tripDirectionDetails = distance travelled
    var currentDriverPositionLatLng = LatLng(
      onlineDriverCurrentPosition!.latitude,
      onlineDriverCurrentPosition!.longitude,
    );

    var tripDirectionDetails = await AssistantMethods.obtainOriginToDestinationDirectionDetails(
      chosenPassengerOriginLatLng!,
      chosenPassengerDestinationLatLng!,
    );

    //fare amount
    double totalFareAmount = AssistantMethods.calculateFareAmountFromOriginToDestination(tripDirectionDetails!);
    if(totalFareAmount == 1)
    {
      FirebaseDatabase.instance.ref()
          .child("fareAmount")
          .child("minAmount")
          .once()
          .then((snap)
      {
        if(snap.snapshot.value != null)
        {
          String fareAmount = snap.snapshot.value.toString();
          totalFareAmount = fareAmount.toDouble()!;

          FirebaseDatabase.instance.ref()
              .child("fareAmount")
              .child("bookingFee")
              .once()
              .then((snapShot)
          {
            String booking = snapShot.snapshot.value.toString();
            bookingFee = booking.toDouble()!;
            totalFareAmount = totalFareAmount + bookingFee;

            FirebaseDatabase.instance.ref()
                .child("All Ride Requests")
                .child(chosenPassengerId.toString())
                .child("fareAmount")
                .set(totalFareAmount.toStringAsFixed(2));

            FirebaseDatabase.instance.ref()
                .child("All Ride Requests")
                .child(chosenPassengerId.toString())
                .child("status")
                .set("ended");

            streamSubscriptionDriverLivePosition!.cancel();

            Navigator.pop(context);

            //display fare amount in dialog box
            showDialog(
              context: context,
              builder: (BuildContext c)=> FareAmountCollectionDialog(
                totalFareAmount: totalFareAmount,
              ),
            );

            //save fare amount to driver total earnings
            saveFareAmountToDriverEarnings(totalFareAmount);
          });
        }
      });
    }

    else if(totalFareAmount == 2)
    {
      FirebaseDatabase.instance.ref()
          .child("fareAmount")
          .child("maxAmount")
          .once()
          .then((snap)
      {
        if(snap.snapshot.value != null)
        {
          String fareAmount = snap.snapshot.value.toString();
          totalFareAmount = fareAmount.toDouble()!;

          FirebaseDatabase.instance.ref()
              .child("fareAmount")
              .child("bookingFee")
              .once()
              .then((snapShot)
          {
            String booking = snapShot.snapshot.value.toString();
            bookingFee = booking.toDouble()!;
            totalFareAmount = totalFareAmount + bookingFee;

            FirebaseDatabase.instance.ref()
                .child("All Ride Requests")
                .child(chosenPassengerId.toString())
                .child("fareAmount")
                .set(totalFareAmount.toStringAsFixed(2));

            FirebaseDatabase.instance.ref()
                .child("All Ride Requests")
                .child(chosenPassengerId.toString())
                .child("status")
                .set("ended");

            streamSubscriptionDriverLivePosition!.cancel();

            Navigator.pop(context);

            //display fare amount in dialog box
            showDialog(
              context: context,
              builder: (BuildContext c)=> FareAmountCollectionDialog(
                totalFareAmount: totalFareAmount,
              ),
            );

            //save fare amount to driver total earnings
            saveFareAmountToDriverEarnings(totalFareAmount);
          });
        }
      });
    }
  }

  saveFareAmountToDriverEarnings(double totalFareAmount)
  {
    FirebaseDatabase.instance.ref()
        .child("drivers")
        .child(currentFirebaseUser.uid)
        .child("earnings")
        .once()
        .then((snap)
    {
      if(snap.snapshot.value != null) //earning sub Child exists
      {
        double oldEarnings = double.parse(snap.snapshot.value.toString());

        FirebaseDatabase.instance.ref()
            .child("fareAmount")
            .child("bookingFee")
            .once()
            .then((snapShot)
        {
          double bookingFee = double.parse(snapShot.snapshot.value.toString());
          double driverTotalEarnings = totalFareAmount + oldEarnings;

          FirebaseDatabase.instance.ref()
              .child("drivers")
              .child(currentFirebaseUser.uid)
              .child("earnings")
              .set(driverTotalEarnings.toStringAsFixed(2));
        });
      }
      else //earning sub Child do not exists
      {
        FirebaseDatabase.instance.ref()
            .child("drivers")
            .child(currentFirebaseUser.uid)
            .child("earnings")
            .set(totalFareAmount.toStringAsFixed(2));
      }
    });
  }

  saveAssignedDriverDetailsToUserRideRequest() async
  {
    var tripDirectionDetails = await AssistantMethods.obtainOriginToDestinationDirectionDetails(
      chosenPassengerOriginLatLng!,
      chosenPassengerDestinationLatLng!,
    );

    //fare amount
    double totalFareAmount = AssistantMethods.calculateFareAmountFromOriginToDestination(tripDirectionDetails!);
    print("Amount Info: " + totalFareAmount.toString());
    if(totalFareAmount == 1)
    {
      FirebaseDatabase.instance.ref()
          .child("fareAmount")
          .child("minAmount")
          .once()
          .then((snap)
      {
        if(snap.snapshot.value != null)
        {
          String fareAmount = snap.snapshot.value.toString();
          totalFareAmount = fareAmount.toDouble()!;

          FirebaseDatabase.instance.ref()
              .child("fareAmount")
              .child("bookingFee")
              .once()
              .then((snapShot)
          {
            String booking = snapShot.snapshot.value.toString();
            bookingFee = booking.toDouble()!;
            totalFareAmount = totalFareAmount + bookingFee;

            DatabaseReference databaseReference = FirebaseDatabase.instance.ref()
                .child("All Ride Requests")
                .child(chosenPassengerId.toString());

            databaseReference.child("fareAmount").set(totalFareAmount.toStringAsFixed(2));
          });
        }
      });
    }

    else if(totalFareAmount == 2)
    {
      FirebaseDatabase.instance.ref()
          .child("fareAmount")
          .child("maxAmount")
          .once()
          .then((snap)
      {
        if(snap.snapshot.value != null)
        {
          String fareAmount = snap.snapshot.value.toString();
          totalFareAmount = fareAmount.toDouble()!;

          FirebaseDatabase.instance.ref()
              .child("fareAmount")
              .child("bookingFee")
              .once()
              .then((snapShot)
          {
            String booking = snapShot.snapshot.value.toString();
            bookingFee = booking.toDouble()!;
            totalFareAmount = totalFareAmount + bookingFee;

            DatabaseReference databaseReference = FirebaseDatabase.instance.ref()
                .child("All Ride Requests")
                .child(chosenPassengerId.toString());

            databaseReference.child("fareAmount").set(totalFareAmount.toStringAsFixed(2));
          });
        }
      });
    }

    DatabaseReference databaseReference = FirebaseDatabase.instance.ref()
        .child("All Ride Requests")
        .child(chosenPassengerId.toString());

    Map driverLocationDataMap =
    {
      "latitude": driverCurrentPosition!.latitude.toString(),
      "longitude": driverCurrentPosition!.longitude.toString(),
    };
    databaseReference.child("driverLocation").set(driverLocationDataMap);

    databaseReference.child("status").set("accepted");
    databaseReference.child("driverId").set(onlineDriverData.id);
    databaseReference.child("driverName").set(onlineDriverData.first_name.toString() + " " + onlineDriverData.last_name.toString());
    databaseReference.child("driverPhone").set(onlineDriverData.phone);
    databaseReference.child("driverPlateNum").set(onlineDriverData.plateNum);
    databaseReference.child("driverRatings").set(onlineDriverData.ratings);
  }

  saveFareAmountToRideRequest() async
  {
    //get the tripDirectionDetails = distance travelled
    // var currentDriverPositionLatLng = LatLng(
    //   onlineDriverCurrentPosition!.latitude,
    //   onlineDriverCurrentPosition!.longitude,
    // );
  }
}
