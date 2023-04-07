import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';

import '../bloc/userRepository.dart';

Color appBlue() {
  return Colors.blue;
}

Color appWhitishBlue() {
  return const Color.fromARGB(255, 211, 217, 255);
}

Color appWhite() {
  return Colors.white;
}

Color appBlack() {
  return Colors.black;
}

Color appText1() {
  // return Colors.black;
  return Colors.white;
}

Color appText2() {
  return Colors.black;
}

Color appLightBlue() {
  return const Color(0xff9FD7f7);
  // return const Color(0xff1292DA);
}

Color appAppBar() {
  return const Color(0xffF2F8FB);
}

Color appPageBackground() {
  return const Color(0xffF2F8FB);
}

// color app

Color appDarkBlue() {
  return const Color(0xff203354);
}

PreferredSizeWidget customAppBar(String pageName, BuildContext context) {
  final height = MediaQuery.of(context).size.height;
  final width = MediaQuery.of(context).size.width;
  return PreferredSize(
    preferredSize: Size.fromHeight(height * 0.075),
    child: AppBar(
      iconTheme: const IconThemeData(
        color: Colors.white,
      ),
      flexibleSpace: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: LinearGradient(begin: Alignment.topCenter, colors: [
              Colors.blue.shade400,
              // Colors.indigo.shade500,
              appLightBlue(),
            ])),
      ),
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.indigo[50],
        statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
        statusBarBrightness: Brightness.dark, // For iOS (dark icons)
      ),
      elevation: 0,
      backgroundColor: appLightBlue(),
      shape: CustomShapeClipper().toBorder(),
      title: Text(pageName),
      centerTitle: true,
      titleTextStyle: GoogleFonts.lato(
          color: Colors.white,
          fontSize: height / 42,
          letterSpacing: 0.6,
          fontWeight: FontWeight.w600),
    ),
  );
}

class CustomShapeClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 40);
    path.quadraticBezierTo(
        size.width / 4, size.height, size.width / 2, size.height);
    path.quadraticBezierTo(
        size.width * 3 / 4, size.height, size.width, size.height - 40);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }

  ShapeBorder toBorder() {
    return RoundedRectangleBorder(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
        side: BorderSide(
          color: Colors.indigo.shade50,
          width: 3,
        ));
  }
}

ButtonStyle customCancelButtonStyle(context) {
  final height = MediaQuery.of(context).size.height;
  return ButtonStyle(
    backgroundColor: MaterialStateProperty.all(Colors.black87),
    fixedSize: MaterialStateProperty.all(
        Size(MediaQuery.of(context).size.width * 0.4, height * 0.052)),
    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        side: BorderSide(color: appBlack()),
      ),
    ),
  );
}

ButtonStyle customAgreeButtonStyle(context) {
  final height = MediaQuery.of(context).size.height;
  return ButtonStyle(
    backgroundColor: MaterialStateProperty.all(appLightBlue()),
    fixedSize: MaterialStateProperty.all(
        Size(MediaQuery.of(context).size.width * 0.4, height * 0.052)),
    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        side: BorderSide(color: Colors.lightBlue.shade500),
      ),
    ),
  );
}

Widget menuBar(
    {required userName, required userPhone, context, height, width}) {
  return Drawer(
    child: ListView(
      children: <Widget>[
        UserAccountsDrawerHeader(
          decoration: BoxDecoration(
              color: appLightBlue(),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              )),

          accountName: Text(userName,
              style: GoogleFonts.lato(
                  fontSize: height / 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  letterSpacing: 1)),
          accountEmail: Text(userPhone,
              style: GoogleFonts.lato(
                  fontSize: height / 58,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                  color: Colors.black)),
          currentAccountPicture: GestureDetector(
            child: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(
                Icons.person,
                color: Colors.blueAccent,
                size: 30,
              ),
            ),
          ),
          // decoration: const BoxDecoration(color: Colors.blue),
        ),
        InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: ListTile(
              title: Text('Home', style: drawerItemsTextStyle(height)),
              leading: const Icon(Icons.home, color: Colors.blue),
            )),
        InkWell(
            onTap: () {
              Navigator.pop(context);
              // Navigator.push(
              //     context,
              // MaterialPageRoute(
              //     builder: (context) => BlocProvider(
              //         create: (context) => UserProfileCubit(),
              //         child: Profile(
              //           userUID: FirebaseAuth.instance.currentUser!.uid,
              //           isUserProfile: true,
              //         ))));
            },
            child: ListTile(
              title: Text('My Account', style: drawerItemsTextStyle(height)),
              leading: const Icon(Icons.person, color: Colors.blue),
            )),
        InkWell(
            onTap: () {
              Navigator.pop(context);
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => const AutoPay()),
              // );
            },
            child: ListTile(
              title: Text('Auto Pay', style: drawerItemsTextStyle(height)),
              leading: const Icon(Icons.autorenew, color: Colors.blue),
            )),
        InkWell(
            onTap: () {
              Navigator.pop(context);
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //       builder: (context) => const HomePageReference()),
              // );
            },
            child: ListTile(
              title: Text('Reference', style: drawerItemsTextStyle(height)),
              leading: const Icon(Icons.groups, color: Colors.blue),
            )),
        const Divider(),
        // InkWell(
        // onTap: () {
        //   Navigator.pop(context);
        //   Navigator.push(
        //     context,
        //     MaterialPageRoute(builder: (context) => const JsonToPdf()),
        //   );
        // },
        // child: ListTile(
        //   title:
        //       Text('GSTIN PDF SAMPLE', style: drawerItemsTextStyle(height)),
        //   leading: const Icon(
        //     Icons.contacts,
        //     color: Colors.blue,
        //   ),
        // )),
        InkWell(
            onTap: () {
              Navigator.pop(context);
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => MerchantResource()),
              // );
            },
            child: ListTile(
              title: Text('Merchant Resource',
                  style: drawerItemsTextStyle(height)),
              leading: const Icon(
                Icons.contacts,
                color: Colors.blue,
              ),
            )),
        InkWell(
            onTap: () async {
              // Navigator.pop(context);
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => TermsAndCondition()),
              final Uri _url = Uri.parse(
                  'https://github.com/retialcredit/karzsecure_policies/blob/main/LICENSE.md');
              if (!await launchUrl(_url)) {
                throw 'Could not launch $_url';
              }
            },
            child: ListTile(
              title: Text('Terms and conditions',
                  style: drawerItemsTextStyle(height)),
              leading: const Icon(Icons.note, color: Colors.blue),
            )),
        InkWell(
            onTap: () {
              Navigator.pop(context);
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => FAQ()),
              // );
            },
            child: ListTile(
              title: Text('FAQ', style: drawerItemsTextStyle(height)),
              leading: const Icon(Icons.question_answer, color: Colors.blue),
            )),
        const Divider(),
        InkWell(
            onTap: () {
              Navigator.pop(context);
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => const AboutUs()),
              // );
            },
            child: ListTile(
              title: Text('About Us', style: drawerItemsTextStyle(height)),
              leading: const Icon(Icons.help, color: Colors.blue),
            )),

        InkWell(
            onTap: () {
              Widget cancelButton = SizedBox(
                width: 120,
                height: 40,
                child: OutlinedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.black87),
                    fixedSize: MaterialStateProperty.all(Size(
                        MediaQuery.of(context).size.width * 0.4,
                        height * 0.052)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        side: BorderSide(color: appBlack()),
                      ),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Cancel",
                    style: GoogleFonts.openSans(
                        color: Colors.white,
                        fontSize: height / 54,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              );
              Widget continueButton = SizedBox(
                width: 120,
                height: 40,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(appLightBlue()),
                    fixedSize: MaterialStateProperty.all(Size(
                        MediaQuery.of(context).size.width * 0.4,
                        height * 0.052)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        side: BorderSide(color: Colors.lightBlue.shade500),
                      ),
                    ),
                  ),
                  onPressed: () async {
                    UserRepository().signOut(context);
                  },
                  child: Text("Logout",
                      style: GoogleFonts.openSans(
                          color: Colors.black,
                          fontSize: height / 54,
                          fontWeight: FontWeight.w600)),
                ),
              );

              // set up the AlertDialog
              AlertDialog alert = AlertDialog(
                icon: Icon(Icons.privacy_tip, color: Colors.red[300], size: 35),
                title: Text(
                  "Alert",
                  style: GoogleFonts.openSans(
                      fontSize: height / 42, fontWeight: FontWeight.w600),
                ),
                content: Text("Are you sure that you want to Logout ?",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.openSans(color: Colors.black87)),
                actions: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: cancelButton,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: continueButton,
                      ),
                    ],
                  ),
                ],
              );

              // show the dialog
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return alert;
                },
              );
            },
            child: ListTile(
              title: Text('Logout', style: drawerItemsTextStyle(height)),
              leading: const Icon(Icons.logout, color: Colors.blue),
            )),
      ],
    ),
  );
}

TextStyle drawerItemsTextStyle(height) {
  return GoogleFonts.lato(fontSize: height / 52, fontWeight: FontWeight.w600);
}

Widget customNotFoundContainer(context, message) {
  double width = MediaQuery.of(context).size.width;
  double height = MediaQuery.of(context).size.height;
  return SizedBox(
    height: height / 6,
    child: Container(
      height: height * 2,
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Lottie.asset("assets/Lottie/notFound_lottie.json",
              height: height * 0.08),

          // SizedBox(height: height * 0.03),
          Text(
            message,
            style: GoogleFonts.openSans(
              fontSize: height / 60,
            ),
          ),
        ],
      ),
    ),
  );
}

String firstLetterToUpperCase(String value) {
  return value.toString().split(" ").map((e) {
    if (e.length == 1) {
      return e.toUpperCase();
    } else {
      if (e == "") {
        return e;
      }
      return e[0].toUpperCase() + e.substring(1).toLowerCase();
    }
  }).join(" ");
}
