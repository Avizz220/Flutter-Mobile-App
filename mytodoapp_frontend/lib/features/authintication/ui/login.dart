import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:mytodoapp_frontend/contants/colors.dart';
import 'package:mytodoapp_frontend/features/authintication/bloc/auth_bloc.dart';
import 'package:mytodoapp_frontend/features/authintication/ui/signup.dart';
import 'package:mytodoapp_frontend/features/home/ui/homepage.dart';
import 'package:mytodoapp_frontend/features/todo/ui/calendar_events.dart';
import 'package:mytodoapp_frontend/services/notification_services_db.dart';
import 'package:mytodoapp_frontend/services/theme_service.dart';
import 'package:mytodoapp_frontend/widgets/custom_button.dart';
import 'package:mytodoapp_frontend/widgets/custom_textfield.dart';
import 'package:mytodoapp_frontend/widgets/task_notification_banner.dart';

class Loginscreen extends StatefulWidget {
  const Loginscreen({super.key});

  @override
  State<Loginscreen> createState() => _LoginscreenState();
}

class _LoginscreenState extends State<Loginscreen> {
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();

  final AuthBloc authBloc = AuthBloc();
  final NotificationServices notificationServices = NotificationServices();
  final ThemeService themeService = ThemeService();
  bool isLoading = false;
  OverlayEntry? _overlayEntry;

  @override
  void dispose() {
    _removeOverlay();
    super.dispose();
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  // Show notification banners after login
  Future<void> _showPendingNotifications(BuildContext context) async {
    try {
      final notifications =
          await notificationServices.getUnreadTaskNotifications();

      if (notifications.isEmpty) return;

      for (var notification in notifications) {
        if (!mounted) break;

        _overlayEntry = OverlayEntry(
          builder:
              (context) => Positioned(
                top: MediaQuery.of(context).padding.top + 10,
                left: 0,
                right: 0,
                child: TaskNotificationBanner(
                  notification: notification,
                  onOk: () async {
                    _removeOverlay();
                    await notificationServices.dismissNotification(
                      notification.notificationID,
                    );
                    if (mounted) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => CalendarEventsScreen(
                                taskId: notification.taskID,
                              ),
                        ),
                      );
                    }
                  },
                  onCancel: () async {
                    _removeOverlay();
                    await notificationServices.dismissNotification(
                      notification.notificationID,
                    );
                  },
                ),
              ),
        );

        Overlay.of(context).insert(_overlayEntry!);

        while (_overlayEntry != null && mounted) {
          await Future.delayed(Duration(milliseconds: 100));
        }

        await Future.delayed(Duration(milliseconds: 300));
      }
    } catch (e) {
      debugPrint('Error showing notifications: $e');
    }
  }

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

            // Show pending notifications after a short delay
            Future.delayed(Duration(milliseconds: 800), () {
              if (mounted) {
                _showPendingNotifications(context);
              }
            });
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
