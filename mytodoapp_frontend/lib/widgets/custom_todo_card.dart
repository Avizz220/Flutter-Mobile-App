import 'package:flutter/material.dart';
import 'package:mytodoapp_frontend/contants/colors.dart';

class CustomeTodoCard extends StatefulWidget {
  final String cardtitle;
  final bool btnvisible;
  final bool isTaskCompleted;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onToggleComplete;
  final VoidCallback? onCardTap;

  const CustomeTodoCard({
    super.key,
    required this.cardtitle,
    required this.btnvisible,
    required this.isTaskCompleted,
    this.onEdit,
    this.onDelete,
    this.onToggleComplete,
    this.onCardTap,
  });

  @override
  State<CustomeTodoCard> createState() => _CustomeTodoCardState();
}

class _CustomeTodoCardState extends State<CustomeTodoCard> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    double screenwidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: widget.onCardTap,
      child: Container(
        width: screenwidth,
        height: 70,
        margin: EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: AppColor.accentColor.withOpacity(0.5)),
        ),
        child: Row(
          children: [
            Checkbox(
              value: widget.isTaskCompleted,
              onChanged: (value) {
                if (widget.onToggleComplete != null) {
                  widget.onToggleComplete!();
                }
              },
              activeColor: AppColor.accentColor,
            ),
            Expanded(
              child: Text(
                widget.cardtitle,
                style: TextStyle(
                  fontFamily: "poppins",
                  color:
                      widget.isTaskCompleted
                          ? (isDark ? Colors.white70 : AppColor.fontcolor)
                          : (isDark ? Colors.white : AppColor.accentColor),
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                  decoration:
                      widget.isTaskCompleted
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                  decorationColor: isDark ? Colors.white70 : AppColor.fontcolor,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Spacer(),
            widget.isTaskCompleted
                ? SizedBox(width: 10)
                : Column(
                  children: [
                    Spacer(),
                    GestureDetector(
                      onTap: widget.onEdit,
                      child: Icon(
                        Icons.edit,
                        color: isDark ? Colors.white70 : Colors.black,
                      ),
                    ),
                    SizedBox(height: 5),
                    GestureDetector(
                      onTap: widget.onDelete,
                      child: Icon(Icons.delete, color: Colors.red),
                    ),
                    Spacer(),
                  ],
                ),
          ],
        ),
      ),
    );
  }
}
