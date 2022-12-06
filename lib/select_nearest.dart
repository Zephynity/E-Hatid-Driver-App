
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:smooth_star_rating_nsafe/smooth_star_rating.dart';

import 'assistant_methods.dart';
import 'global.dart';
import 'navigation_bar.dart';

class SelectNearestActivePassengersScreen extends StatefulWidget
{

  DatabaseReference? referenceRideRequest;

  SelectNearestActivePassengersScreen({this.referenceRideRequest});

  @override
  State<SelectNearestActivePassengersScreen> createState() => _SelectNearestActivePassengersScreenState();
}

class _SelectNearestActivePassengersScreenState extends State<SelectNearestActivePassengersScreen>
{
  @override
  void dispose() {
    print("disposing stuff");
    super.dispose();
    pList = [];
  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.yellow,
        title: Text(
          "Nearest Online Passengers",
          style: TextStyle(
            fontFamily: 'Montserrat',
            color: Colors.white,
            fontSize: 19.sp,
            letterSpacing: -0.5,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.close,
            size: 26.sp,
            color: Color(0xFF777777),
          ),
          onPressed: ()
          {
            //delete or remove ride request from database
            // widget.referenceRideRequest!.remove();
            //Navigator.pop(context);
            Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (_) => Navigation(index: 0,),
            ),
            );
          },
        ),
      ),
      body: ListView.builder(
        itemCount: pList.length,
        itemBuilder: (BuildContext context, int index)
        {
          return GestureDetector(
            onTap: ()
            {
              setState(() {
                chosenPassengerId = pList[index]["id"].toString();
                print("Passenger Id: " + chosenPassengerId.toString());
              });
              Navigator.pop(context, "passengerChoosed");
            },
            child: Card(
              color: Colors.white54,
              elevation: 3,
              shadowColor: Colors.green,
              margin: EdgeInsets.all(8.0),
              child: ListTile(
                leading: Padding(
                  padding: const EdgeInsets.only(top: 2.0),
                  child: Icon(
                    Icons.account_circle_outlined,
                    size: 26.sp,
                    color: Color(0xFF777777),
                  ),
                ),
                title: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [

                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 6.0),
                          child: Text(
                            pList[index]["username"],
                            style: const TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 16,
                              color: Color(0xFF272727),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        Icon(
                          Icons.verified_rounded,
                          color: Color(0xFF0CBC8B),
                        ),
                      ],
                    ),

                    const SizedBox(height: 2,),

                    const SizedBox(height: 20,),

                    //icon + pickup
                    Row(
                      children: [

                        Image.asset(
                          "assets/images/origin.png",
                          height: 26,
                          width: 26,
                        ),

                        const SizedBox(width: 12,),

                        Expanded(
                          child: Container(
                            child: Text(
                              pList[index]["originAddress"],
                              style: const TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 16,
                                color: Color(0xFF272727),
                              ),
                            ),
                          ),
                        ),

                      ],
                    ),
                  ],
                ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      tripDirectionDetailsInfo != null ? tripDirectionDetailsInfo!.duration_text! : "",
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 16.sp,
                        color: Color(0xFF272727),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 2.h,),
                    // Text(
                    //   //tripDirectionDetailsInfo != null ? tripDirectionDetailsInfo!.duration_text! : "",
                    //   //"",
                    //   AssistantMethods.calculateFareAmountFromOriginToDestination(tripDirectionDetailsInfo!).toString(),
                    //   style: TextStyle(
                    //     fontFamily: 'Montserrat',
                    //     fontSize: 16.sp,
                    //     color: Color(0xFF272727),
                    //     fontWeight: FontWeight.w500,
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}