import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:ehatid_driver_app/confirm_dialog.dart';
import 'package:ehatid_driver_app/navigation_bar.dart';
import 'package:ehatid_driver_app/passenger_design_ui.dart';
import 'package:ehatid_driver_app/passengers_list_model.dart';
import 'package:ehatid_driver_app/user_ride_request_information.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:smooth_star_rating_nsafe/smooth_star_rating.dart';

import 'app_info.dart';
import 'assistant_methods.dart';
import 'global.dart';
import 'new_trip_screen.dart';

class SelectNearestActiveDriversScreen extends StatefulWidget
{

  DatabaseReference? referenceRideRequest;
  UserRideRequestInformation? userRideRequestDetails;

  SelectNearestActiveDriversScreen({this.referenceRideRequest, this.userRideRequestDetails});

  @override
  State<SelectNearestActiveDriversScreen> createState() => _SelectNearestActiveDriversScreenState();
}

class _SelectNearestActiveDriversScreenState extends State<SelectNearestActiveDriversScreen>
{
  final currentFirebaseUser = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      backgroundColor: Color(0xFFFFFCEA),
      appBar: AppBar(
        backgroundColor: Color(0xFFFED90F),
        title: const Text(
            "Nearby Passengers Available"
        ),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: ()
          {
            Provider.of<AppInfo>(context, listen: false).passengerInformationList.clear();
            Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (_) => Navigation(index: 0,),
            ),
            );
          },
        ),
      ),
      body: ListView.separated(
        separatorBuilder: (context, i)=> const Divider(
          color: Colors.grey,
          thickness: 2,
          height: 2,
        ),
        itemBuilder: (context, i)
        {
          return GestureDetector(
            onTap: ()
            {
            },
            child: Card(
              color: Colors.white54,
              child: PassengerDesignUIWidget(
                passengersListModel: Provider.of<AppInfo>(context, listen: false).passengerInformationList[i],
              ),
            ),
          );
        },
        itemCount: Provider.of<AppInfo>(context, listen: false).passengerInformationList.length,
        physics: const ClampingScrollPhysics(),
        shrinkWrap: true,
      ),
    );
  }

  readUserInformation(BuildContext context)
  {
    var passengerListKeys = Provider.of<AppInfo>(context, listen: false).activePassengerList;

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
          //audioPlayer.open(Audio("assets/music/boom_tarat_tarat.mp3"));
          //audioPlayer.play();

          double originLat = double.parse((snapData.snapshot.value! as Map)["origin"]["latitude"]);
          double originLng = double.parse((snapData.snapshot.value! as Map)["origin"]["longitude"]);
          String originAddress = (snapData.snapshot.value! as Map)["originAddress"];

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

          setState(() {
            chosenPassengerId = userId;
          });

          showDialog(
            context: context,
            builder: (BuildContext context) => ConfirmDialogBox(
              userRideRequestDetails: userRideRequestDetails,
            ),
          );
        }
        else
        {
          Fluttertoast.showToast(msg: "This Ride Request Id do not exist.");
        }
      });
    }
  }
}

/**class ActiveDriver extends StatefulWidget {
  const ActiveDriver({Key? key}) : super(key: key);

  @override
  State<ActiveDriver> createState() => _ActiveDriverState();
}

class _ActiveDriverState extends State<ActiveDriver> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(19)
        ),
        child: Container(
          height: 45.h,
          width: 150.w,
          child: Column(
            children: [
              Container(
                height: 8.5.h,
                decoration: BoxDecoration(
                  color: Color(0XFF0CBB8A),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                ),
                child: SizedBox.expand(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text("Passengers Near You",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        color: Colors.white,
                        fontSize: 19.sp,
                        letterSpacing: -0.5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: dList.length,
                  itemBuilder: (BuildContext context, int index)
                  {
                    return Card(
                      color: Colors.grey,
                      elevation: 3,
                      shadowColor: Colors.green,
                      margin: EdgeInsets.all(8),
                        child: ListTile(
                          leading:Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Icon(
                              Icons.account_circle_outlined,
                              size: 26.sp,
                              color: Color(0xFF777777),
                            ),
                          ),
                          title: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                dList[index]["name"],
                              ),
                            ],
                          ),
                        ),
                    );
                  },
                ),
              ),
              MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50)
                ),
                minWidth: Adaptive.w(40),
                child: Text("Cancel", style: TextStyle( color: Colors.white,
                  fontSize: 15,
                  fontFamily: "Montserrat",
                  fontWeight: FontWeight.w600,),),
                color: Color(0XFF0CBC8B),
                onPressed: () async
                {
                  //remove or delete the ride request from the database
                  SystemNavigator.pop();
                },
              ),
            ],
          ),
        )
    );
  }
}
**/