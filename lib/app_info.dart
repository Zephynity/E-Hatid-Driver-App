import 'package:ehatid_driver_app/models/directions.dart';
import 'package:ehatid_driver_app/passengers_list_model.dart';
import 'package:ehatid_driver_app/trips_history_model.dart';
import 'package:flutter/cupertino.dart';


class AppInfo extends ChangeNotifier
{
  Directions? userPickUpLocation, userDropOffLocation;
  int countTotalTrips = 0;
  int countTotalPassenger = 0;
  String driverTotalEarnings = "0";
  String driverAverageRatings = "0";
  List<String> historyTripsKeysList = [];
  List<String> activePassengerList = [];
  List<TripsHistoryModel> allTripsHistoryInformationList = [];
  List<PassengersListModel> passengerInformationList = [];


  void updatePickUpLocationAddress(Directions userPickUpAddress)
  {
    userPickUpLocation = userPickUpAddress;
    notifyListeners();
  }

  void updateDropOffLocationAddress(Directions dropOffAddress)
  {
    userDropOffLocation = dropOffAddress;
    notifyListeners();
  }

  updateOverAllTripsCounter(int overAllTripsCounter)
  {
    countTotalTrips = overAllTripsCounter;
    notifyListeners();
  }

  updateOverAllPassengerCounter(int overAllPassengerCounter)
  {
    countTotalPassenger = overAllPassengerCounter;
    notifyListeners();
  }

  updateOverAllTripsKeys(List<String> tripsKeysList)
  {
    historyTripsKeysList = tripsKeysList;
    notifyListeners();
  }

  updateOverAllPassengers(List<String> passengerKeysList)
  {
    activePassengerList = passengerKeysList;
    notifyListeners();
  }

  updateOverAllTripsHistoryInformation(TripsHistoryModel eachTripHistory)
  {
    allTripsHistoryInformationList.add(eachTripHistory);
    notifyListeners();
  }

  updatePassengerList(PassengersListModel eachPassenger)
  {
    passengerInformationList.add(eachPassenger);
    notifyListeners();
  }

  updateDriverTotalEarnings(String driverEarnings)
  {
    driverTotalEarnings = driverEarnings;
  }

  updateDriverAverageRatings(String driverRatings)
  {
    driverAverageRatings = driverRatings;
  }
}