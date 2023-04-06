import 'package:equatable/equatable.dart';

abstract class otpVerificationState extends Equatable {
  const otpVerificationState();
  @override
  List<Object> get props => [];
}

class otpVerificationStateLoading extends otpVerificationState {}

class otpVerificationStateReceived extends otpVerificationState {}

class otpVerificationStateSuccess extends otpVerificationState {}

class otpVerificationStateFailed extends otpVerificationState {
  final String error;
  otpVerificationStateFailed(this.error);

  @override
  List<Object> get props => [error];
}

class otpVerificationStateError extends otpVerificationState {
  final String error;
  otpVerificationStateError(this.error);

  @override
  List<Object> get props => [error];
}
