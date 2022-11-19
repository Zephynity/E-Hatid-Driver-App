import 'package:ehatid_driver_app/accept_decline.dart';
import 'package:ehatid_driver_app/app_info.dart';
import 'package:ehatid_driver_app/homescreen.dart';
import 'package:ehatid_driver_app/main_page.dart';
import 'package:ehatid_driver_app/register_page.dart';
import 'package:ehatid_driver_app/welcome.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'intro_slider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'navigation_bar.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'navigation_screen.dart';

int initScreen = 0;

Future <void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences preferences = await SharedPreferences.getInstance();
  var result = await preferences.getInt('initScreen');
  if(result != null){
    initScreen = result;
  }

  await Firebase.initializeApp();
  runApp(
    RestartWidget(
        child:  MyApp()
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(
      builder: (context, orientation, screenType) {
        return ChangeNotifierProvider(
          create: (context) => AppInfo(),
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              backgroundColor: Color(0xFFFED90F),
            ),
            //home: IntroSliderPage(),
            initialRoute: initScreen == 0 ? 'welcome' : 'homepage',
            // paltan ang login ng homepage
            routes: {
              'homepage': (context) => Navigation(),
              'welcome': (context) => MainPage(),
            },
          ),
        );
      },
    );
  }
}

class RestartWidget extends StatefulWidget {
  RestartWidget({this.child});

  final Widget? child;

  static void restartApp(BuildContext context) {
    context.findAncestorStateOfType<_RestartWidgetState>()?.restartApp();
  }

  @override
  State<StatefulWidget> createState() {
    return _RestartWidgetState();
  }
}

class _RestartWidgetState extends State<RestartWidget> {
  Key key = UniqueKey();

  void restartApp() {
    setState(() {
      key = UniqueKey();
    });
  }


  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: key,
      child: widget.child ?? Container(),
    );
  }
}