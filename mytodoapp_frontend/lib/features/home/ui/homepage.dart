import 'package:flutter/material.dart';
import 'package:mytodoapp_frontend/contants/colors.dart';
import 'package:mytodoapp_frontend/widgets/custom_todo_card.dart';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({super.key});

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  @override
  Widget build(BuildContext context) {
    double screenheight = MediaQuery.of(context).size.height;
    double screenwidth = MediaQuery.of(context).size.width;
    double appbarHeight = AppBar().preferredSize.height;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              "Saturday February 20,2025",
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontFamily: "Poppins",
                fontSize: 12,
              ),
            ),
            Spacer(),
            Image.asset('assets/images/notification.png'),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 25),
                    width: screenwidth,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Welcome Phillip",
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontFamily: "Poppins",
                            fontSize: 24,
                          ),
                        ),
                        Text(
                          "Have a nice day",
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontFamily: "Poppins",
                            fontSize: 12,
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          "Today progress",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontFamily: "Poppins",
                            fontSize: 20,
                          ),
                        ),
                        SizedBox(height: 5),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          height: 76,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/images/menu.png'),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Spacer(),
                              Text(
                                "Today progress",
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontFamily: "Poppins",
                                  fontSize: 10,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 5),
                              LinearProgressIndicator(
                                value: 0.8,
                                color: Colors.white,
                                backgroundColor: AppColor.progressbgcolor,
                              ),
                              SizedBox(height: 8),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  "80%",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontFamily: "Poppins",
                                    fontSize: 10,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              SizedBox(height: 8),
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    width: screenwidth,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Daily Tasks",
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                          ),
                        ),
                        SizedBox(height: 20),
                        CustomeTodoCard(
                          cardtitle: "Workout 01",
                          btnvisible: false,
                          isTaskCompleted: false,
                        ),
                        CustomeTodoCard(
                          cardtitle: "Workout 02",
                          btnvisible: false,
                          isTaskCompleted: true,
                        ),
                        CustomeTodoCard(
                          cardtitle: "Workout 03",
                          btnvisible: false,
                          isTaskCompleted: false,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 100), // padding space for FAB
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColor.accentColor,
        onPressed: () {},
        label: Row(
          children: [
            Icon(Icons.add, color: Colors.white),
            Text(
              "Add Task",
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 15,
                fontFamily: "Poppins",
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
