import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:ehatid_driver_app/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser!;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  int index = 2;

  Future<void> _signOut() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.remove('initScreen');
    try {
      await _firebaseAuth.signOut();
      Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (_) => const LoginScreen(),
        ),
      );
    } catch (e) {
      print(e.toString()) ;
    }
  }

  @override
  Widget build(BuildContext context) {
   /** return Scaffold(
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Signed in as: " + user.email!),
                MaterialButton(
                  onPressed: () async => await _signOut(),
                  color: Colors.yellow,
                  child: Text("Sign Out"),
                )
              ],
          ),
      ),
    );**/
    final items = <Widget> [
        Icon(Icons.home, size: 30,),
        Icon(Icons.wallet, size: 30,),
        Icon(Icons.bar_chart, size: 30,),
        Icon(Icons.history, size: 30,),
        Icon(Icons.account_circle, size: 30,),
    ];
    return Scaffold(
      backgroundColor: Color(0xFFFED90F),
      bottomNavigationBar: CurvedNavigationBar(
        height: 60,
        index: index,
        backgroundColor: Color(0xFFFED90F),
        color: Color(0xFFFCF7E1),
        animationDuration: Duration(milliseconds: 300),
        //onTap: (index){},
        items: items,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Signed in as: " + user.email!),
            MaterialButton(
              onPressed: () async => await _signOut(),
              color: Colors.yellow,
              child: Text("Sign Out"),
            )
          ],
        ),
      ),
    );
  }
}
