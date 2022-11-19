import 'package:ehatid_driver_app/app_info.dart';
import 'package:ehatid_driver_app/trips_history_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';


class EarningsTabPage extends StatefulWidget {
  const EarningsTabPage({Key? key}) : super(key: key);

  @override
  _EarningsTabPageState createState() => _EarningsTabPageState();
}



class _EarningsTabPageState extends State<EarningsTabPage> {

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFFFFFCEA),
      child: Column(
        children: [

          //earnings
          Container(
            color: Color(0xFFFEDF3F),
            width: double.infinity,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 8.h),
              child: Column(
                children: [

                  const Text(
                    "Total Earnings:",
                    style: TextStyle(
                      fontFamily: "Montserrat",
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  SizedBox(height: 2.h),

                  Text(
                    "₱ " + Provider.of<AppInfo>(context, listen: false).driverTotalEarnings,
                    style: const TextStyle(
                      fontFamily: "Montserrat",
                      color: Colors.white,
                      fontSize: 60,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),

          //total number of trips
          ElevatedButton(
            onPressed: ()
            {
              Navigator.of(context).push(MaterialPageRoute(builder: (c)=> TripsHistoryScreen()),)
                  .then((value) => setState(() {}));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              elevation: 2.h,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20),
              child: Row(
                children: [

                  Image.asset(
                    "assets/images/tricycle2.png",
                    width: 18.w,
                  ),

                  SizedBox(width: 5.w),

                  Text(
                    "Trips Completed",
                    style: TextStyle(
                      fontFamily: "Montserrat",
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),

                  Expanded(
                    child: Container(
                      child: Text(
                        Provider.of<AppInfo>(context, listen: false).allTripsHistoryInformationList.length.toString(),
                        textAlign: TextAlign.end,
                        style: const TextStyle(
                          letterSpacing: -0.5,
                          fontFamily: "Montserrat",
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0CBC8B),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 30),
            child: Image.asset(
              "assets/images/Investments.png",
            ),
          ),
        ],
      ),
    );
  }
}
