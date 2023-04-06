import 'package:flutter/material.dart';
import 'package:virtuo/bloc/routes.dart';
import 'package:virtuo/features/signUpPage.dart';

import '../features/landing.dart';
import '../features/login.dart';
import '../features/otpView.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case Routes.landing:
        return MaterialPageRoute(builder: (context) {
          return const LandingPage();
        });
      case Routes.login:
        // return MaterialPageRoute(builder: (_) => const LoginView());
        return MaterialPageRoute(builder: (_) => const LoginViewV2());

      case Routes.otp:
        return MaterialPageRoute(
            builder: (_) => OTPView(phNo: args.toString()));
      // case Routes.registration:
      //   return MaterialPageRoute(builder: (data) => RegistrationView());
      case Routes.userRegistration:
        return MaterialPageRoute(
            // builder: (data) => const UserRegistrationView());
            builder: (data) => const SignUp());
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: const Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}
