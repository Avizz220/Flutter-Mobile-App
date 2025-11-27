import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mytodoapp_frontend/features/authintication/ui/login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late Timer timer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    timer = Timer.periodic(Duration(seconds: 3), (Timer timer) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Loginscreen()),
      );
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    double screenheight =
        MediaQuery.of(
          context,
        ).size.height; //This will take take the size of the phone screen
    double screenwidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: screenwidth,
          height: screenheight,
          child: Center(child: Image.asset('assets/logo/center.png')),
        ),
      ),
    );
  }
}
