import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class PrivacyNotice extends StatefulWidget {

  @override
  State<PrivacyNotice> createState() => PrivacyNoticeState();

}

class PrivacyNoticeState extends State<PrivacyNotice> {

  String formattedDate = DateFormat.yMMMMd('en_US').format(DateTime.now());

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return AlertDialog(
      // backgroundColor: Color(0XFFFFFCEA),
      title: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Privacy Notice ",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  color: Color(0XFF272727),
                  fontSize: 18.5,
                  letterSpacing: -0.5,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Icon(
                Icons.privacy_tip,
                size: 22.sp,
                color:  Color(0XFF272727),
              ),
            ],
          ),
        ]),
      shape: RoundedRectangleBorder(
          borderRadius:
          BorderRadius.all(Radius.circular(20))),
      scrollable: true,
      content: Column(
        children: [
          Text("DO NOT USE THE EHATID APP AND SERVICES IF YOU DO NOT AGREE TO THESE TERMS. \n \n"
    "Please read these Terms and Conditions carefully before using any of our E-Hatid Services. Your access "
    "to and use of the Service is conditioned on your acceptance of and compliance. "
    "These apply to all drivers, passengers, and others who access or use the Service. "
    "By accessing or using the Service you agree to be bound by these Terms. If you disagree with any part of the Terms then you may not access the Service.\n",
            textAlign: TextAlign.justify,
            style: TextStyle(fontFamily: "Montserrat", fontSize: 13),),

          Row(
            children: [
              Text("Terms and Conditions ",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  color: Colors.black,
                  fontSize: 18.5,
                  letterSpacing: -0.5,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Icon(
                Icons.outlined_flag_outlined,
                size: 22.sp,
                color:  Color(0XFF272727),
              ),
            ],
          ),
          SizedBox(height: Adaptive.h(1),),
          Text("E-Hatid is an Android-based mobile application for tricycle booking to help the residents of"
              " Bolbok to have an accessible and convenient mode of transportation via tricycle. This will allow"
              " them to book a tricycle ride in the comfort of their homes without having to worry how they'll get"
              "  a tricycle ride. This is available for use to help them save their time and effort without having"
              " to walk far going to the terminal. \n\n"

              "The free use of the E-Hatid Application is included in the registration of drivers at the TODA"
              "Terminal in Lourdes. This implies that the finances for maintaining and updating the system will"
              "come from the fees paid by the drivers. It is the TODA's responsibility to manage and implement all"
              "of the system's demands and costs, such as hosting and API cost breakdowns.",
        textAlign: TextAlign.justify,
        style: TextStyle(fontFamily: "Montserrat", fontSize: 13),),

          Text("Why we collect your\n information? ",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Montserrat',
              color: Colors.black,
              fontSize: 18.5,
              letterSpacing: -0.5,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: Adaptive.h(1),),

          Text("We collect your information to be able to store it in the admin's system for daily monitoring of"
              " bookings. All the details that are collected about you will not be disclosed in any way or form"
              " because the other users who will manage the system will need to sign a NDA Agreement for everyone's "
              " protection and security.  Ensure that E-Hatid works as it should and you are able to browse"
              " E-Hatid safely and securely. We also collect your information to track "
              "bugs, errors, and usage statistics. In case of any security incident or "
              "data breach, we may also use your information in our investigative "
              "reporting to the National Privacy Commission. \n",
            textAlign: TextAlign.justify,
            style: TextStyle(fontFamily: "Montserrat", fontSize: 13),),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Data Privacy Act ",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  color: Colors.black,
                  fontSize: 18.5,
                  letterSpacing: -0.5,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Icon(
                Icons.rule_folder,
                size: 22.sp,
                color:  Color(0XFF272727),
              ),
            ],
          ),
          SizedBox(height: Adaptive.h(1),),

          Text("The Data Privacy Act affords you the following rights with regards to your personal data/information: \n\n"
          "i. To be informed whether Personal Data pertaining to him or her shall be, are being, or have been processed;\n"
          "ii. To reasonable access to any Personal Data collected and processed in duration of employment;\n"
          "iii. To suspend, withdraw, or order the blocking, removal, or destruction of Personal Data from the relevant company's filing system;\n"
          "iv. To dispute the inaccuracy or error in Personal Data, and the relevant company shall correct it immediately and accordingly, upon the request unless the request is vexatious or otherwise unreasonable;\n"
          "v. Where the Data Subject's Personal Data is processed through electronic means and in a structured and commonly used format, the Data Subject has the right to obtain a copy of such data in an electronic or structured format that is commonly used and allows for further use by the Data Subject;\n"
          "vi. The Data Subject has the right to be indemnified for any damages sustained pursuant to the provisions of the Data Privacy Act or Other Privacy Laws \n"
            "\nIf you want to exercise your rights or learn more about how E-Hatid processes your information, please contact our Data Protection Officer at help@ehatid.ph.",
            textAlign: TextAlign.justify,
            style: TextStyle(fontFamily: "Montserrat", fontSize: 13),),

          SizedBox(height: Adaptive.h(2),),
          MaterialButton(
            onPressed: (){
              Navigator.of(context, rootNavigator: true).pop();
            },
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50)
            ),
            minWidth: Adaptive.w(30),
            child: Text("Done", style: TextStyle( color: Colors.white,
              fontSize: 15,
              fontFamily: "Montserrat",
              fontWeight: FontWeight.w600,),),
            color: Color(0XFF0CBB8A),
          ),
        ],
      ),
      actionsAlignment: MainAxisAlignment.center,
    );
  }
}

