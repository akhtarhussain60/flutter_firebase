import 'package:flutter/material.dart';
import 'package:flutter_firebase/services/splash_services.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  SplashServices splashServices = SplashServices();

  @override
  void initState() {
    splashServices.isLogin(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Center(
          child: Text(
            "Flutter Firebase",
            textAlign: TextAlign.start,
            style: TextStyle(
              fontSize: 30,
              color: Colors.blue,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
