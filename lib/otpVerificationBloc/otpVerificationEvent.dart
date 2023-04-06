import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class otpVerificationEvent extends Equatable {
  const otpVerificationEvent();
  @override
  List<Object> get props => [];
}

class getOtp extends otpVerificationEvent {
  final String phoneNumber;

  getOtp({required this.phoneNumber});

  @override
  List<Object> get props => [];
}

class codeSent extends otpVerificationEvent {}

class verificationCompleted extends otpVerificationEvent {}

class verificationFail extends otpVerificationEvent {
  String message;
  verificationFail({required this.message});

  @override
  List<Object> get props => [message];
}

class submitted extends otpVerificationEvent {
  final String otp;
  final BuildContext context;
  submitted({required this.context, required this.otp});

  @override
  List<Object> get props => [];
}
