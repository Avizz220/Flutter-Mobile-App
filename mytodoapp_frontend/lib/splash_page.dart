import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

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
