import 'dart:async';
import 'package:ehatid_driver_app/bookingcomplete.dart';
import 'package:ehatid_driver_app/navigation_bar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:location/location.dart' as loc;
import 'package:location/location.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:math' show cos, sqrt, asin;

import 'accept_decline.dart';
import 'main.dart';
import 'dart:ui' as ui;


class Destination extends StatefulWidget {
  const Destination({Key? key}) : super(key: key);

  @override
  State<Destination> createState() => _DestinationState();
}

class _DestinationState extends State<Destination> {
  final Completer<GoogleMapController?> _controller = Completer();
  Map<PolylineId, Polyline> polylines = {};
  PolylinePoints polylinePoints = PolylinePoints();
  Location location = Location();
  Marker? sourcePosition, destinationPosition;
  loc.LocationData? _currentPosition;
  LatLng curLocation = LatLng(13.7731, 121.0484);
  StreamSubscription<loc.LocationData>? locationSubscription;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getNavigation();
    addMarker();
  }

  @override
  void dispose() {
    locationSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Home"),
        backgroundColor: Color(0xFFFED90F),
      ),
      body: sourcePosition == null
          ? Center(child: CircularProgressIndicator())
          : Stack(
        children: [
          GoogleMap(
            zoomControlsEnabled: false,
            polylines: Set<Polyline>.of(polylines.values),
            initialCameraPosition: CameraPosition(
              target: curLocation,
              zoom: 16,
            ),
            markers: {sourcePosition!, destinationPosition!},
            onTap: (latLng) {
              print(latLng);
            },
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
          ),
          Positioned(
            top: 30,
            left: 15,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => MyApp()),
                        (route) => false);
              },
            ),
          ),
          Positioned(
            bottom: 10,
            right: 10,
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: Colors.blue),
              child: Center(
                child: IconButton(
                  icon: Icon(
                    Icons.navigation_outlined,
                    color: Colors.white,
                  ),
                  onPressed: () async {
                    await launchUrl(Uri.parse(
                        'google.navigation:q=(13.7930, 121.0710)&key=AIzaSyCGZt0_a-TM1IKRQOLJCaMJsV0ZXuHl7Io'));
                  },
                ),
              ),
            ),
          ),
          Center(
            child: Column(
              children: <Widget>[
                Container(
                  height: Adaptive.h(5),
                  width: Adaptive.h(28),
                  child: GoOnline(context),
                ),
                SizedBox(height: 40.h),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget GoOnline(BuildContext context) => FloatingActionButton.extended(
    label: Text('Booking Completed!',
      style: TextStyle(fontFamily: 'Montserrat', fontSize: 15.sp),
    ),
    backgroundColor: Color(0xFF0CBC8B),
    onPressed: (){
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return BookingComplete();
          },
        ),
      );
    },
  );

  getNavigation() async {
    BitmapDescriptor customMarker = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(),
      "assets/images/tricMarker.png",
    );
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    final GoogleMapController? controller = await _controller.future;
    location.changeSettings(accuracy: loc.LocationAccuracy.high);
    _serviceEnabled = await location.serviceEnabled();

    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    if (_permissionGranted == loc.PermissionStatus.granted) {
      _currentPosition = await location.getLocation();
      curLocation =
          LatLng(_currentPosition!.latitude!, _currentPosition!.longitude!);
      locationSubscription =
          location.onLocationChanged.listen((LocationData currentLocation) {
            controller?.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
              target: LatLng(currentLocation.latitude!, currentLocation.longitude!),
              zoom: 16,
            )));
            if (mounted) {
              controller
                  ?.showMarkerInfoWindow(MarkerId(sourcePosition!.markerId.value));
              setState(() {
                curLocation =
                    LatLng(currentLocation.latitude!, currentLocation.longitude!);
                sourcePosition = Marker(
                  markerId: MarkerId(currentLocation.toString()),
                  icon: customMarker,
                  position:
                  LatLng(currentLocation.latitude!, currentLocation.longitude!),
                  infoWindow: InfoWindow(
                      title: '${double.parse(
                          (getDistance(LatLng(13.7930, 121.0710))
                              .toStringAsFixed(2)))} km'
                  ),
                  onTap: () {
                    print('market tapped');
                  },
                );
              });
              getDirections(LatLng(13.7930, 121.0710));
            }
          });
    }
  }

  getDirections(LatLng dst) async {
    List<LatLng> polylineCoordinates = [];
    List<dynamic> points = [];
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        'AIzaSyCGZt0_a-TM1IKRQOLJCaMJsV0ZXuHl7Io',
        PointLatLng(curLocation.latitude, curLocation.longitude),
        PointLatLng(dst.latitude, dst.longitude),
        travelMode: TravelMode.driving);
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        points.add({'lat': point.latitude, 'lng': point.longitude});
      });
    } else {
      print(result.errorMessage);
    }
    addPolyLine(polylineCoordinates);
  }

  addPolyLine(List<LatLng>polylineCoordinates) {
    PolylineId id = PolylineId('poly');
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.blue,
      points: polylineCoordinates,
      width: 5,
    );
    polylines[id] = polyline;
    setState(() {});
  }

  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  double getDistance(LatLng destposition) {
    return calculateDistance(curLocation.latitude, curLocation.longitude,
        destposition.latitude, destposition.longitude);
  }
  addMarker() {
    setState(() {
      sourcePosition = Marker(
        markerId: MarkerId('source'),
        position: curLocation,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
      );
      destinationPosition = Marker(
        markerId: MarkerId('destination'),
        position: LatLng(13.7930, 121.0710),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan),
      );
    });
  }
}