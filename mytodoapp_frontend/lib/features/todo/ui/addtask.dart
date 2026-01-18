import 'package:flutter/material.dart';
import 'package:mytodoapp_frontend/contants/colors.dart';
import 'package:mytodoapp_frontend/model/todo_model.dart';
import 'package:mytodoapp_frontend/services/todo_services.dart';
import 'package:mytodoapp_frontend/features/todo/ui/add_event_dialog.dart';
import 'package:mytodoapp_frontend/widgets/custom_button.dart';
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    double screenwidth = MediaQuery.of(context).size.width;
    double screenheight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: isDark ? Color(0xFF0D0D0D) : Color(0xFFF8F9FA),
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: 80,
        backgroundColor: AppColor.accentColor,
        title: Text(
          "Add New Task",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
            fontFamily: "Poppins",
            color: Colors.white,
            letterSpacing: 0.5,
          ),
        ),
        leading: Padding(
          padding: EdgeInsets.only(left: 15),
          child: Center(
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                height: 45,
                width: 45,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Icon(
                    Icons.arrow_back_ios_new,
                    size: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 30),
        width: screenwidth,
        height: screenheight - 80,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          color: isDark ? Color(0xFF1A1A1A) : Colors.white,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.title_rounded,
                    color: AppColor.accentColor,
                    size: 20,
                  ),
                  SizedBox(width: 8),
                  Text(
                    "Title",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      fontFamily: "Poppins",
                      color: isDark ? Colors.white : AppColor.accentColor,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              TextField(
                controller: titlecontroller,
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black,
                  fontFamily: 'Poppins',
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: isDark ? Color(0xFF1E1E1E) : Colors.white,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color:
                          isDark
                              ? Colors.white24
                              : AppColor.textfieldbordercolor,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color:
                          isDark
                              ? AppColor.accentColor
                              : AppColor.textfieldbordercolor,
                    ),
                  ),
                  label: Text(
                    "Title",
                    style: TextStyle(
                      color: isDark ? Colors.white70 : AppColor.fontcolor,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
              ),
              SizedBox(height: 25),
              Row(
                children: [
                  Icon(
                    Icons.description_rounded,
                    color: AppColor.accentColor,
                    size: 20,
                  ),
                  SizedBox(width: 8),
                  Text(
                    "Description",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      fontFamily: "Poppins",
                      color: isDark ? Colors.white : AppColor.accentColor,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              TextField(
                minLines: 5,
                maxLines: 8,
                controller: descriptioncontroller,
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black,
                  fontFamily: 'Poppins',
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: isDark ? Color(0xFF1E1E1E) : Colors.white,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color:
                          isDark
                              ? Colors.white24
                              : AppColor.textfieldbordercolor,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color:
                          isDark
                              ? AppColor.accentColor
                              : AppColor.textfieldbordercolor,
                    ),
                  ),
                  label: Text(
                    "Description",
                    style: TextStyle(
                      color: isDark ? Colors.white70 : AppColor.fontcolor,
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

                        // Show dialog to add task to calendar
                        final addToCalendar = await showDialog<bool>(
                          context: context,
                          builder:
                              (context) => AlertDialog(
                                backgroundColor:
                                    isDark ? Color(0xFF1E1E1E) : Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                title: Text(
                                  'Add to Calendar',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18,
                                    color: isDark ? Colors.white : Colors.black,
                                  ),
                                ),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.calendar_today,
                                      size: 50,
                                      color: AppColor.accentColor,
                                    ),
                                    SizedBox(height: 15),
                                    Text(
                                      'Would you like to add this task to your calendar?',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 14,
                                        color:
                                            isDark
                                                ? Colors.white70
                                                : Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                    onPressed:
                                        () => Navigator.pop(context, false),
                                    child: Text(
                                      'Not Now',
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed:
                                        () => Navigator.pop(context, true),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColor.accentColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    child: Text(
                                      'Add to Calendar',
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                        );

                        if (addToCalendar == true) {
                          await showDialog(
                            context: context,
                            builder:
                                (context) => AddEventDialog(
                                  todo: todo,
                                  selectedDate: DateTime.now(),
                                ),
                          );
                        }

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
                    child: CustomeButton(
                      btnwidth: screenwidth,
                      btntext: 'Create Task',
                      icon: Icons.add_task_rounded,
                    ),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
