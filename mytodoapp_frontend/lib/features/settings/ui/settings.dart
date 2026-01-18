import 'package:flutter/material.dart';
import 'package:mytodoapp_frontend/contants/colors.dart';
import 'package:mytodoapp_frontend/features/settings/ui/change_password.dart';
import 'package:mytodoapp_frontend/features/settings/ui/theme_selector.dart';
import 'package:mytodoapp_frontend/features/settings/ui/profile_dialog.dart';
import 'package:mytodoapp_frontend/features/authintication/ui/login.dart';
import 'package:mytodoapp_frontend/services/theme_service.dart';
import 'package:mytodoapp_frontend/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final ThemeService _themeService = ThemeService();
  bool _isDarkMode = false;
  bool _isLoadingTheme = true;
  bool _remindersEnabled = true;
  String? _profilePhotoBase64;

  @override
  void initState() {
    super.initState();
    _loadThemeMode();
    _loadProfilePhoto();
    _loadRemindersSetting();
  }

  Future<void> _loadProfilePhoto() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final doc =
            await FirebaseFirestore.instance
                .collection('Users')
                .doc(user.uid)
                .get();

        if (doc.exists && doc.data()?['profilePhoto'] != null) {
          setState(() {
            _profilePhotoBase64 = doc.data()!['profilePhoto'];
          });
        }
      }
    } catch (e) {
      // Silently fail
    }
  }

  Future<void> _loadThemeMode() async {
    final isDark = await _themeService.getThemeMode();
    setState(() {
      _isDarkMode = isDark;
      _isLoadingTheme = false;
    });
  }

  Future<void> _loadRemindersSetting() async {
    final enabled = await _themeService.getRemindersEnabled();
    setState(() {
      _remindersEnabled = enabled;
    });
  }

  Future<void> _toggleReminders(bool value) async {
    setState(() {
      _remindersEnabled = value;
    });

    await _themeService.saveRemindersEnabled(value);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            value ? 'Reminders enabled' : 'Reminders disabled',
            style: TextStyle(fontFamily: 'Poppins'),
          ),
          backgroundColor: AppColor.accentColor,
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  Future<void> _toggleDarkMode(bool value) async {
    setState(() {
      _isDarkMode = value;
    });

    await _themeService.saveThemeMode(value);

    // Update the app theme
    MyApp.of(context)?.toggleTheme(value);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            value ? 'Dark mode enabled' : 'Light mode enabled',
            style: TextStyle(fontFamily: 'Poppins'),
          ),
          backgroundColor: AppColor.accentColor,
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  Future<void> _logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Loginscreen()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error logging out: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Color(0xFF121212) : Colors.grey[50],
      appBar: AppBar(
        backgroundColor: isDark ? Color(0xFF1E1E1E) : Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDark ? Colors.white : Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Settings',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            fontSize: 20,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          // Profile Section
          GestureDetector(
            onTap: () async {
              final result = await showDialog<String>(
                context: context,
                builder: (context) => ProfileDialog(),
              );

              // Reload profile photo if changed
              if (result != null) {
                _loadProfilePhoto();
              }
            },
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark ? Color(0xFF1E1E1E) : Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  _profilePhotoBase64 != null
                      ? CircleAvatar(
                        radius: 35,
                        backgroundImage: MemoryImage(
                          base64Decode(_profilePhotoBase64!),
                        ),
                      )
                      : CircleAvatar(
                        radius: 35,
                        backgroundColor: AppColor.accentColor.withOpacity(0.2),
                        child: Icon(
                          Icons.person,
                          size: 40,
                          color: AppColor.accentColor,
                        ),
                      ),
                  SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user?.displayName ?? 'User',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: isDark ? Colors.white : Colors.black,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          user?.email ?? '',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Colors.grey[400],
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 30),

          // Security Section
          Text(
            'Security',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(height: 15),

          _buildSettingsTile(
            context: context,
            icon: Icons.lock_outline,
            title: 'Change Password',
            subtitle: 'Update your account password',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ChangePasswordScreen()),
              );
            },
          ),

          SizedBox(height: 30),

          // Appearance Section
          Text(
            'Appearance',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(height: 15),

          // Dark Mode Toggle
          _buildDarkModeToggle(isDark),

          SizedBox(height: 10),

          // Reminders Toggle
          _buildRemindersToggle(isDark),

          SizedBox(height: 10),

          _buildSettingsTile(
            context: context,
            icon: Icons.palette_outlined,
            title: 'Theme Color',
            subtitle: 'Customize your app color theme',
            onTap: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ThemeSelectorScreen()),
              );

              // Refresh the screen if theme was changed
              if (result == true && mounted) {
                setState(() {});
              }
            },
          ),

          SizedBox(height: 30),

          // Account Section
          Text(
            'Account',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(height: 15),

          _buildSettingsTile(
            context: context,
            icon: Icons.logout,
            title: 'Logout',
            subtitle: 'Sign out of your account',
            iconColor: Colors.red,
            onTap: () => _logout(context),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color? iconColor,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: isDark ? Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: (iconColor ?? AppColor.accentColor).withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: iconColor ?? AppColor.accentColor, size: 24),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 13,
            color: Colors.grey[600],
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Colors.grey[400],
        ),
        onTap: onTap,
      ),
    );
  }

  Widget _buildDarkModeToggle(bool isDark) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: isDark ? Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColor.accentColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            _isDarkMode ? Icons.dark_mode : Icons.light_mode,
            color: AppColor.accentColor,
            size: 24,
          ),
        ),
        title: Text(
          'Dark Mode',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        subtitle: Text(
          _isDarkMode ? 'Switch to light theme' : 'Switch to dark theme',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 13,
            color: Colors.grey[600],
          ),
        ),
        trailing:
            _isLoadingTheme
                ? SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColor.accentColor,
                    ),
                  ),
                )
                : Switch(
                  value: _isDarkMode,
                  onChanged: _toggleDarkMode,
                  activeColor: AppColor.accentColor,
                ),
      ),
    );
  }

  Widget _buildRemindersToggle(bool isDark) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: isDark ? Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColor.accentColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            _remindersEnabled
                ? Icons.notifications_active
                : Icons.notifications_off,
            color: AppColor.accentColor,
            size: 24,
          ),
        ),
        title: Text(
          'Event Reminders',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        subtitle: Text(
          'Show notifications for upcoming events',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 13,
            color: Colors.grey[600],
          ),
        ),
        trailing: Switch(
          value: _remindersEnabled,
          onChanged: _toggleReminders,
          activeColor: AppColor.accentColor,
        ),
      ),
    );
  }
}
