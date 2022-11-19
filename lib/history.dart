import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    //total height and width
    return Scaffold(
      backgroundColor: Color(0xFFFFFCEA),
      body: SafeArea(
        child: Container(
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
                        "assets/images/Vector 3.png",
                        width: size.width,
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
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
                  margin: const EdgeInsets.fromLTRB(10, 30, 10, 0),
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/images/ehatid logo.png",
                        width: 350,
                        height: 130,
                      ),
                      Text(
                        "Rides History",
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 28,
                            letterSpacing: -2,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Recent Booking',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 17,
                          letterSpacing: 5,
                        ),
                      ),
                      ElevatedCard(),
                      Booking1(),
                      Booking2(),
                      Booking3(),
                      Booking4(),
                      Booking5(),
                      Booking6(),
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

class ElevatedCard extends StatelessWidget {
  const ElevatedCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: Card(
          elevation: 10, // the size of the shadow
          shadowColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: SizedBox(
            width: 300,
            height: 80,
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      SizedBox(width: 16),
                      Icon(
                        Icons.access_time,
                        size: 30,
                        color: Color(0xFFFFBA4C),
                      ),
                      SizedBox(width: 12),
                      Column(
                        children: <Widget>[
                          Text(
                            'Karlo Pangilinan',
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 5),
                          Row(
                            children: <Widget>[
                              Text(
                                'September 30, 2022 3:00PM',
                                style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Spacer(),
                      Text(
                        '₱ +50',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          color: Color(0xFF0CBC8B),
                          fontSize: 18,
                          letterSpacing: -0.5,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        width: 15,
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Booking1 extends StatelessWidget {
  const Booking1({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        elevation: 10, // the size of the shadow
        shadowColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: SizedBox(
          width: 300,
          height: 80,
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    SizedBox(width: 16),
                    Icon(
                      Icons.access_time,
                      size: 30,
                      color: Color(0xFFFFBA4C),
                    ),
                    SizedBox(width: 12),
                    Column(
                      children: <Widget>[
                        Text(
                          'Cali Kornia',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5),
                        Row(
                          children: <Widget>[
                            Text(
                              'September 30, 2022 2:24PM',
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Spacer(),
                    Text(
                      '₱ +150',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        color: Color(0xFF0CBC8B),
                        fontSize: 18,
                        letterSpacing: -0.5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    )
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

class Booking2 extends StatelessWidget {
  const Booking2({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        elevation: 10, // the size of the shadow
        shadowColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: SizedBox(
          width: 300,
          height: 80,
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    SizedBox(width: 16),
                    Icon(
                      Icons.access_time,
                      size: 30,
                      color: Color(0xFFFFBA4C),
                    ),
                    SizedBox(width: 12),
                    Column(
                      children: <Widget>[
                        Text(
                          'Jaybee Lyn',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5),
                        Row(
                          children: <Widget>[
                            Text(
                              'September 30, 2022 1:45PM',
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Spacer(),
                    Text(
                      '₱ +75',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        color: Color(0xFF0CBC8B),
                        fontSize: 18,
                        letterSpacing: -0.5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    )
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

class Booking3 extends StatelessWidget {
  const Booking3({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        elevation: 10, // the size of the shadow
        shadowColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: SizedBox(
          width: 300,
          height: 80,
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    SizedBox(width: 16),
                    Icon(
                      Icons.access_time,
                      size: 30,
                      color: Color(0xFFFFBA4C),
                    ),
                    SizedBox(width: 12),
                    Column(
                      children: <Widget>[
                        Text(
                          'Gardi Bing',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5),
                        Row(
                          children: <Widget>[
                            Text(
                              'September 30, 2022 11:32AM',
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Spacer(),
                    Text(
                      '₱ +150',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        color: Color(0xFF0CBC8B),
                        fontSize: 18,
                        letterSpacing: -0.5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    )
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

class Booking4 extends StatelessWidget {
  const Booking4({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        elevation: 10, // the size of the shadow
        shadowColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: SizedBox(
          width: 300,
          height: 80,
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    SizedBox(width: 16),
                    Icon(
                      Icons.access_time,
                      size: 30,
                      color: Color(0xFFFFBA4C),
                    ),
                    SizedBox(width: 12),
                    Column(
                      children: <Widget>[
                        Text(
                          'Taylor Swing',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5),
                        Row(
                          children: <Widget>[
                            Text(
                              'September 29, 2022 5:00PM',
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Spacer(),
                    Text(
                      '₱ +120',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        color: Color(0xFF0CBC8B),
                        fontSize: 18,
                        letterSpacing: -0.5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    )
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

class Booking5 extends StatelessWidget {
  const Booking5({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        elevation: 10, // the size of the shadow
        shadowColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: SizedBox(
          width: 300,
          height: 80,
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    SizedBox(width: 16),
                    Icon(
                      Icons.access_time,
                      size: 30,
                      color: Color(0xFFFFBA4C),
                    ),
                    SizedBox(width: 12),
                    Column(
                      children: <Widget>[
                        Text(
                          'Laura Paloi',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5),
                        Row(
                          children: <Widget>[
                            Text(
                              'September 29, 2022 3:30PM',
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Spacer(),
                    Text(
                      '₱ +65',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        color: Color(0xFF0CBC8B),
                        fontSize: 18,
                        letterSpacing: -0.5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    )
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

class Booking6 extends StatelessWidget {
  const Booking6({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        elevation: 10, // the size of the shadow
        shadowColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: SizedBox(
          width: 300,
          height: 80,
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    SizedBox(width: 16),
                    Icon(
                      Icons.access_time,
                      size: 30,
                      color: Color(0xFFFFBA4C),
                    ),
                    SizedBox(width: 12),
                    Column(
                      children: <Widget>[
                        Text(
                          'Raynil Falseno',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5),
                        Row(
                          children: <Widget>[
                            Text(
                              'September 29, 2022 12:00NN',
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Spacer(),
                    Text(
                      '₱ +150',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        color: Color(0xFF0CBC8B),
                        fontSize: 18,
                        letterSpacing: -0.5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    )
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
