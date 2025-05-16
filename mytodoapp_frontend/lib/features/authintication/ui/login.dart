import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mytodoapp_frontend/contants/colors.dart';

class Loginscreen extends StatefulWidget {
  const Loginscreen({super.key});

  @override
  State<Loginscreen> createState() => _LoginscreenState();
}

class _LoginscreenState extends State<Loginscreen> {
  @override
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double screenwidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: AppColor.loginanimationcolour,
      resizeToAvoidBottomInset: true, // ✅ Added to fix keyboard overlap
      body: SafeArea(
         
        child: Container(
          child: Column(
            children: [
              Expanded(
                flex: 1,
                child: Center(
                  child: SizedBox(
                    width: screenwidth - 100,
                    child: Lottie.asset(
                      'assets/animations/loginAnimation.json',
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  width: screenwidth,
                  padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Login",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 35,
                          color: AppColor.fontcolor,
                        ),
                      ),
                      SizedBox(height: 15),
                      Row(
                        children: [
                          Text(
                            "Welcome Back To",
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 13,
                              color: AppColor.labletextcolor,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          SizedBox(width: 10),
                          Text(
                            "My task",
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 13,
                              color: AppColor.accentColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      TextField(
                        controller: emailcontroller,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: AppColor.textfieldbordercolor),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: AppColor.textfieldbordercolor),
                          ),
                          label: Text(
                            "Email",
                            style: TextStyle(
                              color: AppColor.fontcolor,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 15),
                      TextField(
                        controller: passwordcontroller,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: AppColor.textfieldbordercolor),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: AppColor.textfieldbordercolor),
                          ),
                          label: Text(
                            "Password",
                            style: TextStyle(
                              color: AppColor.fontcolor,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 15),
                      Container(
                        width: screenwidth,
                        height: 55,
                        decoration: BoxDecoration(
                          color: AppColor.accentColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: Text(
                            'Login',
                            style: TextStyle(
                              fontFamily: "Poppins",
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Text(
                            "Don;t have an account??",
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Login",
                            style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 14,
                                color: Colors.blue,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
