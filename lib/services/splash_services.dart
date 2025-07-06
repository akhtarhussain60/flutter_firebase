import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/views/firestore_list_screen.dart';
import 'package:flutter_firebase/views/login_screen.dart';

class SplashServices {
  void isLogin(BuildContext context) {
    Timer(
      const Duration(seconds: 4),
      () => loginUser(context),
    );
  }

  void loginUser(BuildContext context) {
    final auth = FirebaseAuth.instance.currentUser;
    if (auth != null) {
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => const HomeScreen(),
      //   ),
      // );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const FirestoreListScreen(),
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ),
      );
    }
  }
}
