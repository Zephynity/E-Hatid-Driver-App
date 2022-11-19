import 'package:ehatid_driver_app/app_info.dart';
import 'package:ehatid_driver_app/global.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:smooth_star_rating_nsafe/smooth_star_rating.dart';




class RatingsTabPage extends StatefulWidget
{
  const RatingsTabPage({Key? key}) : super(key: key);

  @override
  State<RatingsTabPage> createState() => _RatingsTabPageState();
}




class _RatingsTabPageState extends State<RatingsTabPage>
{
  double ratingsNumber=0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getRatingsNumber();
  }

  getRatingsNumber()
  {
    setState(() {
      ratingsNumber = double.parse(Provider.of<AppInfo>(context, listen: false).driverAverageRatings);
    });

    setupRatingsTitle();
  }

  setupRatingsTitle()
  {
    if(ratingsNumber == 1)
    {
      setState(() {
        titleStarsRating = "Very Bad";
      });
    }
    if(ratingsNumber == 2)
    {
      setState(() {
        titleStarsRating = "Bad";
      });
    }
    if(ratingsNumber == 3)
    {
      setState(() {
        titleStarsRating = "Good";
      });
    }
    if(ratingsNumber == 4)
    {
      setState(() {
        titleStarsRating = "Very Good";
      });
    }
    if(ratingsNumber == 5)
    {
      setState(() {
        titleStarsRating = "Excellent";
      });
    }
  }

  @override
  Widget build(BuildContext context)
  {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          "Ratings",
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color(0xFFFED90F),
      ),
      backgroundColor: Color(0xFFFFFCEA),
      body: SafeArea(
        child: Container(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                top: 0,
                child: Image.asset("assets/images/Vector 12.png",
                  width: size.width,
                ),
              ),


              Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                backgroundColor: Colors.transparent,
                child: Container(
                  margin: const EdgeInsets.all(8),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [

                      const SizedBox(height: 22.0,),

                      const Text(
                        "Your Ratings:",
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 22,
                          letterSpacing: 2,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),

                      const SizedBox(height: 22.0,),

                      const Divider(height: 4.0, thickness: 4.0,),

                      const SizedBox(height: 22.0,),

                      SmoothStarRating(
                        rating: ratingsNumber,
                        allowHalfRating: false,
                        starCount: 5,
                        color: Color(0xFF0CBC8B),
                        borderColor: Color(0xFF0CBC8B),
                        size: 46,
                      ),

                      const SizedBox(height: 12.0,),

                      Text(
                        titleStarsRating,
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 30,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF0CBC8B),
                        ),
                      ),

                      const SizedBox(height: 18.0,),

                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
