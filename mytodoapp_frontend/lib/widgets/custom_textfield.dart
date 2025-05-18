import 'package:flutter/material.dart';
import 'package:mytodoapp_frontend/contants/colors.dart';

class CustomTextField extends StatefulWidget {
  //We have to pass some features which are unique to some different text fields
  final TextEditingController controller;
  final String labeltext;
  final Color bordercolor;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.labeltext,
    required this.bordercolor,
  }); //There is a error indicating to solve that slick the bulb icon and we have to import the packages

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller, //Pass the controller
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: widget.bordercolor), //Pass the color
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: widget.bordercolor),
        ),
        label: Text(
          widget.labeltext,
          style: TextStyle(color: AppColor.fontcolor, fontFamily: 'Poppins'),
        ),
      ),
    );
  }
}

//Note-We can esily change the colors and the other propeties using these widgets we can edit any feature of this textfield using these.
