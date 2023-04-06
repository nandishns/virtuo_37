import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:logger/logger.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:virtuo/helpers/commonWidgets.dart';

import '../otpVerificationBloc/otpVerificationBloc.dart';
import '../otpVerificationBloc/otpVerificationEvent.dart';
import '../otpVerificationBloc/otpVerificationState.dart';

class OTPView extends StatefulWidget {
  final String phNo;
  const OTPView({Key? key, required this.phNo}) : super(key: key);
  @override
  State<StatefulWidget> createState() => OTPState();
}

class OTPState extends State<OTPView> {
  ValueNotifier<bool> cflag = ValueNotifier<bool>(false);
  late otpVerificationBloc _verificationBloc;
  // var otp = TextEditingController();
  ValueNotifier<bool> disable = ValueNotifier<bool>(false);
  var l = Logger();
  var test = 0;
  late Timer timer;
  int second = 15;
  bool isTimerRunning = false;
  String otpString = "";
  String timerText(int start) {
    if (start > 9) {
      return start.toString();
    } else {
      return '0${start.toString()}';
    }
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        if (second == 0) {
          isTimerRunning = false;
          timer.cancel();
          return;
        }
        second--;
      });
    });
  }

  @override
  void initState() {
    _verificationBloc = BlocProvider.of<otpVerificationBloc>(context);
    _verificationBloc.add(getOtp(phoneNumber: '+91${widget.phNo}'));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      // backgroundColor: Colors.black,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton:
          BlocConsumer<otpVerificationBloc, otpVerificationState>(
              listener: (context, state) {
                if (state is otpVerificationStateFailed) {
                  showSimpleNotification(
                    const Center(
                      child: Text(
                        "Invalid OTP.",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    background: Colors.red,
                  );
                }

                if (state is verificationFail) {
                  showSimpleNotification(
                    const Center(
                      child: Text(
                        "Phone Number could not be verified",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    background: Colors.red,
                  );
                }
              },
              bloc: BlocProvider.of<otpVerificationBloc>(context),
              builder: (context, state) {
                if (state is otpVerificationStateLoading) {
                  return Container();
                }

                return Padding(
                  padding: EdgeInsets.only(bottom: 10, left: width * .1),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (isTimerRunning == true) {
                            return;
                          }
                          if (otpString.length == 6) {
                            _verificationBloc.add(
                                submitted(otp: otpString, context: context));
                          }
                          startTimer();
                          setState(() {
                            second = 15;
                            isTimerRunning = true;
                          });
                        },
                        child: Card(
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                          child: Container(
                            // width: width / 3.5,
                            width: MediaQuery.of(context).size.width * 0.34,
                            // height: height * .05,
                            height: height * 0.076,
                            decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12))),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Text(
                                  "RESEND",
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          if (otpString.length != 6) {
                            showSimpleNotification(
                              const Center(
                                child: Text(
                                  "Invalid OTP.",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              background: Colors.red,
                            );
                            return;
                          }
                          _verificationBloc
                              .add(submitted(otp: otpString, context: context));
                        },
                        child: Card(
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.34,
                            height: height * 0.076,
                            decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12))),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Text(
                                  "VERIFY",
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
      appBar: customAppBar("Virtuo", context),
      body: BlocBuilder<otpVerificationBloc, otpVerificationState>(
        bloc: BlocProvider.of<otpVerificationBloc>(context),
        builder: (context, state) {
          if (state is otpVerificationStateLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return BlocProvider<otpVerificationBloc>(
            create: (context) => otpVerificationBloc(context: context),
            child: Container(
              margin: EdgeInsets.only(top: height * 0.115, left: width * 0.06),
              height: height,
              width: width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: height * 0.04),
                  RichText(
                      text: TextSpan(
                          text: 'Enter OTP sent to +91 ${widget.phNo}  ',
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                              color: Colors.white.withOpacity(.8)),
                          children: [
                        TextSpan(
                          text: 'CHANGE No.',
                          style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                              color: Color.fromRGBO(50, 201, 214, 1)),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => Navigator.pop(context),
                        )
                      ])),
                  SizedBox(height: height * 0.03),
                  pinFields(height, width, context, cflag, _verificationBloc),
                  SizedBox(height: height * 0.03),
                  isTimerRunning == true
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Click to resend after ",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 15)),
                            const Icon(
                              Icons.timer,
                              color: Colors.white,
                            ),
                            const SizedBox(
                              width: 3,
                            ),
                            Text(
                              // second.toString(),
                              " 00:${timerText(second)}",
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 15),
                            )
                          ],
                        )
                      : Container(),
                  const Spacer(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget pinFields(double height, double width, BuildContext c,
      ValueNotifier<bool> flag, otpVerificationBloc bloc) {
    // var l = Logger();
    return ValueListenableBuilder(
      valueListenable: flag,
      builder: (BuildContext context, value, Widget? child) {
        return Container(
            padding: EdgeInsets.only(right: width * 0.06),
            height: height * 0.08,
            width: width,
            child: PinCodeTextField(
                length: 6,
                obscureText: false,
                animationType: AnimationType.fade,
                cursorColor: Colors.black,
                keyboardType: TextInputType.number,
                textStyle: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    color: !flag.value
                        ? const Color.fromRGBO(29, 31, 29, 1)
                        : const Color.fromRGBO(50, 201, 214, 1)),
                pinTheme: PinTheme(
                  inactiveFillColor: const Color.fromRGBO(240, 241, 244, 1),
                  inactiveColor: Colors.transparent,
                  activeFillColor: flag.value
                      ? const Color.fromRGBO(50, 201, 214, 0.27)
                      : const Color.fromRGBO(240, 241, 244, 1),
                  activeColor: Colors.transparent,
                  selectedColor: Colors.transparent,
                  selectedFillColor: const Color.fromRGBO(240, 241, 244, 1),
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(15),
                  fieldHeight: height * 0.07,
                  fieldWidth: width * 0.13,
                ),
                animationDuration: const Duration(milliseconds: 300),
                enableActiveFill: true,
                onChanged: (value) async {
                  otpString = value;
                  if (value.length == 6) {
                    flag.value = true;
                    bloc.add(submitted(otp: otpString, context: c));
                    return;
                  } else {
                    //  if(value.length==6) showSimpleNotification(Text('OTP is invalid.'), background: Color(0xff29a39d));
                    flag.value = false;
                  }
                },
                appContext: c));
      },
    );
  }
}

Widget logoWithDesc(double height) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SvgPicture.asset(
        'assets/images/logo.svg',
        height: height * 0.06,
      ),
      SizedBox(
        height: height * 0.02,
      ),
      const Text(
        'Merchant Customer',
        style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 19,
            color: Color.fromRGBO(29, 31, 29, 1)),
      ),
      SizedBox(
        height: height * 0.02,
      ),
      const Text(
        'The common wallet and transactional tool for all the shopkeepers',
        style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 15,
            color: Color.fromRGBO(107, 127, 141, 1)),
      )
    ],
  );
}

Widget phoneLogin(double? height, double? width, TextEditingController phno) {
  return Container(
    padding: EdgeInsets.only(right: width! * 0.06),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          decoration: const BoxDecoration(
            color: Color.fromRGBO(240, 241, 244, 1),
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
          padding: const EdgeInsets.symmetric(vertical: 15),
          height: height! * 0.085,
          width: width * 0.18,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('IND',
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: height * 0.016,
                      color: const Color.fromRGBO(107, 127, 141, 1))),
              Text('+91',
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: height * 0.018,
                      color: const Color.fromRGBO(29, 31, 29, 1))),
            ],
          ),
        ),
        Container(
          height: height * 0.08,
          width: width * 0.65,
          decoration: const BoxDecoration(
            color: Color.fromRGBO(240, 241, 244, 1),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: TextFormField(
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
            keyboardType: TextInputType.phone,
            cursorColor: const Color.fromRGBO(29, 31, 29, 1),
            controller: phno,
            onChanged: (s) {},
            decoration: InputDecoration(
              contentPadding:
                  EdgeInsets.only(top: height * 0.015, left: width * 0.05),
              border: InputBorder.none,
              floatingLabelStyle: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Color.fromRGBO(107, 127, 141, 1)),
              labelText: "Mobile no.",
              labelStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
            ),
          ),
        ),
      ],
    ),
  );
}
