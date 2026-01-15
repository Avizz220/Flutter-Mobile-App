import 'package:flutter/material.dart';
import 'package:mytodoapp_frontend/contants/colors.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String labeltext;
  final Color bordercolor;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final bool obscureText;
  final VoidCallback? onSuffixTap;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.labeltext,
    required this.bordercolor,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.onSuffixTap,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Focus(
      onFocusChange: (hasFocus) {
        setState(() {
          _isFocused = hasFocus;
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: _isFocused
              ? [
                  BoxShadow(
                    color: AppColor.accentColor.withOpacity(0.2),
                    blurRadius: 12,
                    offset: Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: TextField(
          controller: widget.controller,
          obscureText: widget.obscureText,
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
            fontFamily: 'Poppins',
            fontSize: 15,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: isDark ? Color(0xFF2C2C2C) : Colors.grey[50],
            prefixIcon: widget.prefixIcon != null
                ? Icon(
                    widget.prefixIcon,
                    color: _isFocused
                        ? AppColor.accentColor
                        : (isDark ? Colors.white54 : Colors.grey[600]),
                    size: 22,
                  )
                : null,
            suffixIcon: widget.suffixIcon != null
                ? IconButton(
                    icon: Icon(
                      widget.suffixIcon,
                      color: isDark ? Colors.white54 : Colors.grey[600],
                      size: 22,
                    ),
                    onPressed: widget.onSuffixTap,
                  )
                : null,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: isDark ? Colors.white12 : Colors.grey[300]!,
                width: 1.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: AppColor.accentColor,
                width: 2,
              ),
            ),
            label: Text(
              widget.labeltext,
              style: TextStyle(
                color: _isFocused
                    ? AppColor.accentColor
                    : (isDark ? Colors.white60 : Colors.grey[600]),
                fontFamily: 'Poppins',
                fontSize: 14,
              ),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          ),
        ),
      ),
    );
  }
}
