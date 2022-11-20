import 'dart:async';
import 'dart:ui';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:ehatid_driver_app/driver_data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'active_nearby_available_passengers.dart';
import 'models/direction_details_info.dart';



final FirebaseAuth fAuth = FirebaseAuth.instance;
User? currentFirebaseUser;
StreamSubscription<Position>? streamSubscriptionPosition;
StreamSubscription<Position>? streamSubscriptionDriverLivePosition;
List pList = []; //online-active passengers Information List
List dList= []; //online active drivers info list
AssetsAudioPlayer audioPlayer = AssetsAudioPlayer(); //sound notification
Position? driverCurrentPosition; //position of driver
DriverData onlineDriverData = DriverData();
String titleStarsRating = "Good";

bool isDriverActive = false;
String statusText = "Go Online";
Color buttonColor = Color(0xFF0CBC8B);
Color passengerButtonColor = Color(0x4D0CBC8B);

String? chosenPassengerId = "";
String? chosenPassengerStatus = "";
String? chosenPassengerDriverId = "";
String? chosenPassengerUsername = "";
String? chosenPassengerOriginAddress = "";
String? chosenPassengerDestinationAddress = "";
double? chosenPassengerOriginLat;
double? chosenPassengerOriginLng;
double? chosenPassengerDestinationLat;
double? chosenPassengerDestinationLng;
LatLng? chosenPassengerOriginLatLng;
LatLng? chosenPassengerDestinationLatLng;
LatLng? passengerOriginLatLng;
DirectionDetailsInfo? tripDirectionDetailsInfo;
String cloudMessagingServerToken = "key=AAAAI12SKic:APA91bEBXIQCZlwAZlLzIeuPNd5nQAUpKL4AhWvQkLtNIb3wu55BWO_-dcSRrcyeuEraWGSCVTt573S3fpT2ajuUOLXssSH0mIBSdrOPT7cfNQreYaLRDJPiEXKcjP_tdTQ2rSpd6VkQ";
String userDropOffAddress = "";
String distanceFromDriverToPassenger = "";

List<ActiveNearbyAvailablePassengers> onlineNearbyAvailablePassengersList = [];

double baseAmount = 0;
double bookingFee = 0;
double totalFareAmount = 0;