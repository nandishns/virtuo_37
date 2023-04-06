import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:overlay_support/overlay_support.dart';

import '../helpers/commonWidgets.dart';
import 'otpView.dart';

class LoginViewV2 extends StatefulWidget {
  const LoginViewV2({super.key});

  @override
  State<LoginViewV2> createState() => _LoginViewV2State();
}

class _LoginViewV2State extends State<LoginViewV2> {
  var phno = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(begin: Alignment.topCenter, colors: [
          Colors.blue.shade300,
          Colors.indigo.shade500,
          appLightBlue(),
        ])),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(
              height: 70,
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Virtuo",
                    style: GoogleFonts.lato(
                        color: Colors.white,
                        fontSize: 40,
                        letterSpacing: 0.5,
                        fontWeight: FontWeight.w800),
                  ),
                  SizedBox(
                    height: 10,
                  ),

                  Text(
                    "Learn With Visualisation",
                    style: GoogleFonts.lato(color: Colors.white, fontSize: 18),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  // SizedBox(
                  //   height: 10,
                  // ),
                  // FadeAnimation(
                  //     1.3,
                  //     Text(
                  //       "Helping SMBs Reduce B2B Credit Defaults",
                  //       style: TextStyle(color: Colors.white, fontSize: 18),
                  //     )),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(60),
                        topRight: Radius.circular(60))),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(30),
                    child: Column(
                      children: <Widget>[
                        const SizedBox(
                          height: 30,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              // color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: const [
                                BoxShadow(
                                    color: Color.fromRGBO(225, 95, 27, .3),
                                    blurRadius: 20,
                                    offset: Offset(0, 10))
                              ]),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                decoration: const BoxDecoration(
                                  color: Color.fromRGBO(240, 241, 244, 1),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15)),
                                ),
                                padding: EdgeInsets.symmetric(
                                    vertical: height * 0.015),
                                height: height * 0.08,
                                width: width * 0.18,
                                child: Column(
                                  // mainAxisAlignment:
                                  //     MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('IND',
                                        style: GoogleFonts.lato(
                                          color:
                                              Color.fromRGBO(107, 127, 141, 1),
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12,
                                        )),
                                    Text('+91',
                                        style: GoogleFonts.lato(
                                          // fontWeight: FontWeight.w700,
                                          // fontSize: height * 0.018,
                                          // color: const Color.fromRGBO(
                                          //     29, 31, 29, 1),
                                          fontWeight: FontWeight.w700,
                                          fontSize: 16,
                                          color: Color.fromRGBO(29, 31, 29, 1),
                                        )),
                                  ],
                                ),
                              ),
                              Container(
                                height: height * 0.08,
                                width: width * 0.65,
                                decoration: const BoxDecoration(
                                  color: Color.fromRGBO(240, 241, 244, 1),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                ),
                                child: TextFormField(
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(10),
                                    FilteringTextInputFormatter.allow(
                                        RegExp('[0-9]')),
                                  ],
                                  // maxLength : 10,
                                  style: GoogleFonts.lato(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16),
                                  keyboardType: TextInputType.phone,
                                  cursorColor:
                                      const Color.fromRGBO(29, 31, 29, 1),
                                  controller: phno,
                                  onChanged: (s) {},
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.only(
                                        top: height * 0.015,
                                        left: width * 0.07),
                                    border: InputBorder.none,
                                    floatingLabelStyle: GoogleFonts.lato(
                                      fontWeight: FontWeight.w500,
                                      color: const Color.fromRGBO(
                                          107, 127, 141, 1),
                                    ),
                                    labelText: "Mobile no.",
                                    labelStyle: GoogleFonts.lato(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        TextButton(
                            onPressed: () {
                              if (phno.text.length != 10 ||
                                  double.tryParse(phno.text) == null) {
                                showSimpleNotification(
                                  Center(
                                    child: Text(
                                      'Invalid phone number',
                                      style: GoogleFonts.lato(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  background: Colors.red,
                                );
                                return;
                              }
                              Navigator.push(
                                  context,
                                  MaterialPageRoute<dynamic>(
                                      builder: (context) =>
                                          // OTPView(phNo: phno.text),
                                          OTPView(phNo: phno.text)));
                            },
                            child: Container(
                              height: 50,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 50),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      colors: [
                                        Colors.blue.shade600,
                                        // Colors.indigo.shade500,
                                        appLightBlue(),
                                      ])),
                              child: Center(
                                child: Text(
                                  "Login",
                                  style: GoogleFonts.lato(
                                      color: Colors.white,
                                      fontSize: height / 46,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            )),
                        const SizedBox(
                          height: 50,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
