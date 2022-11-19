import 'package:ehatid_driver_app/trips_history_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';


class HistoryDesignUIWidget extends StatefulWidget
{
  TripsHistoryModel? tripsHistoryModel;

  HistoryDesignUIWidget({this.tripsHistoryModel});

  @override
  State<HistoryDesignUIWidget> createState() => _HistoryDesignUIWidgetState();
}


class _HistoryDesignUIWidgetState extends State<HistoryDesignUIWidget>
{
  String formatDateAndTime(String dateTimeFromDB)
  {
    DateTime dateTime = DateTime.parse(dateTimeFromDB);

                                          // Dec 10                            //2022                         //1:12 pm
    String formattedDatetime = "${DateFormat.MMMd().format(dateTime)}, ${DateFormat.y().format(dateTime)} - ${DateFormat.jm().format(dateTime)}";

    return formattedDatetime;
  }

  @override
  Widget build(BuildContext context)
  {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20),),
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //driver name + Fare Amount
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Color(0XFFFED90F),
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2.0),
                          child: Row(
                            children: [
                              Text(
                                widget.tripsHistoryModel!.username!,
                                style: const TextStyle(
                                  color: Color(0xbc000000),
                                  fontFamily: "Montserrat",
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              Icon(
                                Icons.verified_rounded,
                                color: Color(0xFF0CBC8B),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 8,),

                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Text(
                    "₱ " + widget.tripsHistoryModel!.fareAmount!,
                    style: const TextStyle(
                      color: Color(0xFF0CBC8B),
                      fontFamily: "Montserrat",
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 2,),

           /*** // car details
            Row(
              children: [
                const Icon(
                  Icons.car_repair,
                  color: Colors.black,
                  size: 28,
                ),

                const SizedBox(width: 12,),

              ],
            ),***/

            const SizedBox(height: 20,),

            //icon + pickup
            Container(
              decoration: BoxDecoration(
                color: Color(0XFFEBE5D8),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 2.0),
                child: Row(
                  children: [

                    Icon(
                      Icons.location_pin,
                      color: Color(0xffCCCCCC),
                    ),

                    SizedBox(width: 1.w,),

                    Expanded(
                      child: Container(
                        child: Text(
                          widget.tripsHistoryModel!.originAddress!,
                          //overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Color(0xbc000000),
                            fontSize: 13,
                            fontFamily: "Montserrat",
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 14,),

            //icon + dropOff
            Container(
              decoration: BoxDecoration(
                color: Color(0XFFEBE5D8),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 2.0),
                child: Row(
                  children: [

                    Icon(
                      Icons.storefront,
                      color: Color(0xffCCCCCC),
                    ),

                    SizedBox(width: 1.w,),

                    Expanded(
                      child: Container(
                        child: Text(
                          widget.tripsHistoryModel!.destinationAddress!,
                          //overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Color(0xbc000000),
                            fontSize: 13,
                            fontFamily: "Montserrat",
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 14,),

            //trip time and date
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(""),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 11.0, vertical: 2.0),
                    child: Text(
                      formatDateAndTime(widget.tripsHistoryModel!.time!),
                      style: TextStyle( color: Color(0xbc000000),
                        fontSize: 13,
                        fontFamily: "Montserrat",
                        fontWeight: FontWeight.w400,),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 2,),

          ],
        ),
      ),
    );
  }
}
