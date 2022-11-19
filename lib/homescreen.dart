import 'dart:async';
import 'package:ehatid_driver_app/geofire_assistant.dart';
import 'package:ehatid_driver_app/active_nearby_available_passengers.dart';
import 'package:ehatid_driver_app/progress_dialog.dart';
import 'package:ehatid_driver_app/push_notification_system.dart';
import 'package:ehatid_driver_app/user_ride_request_information.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import 'app_info.dart';
import 'assistant_methods.dart';
import 'confirm_dialog.dart';
import 'global.dart';


class HomePage extends StatefulWidget {
  UserRideRequestInformation? userRideRequestDetails;
  HomePage({
    this.userRideRequestDetails,
  });

  @override
  _HomePageState createState() => _HomePageState();
}


class _HomePageState extends State<HomePage>
{
  Completer<GoogleMapController> _controllerGoogleMap = Completer();
  GoogleMapController? newGoogleMapController;
  final currentFirebaseUser = FirebaseAuth.instance.currentUser!;
  final panelController = PanelController();

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(13.7731, 121.0484),
    zoom: 16,
  );

  GlobalKey<ScaffoldState> sKey = GlobalKey<ScaffoldState>();

  var geoLocator = Geolocator();

  LocationPermission? _locationPermission;

  List<LatLng> pLineCoOrdinatesList = [];
  Set<Polyline> polyLineSet = {};

  Set<Marker> markersSet = {};

  bool activeNearbyDriverKeysLoaded = false; //Activedrivers code
  bool activeNearbyPassengerKeysLoaded = false; //Activepassenger code
  bool isVisible = true;
  bool dialog = false;

  DatabaseReference? referenceRideRequest;

  double waitingResponseFromPassengerContainerHeight = 0;
  double assignedPassengerInfoContainerHeight = 0;

  static const double OnlineGo = 130;
  double GoOnlineHeight = OnlineGo;
  double mapPadding = 0;

  checkIfLocationPermissionAllowed() async
  {
    _locationPermission = await Geolocator.requestPermission();

    if(_locationPermission == LocationPermission.denied)
    {
      _locationPermission = await Geolocator.requestPermission();
    }
  }

  locateUserPosition() async {
    Position cPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    driverCurrentPosition = cPosition;

    LatLng latLngPosition = LatLng(driverCurrentPosition!.latitude, driverCurrentPosition!.longitude);

    CameraPosition cameraPosition = CameraPosition(target: latLngPosition, zoom: 14);

    newGoogleMapController!.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    String humanReadableAddress = await AssistantMethods.searchAddressForGeographicCoordinates(driverCurrentPosition!, context);
    print("this is your address =" + humanReadableAddress);

    AssistantMethods.readDriverRatings(context);

    initializeGeoFireListener(); //Active Passengers
  }

  readCurrentDriverInformation() async
  {
    FirebaseDatabase.instance.ref()
        .child("drivers")
        .child(currentFirebaseUser.uid)
        .once()
        .then((snap)
    {
      if(snap.snapshot.value != null)
      {
        onlineDriverData.id = (snap.snapshot.value as Map)["id"];
        onlineDriverData.first_name = (snap.snapshot.value as Map)["first_name"];
        onlineDriverData.last_name = (snap.snapshot.value as Map)["last_name"];
        onlineDriverData.username = (snap.snapshot.value as Map)["username"];
        onlineDriverData.phone = (snap.snapshot.value as Map)["phone"];
        onlineDriverData.email = (snap.snapshot.value as Map)["email"];
        onlineDriverData.birthdate = (snap.snapshot.value as Map)["birthdate"];
        onlineDriverData.password = (snap.snapshot.value as Map)["password"];
        onlineDriverData.plateNum = (snap.snapshot.value as Map)["plateNum"];
        onlineDriverData.licenseNum = (snap.snapshot.value as Map)["licenseNum"];
        onlineDriverData.ratings = (snap.snapshot.value as Map)["ratings"];
      }
    });

    PushNotificationSystem pushNotificationSystem = PushNotificationSystem();
    pushNotificationSystem.initializeCloudMessaging(context);
    pushNotificationSystem.generateAndGetToken();

    AssistantMethods.readDriverEarnings(context);
    AssistantMethods.readKeysForOnlinePassengers(context);
  }

  @override
  void initState() {
    super.initState();
    //_setMarker(LatLng(37.42796133580664, -122.085749655962));
    checkIfLocationPermissionAllowed();
    readCurrentDriverInformation();
    print("showing stuff");
    print(dList);
    print(onlineNearbyAvailablePassengersList);
  }

  @override
  Widget build(BuildContext context)
  {
    final paneHeightClosed = MediaQuery.of(context).size.height * 0.19;
    final paneHeightOpen = MediaQuery.of(context).size.height * 0.191;

    return Theme(
      data: Theme.of(context).copyWith(canvasColor: Color(0xFFFFFCEA)),
      child: Scaffold(
        backgroundColor: Color(0xFFEBE5D8),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text(
            "Home",
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Color(0xFFFED90F),
        ),
        body: Stack(
          children: [
            GoogleMap(
              padding: EdgeInsets.only(bottom: mapPadding),
              mapType: MapType.normal,
              myLocationEnabled: true,
              zoomGesturesEnabled: true,
              zoomControlsEnabled: true,
              initialCameraPosition: _kGooglePlex,
              polylines: polyLineSet,
              markers: markersSet,
              onMapCreated: (GoogleMapController controller) {
                _controllerGoogleMap.complete(controller);
                newGoogleMapController = controller;

                setState(() {
                  mapPadding = 18.h;
                });

                locateUserPosition();
              },
            ),
            //ui for online offline driver
            statusText != "Go Offline"
                ? Container(
              height: MediaQuery.of(context).size.height,
              width: double.infinity,
              color: Colors.black87,
            )
                : Container(),

            //button for online offline driver
            Positioned(
              top: statusText != "Go Offline"
                  ? 40.h
                  : 25,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: ()
                    {
                      if(isDriverActive != true) //offline
                        {
                        driverIsOnlineNow();
                        locateUserPosition();
                        //updateDriversLocationAtRealTime();

                        setState(() {
                          statusText = "Go Offline";
                          isDriverActive = true;
                          buttonColor = Colors.redAccent;
                          passengerButtonColor = Color(0xFF0CBC8B);
                        });

                        //display Toast
                        Fluttertoast.showToast(msg: "You're Now Online");
                      }
                      else //online
                      {
                        driverIsOfflineNow();

                        setState(() {
                          statusText = "Go Online";
                          isDriverActive = false;
                          buttonColor = Color(0xFF0CBC8B);
                          passengerButtonColor = Color(0x4D0CBC8B);
                        });

                        //display Toast
                        Fluttertoast.showToast(msg: "You're Now Offline");
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: buttonColor,
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(26),
                      ),
                    ),
                    child: statusText != "Go Offline"
                        ? Text(
                      statusText,
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    )
                        : const Icon(
                      Icons.phonelink_erase_rounded,
                      color: Colors.white,
                      size: 26,
                    ),
                  ),
                ],
              ),
            ),

            if (statusText != "Go Online")
              SlidingUpPanel(
                controller: panelController,
                minHeight: paneHeightClosed,
                maxHeight: paneHeightOpen,
                parallaxEnabled: true,
                parallaxOffset: 0.5,
                color: Color(0xFFFED90F),
                onPanelSlide: (position) => setState(() {

                }),

                panelBuilder: (controller) => PanelWidget(
                  controller: controller,
                  panelController: panelController,
                ),
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),

            if (statusText != "Go Online")
              ElevatedButton(
                onPressed: ()
                {
                  Fluttertoast.showToast(msg: "Refreshed");
                  locateUserPosition();
                  checkIfLocationPermissionAllowed();
                  readCurrentDriverInformation();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(26),
                  ),
                ),
                child: Icon(
                  Icons.refresh_rounded,
                  color: Colors.white,
                  size: 26,
                ),
              ),

            if (statusText != "Go Online")
              Positioned(
                bottom: 20.h,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: ()
                      {
                        if(isDriverActive != true) //offline
                        {
                          Fluttertoast.showToast(msg: "You're Still Offline");
                        }
                        else
                        {
                          pList.clear();
                          onlineNearbyAvailablePassengersList = GeoFireAssistant.activeNearbyAvailablePassengersList;
                          searchNearestOnlinePassengers();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: passengerButtonColor,
                        elevation: 1.h,
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(26),
                        ),
                      ),
                      child: Icon(
                        Icons.emoji_people_rounded,
                        color: Colors.white,
                        size: 26,
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


  //Section 17: Para Mapalabas ang ACTIVE
  initializeGeoFireListener() {
    Geofire.initialize("activePassengers");
    Geofire.queryAtLocation(
        driverCurrentPosition!.latitude, driverCurrentPosition!.longitude, 5)! //km radius na nakikita
        .listen((map) {
      print(map);
      if (map != null) {
        var callBack = map['callBack'];

        //latitude will be retrieved from map['latitude']
        //longitude will be retrieved from map['longitude']

        switch (callBack)
            {
          case Geofire.onKeyEntered: //whenever any driver become active or online
            ActiveNearbyAvailablePassengers activeNearbyAvailablePassengers = ActiveNearbyAvailablePassengers();
            activeNearbyAvailablePassengers.locationLatitude = map['latitude'];
            activeNearbyAvailablePassengers.locationLongitude = map['longitude'];
            activeNearbyAvailablePassengers.passengerId = map['key'];
            GeoFireAssistant.activeNearbyAvailablePassengersList.add(activeNearbyAvailablePassengers);
            if(activeNearbyPassengerKeysLoaded == true)
            {
              displayActivePassengersOnUsersMap();
            }
            break;

          case Geofire.onKeyExited: //whenever any driver become non-active or offline
            GeoFireAssistant.deleteOfflinePassengerFromList(map['key']);
            break;

        //whenever the driver moves - update driver location
          case Geofire.onKeyMoved:
            ActiveNearbyAvailablePassengers activeNearbyAvailablePassengers = ActiveNearbyAvailablePassengers();
            activeNearbyAvailablePassengers.locationLatitude = map['latitude'];
            activeNearbyAvailablePassengers.locationLongitude = map['longitude'];
            activeNearbyAvailablePassengers.passengerId = map['key'];
            GeoFireAssistant.updateActiveNearbyAvailableDriveLocation(activeNearbyAvailablePassengers);
            displayActivePassengersOnUsersMap();
            break;

        //display those online drivers on users map
          case Geofire.onGeoQueryReady:
            displayActivePassengersOnUsersMap();
            break;
        }
      }

      if (mounted) setState(() {});
    });
  }

  sendNotificationToDriverNow(String chosenPassengerId)
  {
    //assign RideRequestId to newRideStatus in Drives Parent node for that specific chosen driver
    FirebaseDatabase.instance.ref()
        .child("drivers")
        .child(chosenPassengerId)
        .child("newRideStatus")
        .set(referenceRideRequest!.key);

    //automate the push notifications
    FirebaseDatabase.instance.ref()
        .child("drivers")
        .child(chosenPassengerId)
        .child("token")
        .once().then((snap)
    {
      if(snap.snapshot.value != null)
      {
        String deviceRegistrationToken = snap.snapshot.value.toString();

        //send notification now
        AssistantMethods.sendNotificationToDriverNow(
          deviceRegistrationToken,
          referenceRideRequest!.key.toString(),
          context,
        );

        Fluttertoast.showToast(msg: "Notification sent successfully.");
      }
      else
      {
        Fluttertoast.showToast(msg: "Please choose another driver.");
        return;
      }
    });

  }

  retrieveOnlinePassengersInformation(List onlineNearestPassengersList) async
  {
    Object? empty = "";
    DatabaseReference ref = FirebaseDatabase.instance.ref().child("passengers");
    for(int i = 0; i<onlineNearestPassengersList.length; i++)
    {
      await ref.child(onlineNearestPassengersList[i].passengerId.toString())
          .once()
          .then((dataSnapshot)
      {
        var passengerKeyInfo = dataSnapshot.snapshot.value;
        if (passengerKeyInfo.toString() == empty.toString())
        {
          print("Same lang");
          return null;
        }
        else
        {
          empty = passengerKeyInfo;
          dList.add(passengerKeyInfo);
          print("passengerKey Info: " + dList.toString());
        }
      });
    }
  }

  displayActivePassengersOnUsersMap()
  {
    if (mounted) setState(() async {
      markersSet.clear();

      Set<Marker> driversMarketSet = Set<Marker>();

      for(ActiveNearbyAvailablePassengers eachPassenger in GeoFireAssistant.activeNearbyAvailablePassengersList)
      {
        LatLng eachPassengerActivePosition = LatLng(eachPassenger.locationLatitude!, eachPassenger.locationLongitude!);

        BitmapDescriptor passengerIcon = await BitmapDescriptor.fromAssetImage(
          ImageConfiguration(),
          "assets/images/passengerMarker.png",
        );

        Marker marker = Marker(
          markerId: MarkerId(eachPassenger.passengerId!),
          position: eachPassengerActivePosition,
          icon: passengerIcon,
          rotation: 360,
        );

        driversMarketSet.add(marker);
      }

      setState(() {
        markersSet = driversMarketSet;
      });
    });
  }

  driverIsOnlineNow() async
  {
    DatabaseReference ref = FirebaseDatabase.instance.ref()
        .child("drivers")
        .child(currentFirebaseUser.uid)
        .child("newRideStatus");

    ref.set("idle"); //searching for ride request
    ref.onValue.listen((event) { });
  }

  driverIsOfflineNow()
  {
    Geofire.removeLocation(currentFirebaseUser.uid);

    DatabaseReference? ref = FirebaseDatabase.instance.ref()
        .child("drivers")
        .child(currentFirebaseUser.uid)
        .child("newRideStatus");
    ref.onDisconnect();
    ref.remove();
    ref = null;
  }

  searchNearestOnlinePassengers() async
  {
    //no active driver available
    if(onlineNearbyAvailablePassengersList.length == 0)
    {
      //cancel/delete the ride request
      //referenceRideRequest!.remove();

      setState(() {
        polyLineSet.clear();
        markersSet.clear();
        pLineCoOrdinatesList.clear();
      });

      Fluttertoast.showToast(msg: "No Online Nearby Passengers");
      return;
    }

    //there are active drivers available
    setState(() {
      readUserInformation(context);
    });
  }

  readUserInformation(BuildContext context) async
  {
    var passengerListKeys = Provider.of<AppInfo>(context, listen: false).activePassengerList;
    print ("passenger list: " + passengerListKeys.toString());

    for(String eachPassengerKey in passengerListKeys)
    {
      FirebaseDatabase.instance.ref()
          .child("All Ride Requests")
          .child(eachPassengerKey)
          .once()
          .then((snapData)
      {
        if(snapData.snapshot.value != null)
        {
          var passengerRequestInfo = snapData.snapshot.value;

          setState(() {
            pList.add(passengerRequestInfo);
          });
          print("pList: " + pList.toString());

          double originLat = double.parse((snapData.snapshot.value! as Map)["origin"]["latitude"]);
          double originLng = double.parse((snapData.snapshot.value! as Map)["origin"]["longitude"]);
          String originAddress = (snapData.snapshot.value! as Map)["originAddress"];
          passengerOriginLatLng = LatLng(originLat, originLng);

          double destinationLat = double.parse((snapData.snapshot.value! as Map)["destination"]["latitude"]);
          double destinationLng = double.parse((snapData.snapshot.value! as Map)["destination"]["longitude"]);
          String destinationAddress = (snapData.snapshot.value! as Map)["destinationAddress"];

          String userName = (snapData.snapshot.value! as Map)["username"];
          String userId = (snapData.snapshot.value! as Map)["id"];
          // String userPhone = (snapData.snapshot.value! as Map)["phone"];

          String? rideRequestId = snapData.snapshot.key;

          UserRideRequestInformation userRideRequestDetails = UserRideRequestInformation();

          userRideRequestDetails.originLatLng = LatLng(originLat, originLng);
          userRideRequestDetails.originAddress = originAddress;

          userRideRequestDetails.destinationLatLng = LatLng(destinationLat, destinationLng);
          userRideRequestDetails.destinationAddress = destinationAddress;

          userRideRequestDetails.userName = userName;
          userRideRequestDetails.userId = userId;
          // userRideRequestDetails.userPhone = userPhone;

          userRideRequestDetails.rideRequestId = rideRequestId;
        }
        else
        {
          Fluttertoast.showToast(msg: "Unknown error occurred. Please refresh.");
        }
      });
    }

    Timer(const Duration(seconds: 1), (){
      setState(() {
        showListOfPassengers();
      });
    });
  }

  showListOfPassengers()
  {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => ConfirmDialogBox(),
    );
  }
}

class PanelWidget extends StatelessWidget {
  final ScrollController controller;
  final PanelController panelController;

  const PanelWidget({
    Key? key,
    required this.controller,
    required this.panelController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => ListView(
    padding: EdgeInsets.zero,
    controller: controller,
    children: <Widget>[
      SizedBox(height: 5),
      buildAboutText(context),
    ],
  );

  Widget buildAboutText(BuildContext context) => Container(
    child: Center(
      child: Column(
        children: <Widget>[
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: SizedBox(
              width: 320,
              height: 30,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.circle,
                          size: 20,
                          color: Color(0xFF0CBC8B),
                        ),
                        SizedBox(width: 5),
                        Text(
                          'You’re online.',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 12,
                            letterSpacing: -0.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: SizedBox(
                  width: 180,
                  height: 60,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.monetization_on,
                              size: 40,
                              color: Color(0xFF0CBC8B),
                            ),
                            SizedBox(width: 5),
                            Column(
                              children: <Widget>[
                                Text('Earning Balance:',
                                  style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize: 13,
                                    fontWeight: FontWeight.w200,
                                  ),
                                ),
                                SizedBox(height: 2),
                                Row(
                                  children: <Widget>[
                                    Text(
                                      "₱ " + Provider.of<AppInfo>(context, listen: false).driverTotalEarnings,
                                      style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontSize: 13,
                                        fontWeight: FontWeight.w200,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: SizedBox(
                  width: 130,
                  height: 60,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(width: 5),
                            Column(
                              children: <Widget>[
                                Text('Total Trips',
                                  style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize: 13,
                                    fontWeight: FontWeight.w200,
                                  ),
                                ),
                                Row(
                                  children: <Widget>[
                                    Text(
                                      Provider.of<AppInfo>(context, listen: false).allTripsHistoryInformationList.length.toString(),
                                      style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontSize: 32,
                                        color: Color(0xFFCCCCCC),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );

  void togglePanel() => panelController.isPanelOpen
      ? panelController.close()
      : panelController.open();
}