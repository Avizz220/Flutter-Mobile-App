import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mytodoapp_frontend/contants/colors.dart';
import 'package:mytodoapp_frontend/features/authintication/ui/signup.dart';
import 'package:mytodoapp_frontend/widgets/custom_button.dart';
import 'package:mytodoapp_frontend/widgets/custom_textfield.dart';

class Loginscreen extends StatefulWidget {
  const Loginscreen({super.key});

  @override
  State<Loginscreen> createState() => _LoginscreenState();
}

class _LoginscreenState extends State<Loginscreen> {
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double screenwidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColor.loginanimationcolour,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
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
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    padding: EdgeInsets.zero,
                    physics: BouncingScrollPhysics(),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: IntrinsicHeight(
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
                              SizedBox(height: 15),
                              CustomTextField(
                                controller: emailcontroller,
                                labeltext: "Email",
                                bordercolor: AppColor.textfieldbordercolor,
                              ),
                              SizedBox(height: 15),
                              CustomTextField(
                                controller: passwordcontroller,
                                labeltext: "Password",
                                bordercolor: AppColor.textfieldbordercolor,
                              ),
                              SizedBox(height: 15),
                              CustomeButton(
                                btnwidth: screenwidth,
                                btntext: "Login",
                              ),
                              SizedBox(height: 20),
                              Row(
                                children: [
                                  Text(
                                    "Don't have an account??",
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 14,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  GestureDetector(
                                    onTap: () => {Navigator.push(context, MaterialPageRoute(builder: (context)=>SignUpScreen()))
                                    },
                                    child: Text(
                                      "Sign up",
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 14,
                                        color: Colors.blue,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
