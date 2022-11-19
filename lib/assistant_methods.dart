import 'dart:convert';

import 'package:ehatid_driver_app/assistants/request_assistant.dart';
import 'package:ehatid_driver_app/global.dart';
import 'package:ehatid_driver_app/global/map_key.dart';
import 'package:ehatid_driver_app/app_info.dart';
import 'package:ehatid_driver_app/models/direction_details_info.dart';
import 'package:ehatid_driver_app/models/directions.dart';
import 'package:ehatid_driver_app/models/user_model.dart';
import 'package:ehatid_driver_app/passengers_list_model.dart';
import 'package:ehatid_driver_app/trips_history_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:supercharged/supercharged.dart';


class AssistantMethods
{
  static sendNotificationToDriverNow(String deviceRegistrationToken, String userRideRequestId, context) async
  {
    String destinationAddress = userDropOffAddress;

    Map<String, String> headerNotification =
    {
      'Content-Type': 'application/json',
      'Authorization': cloudMessagingServerToken,
    };

    Map bodyNotification =
    {
      "body":"Destination Address: \n $destinationAddress.",
      "title":"Found a Driver"
    };

    Map dataMap =
    {
      "click_action": "FLUTTER_NOTIFICATION_CLICK",
      "id": "1",
      "status": "done",
      "rideRequestId": userRideRequestId
    };

    Map officialNotificationFormat =
    {
      "notification": bodyNotification,
      "data": dataMap,
      "priority": "high",
      "to": deviceRegistrationToken,
    };

    var responseNotification = http.post(
      Uri.parse("https://fcm.googleapis.com/fcm/send"),
      headers: headerNotification,
      body: jsonEncode(officialNotificationFormat),
    );
  }

  static Future<String> searchAddressForGeographicCoordinates(Position position, context) async
  {
    String apiUrl = "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$mapKey";
    String humanReadableAddress="";

    var requestResponse = await RequestAssistant.receiveRequest(apiUrl);

    if(requestResponse != "Error Occurred, Failed. No Response.")
    {
      humanReadableAddress = requestResponse["results"][0]["formatted_address"];

      Directions userPickUpAddress = Directions();
      userPickUpAddress.locationLatitude = position.latitude;
      userPickUpAddress.locationLongitude = position.longitude;
      userPickUpAddress.locationName = humanReadableAddress;

      Provider.of<AppInfo>(context, listen: false).updatePickUpLocationAddress(userPickUpAddress);
    }

    return humanReadableAddress;
  }

  static Future<DirectionDetailsInfo?> obtainOriginToDestinationDirectionDetails(LatLng originPosition, LatLng destinationPosition) async
  {
    String urlOriginToDestinationDirectionDetails = "https://maps.googleapis.com/maps/api/directions/json?origin=${originPosition.latitude},${originPosition.longitude}&destination=${destinationPosition.latitude},${destinationPosition.longitude}&key=$mapKey";

    var responseDirectionApi = await RequestAssistant.receiveRequest(urlOriginToDestinationDirectionDetails);

    if(responseDirectionApi == "Error Occurred, Failed. No Response.")
    {
      return null;
    }

    DirectionDetailsInfo directionDetailsInfo = DirectionDetailsInfo();
    directionDetailsInfo.e_points = responseDirectionApi["routes"][0]["overview_polyline"]["points"];

    directionDetailsInfo.distance_text = responseDirectionApi["routes"][0]["legs"][0]["distance"]["text"];
    directionDetailsInfo.distance_value = responseDirectionApi["routes"][0]["legs"][0]["distance"]["value"];

    directionDetailsInfo.duration_text = responseDirectionApi["routes"][0]["legs"][0]["duration"]["text"];
    directionDetailsInfo.duration_value = responseDirectionApi["routes"][0]["legs"][0]["duration"]["value"];

    return directionDetailsInfo;
  }

  static pauseLiveLocationUpdates()
  {
    currentFirebaseUser = fAuth.currentUser;

    streamSubscriptionPosition!.pause();
    Geofire.removeLocation(currentFirebaseUser!.uid);
  }

  static resumeLiveLocationUpdates()
  {
    currentFirebaseUser = fAuth.currentUser;

    streamSubscriptionPosition!.resume();
    Geofire.setLocation(
        currentFirebaseUser!.uid,
        driverCurrentPosition!.latitude,
        driverCurrentPosition!.longitude
    );
  }

  static readFareAmount()
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
        double totalFareAmount = fareAmount.toDouble()!;
        return double.parse(totalFareAmount.toStringAsFixed(2));
      }
    });
  }

  static double calculateFareAmountFromOriginToDestination(DirectionDetailsInfo directionDetailsInfo)
  {
    double timeTraveledFareAmountPerMinute = (directionDetailsInfo.duration_value! / 60) * 0.1; //Per minute magkano ang ichacharge mo

    double distanceTraveledFareAmountPerKilometer = (directionDetailsInfo.distance_value! / 2000) * 50;

    double? totalFareAmount;

    if(directionDetailsInfo.distance_value! > 3000)
    {
      double totalFareAmount = 2;
      return double.parse(totalFareAmount.toString());
    }

    else
    {
      double totalFareAmount = 1;
      return double.parse(totalFareAmount.toString());
    }

    //Round off

    //If 1 USD = 58 peso
    // double totalFareAmount = timeTraveledFareAmountPerMinute + distanceTraveledFareAmountPerKilometer;
    // double localCurrencyTotalFare = totalFareAmount * 58; for conversion


  }

  static void readKeysForOnlinePassengers(context)
  {
    FirebaseDatabase.instance.ref()
        .child("All Ride Requests")
        .orderByChild("driverId")
        .equalTo("waiting")
        .once()
        .then((snap)
    {
      if(snap.snapshot.value != null)
      {
        Map keysPassengerId = snap.snapshot.value as Map;

        //count total number trips and share it with Provider
        int overAllPassengerCounter = keysPassengerId.length;
        Provider.of<AppInfo>(context, listen: false).updateOverAllPassengerCounter(overAllPassengerCounter);

        //share trips keys with Provider
        List<String> passengerKeysList = [];
        print("keysPassengerID");
        print(keysPassengerId);
        keysPassengerId.forEach((key, value)
        {
          passengerKeysList.add(key);
        });
        Provider.of<AppInfo>(context, listen: false).updateOverAllPassengers(passengerKeysList);

        //get trips keys data - read trips complete information
        readPassengerInformation(context);
      }
    });
  }

  static void readPassengerInformation(context)
  {
    var passengerAllKeys = Provider.of<AppInfo>(context, listen: false).activePassengerList;

    for(String eachKeys in passengerAllKeys)
    {
      FirebaseDatabase.instance.ref()
          .child("All Ride Requests")
          .child(eachKeys)
          .once()
          .then((snap)
      {
        var eachPassenger = PassengersListModel.fromSnapshot(snap.snapshot);

        if((snap.snapshot.value as Map)["driverId"] == "waiting")
        {
          //update-add each history to OverAllTrips History Data List
          Provider.of<AppInfo>(context, listen: false).updatePassengerList(eachPassenger);
        }
      });
    }
  }

  //retrieve the trips KEYS for online user
  //trip key = ride request key
  static void readTripsKeysForOnlineDriver(context)
  {
    FirebaseDatabase.instance.ref()
        .child("All Ride Requests")
        .orderByChild("driverId")
        .equalTo(fAuth.currentUser!.uid)
        .once()
        .then((snap)
    {
      if(snap.snapshot.value != null)
      {
        Map keysTripsId = snap.snapshot.value as Map;

        //count total number trips and share it with Provider
        int overAllTripsCounter = keysTripsId.length;
        Provider.of<AppInfo>(context, listen: false).updateOverAllTripsCounter(overAllTripsCounter);

        //share trips keys with Provider
        List<String> tripsKeysList = [];
        keysTripsId.forEach((key, value)
        {
          tripsKeysList.add(key);
        });
        Provider.of<AppInfo>(context, listen: false).updateOverAllTripsKeys(tripsKeysList);

        //get trips keys data - read trips complete information
        readTripsHistoryInformation(context);
      }
    });
  }

  static void readTripsHistoryInformation(context)
  {
    Provider.of<AppInfo>(context, listen: false).allTripsHistoryInformationList.clear();
    var tripsAllKeys = Provider.of<AppInfo>(context, listen: false).historyTripsKeysList;

    for(String eachKey in tripsAllKeys)
    {
      FirebaseDatabase.instance.ref()
          .child("All Ride Requests")
          .child(eachKey)
          // .orderByChild("time")
          // .startAt("2022-11-14 19:18:47.241547")
          .once()
          .then((snap)
      {
        var eachTripHistory = TripsHistoryModel.fromSnapshot(snap.snapshot);

        if((snap.snapshot.value as Map)["status"] == "ended")
        {
          //update-add each history to OverAllTrips History Data List
          Provider.of<AppInfo>(context, listen: false).updateOverAllTripsHistoryInformation(eachTripHistory);
        }
      });
    }
  }

  //readDriverEarnings
  static void readDriverEarnings(context)
  {
    FirebaseDatabase.instance.ref()
        .child("drivers")
        .child(fAuth.currentUser!.uid)
        .child("earnings")
        .once()
        .then((snap)
    {
      if(snap.snapshot.value != null)
      {
        String driverEarnings = snap.snapshot.value.toString();
        Provider.of<AppInfo>(context, listen: false).updateDriverTotalEarnings(driverEarnings);
      }
    });

    readTripsKeysForOnlineDriver(context);
  }

  static void readDriverRatings(context)
  {
    FirebaseDatabase.instance.ref()
        .child("drivers")
        .child(fAuth.currentUser!.uid)
        .child("ratings")
        .once()
        .then((snap)
    {
      if(snap.snapshot.value != null)
      {
        String driverRatings = snap.snapshot.value.toString();
        Provider.of<AppInfo>(context, listen: false).updateDriverAverageRatings(driverRatings);
      }
    });
  }
}