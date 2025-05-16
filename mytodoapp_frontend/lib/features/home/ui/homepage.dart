import 'package:flutter/material.dart';
import 'package:mytodoapp_frontend/contants/colors.dart';

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
      body: SizedBox(
        //No need to add containers here as we are not going to add any decorations here
        height:
            screenheight -
            AppBar()
                .preferredSize
                .height, //We should reduce the height of the appdbar form the full width
        width: screenwidth,
        child: Column(
          children: [
            Expanded(
              //We added expanded widgrts here as we need to have a responsive designs for this other wise it will be overflowed
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 25),
                height: 240,
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
                    Spacer(),
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
                        ), //We can add an image to our container
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
                            //We can add a inear progress indiactor using this keyword
                            value:
                                0.8, //This is the value which has to be filled
                            color: Colors.white,
                            backgroundColor: AppColor.progressbgcolor,
                          ),
                          SizedBox(height: 8),
                          Align(
                            //We can manually align single elements using this widget by wrapping
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
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15),
              height:
                  screenheight -
                  (AppBar().preferredSize.height +
                      240), //We should give a specific height for this as we have to have a list view in this
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 25,
                    child: Text(
                      "Daily Tasks",
                      style: TextStyle(
                        fontFamily: "poppins",
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  SizedBox(
                    height:
                        screenheight - (AppBar().preferredSize.height + 265),
                    width: screenwidth,

                    child: Column(
                      children: [
                        Container(
                          width: screenwidth,
                          height: 70,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: AppColor.accentColor.withOpacity(0.5),
                            ),
                          ),
                          child: Row(
                            children: [
                              Radio(
                                value: 0,
                                groupValue: 0,
                                onChanged: (value) {},
                              ),
                              Text(
                                "My Task 1",
                                style: TextStyle(
                                  fontFamily: "poppins",
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15,
                                ),
                              ),
                              Spacer(),
                              Column(
                                children: [
                                  Spacer(),
                                  Icon(Icons.edit),
                                  SizedBox(height: 5),
                                  Icon(Icons.delete, color: Colors.red),
                                  Spacer(),
                                ],
                              ),
                              SizedBox(width: 10),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColor.accentColor,
        onPressed:
            () {}, //We can set what happened to the button when i click it
        label: Row(
          //We can use row as a widget
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
