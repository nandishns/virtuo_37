import 'package:bloc/bloc.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';

import 'bloc/app.dart';
import 'bloc/appBlocObserver.dart';
import 'bloc/appState.dart';
import 'bloc/store.dart';

// ...
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await FirebaseAppCheck.instance.activate();
  final Store<AppState> store = appStore;
  BlocOverrides.runZoned(
    () => runApp(MyApp(
      store: store,
    )),
    blocObserver: AppBlocObserver(),
  );
}
