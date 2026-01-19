import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mytodoapp_frontend/contants/colors.dart';
import 'package:mytodoapp_frontend/features/authintication/bloc/auth_bloc.dart';
import 'package:mytodoapp_frontend/features/authintication/ui/login.dart';
import 'package:mytodoapp_frontend/model/user_model.dart';
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
  TextEditingController confirmPasswordController = TextEditingController();

  final AuthBloc authBloc = AuthBloc();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    double screenwidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: isDark ? Color(0xFF121212) : Colors.white,
      resizeToAvoidBottomInset: true, // ✅ Important for handling keyboard
      body: BlocConsumer<AuthBloc, AuthState>(
        bloc: authBloc,
        listener: (context, state) {
          if (state is SignupInProgressState) {
            setState(() {
              isLoading = true;
            });
          } else if (state is SignupSuccessState) {
            setState(() {
              isLoading = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Sign up successful!',
                  style: TextStyle(color: Colors.white),
                ),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Loginscreen()),
            );
          } else if (state is SignupErrorState) {
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
                  child: Image.asset('assets/images/signup.png'),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    width: screenwidth,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    decoration: BoxDecoration(
                      color: isDark ? Color(0xFF1E1E1E) : AppColor.signupcolor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: SingleChildScrollView(
                      // ✅ Only added this to allow scroll
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Sign Up",
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 35,
                              color: isDark ? Colors.white : AppColor.fontcolor,
                            ),
                          ),
                          SizedBox(height: 25),
                          CustomTextField(
                            controller: namecontroller,
                            labeltext: "Name",
                            bordercolor: Colors.white,
                            prefixIcon: Icons.person_rounded,
                          ),
                          SizedBox(height: 15),
                          CustomTextField(
                            controller: emailcontroller,
                            labeltext: "Email",
                            bordercolor: Colors.white,
                            prefixIcon: Icons.email_rounded,
                          ),
                          SizedBox(height: 15),
                          CustomTextField(
                            controller: passwordcontroller,
                            labeltext: "Password",
                            bordercolor: Colors.white,
                            prefixIcon: Icons.lock_rounded,
                            obscureText: true,
                          ),
                          SizedBox(height: 15),
                          CustomTextField(
                            controller: confirmPasswordController,
                            labeltext: "Confirm Password",
                            bordercolor: Colors.white,
                            prefixIcon: Icons.lock_outline_rounded,
                            obscureText: true,
                          ),
                          SizedBox(height: 25),
                          isLoading
                              ? Center(child: CircularProgressIndicator())
                              : GestureDetector(
                                onTap: () {
                                  // Validate fields are not empty
                                  if (namecontroller.text.isEmpty ||
                                      emailcontroller.text.isEmpty ||
                                      passwordcontroller.text.isEmpty ||
                                      confirmPasswordController.text.isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Please fill in all fields',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                    return;
                                  }

                                  // Validate passwords match
                                  if (passwordcontroller.text !=
                                      confirmPasswordController.text) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Passwords do not match!',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                    return;
                                  }

                                  final user = UserModel(
                                    userID: '',
                                    name: namecontroller.text,
                                    email: emailcontroller.text,
                                    password: passwordcontroller.text,
                                    fcmToken: '',
                                  );
                                  authBloc.add(SignUpEvent(userModel: user));
                                },
                                child: CustomeButton(
                                  btnwidth: screenwidth,
                                  btntext: "Sign Up",
                                ),
                              ),
                          SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Already have an account??",
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 14,
                                  color: isDark ? Colors.white70 : Colors.black,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              SizedBox(width: 10),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Loginscreen(),
                                    ),
                                  );
                                },
                                child: Text(
                                  "Login",
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
              ],
            ),
          );
        },
      ),
    );
  }
}
