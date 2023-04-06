import 'package:redux/redux.dart';
import 'package:virtuo/bloc/states.dart';

import 'appState.dart';

AppState appReducer(AppState state, action) => AppState(
      isloading: loadingReducer(state.isloading, action),
      userProfile: userProfileReducer(state.userProfile, action),
    );

final appStore = Store(appReducer,
    initialState: AppState(
      isloading: LoadingState(isLoading: false),
      userProfile: UserProfileState(userProfile: {}),
    ));

LoadingState loadingReducer(LoadingState state, action) {
  if (action is SetLoadingAction) {
    return LoadingState(isLoading: action.isLoading);
  } else {
    return state;
  }
}

UserProfileState userProfileReducer(UserProfileState state, action) {
  if (action is SetUserProfileAction) {
    return UserProfileState(userProfile: action.payload);
  } else {
    return state;
  }
}

class SetUserProfileAction {
  Map<String, dynamic> payload;
  SetUserProfileAction({
    required this.payload,
  });
}

class SetLoadingAction {
  bool isLoading;

  SetLoadingAction({
    required this.isLoading,
  });
}
