// import 'package:merchantcustomer/global_features/user_profile_cubit/user_profile_cubit.dart';

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../bloc/routes.dart';
import '../bloc/userRepository.dart';
import '../features/virtuoDashboard.dart';
import 'otpVerificationEvent.dart';
import 'otpVerificationState.dart';

class otpVerificationBloc
    extends Bloc<otpVerificationEvent, otpVerificationState> {
  String phoneNumber = "";
  String verificationId = "";
  final FirebaseAuth _auth = FirebaseAuth.instance;
  BuildContext context;
  otpVerificationBloc({required this.context})
      : super(otpVerificationStateLoading()) {
    on<otpVerificationEvent>((event, emit) async {
      if (event is getOtp) {
        final String phoneNumber = event.phoneNumber;
        emit(otpVerificationStateLoading());
        final User? user = FirebaseAuth.instance.currentUser;
        await verifyPhoneNumber(phoneNumber);
      } else if (event is verificationCompleted || event is codeSent) {
        // await Fluttertoast.showToast(msg: "Invalid OTP. Please try again");
        emit(otpVerificationStateReceived());
      } else if (event is verificationFail) {
        emit(otpVerificationStateFailed(event.message));
      } else if (event is submitted) {
        _mapSubmittedToState(event);
      }
    });
  }
  Stream<otpVerificationState> mapEventToState(
      otpVerificationEvent event) async* {}

  Future verifyPhoneNumber(phoneNumber) async {
    try {
      await _auth.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          timeout: const Duration(seconds: 15),
          verificationCompleted: (phoneAuthCredential) {
            add(verificationCompleted());
          },
          verificationFailed: (verificationFailed) {
            var message = verificationFailed.message ?? "";
            Fluttertoast.showToast(msg: "Invalid OTP. Please try again");
            add(verificationFail(message: message));
          },
          codeSent: (verificationId, resendingToken) {
            this.verificationId = verificationId;
            Fluttertoast.showToast(msg: "OTP has been sent");
            add(codeSent());
          },
          codeAutoRetrievalTimeout: (verificationId) {});
    } catch (e) {
      print("verifyPhoneNumber error_______________ inside catch block.");
    }
  }

  _mapSubmittedToState(submitted event) async {
    final String enteredOtp = event.otp;
    final BuildContext context = event.context;
    emit(otpVerificationStateLoading());

    PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
        verificationId: verificationId, smsCode: enteredOtp);

    try {
      final authCredential =
          await _auth.signInWithCredential(phoneAuthCredential);

      if (authCredential.user != null) {
        var user = authCredential.user;
        UserRepository(firebaseAuth: user);
        int userRoleId = await UserRepository().isUserDataPresent(user!.uid);
        if (userRoleId == -1) {
          // ignore: use_build_context_synchronously
          await Navigator.pushNamed(context, Routes.noInternectConnection,
              arguments: {"routeName": Routes.landing});
        } else if (userRoleId == 0) {
          // ignore: use_build_context_synchronously
          await Navigator.pushNamed(context, Routes.userRegistration);
        } else {
          // if (userRoleId != 1) {
          //   // ignore: use_build_context_synchronously
          //   BlocProvider.of<UserProfileCubit>(context).setSelfProfileData(true);
          //   print(
          //       "JUMPED TO DAHSBOARD____________________________________________");
          // }
          await Fluttertoast.showToast(msg: "OTP Verification Success");
          // ignore: use_build_context_synchronously
          await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: ((context) => userRoleId == 1
                      ? const VirtuoDashboard()
                      : const VirtuoDashboard())));
        }

        emit(otpVerificationStateSuccess());
      }
    } on FirebaseAuthException catch (e) {
      emit(otpVerificationStateFailed("Invalid OTP"));
    }
  }
}
