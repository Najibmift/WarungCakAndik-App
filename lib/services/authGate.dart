import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_app_flutter_1/screen/login/login.dart';
import 'package:my_app_flutter_1/screen/menu/bottom_navbar.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // user is logged in
          if (snapshot.hasData) {
            return MyHomePage();
          }

          // user in NOT logged in
          else {
            return const LoginScreen();
          }
        },
      ),
    );
  }
}
