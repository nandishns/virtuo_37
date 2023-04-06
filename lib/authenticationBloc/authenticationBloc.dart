import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../bloc/userRepository.dart';

part 'authenctionEvent.dart';
part 'authenticationState.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final UserRepository userRepository;

  AuthenticationBloc({required this.userRepository})
      : super(AuthenticationIntialState()) {
    on<AuthenticationEvent>((event, emit) async {
      var uid = userRepository.firebaseAuth.currentUser?.uid;
      int flag = await userRepository.isUserDataPresent(uid ?? 'null');
      if (event is AuthStarted) {
        if (userRepository.currentUser()) {
          if (flag == -1) {
            emit(AuthenticationNoInternetState());
          } else if (flag == 0) {
            emit(AuthenticatedUnregistered());
          } else {
            emit(AuthenticationAuthenticated(userRoleId: flag));
          }
        } else {
          emit(AuthenticationUnauthenticated());
        }
      }
      if (event is LoggedIn) {
        emit(AuthenticationLoading());
        if (flag == -1) {
          emit(AuthenticationNoInternetState());
        } else if (flag == 0) {
          emit(AuthenticatedUnregistered());
        } else {
          emit(AuthenticationAuthenticated(userRoleId: flag));
        }
      }
      if (event is LoggedOut) {
        emit(AuthenticationUnauthenticated());
      }
    });
  }
}
