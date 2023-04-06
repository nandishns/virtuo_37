part of 'authenticationBloc.dart';

abstract class AuthenticationState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthenticationAuthenticated extends AuthenticationState {
  final int userRoleId;
  AuthenticationAuthenticated({required this.userRoleId});
}

class AuthenticatedUnregistered extends AuthenticationState {}

class AuthenticationUnauthenticated extends AuthenticationState {}

class AuthenticationLoading extends AuthenticationState {}

class AuthenticationIntialState extends AuthenticationState {}

class AuthenticationNoInternetState extends AuthenticationState {}
