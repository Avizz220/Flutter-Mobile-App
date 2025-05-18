import 'package:flutter/material.dart';
import 'package:mytodoapp_frontend/contants/colors.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    double screenwidth = MediaQuery.of(context).size.width;
    double screenheight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true, //This is how we can cnter the title
        toolbarHeight:
            120, //This is the way that we can give height for the appbar
        backgroundColor:
            Colors.white, //We can also give the background colour for this
        title: Text(
          "Notifications",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
            fontFamily: "Poppins",
            color: AppColor.accentColor,
          ),
        ),
        leading: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 45,
              width: 45,
              decoration: BoxDecoration(
                color: AppColor.accentColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Icon(Icons.arrow_back, size: 16, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
      body: Container(
        //We need container to to give the height of this
        width: screenwidth,
        color: Colors.white,
        height:
            screenheight -
            120, //We are using container in this as we need to give the height and width for these using colomns don't allow this
        child: Column(
          //We need a column to indicate the children of this
          children: [
            Container(
              height: 1,
              width: screenwidth,
              color: AppColor.accentColor,
            ),

            Container(
              padding: EdgeInsets.symmetric(horizontal: 15),
              height: 60,
              width: screenwidth,
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment
                        .start, //To get the horizontally center of the column
                mainAxisAlignment:
                    MainAxisAlignment
                        .center, //To get the center vertically of the column
                children: [
                  Text(
                    "Ai Task Completed",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                      fontFamily: "Poppins",
                      color: AppColor.fontcolor,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "Well done Phillip, you have completed all the tasks for today",
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 10,
                      fontFamily: "Poppins",
                      color: AppColor.fontcolor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
