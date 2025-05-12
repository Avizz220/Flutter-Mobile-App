import 'package:flutter/material.dart';
import 'package:mytodoapp_frontend/contants/colors.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  @override
    TextEditingController namecontroller = TextEditingController();
    TextEditingController emailcontroller = TextEditingController();
    TextEditingController passwordcontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    double screenwidth = MediaQuery.of(context).size.width;
    double screenheight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(flex: 1, child: Image.asset('assets/images/signup.png')),
            Expanded(
              flex: 1,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                width: screenwidth,
                decoration: BoxDecoration(
                  color: AppColor.signupcolor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
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
                    TextField(
                      controller: namecontroller,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Colors.white
                          )

                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Colors.white
                          )

                        ),
                        label: Text("Name",style: TextStyle(
                          color: AppColor.fontcolor,
                          fontFamily: 'Poppins',
                        ),),
                      ),
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
                          borderSide: BorderSide(
                            color: Colors.white
                          )

                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Colors.white
                          )

                        ),
                        label: Text("Email",style: TextStyle(
                          color: AppColor.fontcolor,
                          fontFamily: 'Poppins',
                        ),),
                      ),
                    ),
                    SizedBox(
                      height: 15,

                    ),
                     TextField(
                      controller: passwordcontroller,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Colors.white
                          )

                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Colors.white
                          )

                        ),
                        label: Text("Password",style: TextStyle(
                          color: AppColor.fontcolor,
                          fontFamily: 'Poppins',
                        ),),
                      ),
                    ),
                      SizedBox(
                      height: 25,

                    ),
                    Container(
                      width: screenwidth,
                      height: 55,
                      decoration: BoxDecoration(
                        color: AppColor.accentColor,
                        borderRadius: BorderRadius.circular(20)

                      ),
                      child: Center(
                        child: Text('Sign Up',style: TextStyle(
                          fontFamily: "Poppons",
                          color: Colors.white,
                          fontWeight: FontWeight.w500,



                        ),),
                      ),
                    ),
                    Row(
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
                      SizedBox(
                        width: 10,
                      ),
                       Text(
                        "Sign up",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14,
                          color: Colors.blue,
                          fontWeight: FontWeight.w600
                        ),
                      ),
                      ] 
                    ),

                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
