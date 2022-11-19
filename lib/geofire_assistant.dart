import 'package:ehatid_driver_app/active_nearby_available_passengers.dart';

class GeoFireAssistant {
  static List<ActiveNearbyAvailablePassengers> activeNearbyAvailablePassengersList = [
  ];

  static void deleteOfflinePassengerFromList(String passengerId)
  {
    int indexNumber = activeNearbyAvailablePassengersList.indexWhere((
        element) => element.passengerId == passengerId);
    activeNearbyAvailablePassengersList.removeAt(indexNumber);
  }

  static void updateActiveNearbyAvailableDriveLocation(ActiveNearbyAvailablePassengers passengerWhoMove)
  {
    int indexNumber = activeNearbyAvailablePassengersList.indexWhere((
        element) => element.passengerId == passengerWhoMove.passengerId);

    activeNearbyAvailablePassengersList[indexNumber].locationLatitude =
        passengerWhoMove.locationLatitude;
    activeNearbyAvailablePassengersList[indexNumber].locationLongitude =
        passengerWhoMove.locationLongitude;
  }
}