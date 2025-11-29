import 'package:flutter/material.dart';
import 'package:mytodoapp_frontend/contants/colors.dart';
import 'package:mytodoapp_frontend/features/todo/ui/addtask.dart';
import 'package:mytodoapp_frontend/features/todo/ui/edittask.dart';
import 'package:mytodoapp_frontend/features/todo/ui/notifications.dart';
import 'package:mytodoapp_frontend/features/todo/ui/calendar_events.dart';
import 'package:mytodoapp_frontend/features/todo/ui/add_event_dialog.dart';
import 'package:mytodoapp_frontend/features/todo/ui/event_detail.dart';
import 'package:mytodoapp_frontend/features/authintication/ui/login.dart';
import 'package:mytodoapp_frontend/model/todo_model.dart';
import 'package:mytodoapp_frontend/services/todo_services.dart';
import 'package:mytodoapp_frontend/services/notification_services_db.dart';
import 'package:mytodoapp_frontend/services/event_services.dart';
import 'package:mytodoapp_frontend/widgets/custom_todo_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({super.key});

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  final TodoServices todoServices = TodoServices();
  final NotificationServices notificationServices = NotificationServices();
  final EventServices eventServices = EventServices();
  String userName = '';
  String currentDate = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _setCurrentDate();
  }

  void _setCurrentDate() {
    final now = DateTime.now();
    final formatter = DateFormat('EEEE MMMM d, yyyy');
    setState(() {
      currentDate = formatter.format(now);
    });
  }

  Future<void> _loadUserData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final userDoc =
            await FirebaseFirestore.instance
                .collection('Users')
                .doc(user.uid)
                .get();

        if (userDoc.exists) {
          setState(() {
            userName = userDoc.data()?['name'] ?? 'User';
          });
        }
      }
    } catch (e) {
      setState(() {
        userName = 'User';
      });
    }
  }

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
              currentDate.isNotEmpty ? currentDate : "Loading...",
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontFamily: "Poppins",
                fontSize: 12,
              ),
            ),
            Spacer(),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CalendarEventsScreen(),
                  ),
                );
              },
              child: Icon(Icons.calendar_today, size: 24),
            ),
            SizedBox(width: 20),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NotificationScreen()),
                );
              },
              child: Stack(
                children: [
                  Image.asset('assets/images/notification.png'),
                  StreamBuilder<int>(
                    stream: notificationServices.getUnreadCountStream(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData && snapshot.data! > 0) {
                        return Positioned(
                          right: 0,
                          top: 0,
                          child: Container(
                            padding: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            constraints: BoxConstraints(
                              minWidth: 18,
                              minHeight: 18,
                            ),
                            child: Center(
                              child: Text(
                                '${snapshot.data! > 9 ? '9+' : snapshot.data}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ),
                          ),
                        );
                      }
                      return SizedBox.shrink();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder:
                    (context) => AlertDialog(
                      title: Text(
                        'Logout',
                        style: TextStyle(fontFamily: 'Poppins'),
                      ),
                      content: Text(
                        'Are you sure you want to logout?',
                        style: TextStyle(fontFamily: 'Poppins'),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: Text(
                            'Cancel',
                            style: TextStyle(fontFamily: 'Poppins'),
                          ),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: Text(
                            'Logout',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ],
                    ),
              );

              if (confirm == true) {
                try {
                  await FirebaseAuth.instance.signOut();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => Loginscreen()),
                    (route) => false,
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Failed to logout: ${e.toString()}',
                        style: TextStyle(color: Colors.white),
                      ),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            icon: Icon(Icons.logout),
            tooltip: 'Logout',
          ),
        ],
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
                          userName.isNotEmpty ? "Welcome $userName" : "Welcome",
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
                        StreamBuilder<List<TodoModel>>(
                          stream: todoServices.getTodos(),
                          builder: (context, snapshot) {
                            double progress = 0.0;
                            int completedCount = 0;
                            int totalCount = 0;

                            if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                              totalCount = snapshot.data!.length;
                              completedCount =
                                  snapshot.data!
                                      .where((todo) => todo.isCompleted)
                                      .length;
                              progress =
                                  totalCount > 0
                                      ? completedCount / totalCount
                                      : 0.0;
                            }

                            int percentage = (progress * 100).round();

                            return Container(
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
                                    value: progress,
                                    color: Colors.white,
                                    backgroundColor: AppColor.progressbgcolor,
                                  ),
                                  SizedBox(height: 8),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      "$percentage%",
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
                            );
                          },
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
                        StreamBuilder<List<TodoModel>>(
                          stream: todoServices.getTodos(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }

                            if (snapshot.hasError) {
                              return Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Text(
                                    'Error loading tasks',
                                    style: TextStyle(
                                      fontFamily: "Poppins",
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                              );
                            }

                            if (!snapshot.hasData || snapshot.data!.isEmpty) {
                              return Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Text(
                                    'No tasks yet. Add your first task!',
                                    style: TextStyle(
                                      fontFamily: "Poppins",
                                      fontSize: 14,
                                      color: AppColor.fontcolor,
                                    ),
                                  ),
                                ),
                              );
                            }

                            final todos = snapshot.data!;
                            return Column(
                              children:
                                  todos.map((todo) {
                                    return CustomeTodoCard(
                                      cardtitle: todo.title,
                                      btnvisible: false,
                                      isTaskCompleted: todo.isCompleted,
                                      onCardTap: () async {
                                        final event = await eventServices
                                            .getEventByTaskId(todo.todoID);
                                        if (event != null) {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder:
                                                  (context) =>
                                                      EventDetailScreen(
                                                        event: event,
                                                        todo: todo,
                                                      ),
                                            ),
                                          );
                                        } else {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                'This task is not added to calendar yet',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontFamily: 'Poppins',
                                                ),
                                              ),
                                              backgroundColor: Colors.orange,
                                            ),
                                          );
                                        }
                                      },
                                      onToggleComplete: () async {
                                        try {
                                          await todoServices.toggleTodoComplete(
                                            todo.todoID,
                                            todo.isCompleted,
                                          );
                                        } catch (e) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                'Failed to update task',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                              backgroundColor: Colors.red,
                                            ),
                                          );
                                        }
                                      },
                                      onEdit: () async {
                                        await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder:
                                                (context) =>
                                                    EditTask(todo: todo),
                                          ),
                                        );
                                        setState(() {});
                                      },
                                      onDelete: () async {
                                        final confirm = await showDialog<bool>(
                                          context: context,
                                          builder:
                                              (context) => AlertDialog(
                                                title: Text(
                                                  'Delete Task',
                                                  style: TextStyle(
                                                    fontFamily: 'Poppins',
                                                  ),
                                                ),
                                                content: Text(
                                                  'Are you sure you want to delete this task?',
                                                  style: TextStyle(
                                                    fontFamily: 'Poppins',
                                                  ),
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed:
                                                        () => Navigator.pop(
                                                          context,
                                                          false,
                                                        ),
                                                    child: Text(
                                                      'Cancel',
                                                      style: TextStyle(
                                                        fontFamily: 'Poppins',
                                                      ),
                                                    ),
                                                  ),
                                                  TextButton(
                                                    onPressed:
                                                        () => Navigator.pop(
                                                          context,
                                                          true,
                                                        ),
                                                    child: Text(
                                                      'Delete',
                                                      style: TextStyle(
                                                        fontFamily: 'Poppins',
                                                        color: Colors.red,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                        );

                                        if (confirm == true) {
                                          try {
                                            await todoServices.deleteTodo(
                                              todo.todoID,
                                            );
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  'Task deleted successfully!',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                backgroundColor: Colors.green,
                                              ),
                                            );
                                          } catch (e) {
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  'Failed to delete task',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                backgroundColor: Colors.red,
                                              ),
                                            );
                                          }
                                        }
                                      },
                                    );
                                  }).toList(),
                            );
                          },
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
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Addtask()),
          );
          setState(() {});
        },
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
