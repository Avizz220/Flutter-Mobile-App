import 'package:flutter/material.dart';
import 'package:mytodoapp_frontend/contants/colors.dart';

class CustomeButton extends StatefulWidget {
  final double btnwidth;
  final String btntext;
  final IconData? icon;

  const CustomeButton({
    super.key,
    required this.btnwidth,
    required this.btntext,
    this.icon,
  });

  @override
  State<CustomeButton> createState() => _CustomeButtonState();
}

class _CustomeButtonState extends State<CustomeButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          width: widget.btnwidth,
          height: 56,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColor.accentColor,
                AppColor.accentColor.withOpacity(0.8),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColor.accentColor.withOpacity(0.4),
                blurRadius: 12,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.icon != null) ...[
                  Icon(widget.icon, color: Colors.white, size: 22),
                  SizedBox(width: 8),
                ],
                Text(
                  widget.btntext,
                  style: TextStyle(
                    fontFamily: "Poppins",
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
