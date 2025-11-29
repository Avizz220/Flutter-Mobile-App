import 'package:flutter/material.dart';
import 'package:mytodoapp_frontend/contants/colors.dart';
import 'package:mytodoapp_frontend/model/todo_model.dart';
import 'package:mytodoapp_frontend/services/todo_services.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Addtask extends StatefulWidget {
  const Addtask({super.key});

  @override
  State<Addtask> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<Addtask> {
  TextEditingController titlecontroller = TextEditingController();
  TextEditingController descriptioncontroller = TextEditingController();

  final TodoServices todoServices = TodoServices();
  bool isLoading = false;

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
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                height: 45,
                width: 45,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(child: Icon(Icons.arrow_back, size: 16)),
              ),
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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
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
                    borderSide: BorderSide(
                      color: AppColor.textfieldbordercolor,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: AppColor.textfieldbordercolor,
                    ),
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
                controller: descriptioncontroller,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: AppColor.textfieldbordercolor,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: AppColor.textfieldbordercolor,
                    ),
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
              SizedBox(height: 40),
              isLoading
                  ? Center(child: CircularProgressIndicator())
                  : GestureDetector(
                    onTap: () async {
                      if (titlecontroller.text.isEmpty ||
                          descriptioncontroller.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Please fill all fields',
                              style: TextStyle(color: Colors.white),
                            ),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }

                      setState(() {
                        isLoading = true;
                      });

                      try {
                        final user = FirebaseAuth.instance.currentUser;
                        if (user == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Please login first',
                                style: TextStyle(color: Colors.white),
                              ),
                              backgroundColor: Colors.red,
                            ),
                          );
                          setState(() {
                            isLoading = false;
                          });
                          return;
                        }

                        final todoID =
                            DateTime.now().millisecondsSinceEpoch.toString();
                        final todo = TodoModel(
                          todoID: todoID,
                          title: titlecontroller.text,
                          description: descriptioncontroller.text,
                          userID: user.uid,
                          isCompleted: false,
                          createdAt: DateTime.now(),
                        );

                        await todoServices.addTodoDatabase(todo);

                        setState(() {
                          isLoading = false;
                        });

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Task added successfully!',
                              style: TextStyle(color: Colors.white),
                            ),
                            backgroundColor: Colors.green,
                          ),
                        );

                        Navigator.pop(context);
                      } catch (e) {
                        setState(() {
                          isLoading = false;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Failed to add task: ${e.toString()}',
                              style: TextStyle(color: Colors.white),
                            ),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    child: Container(
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
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
