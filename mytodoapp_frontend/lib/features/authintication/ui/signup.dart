import 'package:flutter/material.dart';
import 'package:mytodoapp_frontend/contants/colors.dart';
import 'package:mytodoapp_frontend/widgets/custom_button.dart';
import 'package:mytodoapp_frontend/widgets/custom_textfield.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController namecontroller = TextEditingController();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double screenwidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true, // ✅ Important for handling keyboard
      body: SafeArea(
        child: Column(
          children: [
            Expanded(flex: 1, child: Image.asset('assets/images/signup.png')),
            Expanded(
              flex: 1,
              child: Container(
                width: screenwidth,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                decoration: BoxDecoration(
                  color: AppColor.signupcolor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: SingleChildScrollView( // ✅ Only added this to allow scroll
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Sign Up",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 35,
                          color: AppColor.fontcolor,
                        ),
                      ),
                      SizedBox(height: 25),
                      CustomTextField(
                        controller: namecontroller,
                        labeltext: "Name",
                        bordercolor: Colors.white,
                      ),
                      SizedBox(height: 15),
                      CustomTextField(
                        controller: emailcontroller,
                        labeltext: "Email",
                        bordercolor: Colors.white,
                      ),
                      SizedBox(height: 15),
                      CustomTextField(
                        controller: passwordcontroller,
                        labeltext: "Password",
                        bordercolor: Colors.white,
                      ),
                      SizedBox(height: 25),
                      CustomeButton(btnwidth: screenwidth, btntext: "Sign Up"),
                      SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Already have an account??",
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          SizedBox(width: 10),
                          Text(
                            "Login",
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 14,
                              color: Colors.blue,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
