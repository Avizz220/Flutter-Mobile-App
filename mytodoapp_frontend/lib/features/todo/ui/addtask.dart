import 'package:flutter/material.dart';
import 'package:mytodoapp_frontend/contants/colors.dart';

class Addtask extends StatefulWidget {
  const Addtask({super.key});

  @override
  State<Addtask> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<Addtask> {
  TextEditingController titlecontroller = TextEditingController();
  TextEditingController descriptioncontroller =
      TextEditingController(); //This is the place where we are declaring the controllers
  @override
  Widget build(BuildContext context) {
    double screenwidth = MediaQuery.of(context).size.width;
    double screenheight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: AppColor.accentColor,
      appBar: AppBar(
        centerTitle: true, //This is how we can cnter the title
        toolbarHeight:
            120, //This is the way that we can give height for the appbar
        backgroundColor:
            AppColor
                .accentColor, //We can also give the background colour for this
        title: Text(
          "Add Task",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
            fontFamily: "Poppins",
            color: Colors.white,
          ),
        ),
        leading: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 45,
              width: 45,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(child: Icon(Icons.arrow_back, size: 16)),
            ),
          ],
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        width: screenwidth,
        height: screenheight - 120,
        decoration: BoxDecoration(
          //This is how we decorate our container using decoration
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(50),
            topRight: Radius.circular(50),
          ),
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Title",
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
                fontFamily: "Poppins",
                color: AppColor.accentColor,
              ),
            ),
            SizedBox(height: 15),
            TextField(
              controller: titlecontroller,
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
                  "Title",
                  style: TextStyle(
                    color: AppColor.fontcolor,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
            ),
            SizedBox(height: 40),
            Text(
              "Description",
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
                fontFamily: "Poppins",
                color: AppColor.accentColor,
              ),
            ),
            SizedBox(height: 15),
            TextField(
              minLines: 5,
              maxLines: 8,
              //This is how we increase and decrease the size of the textfield
              controller: titlecontroller,
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
                  "Description",
                  style: TextStyle(
                    color: AppColor.fontcolor,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
            ),
            SizedBox(
              height:40,
            ),
            Container(
              width: screenwidth,
              height: 55,
              decoration: BoxDecoration(
                color: AppColor.accentColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  'Create Task',
                  style: TextStyle(
                    fontFamily: "Poppins",
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
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
