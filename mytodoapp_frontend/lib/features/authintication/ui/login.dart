import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:mytodoapp_frontend/contants/colors.dart';
import 'package:mytodoapp_frontend/features/authintication/bloc/auth_bloc.dart';
import 'package:mytodoapp_frontend/features/authintication/ui/signup.dart';
import 'package:mytodoapp_frontend/features/home/ui/homepage.dart';
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

  final AuthBloc authBloc = AuthBloc();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    double screenwidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor:
          isDark ? Color(0xFF121212) : AppColor.loginanimationcolour,
      resizeToAvoidBottomInset: true,
      body: BlocConsumer<AuthBloc, AuthState>(
        bloc: authBloc,
        listener: (context, state) {
          if (state is SignInProgressState) {
            setState(() {
              isLoading = true;
            });
          } else if (state is SignInSuccessState) {
            setState(() {
              isLoading = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Login successful!',
                  style: TextStyle(color: Colors.white),
                ),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => HomePageScreen()),
              (Route<dynamic> route) => false,
            );
          } else if (state is SignInErrorState) {
            setState(() {
              isLoading = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.error,
                  style: TextStyle(color: Colors.white),
                ),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          return SafeArea(
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
                              padding: EdgeInsets.symmetric(
                                vertical: 30,
                                horizontal: 20,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    isDark ? Color(0xFF1E1E1E) : Colors.white,
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
                                      color:
                                          isDark
                                              ? Colors.white
                                              : AppColor.fontcolor,
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
                                          color:
                                              isDark
                                                  ? Colors.white70
                                                  : AppColor.labletextcolor,
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
                                  isLoading
                                      ? SizedBox(
                                        height: 35,
                                        width: screenwidth,
                                        child: Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                      )
                                      : GestureDetector(
                                        onTap: () {
                                          authBloc.add(
                                            SignInEvent(
                                              email: emailcontroller.text,
                                              password: passwordcontroller.text,
                                            ),
                                          );
                                        },
                                        child: CustomeButton(
                                          btnwidth: screenwidth,
                                          btntext: "Login",
                                        ),
                                      ),
                                  SizedBox(height: 20),
                                  Row(
                                    children: [
                                      Text(
                                        "Don't have an account??",
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 14,
                                          color:
                                              isDark
                                                  ? Colors.white70
                                                  : Colors.black,
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      GestureDetector(
                                        onTap:
                                            () => {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder:
                                                      (context) =>
                                                          SignUpScreen(),
                                                ),
                                              ),
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
          );
        },
      ),
    );
  }
}
