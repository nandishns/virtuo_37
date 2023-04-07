import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import '../bloc/appState.dart';
import '../bloc/states.dart';
import '../helpers/commonWidgets.dart';
import '../helpers/databaseConstants.dart';
import 'concepts.dart';
import 'notificatioj.dart';

class VirtuoDashboard extends StatefulWidget {
  const VirtuoDashboard({Key? key}) : super(key: key);

  @override
  State<VirtuoDashboard> createState() => _VirtuoDashboardState();
}

enum DrawerSections {
  dashboard,
  // contacts,
  // events,
  // notes,
  // settings,
  // notifications,
  // privacy_policy,
  // send_feedback,
}

class _VirtuoDashboardState extends State<VirtuoDashboard> {
  // ignore: constant_identifier_names
  static const String SEARCH_MERCHANT = "searchMerchant";

  // ignore: constant_identifier_names
  static const String PROFILE = "profile";

  // ignore: constant_identifier_names
  static const String REPORT_DEFAULTER = "reportDefaulter";

  // ignore: constant_identifier_names
  static const String DEFAULTER_HISTORY = "defaulterHistory";

  // ignore: constant_identifier_names
  static const String NOTIFICATIONS = "notifications";
  String userName = " ";
  late bool isGstinPresent;
  bool isButtonPressed = false;

  var currentPage = DrawerSections.dashboard;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return WillPopScope(
        onWillPop: () {
          return showExitPopup(context, false, height, width);
        },
        child: StoreConnector<AppState, UserProfileState>(
            converter: (store) => store.state.userProfile,
            builder: ((context, userProfileState) {
              Map<String, dynamic> userProfile = userProfileState.userProfile;

              String userName =
                  firstLetterToUpperCase(userProfile[NAME_KEY] ?? '');
              String userPhone = userProfile[PHONE_KEY] ?? '';
              return Scaffold(
                backgroundColor: appLightBlue(),
                appBar: appBar(context, width, height),
                body: SingleChildScrollView(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        userCard(context, height, width, userName),
                        SizedBox(
                          height: height * 0.02,
                        ),
                        featuresCard(context, height, width),
                      ]),
                ),
                drawer: menuBar(
                    userName: userName,
                    userPhone: userPhone,
                    context: context,
                    height: height,
                    width: width),
              );
            })));
  }

  Widget userCard(BuildContext context, height, width, userName) {
    String _getGreetingMessage() {
      var hour = DateTime.now().hour;
      if (hour < 12) {
        return "Good Morning!";
      } else if (hour < 18) {
        return "Good Afternoon!";
      } else {
        return "Good Evening!";
      }
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 0),
      child: Container(
        height: height * 0.18,
        decoration: const BoxDecoration(
          // color: appLightBlue(),
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
            top: Radius.circular(15),
          ),
          boxShadow: [
            // BoxShadow(
            //   color: Colors.grey.withOpacity(0.2),
            //   spreadRadius: 2,
            //   blurRadius: 5,
            //   offset: const Offset(0, 3),
            // ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //username
            Expanded(
              flex: 70,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(15, 2, 0, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: height * 0.04,
                    ),
                    Text(
                      _getGreetingMessage(),
                      textScaleFactor: 1,
                      style: GoogleFonts.poppins(
                        fontSize: height / 38,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    FutureBuilder(
                      future: getUserName(),
                      builder: (context, snapshot) {
                        // if (snapshot.connectionState == ConnectionState.waiting) {
                        //   return const CircularProgressIndicator();
                        // }
                        if (snapshot.hasData) {
                          dynamic data = snapshot.data;
                          if (data.length == 0) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Center(
                                  child: Text("Loading"),
                                )
                              ],
                            );
                          }
                          return Text(
                            userName,
                            style: GoogleFonts.lato(
                              fontSize: height / 40,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          );
                        }
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(child: Text("Loading")),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: height * 0.2,
            ),
            Expanded(
              flex: 50,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    SizedBox(
                      height: height * 0.04,
                    ),
                    SizedBox(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Lottie.asset("assets/lotties/streak.json",
                                  height: height * 0.09),
                              Text("0", style: GoogleFonts.ubuntu(fontSize: 30))
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Text(
                    //   "Karzsecure",
                    //   style: GoogleFonts.openSans(
                    //       fontWeight: FontWeight.w700,
                    //       fontSize: height / 62,
                    //       color: Colors.black54),
                    // ),
                  ],
                ),
              ),
            )
          ],
          //karzsecure
        ),
      ),
    );
  }

  Widget featuresCard(BuildContext context, height, width) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.661,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(55),
          topRight: Radius.circular(55),
        ),
        // border: Border(
        //   top: BorderSide(width: 2, color: Colors.blue),
        // ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          featureContainer(
            width: width,
            height: height,
            featureName: REPORT_DEFAULTER,
          ),
          SizedBox(
            height: height * .05,
          ),
          featureContainer(
            width: width,
            height: height,
            featureName: PROFILE,
          ),
          SizedBox(height: height * 0.05),
          featureContainer(
            width: width,
            height: height,
            featureName: DEFAULTER_HISTORY,
          ),
        ],
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Widget MyDrawerList() {
    return Container(
      padding: const EdgeInsets.only(
        top: 15,
      ),
      child: Column(
        // shows the list of menu drawer
        children: [
          menuItem(1, "Dashboard", Icons.dashboard_outlined,
              currentPage == DrawerSections.dashboard ? true : false),
          // menuItem(2, "Contacts", Icons.people_alt_outlined,
          //     currentPage == DrawerSections.contacts ? true : false),
          // menuItem(3, "Events", Icons.event,
          //     currentPage == DrawerSections.events ? true : false),
          // menuItem(4, "Notes", Icons.notes,
          //     currentPage == DrawerSections.notes ? true : false),
          // Divider(),
          // menuItem(5, "Settings", Icons.settings_outlined,
          //     currentPage == DrawerSections.settings ? true : false),
          // menuItem(6, "Notifications", Icons.notifications_outlined,
          //     currentPage == DrawerSections.notifications ? true : false),
          // Divider(),
          // menuItem(7, "Privacy policy", Icons.privacy_tip_outlined,
          //     currentPage == DrawerSections.privacy_policy ? true : false),
          // menuItem(8, "Send feedback", Icons.feedback_outlined,
          //     currentPage == DrawerSections.send_feedback ? true : false),
        ],
      ),
    );
  }

  Widget menuItem(int id, String title, IconData icon, bool selected) {
    return Material(
      color: selected ? Colors.grey[300] : Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.pop(context);
          setState(() {
            if (id == 1) {
              currentPage = DrawerSections.dashboard;
            }
            // else if (id == 2) {
            //   currentPage = DrawerSections.contacts;
            // } else if (id == 3) {
            //   currentPage = DrawerSections.events;
            // } else if (id == 4) {
            //   currentPage = DrawerSections.notes;
            // } else if (id == 5) {
            //   currentPage = DrawerSections.settings;
            // } else if (id == 6) {
            //   currentPage = DrawerSections.notifications;
            // } else if (id == 7) {
            //   currentPage = DrawerSections.privacy_policy;
            // } else if (id == 8) {
            //   currentPage = DrawerSections.send_feedback;
            // }
          });
        },
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            children: [
              Expanded(
                child: Icon(
                  icon,
                  size: 20,
                  color: Colors.black,
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget featureContainer({width, height, featureName}) {
    return GestureDetector(
      onTap: () {
        switch (featureName) {
          case SEARCH_MERCHANT:
            // ignore: use_build_context_synchronously
            // Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //         builder: ((context) => BlocProvider(
            //               create: ((context) => SearchUserCubit()),
            //               child: const SearchUser(),
            //             ))));
            break;
          case REPORT_DEFAULTER:
            // ignore: use_build_context_synchronously
            // Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //         builder: ((context) => BlocProvider(
            //               create: ((context) => SearchUserCubit()),
            //               child: const AssociationMarkAsFraud(),
            //             ))));
            break;
          case DEFAULTER_HISTORY:
            // ignore: use_build_context_synchronously
            Navigator.push(context,
                MaterialPageRoute(builder: ((context) => const Concepts())));
            break;
          case PROFILE:
            // Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //         builder: (context) => BlocProvider(
            //             create: (context) => UserProfileCubit(),
            //             child: Profile(
            //               userUID: FirebaseAuth.instance.currentUser!.uid,
            //               isUserProfile: true,
            //             ))));
            // Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //         builder: ((context) => BlocProvider(
            //               create: ((context) => SearchUserCubit()),
            //               child: const SearchUser(),
            //             ))));
            break;
          default:
            return;
        }
      },
      child: Container(
        width: width,
        height: height * 0.14,
        padding: const EdgeInsets.only(left: 15, right: 10),
        margin: const EdgeInsets.only(left: 20, right: 20),
        decoration: BoxDecoration(
          color: featureName == PROFILE ? appLightBlue() : Colors.white,
          border: Border.all(color: Colors.transparent, width: 2),
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          boxShadow: [
            BoxShadow(
              color: Colors.indigo.withOpacity(0.2),
              spreadRadius: 4,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              flex: 8,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    returnFeatureName(featureName),
                    style: GoogleFonts.lato(
                        fontWeight: FontWeight.bold,
                        color: featureName == PROFILE
                            ? Colors.black87
                            : const Color.fromARGB(255, 88, 86, 86),
                        fontSize: height / 42),
                  ),
                  SizedBox(
                    height: height * .01,
                  ),
                  Text(
                    returnFeatureDescription(featureName),
                    style: GoogleFonts.lato(
                        fontWeight: FontWeight.w600,
                        color: featureName == PROFILE
                            ? Colors.black87
                            : const Color.fromARGB(255, 88, 86, 86),
                        fontSize: height / 54),
                  ),
                ],
              ),
            ),
            Expanded(
                flex: 2,
                child: Icon(
                  returnIconData(featureName),
                  color: featureName == PROFILE
                      ? Colors.black54
                      : Colors.blue[300],
                  size: 50,
                ))
          ],
        ),
      ),
    );
  }

  Color returnFeatureColor(featureName) {
    switch (featureName) {
      case SEARCH_MERCHANT:
        // return Colors.green.withOpacity(0.5);
        return appBlue();
      case REPORT_DEFAULTER:
        // return const Color(0xff1A1A1C);
        return appBlue();
      case DEFAULTER_HISTORY:
        // return const Color.fromARGB(255, 73, 22, 82);
        return appBlue();
      case NOTIFICATIONS:
        // return const Color(0xff1A1A1C);
        return appBlue();
      default:
        // return const Color(0xff1A1A1C);
        return appBlue();
    }
  }

  String returnFeatureName(featureName) {
    switch (featureName) {
      case SEARCH_MERCHANT:
        return "Search Merchant";
      case REPORT_DEFAULTER:
        return "Virtuo Labs";
      case DEFAULTER_HISTORY:
        return "Concept Visualisation";
      case NOTIFICATIONS:
        return "View Notifications";
      case PROFILE:
        return "View Profile";
      default:
        return "";
    }
  }

  String returnFeatureDescription(featureName) {
    switch (featureName) {
      case SEARCH_MERCHANT:
        return "View merchant profile using their Phone no. or GSTIN";
      case REPORT_DEFAULTER:
        return "VR STEM Experiments";
      case DEFAULTER_HISTORY:
        return "Learn STEM Concepts using Virtuo Visualisation";
      case PROFILE:
        return "Check profile of businesses by their GSTIN or Phone number";
      case NOTIFICATIONS:
        return "Here Merchant marked by you as defaulter will be visible.";
      default:
        return "";
    }
  }

  IconData returnIconData(featureName) {
    switch (featureName) {
      case SEARCH_MERCHANT:
        return Icons.search;
      case REPORT_DEFAULTER:
        return Icons.science;
      case DEFAULTER_HISTORY:
        return Icons.list_alt;
      case PROFILE:
        return Icons.person;
      default:
        return Icons.abc;
    }
  }

  PreferredSizeWidget appBar(
    BuildContext context,
    width,
    height,
  ) {
    return PreferredSize(
      preferredSize: Size.fromHeight(height * 0.075),
      child: AppBar(
        leading: Builder(builder: (context) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(8, 6, 0, 0),
            child: IconButton(
              icon: const Icon(
                Icons.sort,
                color: Colors.blueAccent,
                size: 36,
              ),
              onPressed: () => Scaffold.of(context).openDrawer(),
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            ),
          );
        }),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.indigo[50],
          statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
          statusBarBrightness: Brightness.light, // For iOS (dark icons)
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        shape: CustomShapeClipper().toBorder(),
        title: Row(
          children: [
            Expanded(flex: 5, child: searchWidget(context)),
            Expanded(
              flex: 1,
              child: IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Notifications(),
                        ));
                  },
                  icon: const Padding(
                    padding: EdgeInsets.fromLTRB(4, 6, 0, 0),
                    child: Icon(
                      Icons.notifications,
                      size: 30,
                      // color: Colors.grey,
                      color: Colors.blueAccent,
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }

  Widget searchWidget(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final searchBarWidth = screenWidth * 0.8;

    return GestureDetector(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
        child: Container(
          width: searchBarWidth,
          height: height * 0.048,
          decoration: BoxDecoration(
            color: Colors.indigo[50],
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextField(
            decoration: InputDecoration(
              hintText: "   Search by Concept or Topics...",
              hintStyle: GoogleFonts.openSans(fontWeight: FontWeight.w500),
              enabled: false,
              suffixIcon: const Icon(
                Icons.search,
                size: 30,
                color: Colors.blueAccent,
              ),
              border: InputBorder.none,
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> showExitPopup(context, bool enabled, height, width) async {
    Widget cancelButton = SizedBox(
      width: 120,
      height: 40,
      child: OutlinedButton(
        style: customCancelButtonStyle(context),
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: Text("Cancel",
            style: GoogleFonts.openSans(
              color: Colors.white,
              fontSize: height / 56,
              fontWeight: FontWeight.w600,
            )),
      ),
    );
    Widget continueButton = SizedBox(
      width: 120,
      height: 40,
      child: ElevatedButton(
        style: customAgreeButtonStyle(context),
        onPressed: () async {
          exit(0);
        },
        child: Text("Exit",
            style: GoogleFonts.openSans(
                color: Colors.black,
                fontSize: height / 56,
                fontWeight: FontWeight.w600)),
      ),
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      icon: const Icon(Icons.task_alt, color: Colors.green, size: 35),
      title: Text(
        "Confirm",
        style: GoogleFonts.openSans(fontSize: 25, fontWeight: FontWeight.w600),
      ),
      content: Text("Are you sure that you want to Exit application ?",
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
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}

Future<dynamic> getUserName() async {
  // isLoading = true;
  try {
    String currentUserID =
        FirebaseAuth.instance.currentUser!.uid.toString().toLowerCase();
    QuerySnapshot userName = await FirebaseFirestore.instance
        .collection(USERS_COLLECTION)
        .where(USER_UID_KEY, isEqualTo: currentUserID)
        .get();
    if (userName.docs.isNotEmpty) {
      final userRef = userName.docs.first.data();
      final username = userRef;
      if (username != null) {
        print(username);
        // do something with the username
        return username;
      } else {
        // handle the case where the userRef map doesn't contain the NAME_KEY
        return "";
      }
    } else {
      // handle the case where no user was found
      return "";
    }

    // isLoading = false;
  } catch (e) {
    print(e);
    return "";
  }
}
