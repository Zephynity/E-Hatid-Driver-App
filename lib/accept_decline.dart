import 'dart:async';
import 'package:ehatid_driver_app/navigation_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

List cars = [
  {'id': 0, 'name': 'Select a ride', 'price': 0.0},
  {'id': 1, 'name': 'Uber', 'price': 1.0},
  {'id': 2, 'name': 'Grab', 'price': 2.0},
  {'id': 3, 'name': 'Grab', 'price': 3.0},
  {'id': 2, 'name': 'Grab', 'price': 2.0},
  {'id': 2, 'name': 'Grab', 'price': 2.0},
];

class AcceptDecline extends StatefulWidget {
  @override
  State<AcceptDecline> createState() => AcceptDeclineState();
}

class AcceptDeclineState extends State<AcceptDecline> {
  Completer<GoogleMapController> _controller = Completer();

  final panelController = PanelController();

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(13.7731, 121.0484),
    zoom: 14.4746,
  );

  static final Marker _kPickUpMarker = Marker(
    markerId: MarkerId('_kPickUp'),
    infoWindow: InfoWindow(title: 'Passenger Location'),
    icon: BitmapDescriptor.defaultMarker,
    position: LatLng(13.7731, 121.0484),
  );

  static final Marker _kDestinationMarker = Marker(
    markerId: MarkerId('_kDestination'),
    infoWindow: InfoWindow(title: 'Destination'),
    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
    position: LatLng(13.7991, 121.0478),
  );

  static final CameraPosition _kLake = CameraPosition(
    //bearing: 192.8334901395799,
      target: LatLng(13.7731, 121.0484),
      //tilt: 59.440717697143555,
      zoom: 107.15);

  @override
  Widget build(BuildContext context) {
    final paneHeightClosed = Adaptive.h(11);
    final paneHeightOpen = Adaptive.h(45);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color(0xFFFED90F),
        title: Text('Trip Details',
            style:TextStyle(fontFamily: 'Montserrat', fontSize: 18, fontWeight: FontWeight.bold)),
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
      ),
      body: SlidingUpPanel(
        controller: panelController,
        minHeight: paneHeightClosed,
        maxHeight: paneHeightOpen,
        parallaxEnabled: true,
        parallaxOffset: 0.5,
        color: Color(0xFFEBE5D8),
        body: GoogleMap(
          mapType: MapType.normal,
          markers: {_kPickUpMarker, _kDestinationMarker},
          initialCameraPosition: _kGooglePlex,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
        ),
        panelBuilder: (controller) => PanelWidget(
          controller: controller,
          panelController: panelController,
        ),
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
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
      SizedBox(height: Adaptive.h(1)),
      buildDragHandle(),
      SizedBox(height: Adaptive.h(1.5)),
      buildAboutText(context),
    ],
  );

  Widget buildAboutText(BuildContext context) => Container(
    padding: EdgeInsets.symmetric(horizontal: 24),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          height: Adaptive.h(7),
          width: Adaptive.w(100),
          child: Row(
            //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget> [
              Icon(Icons.account_circle,
                size: 40,
                color: Color(0xFF272727),
              ),
              SizedBox(width: Adaptive.w(2),),
              Column(
                children: [
                  Row(
                    children: [
                      Text("Karlo Pangilinan ",
                        style: TextStyle(fontFamily: 'Montserrat', fontSize: 4.3.w, fontWeight: FontWeight.w600,
                        ),
                      ),
                      Icon(Icons.verified_rounded,
                        color: Color(0xFF0CBC8B),),
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(width: Adaptive.w(2),),
                      Text("Verified Passenger",
                        style: TextStyle(fontFamily: 'Montserrat', fontSize: 3.6.w,
                        ),
                      ),
                      SizedBox(width: 50,),
                    ],
                  ),
                ],
              ),
              Spacer(),
              Icon(Icons.call,
                size: 40,
                color: Color(0xFF0CBC8B),
              ),
            ],
          ),
        ),
        SizedBox(height: Adaptive.h(1),),
        FittedBox(
          fit: BoxFit.fill,
          child: Row(
            children: [
              SizedBox(width: Adaptive.w(3),),
              Image.asset("assets/images/line.png", height: Adaptive.h(16),),
              SizedBox(width: Adaptive.w(8),),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text("Pickup Point:",
                    style: TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.w600,color: Color(0XFF9E9E9E)),),
                  Text("7-Eleven, Bolbok, Batangas City",
                    style: TextStyle(fontFamily: 'Montserrat',),), //PLACE YOUR LOCATION HERE
                  SizedBox(height: Adaptive.h(2),),
                  Center(
                    child: Container(
                      width: 280,
                      height: 2,
                      decoration: BoxDecoration(
                        color: Color(0XFFCCC9C1),
                        borderRadius: BorderRadius.circular(32),
                      ),
                    ),
                  ),
                  SizedBox(height: Adaptive.h(1),),
                  Text("Destination:",
                    style: TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.w600, color: Color(0XFFFFBA4C)),),
                  Text("Sta. Rita de Cascia Parish Church",
                    style: TextStyle(fontFamily: 'Montserrat',),),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: Adaptive.h(1),),
        Container(
          width: Adaptive.w(90),
          height: Adaptive.h(7),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text("Distance",
                    style: TextStyle(fontFamily: 'Montserrat', fontSize: 18, fontWeight: FontWeight.w600,),
                  ),
                  Text("Time",
                    style: TextStyle(fontFamily: 'Montserrat', fontSize: 18, fontWeight: FontWeight.w600,),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  //SizedBox(height: 20,),
                  Text("192m away",
                    style: TextStyle(fontFamily: 'Montserrat', fontSize: 18, fontWeight: FontWeight.w600,color: Color(0XFFFFBA4C)),
                  ),
                  Text("15 mins",
                    style: TextStyle(fontFamily: 'Montserrat', fontSize: 18, fontWeight: FontWeight.w600, color: Color(0XFFFFBA4C)),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: Adaptive.h(2),),
        Align(
          alignment: Alignment.bottomCenter,
          child: Row(
            //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(width: Adaptive.w(2),),
              MaterialButton(
                onPressed: (){
                  showDialog(
                    context: context,
                    builder: (context) => BookingSuccessDialog(),
                  );
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50)
                ),
                minWidth: Adaptive.w(40),
                child: Text("Continue", style: TextStyle( color: Colors.white,
                  fontSize: 15,
                  fontFamily: "Montserrat",
                  fontWeight: FontWeight.w600,),),
                color: Color(0XFF0CBC8B),
              ),
              SizedBox(width: Adaptive.w(2),),
              MaterialButton(
                onPressed: (){
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50)
                ),
                minWidth: Adaptive.w(40),
                child: Text("Cancel", style: TextStyle( color: Colors.white,
                  fontSize: 15,
                  fontFamily: "Montserrat",
                  fontWeight: FontWeight.w600,),),
                color: Color(0XFFC5331E),
              ),
            ],
          ),
        ),
      ],
    ),
  );

  Widget buildDragHandle() => GestureDetector(
    child: Center(
      child: Container(
        width: Adaptive.w(15),
        height: Adaptive.h(0.5),
        decoration: BoxDecoration(
          color: Color(0XFFD1D1D1),
          borderRadius: BorderRadius.circular(32),
        ),
      ),
    ),
    onTap: togglePanel,
  );

  void togglePanel() => panelController.isPanelOpen
      ? panelController.close()
      : panelController.open();
}

class BookingSuccessDialog extends StatelessWidget {
  final _priceController = TextEditingController();
  BookingSuccessDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(19)
      ),
      child: Container(
        height: Adaptive.h(50),
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.1,
              decoration: BoxDecoration(
                color: Color(0XFF0CBB8A),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
              child: SizedBox.expand(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Booking Successful!",
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        color: Colors.white,
                        fontSize: 20,
                        letterSpacing: -0.5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text("Passenger ID: 554321",
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        color: Colors.white,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Form(
              child: Container(
                width: Adaptive.w(50),
                height: Adaptive.h(9),
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("PHP",
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        color: Colors.black,
                        fontSize: 20,
                        letterSpacing: -0.5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Flexible(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.32,
                        child: TextField(
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(hintText: "Fare Price",
                            hintStyle: TextStyle(
                              fontFamily: 'Montserrat',
                              color: Colors.black,
                              fontSize: 18,
                            ),
                            //isCollapsed: true,
                            contentPadding: EdgeInsets.symmetric(horizontal: 10),),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: Adaptive.h(7),),
                Text("Base Fare:",
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    color: Colors.black,
                    fontSize: 14,
                  ),
                ),
                SizedBox(width: Adaptive.w(34),),
                Text("P40.00",
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    color: Colors.black,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            // SizedBox(height: Adaptive.h(2),),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("Booking Fee:",
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    color: Colors.black,
                    fontSize: 14,
                  ),
                ),
                SizedBox(width: Adaptive.w(30),),
                Text("P10.00",
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    color: Colors.black,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            SizedBox(height: Adaptive.h(3),),
            Center(
              child: Container(
                width: Adaptive.w(60),
                height: Adaptive.h(.2),
                decoration: BoxDecoration(
                  color: Color(0XFFCCC9C1),
                  borderRadius: BorderRadius.circular(32),
                ),
              ),
            ),
            SizedBox(height: Adaptive.h(2),),
            Center(
              child: Container(
                height: Adaptive.h(8),
                child: Text(
                  "Don't worry! Additional charges may apply\n if cancellation of booking is done by\n the passenger.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    color: Colors.black,
                    fontSize: 11,
                  ),
                ),
              ),
            ),
            // SizedBox(height: Adaptive.h(3),),
            MaterialButton(
              onPressed: () {
                Navigator.pushReplacement(context, MaterialPageRoute(
                  builder: (_) => NavigationScreen(),
                ),
                );
              },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50)
              ),
              minWidth: Adaptive.w(50),
              child: Text("Get Directions", style: TextStyle( color: Colors.white,
                fontSize: 15,
                fontFamily: "Montserrat",
                fontWeight: FontWeight.w600,),),
              color: Color(0XFF0CBB8A),
            ),
          ],
        ),
      ),
    );
  }
}