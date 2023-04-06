import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:virtuo/features/signUpPage.dart';
import 'package:virtuo/features/virtuoDashboard.dart';

import '../authenticationBloc/authenticationBloc.dart';
import '../bloc/routes.dart';
import 'login.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, state) {
        if (state is AuthenticationIntialState) {
          return initialAppLoading();
        }
        if (state is AuthenticationLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is AuthenticationNoInternetState) {
          print("Passing : ${Routes.landing}");
        }
        if (state is AuthenticationAuthenticated) {
          return const VirtuoDashboard();
        }

        if (state is AuthenticatedUnregistered) {
          // return const UserRegistrationView();
          return const SignUp();
        }

        if (state is AuthenticationUnauthenticated) {
          //Should it still go to the landing page ??
          // return const LoginView();
          return const LoginView();
        }

        // if (state is AuthenticationIntialState) {
        //   return initialAppLoading();
        // }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget initialAppLoading() {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Expanded(flex: 3, child: Container()),
          Expanded(
            flex: 3,
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.2,
              child: Image.asset(
                "virtuo_logo.png",
              ),
            ),
          ),
          Expanded(flex: 5, child: Container()),
          Expanded(
            flex: 2,
            child: Center(
                child: Column(
              children: [
                Text(
                  "VIRTUO",
                  style: GoogleFonts.openSans(
                      color: Colors.white,
                      fontSize: MediaQuery.of(context).size.height / 42,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  "1.0.0",
                  style: GoogleFonts.openSans(
                    color: Colors.grey,
                    fontSize: 20,
                  ),
                ),
              ],
            )),
          )
        ],
      ),
    );
  }
}
