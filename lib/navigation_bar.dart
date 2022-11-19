import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:ehatid_driver_app/earning_tab.dart';
import 'package:ehatid_driver_app/homescreen.dart';
import 'package:ehatid_driver_app/profile_tab.dart';
import 'package:ehatid_driver_app/ratings_tab.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app_info.dart';

class Navigation extends StatefulWidget {
  const Navigation({Key? key}) : super(key: key);

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {

  GlobalKey<CurvedNavigationBarState> _navKey = GlobalKey();

  TextEditingController latController = TextEditingController();
  TextEditingController lngController = TextEditingController();

  var myindex = 0;

  var PagesAll = [HomePage(), EarningsTabPage(), RatingsTabPage(), ProfileTabPage()];

  @override
  Widget build(BuildContext context) {
    //total height and width
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFFFFFCEA),
        bottomNavigationBar: CurvedNavigationBar(
          key: _navKey,
          items: [
            Icon((myindex == 0) ? Icons.home_outlined : Icons.home, size: 30,),
            Icon((myindex == 1) ? Icons.history_outlined : Icons.history, size: 30,),
            Icon((myindex == 2) ? Icons.star_border : Icons.star , size: 30,),
            Icon((myindex == 3) ? Icons.account_circle_outlined : Icons.account_circle_sharp , size: 30,),
          ],
          height: 60,
          backgroundColor: Color(0xFFFFFCEA),
          color: Color(0xFFFED90F),
          animationDuration: Duration(milliseconds: 300),
          onTap: (index){
            setState(() {
              myindex = index;
              if(index == 0)
              {
                Provider.of<AppInfo>(context, listen: false).allTripsHistoryInformationList.clear();
              }
            });
          },
        ),
        body: PagesAll[myindex],
      ),
    );
  }
}