import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:ehatid_driver_app/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Wallet extends StatefulWidget {
  const Wallet({
    Key? key,
  }) : super(key: key);

  @override
  State<Wallet> createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
  final user = FirebaseAuth.instance.currentUser!;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<void> _signOut() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.remove('initScreen');
    try {
      await _firebaseAuth.signOut();
      Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (_) => LoginScreen(),
      ),
      );
    } catch (e) {
      print(e.toString()) ;
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;
    //total height and width
    return Scaffold(
      backgroundColor: Color(0xFFFFFCEA),
      appBar: AppBar(
        centerTitle: true,
        title: Text("Wallet",
            style:TextStyle(fontFamily: 'Montserrat', fontSize: 18, fontWeight: FontWeight.bold)),
        elevation: 0,
        backgroundColor: Color(0xFFFED90F),
      ),
      drawer: Drawer(
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView(
                children: <Widget>[
                  UserAccountsDrawerHeader(
                    decoration: BoxDecoration(
                      color: Color(0xFFFED90F),
                    ),
                    accountName: new Text('Machu'),
                    accountEmail: new Text(user.email!),
                    currentAccountPicture: new CircleAvatar(
                      radius: 50.0,
                      backgroundImage: AssetImage("assets/images/machu.jpg"),
                    ),
                  ),
                  ListTile(
                    title: new Text("Account"),
                    onTap: (){},
                    leading: Icon(
                      Icons.account_circle_sharp,
                      color: Color(0xFFFED90F),
                    ),
                    trailing: Icon(
                      Icons.arrow_right,
                    ),
                  ),
                  ListTile(
                    title: new Text("FAQ"),
                    onTap: (){},
                    leading: Icon(
                      Icons.question_answer_outlined,
                    ),
                    trailing: Icon(
                      Icons.arrow_right,
                    ),
                  ),
                  ListTile(
                    title: new Text("How To Use App"),
                    onTap: (){},
                    leading: Icon(
                      Icons.info_outline_rounded,
                    ),
                    trailing: Icon(
                      Icons.arrow_right,
                    ),
                  ),
                  ListTile(
                    title: new Text("Settings"),
                    onTap: (){},
                    leading: Icon(
                      Icons.settings,
                    ),
                    trailing: Icon(
                      Icons.arrow_right,
                    ),
                  ),
                  ListTile(
                    title: new Text("Terms & Conditions"),
                    onTap: (){},
                    leading: Icon(
                      Icons.book,
                    ),
                    trailing: Icon(
                      Icons.arrow_right,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              child: Column(
                children: <Widget>[
                  Container(
                    child: Align(
                      alignment: FractionalOffset.bottomCenter,
                      child: Container(
                        child: Column(
                          children: <Widget>[
                            Divider(),
                            ListTile(
                              title: Text("Sign Out"),
                              onTap: () async => await _signOut(),
                              leading: Icon(
                                Icons.logout,
                              ),
                              trailing: Icon(
                                Icons.arrow_right,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Stack(
            children: <Widget>[
              Container(
                height: size.height,
                width: double.infinity,
                child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    Positioned(
                      top: 0,
                      child: Image.asset(
                        "assets/images/Vector 4.png",
                        width: size.width,
                      ),
                    ),
                  ],
                ),
              ),
              SingleChildScrollView(
                child: Container(
                  margin: const EdgeInsets.fromLTRB(10, 20, 10, 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.asset(
                        "assets/images/Investments.png",
                      ),
                      SizedBox(height: 20,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          EarningCard(),
                          SizedBox(width: 10),
                          PointsCard(),
                        ],
                      ),
                      SizedBox(height: 25),
                      Text(
                        "RECENT TRANSACTIONS",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 13,
                            color: Color(0xff272727),
                            fontWeight: FontWeight.w500
                        ),
                      ),
                      SizedBox(height: 10),
                      TransactCard(),
                      SizedBox(height: 10),
                      TransactCard2(),
                      SizedBox(height: 10),
                      TransactCard3(),
                      SizedBox(height: 10),
                      TransactCard4(),
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

class EarningCard extends StatelessWidget {
  const EarningCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        elevation: 16, // the size of the shadow
        shadowColor: Colors.black,
        child: SizedBox(
          width: 150,
          height: 100,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('₱ 1,500',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    color: Color(0xFF0CBC8B),
                    fontSize: 22,
                    letterSpacing: -0.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 10),
                Text('Earning\nBalance',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 14,
                    letterSpacing: -0.5,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PointsCard extends StatelessWidget {
  const PointsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        elevation: 16, // the size of the shadow
        shadowColor: Colors.black,
        child: SizedBox(
          width: 150,
          height: 100,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.star,
                      color: Color(0xFFFFBA4C),
                    ),
                    SizedBox(width: 5),
                    Text('100',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        color: Color(0xFFFFBA4C),
                        fontSize: 22,
                        letterSpacing: -0.5,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Text('Available\n   Points',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 14,
                    letterSpacing: -0.5,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TransactCard extends StatelessWidget {
  const TransactCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        elevation: 10, // the size of the shadow
        shadowColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: SizedBox(
          width: 300,
          height: 60,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    SizedBox(width: 12),
                    Icon(
                      Icons.monetization_on,
                      size: 30,
                      color: Color(0xFFFFBA4C),
                    ),
                    SizedBox(width: 12),
                    Column(
                      children: <Widget>[
                        Text('Booking Completed!',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 14,
                            letterSpacing: -0.5,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5),
                        Row(
                          children: <Widget>[
                            Text('Karlo Pangilinan',
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 14,
                                letterSpacing: -0.5,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Icon(
                              Icons.verified_rounded,
                              size: 16,
                              color: Color(0xFF0CBC8B),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Spacer(),
                    Text('₱ +50',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        color: Color(0xFF0CBC8B),
                        fontSize: 18,
                        letterSpacing: -0.5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 15,)
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TransactCard2 extends StatelessWidget {
  const TransactCard2({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        elevation: 10, // the size of the shadow
        shadowColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: SizedBox(
          width: 300,
          height: 60,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    SizedBox(width: 12),
                    Icon(
                      Icons.monetization_on,
                      size: 30,
                      color: Color(0xFFFFBA4C),
                    ),
                    SizedBox(width: 12),
                    Column(
                      children: <Widget>[
                        Text('Booking Completed!',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 14,
                            letterSpacing: -0.5,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5),
                        Row(
                          children: <Widget>[
                            Text('Ric Tingchuy',
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 14,
                                letterSpacing: -0.5,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Icon(
                              Icons.verified_rounded,
                              size: 16,
                              color: Color(0xFF0CBC8B),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Spacer(),
                    Text('₱ +50',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        color: Color(0xFF0CBC8B),
                        fontSize: 18,
                        letterSpacing: -0.5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 15,)
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TransactCard3 extends StatelessWidget {
  const TransactCard3({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        elevation: 10, // the size of the shadow
        shadowColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: SizedBox(
          width: 300,
          height: 60,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    SizedBox(width: 12),
                    Icon(
                      Icons.cancel_rounded,
                      size: 30,
                      color: Colors.red,
                    ),
                    SizedBox(width: 12),
                    Column(
                      children: <Widget>[
                        Text('Booking Cancelled!',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 14,
                            letterSpacing: -0.5,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5),
                        Row(
                          children: <Widget>[
                            Text('Marc Irwin',
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 14,
                                letterSpacing: -0.5,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Icon(
                              Icons.verified_rounded,
                              size: 16,
                              color: Color(0xFF0CBC8B),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Spacer(),
                    Row(
                      children: <Widget>[
                        Icon(
                          Icons.star,
                          color: Color(0xFFFFBA4C),
                        ),
                        Text('+10',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            color: Color(0xFFFFBA4C),
                            fontSize: 18,
                            letterSpacing: -0.5,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 15,)
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TransactCard4 extends StatelessWidget {
  const TransactCard4({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        elevation: 10, // the size of the shadow
        shadowColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: SizedBox(
          width: 300,
          height: 60,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    SizedBox(width: 12),
                    Icon(
                      Icons.monetization_on,
                      size: 30,
                      color: Color(0xFFFFBA4C),
                    ),
                    SizedBox(width: 12),
                    Column(
                      children: <Widget>[
                        Text('Booking Completed!',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 14,
                            letterSpacing: -0.5,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5),
                        Row(
                          children: <Widget>[
                            Text('Nicolas Gamab',
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 14,
                                letterSpacing: -0.5,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Icon(
                              Icons.verified_rounded,
                              size: 16,
                              color: Color(0xFF0CBC8B),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Spacer(),
                    Text('₱ +80',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        color: Color(0xFF0CBC8B),
                        fontSize: 18,
                        letterSpacing: -0.5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 15,)
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}