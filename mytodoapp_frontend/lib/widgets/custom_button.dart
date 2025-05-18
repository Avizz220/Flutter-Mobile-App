import 'package:flutter/material.dart';
import 'package:mytodoapp_frontend/contants/colors.dart';

class CustomeButton extends StatelessWidget {
  final double btnwidth;
  final String btntext;

  const CustomeButton({super.key, required this.btnwidth, required this.btntext});

  @override
  Widget build(BuildContext context) {
    return Container(
      width:
          btnwidth, //we don't need the widget . extension in this it is only required in stateful widgets
      height: 55,
      decoration: BoxDecoration(
        color: AppColor.accentColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: Text(
          btntext,
          style: TextStyle(
            fontFamily: "Poppons",
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
