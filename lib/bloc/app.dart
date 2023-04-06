import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_redux/flutter_redux.dart';
// import 'package:merchantcustomer/global_features/user_profile_cubit/user_profile_cubit.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:redux/redux.dart';
import 'package:virtuo/bloc/routes.dart';
import 'package:virtuo/bloc/routesGenerator.dart';
import 'package:virtuo/bloc/userRepository.dart';

import '../authenticationBloc/authenticationBloc.dart';
import '../otpVerificationBloc/otpVerificationBloc.dart';
import 'appState.dart';
import 'firestoreRepository.dart';

class MyApp extends StatelessWidget {
  final Store<AppState> store;
  const MyApp({Key? key, required this.store}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

    return StoreProvider(
      store: store,
      child: MultiRepositoryProvider(
        providers: [
          RepositoryProvider<UserRepository>(
            create: (context) => UserRepository(),
            lazy: true,
          ),
          RepositoryProvider<FireStoreDb>(
            create: (context) => FireStoreRepository(),
            lazy: true,
          ),
        ],
        child: MultiBlocProvider(
          providers: [
            BlocProvider<AuthenticationBloc>(
              create: (context) {
                return AuthenticationBloc(
                    userRepository:
                        RepositoryProvider.of<UserRepository>(context))
                  ..add(AuthStarted());
              },
            ),
            BlocProvider<otpVerificationBloc>(
              create: (context) {
                return otpVerificationBloc(context: context);
              },
            ),

            // BlocProvider<UserProfileCubit>(
            //   create: (context) => UserProfileCubit(),
            // )
          ],
          child: OverlaySupport(
            child: MaterialApp(
                debugShowCheckedModeBanner: false,
                onGenerateRoute: RouteGenerator.generateRoute,
                initialRoute: Routes.landing),
          ),
        ),
      ),
    );
  }
}
