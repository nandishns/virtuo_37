import 'package:virtuo/bloc/states.dart';

class AppState {
  LoadingState isloading;
  UserProfileState userProfile;

  AppState({
    required this.isloading,
    required this.userProfile,
  });
}
