import 'package:ehatid_driver_app/background.dart';
import 'package:flutter/material.dart';
import 'package:intro_slider/dot_animation_enum.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:intro_slider/slide_object.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'signup.dart';

class IntroSliderPage extends StatefulWidget {
  @override
  _IntroSliderPageState createState() => _IntroSliderPageState();
}

class _IntroSliderPageState extends State<IntroSliderPage> {
  List<Slide> slides = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    slides.add(
      new Slide(
        title: "More Passengers",
        description:
        "No need to worry about getting passengers, \n as they will be able to connect directly to you",
        pathImage: "assets/images/illus8.png",
      ),
    );
    slides.add(
      new Slide(
        title: "Convenient",
        description: "Efficient way of acquiring new \n passengers for all stray tricycle drivers",
        pathImage: "assets/images/illus2.png",
      ),
    );
    slides.add(
      new Slide(
        title: "Earn More",
        description: "Higher revenue pay for maximizing \n every trip journey",
        pathImage: "assets/images/illus11.png",
      ),
    );
    slides.add(
      new Slide(
        title: "Accept a Job",
        description: "Register in TODA G5 Terminal and \n experience your first trip.",
        pathImage: "assets/images/ehatid logo.png",
      ),
    );
  }

  List<Widget> renderListCustomTabs() {
    List<Widget> tabs = [];
    for (int i = 0; i < slides.length; i++) {
      Slide currentSlide = slides[i];
      tabs.add(
        Container(
          width: double.infinity,
          height: double.infinity,
          child: Container(
            margin: EdgeInsets.only(bottom: 10, top: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  child: Image.asset(
                    currentSlide.pathImage.toString(),
                    matchTextDirection: true,
                    width: Adaptive.h(50),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 5),
                  child: Text(
                    currentSlide.title.toString(),
                    style: TextStyle(fontFamily: 'Montserrat', fontSize: 32, letterSpacing: -2, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 3,
                  ),
                  child: FittedBox(
                    child: Text(
                      currentSlide.description.toString(),
                      style: TextStyle(
                          fontFamily: 'Montserrat', fontSize: 15, color: Color(0xff646262), letterSpacing: -0.5, fontWeight: FontWeight.w500
                      ),
                      maxLines: 3,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  margin: EdgeInsets.only(
                    top: 15,
                    left: 20,
                    right: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
    return tabs;
  }

  @override
  Widget build(BuildContext context) {
    return Background(
      child: IntroSlider(
        //backgroundColorAllSlides: Colors.yellow,
        renderSkipBtn: Text(
          "Skip",
          style: TextStyle(fontFamily: 'Montserrat', fontSize: 20, color: Color(0xff8C8C8C)),
        ),
        renderNextBtn: Text(
          "Next",
          style: TextStyle(fontFamily: 'Montserrat', fontSize: 20, color: Colors.white),
        ),
        renderDoneBtn: Text(
          "Done",
          style: TextStyle(fontFamily: 'Montserrat', fontSize: 20, color: Colors.white),
        ),
        colorDot: Colors.white,
        sizeDot: 10.0,
        typeDotAnimation: dotSliderAnimation.SIZE_TRANSITION,
        listCustomTabs: this.renderListCustomTabs(),
        scrollPhysics: BouncingScrollPhysics(),
        onDonePress: () => Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => SignUpPage(),
          ),
        ),
      ),
    );
  }
}