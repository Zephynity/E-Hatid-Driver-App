import 'package:ehatid_driver_app/app_info.dart';
import 'package:ehatid_driver_app/history_design_ui.dart';
import 'package:ehatid_driver_app/navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';


class TripsHistoryScreen extends StatefulWidget
{
  @override
  State<TripsHistoryScreen> createState() => _TripsHistoryScreenState();
}




class _TripsHistoryScreenState extends State<TripsHistoryScreen>
{
  @override
  Widget build(BuildContext context)
  {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color(0xFFFFFCEA),
      appBar: AppBar(
        backgroundColor: Color(0xFFFED90F),
        centerTitle: true,
        title: Text(
          "Trips History",
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: ()
          {
            Provider.of<AppInfo>(context, listen: false).allTripsHistoryInformationList.clear();
            Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (_) => Navigation(),
            ),
            );
          },
        ),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Positioned(
            top: 0,
            child: Image.asset("assets/images/Vector 11.png",
              width: size.width,
            ),
          ),

          Positioned(
            child: Provider.of<AppInfo>(context, listen: false).allTripsHistoryInformationList.length == 0
                ? Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("assets/images/history.png",
                  width: size.width,
                ),
                Text("You haven't accepted any tricycle booking yet.",
                  style: TextStyle(fontFamily: 'Montserrat', color: Color(0XFF353535)),),
              ],
            )
                : ListView.separated(
              separatorBuilder: (context, i)=> Divider(
                color: Colors.transparent,
                thickness: 2,
                height: 0.5.h,
              ),
              itemBuilder: (context, i)
              {
                return Card(
                  color: Colors.white54,
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: HistoryDesignUIWidget(
                    tripsHistoryModel: Provider.of<AppInfo>(context, listen: false).allTripsHistoryInformationList[i],
                  ),
                );
              },
              itemCount: Provider.of<AppInfo>(context, listen: false).allTripsHistoryInformationList.length,
              physics: const ClampingScrollPhysics(),
              shrinkWrap: true,
            ),
          ),
        ],
      ),
    );
  }
}
