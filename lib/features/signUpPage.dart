import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:virtuo/features/virtuoDashboard.dart';
import 'package:virtuo/helpers/commonWidgets.dart';
import 'package:virtuo/helpers/databaseConstants.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final nameController = TextEditingController();
  final schoolController = TextEditingController();
  final cityController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: customAppBar("Student Details", context),
      body: SingleChildScrollView(
        child: Column(
          children: [
            signUpFields("Name", nameController),
            signUpFields("School/College Name", schoolController),
            signUpFields("City", cityController),
            SizedBox(
              height: height * 0.04,
            ),
            TextButton(
                onPressed: () async {
                  if (nameController.text.isEmpty ||
                      schoolController.text.isEmpty ||
                      cityController.text.isEmpty) {
                    showSimpleNotification(
                      Center(
                        child: Text(
                          'Please Enter all details',
                          style: GoogleFonts.lato(fontWeight: FontWeight.bold),
                        ),
                      ),
                      background: Colors.red,
                    );
                    return;
                  } else {
                    String? token = await FirebaseMessaging.instance.getToken();
                    final userData = {
                      NAME_KEY: nameController.text.trim().toLowerCase(),
                      CITY_KEY: cityController.text.trim().toLowerCase(),
                      SCHOOL_KEY: schoolController.text.trim().toLowerCase(),
                      PHONE_KEY: FirebaseAuth.instance.currentUser!.phoneNumber,
                      USER_UID_KEY: FirebaseAuth.instance.currentUser!.uid,
                      FCM_DEVICE_ID: token,
                      CREATED_AT_KEY: DateTime.now(),
                    };
                    try {
                      await FirebaseFirestore.instance
                          .collection(USERS_COLLECTION)
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .set(userData);
                      await Fluttertoast.showToast(
                          msg: "Profile Created Successfully");
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const VirtuoDashboard()),
                          (route) => false);
                    } catch (e) {
                      print(e);
                    }
                  }
                },
                child: Container(
                  height: 50,
                  margin: const EdgeInsets.symmetric(horizontal: 50),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient:
                          LinearGradient(begin: Alignment.topCenter, colors: [
                        Colors.blue.shade600,
                        // Colors.indigo.shade500,
                        appLightBlue(),
                      ])),
                  child: Center(
                    child: Text(
                      "Create Profile",
                      style: GoogleFonts.lato(
                          color: Colors.white,
                          fontSize: height / 46,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}

Widget signUpFields(label, controller) {
  return Container(
    margin: const EdgeInsets.fromLTRB(20, 30, 20, 10),
    child: TextFormField(
      // keyboardType: TextInputType.number,
      controller: controller,
      decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(
              borderSide: BorderSide(
            color: Colors.black,
            width: 2,
          ))),
    ),
  );
}
