import 'package:ehatid_driver_app/passengers_list_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class PassengerDesignUIWidget extends StatefulWidget
{
  PassengersListModel? passengersListModel;

  PassengerDesignUIWidget({this.passengersListModel});

  @override
  State<PassengerDesignUIWidget> createState() => _PassengerDesignUIWidgetState();
}


class _PassengerDesignUIWidgetState extends State<PassengerDesignUIWidget>
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
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            //driver name + Fare Amount
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 6.0),
                      child: Text(
                        "Passenger: " + widget.passengersListModel!.username!,
                        style: const TextStyle(
                          fontFamily: "Montserrat",
                          fontSize: 16,
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

                const SizedBox(width: 12,),

                // Text(
                //   "₱ " + widget.passengersListModel!.fareAmount!,
                //   style: const TextStyle(
                //     color: Color(0xFF0CBC8B),
                //     fontFamily: "Montserrat",
                //     fontSize: 20,
                //     fontWeight: FontWeight.bold,
                //   ),
                // ),
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
                      widget.passengersListModel!.originAddress!,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: "Montserrat",
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),

              ],
            ),

            const SizedBox(height: 14,),

            //icon + dropOff
            Row(
              children: [

                Image.asset(
                  "assets/images/destination.png",
                  height: 24,
                  width: 24,
                ),

                const SizedBox(width: 12,),

                Expanded(
                  child: Container(
                    child: Text(
                      widget.passengersListModel!.destinationAddress!,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: "Montserrat",
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),

              ],
            ),

            const SizedBox(height: 14,),

            //trip time and date
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(""),
                Text(
                  formatDateAndTime(widget.passengersListModel!.time!),
                  style: const TextStyle(
                    fontFamily: "Montserrat",
                    color: Colors.grey,
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
