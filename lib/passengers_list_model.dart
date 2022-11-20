import 'package:firebase_database/firebase_database.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PassengersListModel
{
  String? time;
  String? originAddress;
  String? destinationAddress;
  String? status;
  String? fareAmount;
  String? username;
  String? driverId;
  String? originLat;
  String? originLng;
  String? destinationLat;
  String? destinationLng;
  LatLng? originLatLng;
  LatLng? destinationLatLng;

  PassengersListModel({
    this.time,
    this.originAddress,
    this.destinationAddress,
    this.status,
    this.username,
    this.driverId,
    this.originLat,
    this.originLng,
    this.destinationLat,
    this.destinationLng,
    this.originLatLng,
    this.destinationLatLng,
  });

  PassengersListModel.fromSnapshot(DataSnapshot dataSnapshot)
  {
    time = (dataSnapshot.value as Map)["time"];
    originAddress = (dataSnapshot.value as Map)["originAddress"];
    destinationAddress = (dataSnapshot.value as Map)["destinationAddress"];
    status = (dataSnapshot.value as Map)["status"];
    fareAmount = (dataSnapshot.value as Map)["fareAmount"];
    username = (dataSnapshot.value as Map)["username"];
    driverId = (dataSnapshot.value as Map)["driverId"];
    originLat = (dataSnapshot.value as Map)["origin"]["latitude"];
    originLng = (dataSnapshot.value as Map)["origin"]["longitude"];
    destinationLat = (dataSnapshot.value as Map)["destination"]["latitude"];
    destinationLng = (dataSnapshot.value as Map)["destination"]["longitude"];
  }
}