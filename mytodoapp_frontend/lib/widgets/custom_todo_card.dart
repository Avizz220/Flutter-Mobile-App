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
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        width: screenwidth,
        margin: EdgeInsets.only(bottom: 12),
        padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        decoration: BoxDecoration(
          color: isDark ? Color(0xFF1E1E1E) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: widget.isTaskCompleted
                ? (isDark ? Colors.white12 : Colors.grey[300]!)
                : AppColor.accentColor.withOpacity(0.3),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: widget.isTaskCompleted
                  ? Colors.transparent
                  : (isDark
                      ? Colors.black26
                      : AppColor.accentColor.withOpacity(0.08)),
              blurRadius: 8,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Transform.scale(
              scale: 1.1,
              child: Checkbox(
                value: widget.isTaskCompleted,
                onChanged: (value) {
                  if (widget.onToggleComplete != null) {
                    widget.onToggleComplete!();
                  }
                },
                activeColor: AppColor.accentColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ),
            SizedBox(width: 4),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  widget.cardtitle,
                  style: TextStyle(
                    fontFamily: "Poppins",
                    color: widget.isTaskCompleted
                        ? (isDark ? Colors.white38 : Colors.grey[500])
                        : (isDark ? Colors.white : Colors.grey[800]),
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                    decoration: widget.isTaskCompleted
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                    decorationColor:
                        isDark ? Colors.white38 : Colors.grey[500],
                    decorationThickness: 2,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),
            ),
            SizedBox(width: 8),
            widget.isTaskCompleted
                ? Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 20,
                    ),
                  )
                : Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColor.accentColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: IconButton(
                          onPressed: widget.onEdit,
                          icon: Icon(
                            Icons.edit_rounded,
                            color: AppColor.accentColor,
                            size: 20,
                          ),
                          padding: EdgeInsets.zero,
                        ),
                      ),
                      SizedBox(width: 8),
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: IconButton(
                          onPressed: widget.onDelete,
                          icon: Icon(
                            Icons.delete_rounded,
                            color: Colors.red,
                            size: 20,
                          ),
                          padding: EdgeInsets.zero,
                        ),
                      ),
                    ],
                  ),
            SizedBox(width: 4),
          ],
        ),
      ),
    );
  }
}
