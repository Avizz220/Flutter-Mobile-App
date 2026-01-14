import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:mytodoapp_frontend/contants/colors.dart';
import 'package:mytodoapp_frontend/features/todo/ui/addtask.dart';
import 'package:mytodoapp_frontend/features/todo/ui/edittask.dart';
import 'package:mytodoapp_frontend/features/todo/ui/notifications.dart';
import 'package:mytodoapp_frontend/features/todo/ui/calendar_events.dart';
import 'package:mytodoapp_frontend/features/todo/ui/event_detail.dart';
import 'package:mytodoapp_frontend/features/todo/ui/add_event_dialog.dart';
import 'package:mytodoapp_frontend/features/authintication/ui/login.dart';
import 'package:mytodoapp_frontend/features/settings/ui/settings.dart';
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
  bool _hasShownReminders = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _setCurrentDate();

    // Reset flag on init
    _hasShownReminders = false;

    // Schedule reminder check after the first frame is rendered
    WidgetsBinding.instance.addPostFrameCallback((_) {_checkAndShowTodayReminders();
    });
  }

  Future<void> _checkAndShowTodayReminders() async {// Small delay to ensure UI is ready
    await Future.delayed(Duration(milliseconds: 500));

    if (_hasShownReminders) {return;
    }
    _hasShownReminders = true;

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        return;
      }

      // Get all events for today from the Events collection
      final now = DateTime.now();
      final eventsSnapshot =
          await FirebaseFirestore.instance
              .collection('Events')
              .where('userID', isEqualTo: user.uid)
              .get();

      List<Map<String, dynamic>> todayEvents = [];

      for (var doc in eventsSnapshot.docs) {
        final data = doc.data();

        if (data['eventDate'] != null) {
          DateTime eventDate;

          // Handle both Timestamp and String formats
          if (data['eventDate'] is Timestamp) {
            eventDate = (data['eventDate'] as Timestamp).toDate();
          } else if (data['eventDate'] is String) {
            eventDate = DateTime.parse(data['eventDate']);
          } else {
            continue;
          }// Check if event is today
          if (eventDate.year == now.year &&
              eventDate.month == now.month &&
              eventDate.day == now.day) {// Get the associated task to check if it's completed
            if (data['taskID'] != null &&
                data['taskID'].toString().isNotEmpty) {
              try {
                final taskDoc =
                    await FirebaseFirestore.instance
                        .collection('Users')
                        .doc(user.uid)
                        .collection('Todos')
                        .doc(data['taskID'])
                        .get();

                if (taskDoc.exists) {
                  final taskData = taskDoc.data();
                  if (taskData != null && taskData['isCompleted'] == true) {
                    continue;
                  }
                }
              } catch (e) {
                // Ignore errors checking task completion status
              }
            }

            data['eventID'] = doc.id;
            data['eventDateParsed'] = eventDate;
            todayEvents.add(data);
          }
        }
      }

      if (todayEvents.isEmpty) {
        return;
      }

      // Sort by start time
      todayEvents.sort((a, b) {
        final aTime = a['startTime'] ?? '';
        final bTime = b['startTime'] ?? '';
        return aTime.compareTo(bTime);
      });

      // Show reminders one by one
      for (int i = 0; i < todayEvents.length; i++) {
        if (!mounted) {
          break;
        }
        await _showTaskReminder(todayEvents[i], i + 1, todayEvents.length);
      }
    } catch (e) {
      // Ignore errors loading reminders
    }
  }

  Future<void> _showTaskReminder(
    Map<String, dynamic> task,
    int current,
    int total,
  ) async {
    if (!mounted) {
      return;
    }

    try {
      // Ensure we have a valid overlay
      final overlayState = Overlay.of(context);

      final overlayEntry = OverlayEntry(
        builder:
            (context) => _TopNotificationBanner(
              task: task,
              current: current,
              total: total,
            ),
      );

      overlayState.insert(overlayEntry);// Auto-dismiss after 3.5 seconds
      await Future.delayed(Duration(milliseconds: 3500));

      if (overlayEntry.mounted) {
        overlayEntry.remove();
      }

      // Small delay before showing next reminder for smooth transition
      await Future.delayed(Duration(milliseconds: 300));
    } catch (e) {
      // Ignore errors displaying reminders
    }
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    double screenwidth = MediaQuery.of(context).size.width;

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
                  MaterialPageRoute(builder: (context) => SettingsScreen()),
                );
              },
              child: Icon(Icons.settings_outlined, size: 24),
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
                  if (!mounted) return;
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
                            color: isDark ? Colors.white : Colors.black,
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
                            color: isDark ? Colors.white : Colors.black,
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
                                          // Show dialog asking to add to calendar
                                          final addToCalendar = await showDialog<
                                            bool
                                          >(
                                            context: context,
                                            builder:
                                                (context) => AlertDialog(
                                                  title: Text(
                                                    'Add to Calendar',
                                                    style: TextStyle(
                                                      fontFamily: 'Poppins',
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                  content: Text(
                                                    'This task is not in your calendar. Would you like to add it now?',
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
                                                        'Add to Calendar',
                                                        style: TextStyle(
                                                          fontFamily: 'Poppins',
                                                          color:
                                                              AppColor
                                                                  .accentColor,
                                                          fontWeight:
                                                              FontWeight.w600,
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
                                                    selectedDate:
                                                        DateTime.now(),
                                                  ),
                                            );
                                          }
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
                                            if (!mounted) return;
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

class _TopNotificationBanner extends StatefulWidget {
  final Map<String, dynamic> task;
  final int current;
  final int total;

  const _TopNotificationBanner({
    required this.task,
    required this.current,
    required this.total,
  });

  @override
  State<_TopNotificationBanner> createState() => _TopNotificationBannerState();
}

class _TopNotificationBannerState extends State<_TopNotificationBanner>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Get event/task data
    final title = widget.task['title'] ?? '';
    final location = widget.task['location'] ?? '';
    final startTime = widget.task['startTime'] ?? '';
    final endTime = widget.task['endTime'] ?? '';
    final category = widget.task['category'] ?? '';

    // Get category color
    Color categoryColor = _getCategoryColor(category);

    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SlideTransition(
        position: _slideAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SafeArea(
            child: GestureDetector(
              onVerticalDragUpdate: (details) {
                // Swipe up to dismiss
                if (details.delta.dy < -5) {
                  _controller.reverse();
                }
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      blurRadius: 30,
                      offset: Offset(0, 15),
                      spreadRadius: -5,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      decoration: BoxDecoration(
                        color:
                            isDark
                                ? Color(0xFF1E1E1E).withValues(alpha: 0.95)
                                : Colors.white.withValues(alpha: 0.95),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color:
                              isDark
                                  ? Colors.white.withValues(alpha: 0.1)
                                  : Colors.black.withValues(alpha: 0.05),
                          width: 1.5,
                        ),
                      ),
                      child: Stack(
                        children: [
                          // Colored accent bar on the left
                          Positioned(
                            left: 0,
                            top: 0,
                            bottom: 0,
                            child: Container(
                              width: 5,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    categoryColor,
                                    categoryColor.withValues(alpha: 0.6),
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                              ),
                            ),
                          ),

                          // Main content
                          Padding(
                            padding: EdgeInsets.fromLTRB(20, 16, 16, 16),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Header Row
                                Row(
                                  children: [
                                    // Icon with gradient background
                                    Container(
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            categoryColor.withValues(alpha: 0.2),
                                            categoryColor.withValues(alpha: 0.1),
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Icon(
                                        Icons.event_available_rounded,
                                        color: categoryColor,
                                        size: 22,
                                      ),
                                    ),
                                    SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Upcoming Event',
                                            style: TextStyle(
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w600,
                                              fontSize: 13,
                                              color:
                                                  isDark
                                                      ? Colors.white
                                                          .withValues(alpha: 0.9)
                                                      : Color(0xFF2D3748),
                                              letterSpacing: 0.3,
                                            ),
                                          ),
                                          SizedBox(height: 2),
                                          Text(
                                            '${widget.current} of ${widget.total} ${widget.total == 1 ? 'reminder' : 'reminders'}',
                                            style: TextStyle(
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w400,
                                              fontSize: 11,
                                              color:
                                                  isDark
                                                      ? Colors.white
                                                          .withValues(alpha: 0.5)
                                                      : Color(0xFF718096),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Dismiss button
                                    GestureDetector(
                                      onTap: () => _controller.reverse(),
                                      child: Container(
                                        padding: EdgeInsets.all(6),
                                        decoration: BoxDecoration(
                                          color:
                                              isDark
                                                  ? Colors.white.withValues(
                                                    alpha: 0.1,
                                                  )
                                                  : Colors.black.withValues(
                                                    alpha: 0.05,
                                                  ),
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: Icon(
                                          Icons.close_rounded,
                                          size: 16,
                                          color:
                                              isDark
                                                  ? Colors.white.withValues(
                                                    alpha: 0.6,
                                                  )
                                                  : Color(0xFF718096),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                SizedBox(height: 14),

                                // Divider
                                Container(
                                  height: 1,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        isDark
                                            ? Colors.white.withValues(alpha: 0.05)
                                            : Colors.black.withValues(alpha: 0.05),
                                        isDark
                                            ? Colors.white.withValues(alpha: 0.1)
                                            : Colors.black.withValues(alpha: 0.1),
                                        isDark
                                            ? Colors.white.withValues(alpha: 0.05)
                                            : Colors.black.withValues(alpha: 0.05),
                                      ],
                                    ),
                                  ),
                                ),

                                SizedBox(height: 14),

                                // Title
                                Text(
                                  title,
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w600,
                                    fontSize: 17,
                                    color:
                                        isDark
                                            ? Colors.white
                                            : Color(0xFF1A202C),
                                    height: 1.3,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),

                                SizedBox(height: 12),

                                // Info Row
                                Wrap(
                                  spacing: 12,
                                  runSpacing: 8,
                                  children: [
                                    // Time chip
                                    if (startTime.isNotEmpty)
                                      _buildInfoChip(
                                        icon: Icons.schedule_rounded,
                                        text:
                                            startTime.isNotEmpty &&
                                                    endTime.isNotEmpty
                                                ? '$startTime - $endTime'
                                                : startTime,
                                        color:
                                            isDark
                                                ? Colors.blue[300]!
                                                : Colors.blue[600]!,
                                        isDark: isDark,
                                      ),

                                    // Location chip
                                    if (location.isNotEmpty)
                                      _buildInfoChip(
                                        icon: Icons.location_on_rounded,
                                        text: location,
                                        color:
                                            isDark
                                                ? Colors.orange[300]!
                                                : Colors.orange[600]!,
                                        isDark: isDark,
                                      ),

                                    // Category chip
                                    if (category.isNotEmpty)
                                      _buildCategoryChip(
                                        text: category,
                                        color: categoryColor,
                                        isDark: isDark,
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip({
    required IconData icon,
    required String text,
    required Color color,
    required bool isDark,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: isDark ? 0.15 : 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          SizedBox(width: 5),
          Flexible(
            child: Text(
              text,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: color,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip({
    required String text,
    required Color color,
    required bool isDark,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withValues(alpha: 0.2), color.withValues(alpha: 0.15)],
        ),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.4), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'booking':
        return Color(0xFF3B82F6); // Blue
      case 'ux':
        return Color(0xFFEC4899); // Pink
      case 'shopping':
        return Color(0xFF8B5CF6); // Purple
      case 'meeting':
        return Color(0xFFF59E0B); // Yellow/Orange
      case 'work':
        return Color(0xFF10B981); // Green
      default:
        return Color(0xFF6366F1); // Indigo
    }
  }
}
