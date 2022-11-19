import 'package:firebase_database/firebase_database.dart';

class PassengersListModel
{
  String? time;
  String? originAddress;
  String? destinationAddress;
  String? status;
  String? fareAmount;
  String? username;
  String? driverId;

  PassengersListModel({
    this.time,
    this.originAddress,
    this.destinationAddress,
    this.status,
    this.username,
    this.driverId,
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
  }
}