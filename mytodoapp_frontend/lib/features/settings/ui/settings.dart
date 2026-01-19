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

/// Settings screen for user preferences and account management
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final ThemeService _themeService = ThemeService();

  // State variables
  bool _isDarkMode = false;
  bool _isLoadingTheme = true;
  bool _remindersEnabled = true;
  String? _profilePhotoBase64;

  @override
  void initState() {
    super.initState();
    _initializeSettings();
  }

  /// Initialize all settings from storage
  void _initializeSettings() {
    _loadThemeMode();
    _loadProfilePhoto();
    _loadRemindersSetting();
  }

  /// Load user profile photo from Firestore
  Future<void> _loadProfilePhoto() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

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
    } catch (e) {
      // Silently handle errors
      print('Error loading profile photo: $e');
    }
  }

  /// Load theme mode preference
  Future<void> _loadThemeMode() async {
    final isDark = await _themeService.getThemeMode();
    setState(() {
      _isDarkMode = isDark;
      _isLoadingTheme = false;
    });
  }

  /// Load reminders enabled setting
  Future<void> _loadRemindersSetting() async {
    final enabled = await _themeService.getRemindersEnabled();
    setState(() {
      _remindersEnabled = enabled;
    });
  }

  /// Toggle reminder notifications
  Future<void> _toggleReminders(bool value) async {
    setState(() => _remindersEnabled = value);
    await _themeService.saveRemindersEnabled(value);

    if (mounted) {
      _showSnackBar(
        value ? 'Reminders enabled' : 'Reminders disabled',
        AppColor.accentColor,
      );
    }
  }

  /// Toggle dark/light mode
  Future<void> _toggleDarkMode(bool value) async {
    setState(() => _isDarkMode = value);
    await _themeService.saveThemeMode(value);
    MyApp.of(context)?.toggleTheme(value);

    if (mounted) {
      _showSnackBar(
        value ? 'Dark mode enabled' : 'Light mode enabled',
        AppColor.accentColor,
      );
    }
  }

  /// Show a snackbar message
  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: TextStyle(fontFamily: 'Poppins')),
        backgroundColor: color,
        duration: Duration(seconds: 1),
      ),
    );
  }

  /// Show app rating dialog before logout
  Future<void> _showRatingDialog(BuildContext context) async {
    int selectedRating = 0;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              elevation: 10,
              backgroundColor: Colors.transparent,
              insetPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: 400,
                  maxHeight: MediaQuery.of(context).size.height * 0.8,
                ),
                decoration: _buildDialogDecoration(
                  isDark,
                  AppColor.accentColor,
                ),
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildRatingIcon(),
                      SizedBox(height: 20),
                      _buildDialogTitle('Rate Our App', isDark),
                      SizedBox(height: 10),
                      _buildRatingDescription(isDark),
                      SizedBox(height: 24),
                      _buildStarRating(selectedRating, setDialogState, isDark),
                      SizedBox(height: 24),
                      _buildRatingButtons(
                        selectedRating,
                        dialogContext,
                        context,
                        isDark,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  /// Build star rating widget
  Widget _buildStarRating(
    int selectedRating,
    StateSetter setState,
    bool isDark,
  ) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 8,
      children: List.generate(5, (index) {
        final isSelected = selectedRating > index;
        return GestureDetector(
          onTap: () => setState(() => selectedRating = index + 1),
          child: AnimatedContainer(
            duration: Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            child: Icon(
              isSelected ? Icons.star_rounded : Icons.star_outline_rounded,
              size: isSelected ? 42 : 38,
              color:
                  isSelected
                      ? AppColor.accentColor
                      : (isDark
                          ? Colors.white.withOpacity(0.3)
                          : Colors.grey[400]),
            ),
          ),
        );
      }),
    );
  }

  /// Build rating dialog buttons
  Widget _buildRatingButtons(
    int selectedRating,
    BuildContext dialogContext,
    BuildContext parentContext,
    bool isDark,
  ) {
    return Row(
      children: [
        Expanded(
          child: _buildDialogButton(
            text: 'Skip',
            onTap: () {
              Navigator.of(dialogContext).pop();
              _showLogoutConfirmation(parentContext);
            },
            isPrimary: false,
            isDark: isDark,
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _buildDialogButton(
            text: 'Submit',
            onTap:
                selectedRating > 0
                    ? () {
                      Navigator.of(dialogContext).pop();
                      _submitRating(parentContext, selectedRating);
                    }
                    : null,
            isPrimary: true,
            isDark: isDark,
            isEnabled: selectedRating > 0,
          ),
        ),
      ],
    );
  }

  /// Submit user rating
  Future<void> _submitRating(BuildContext context, int rating) async {
    print('User rated the app: $rating stars');

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 12),
            Text(
              'Thank you for your feedback!',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: Duration(seconds: 2),
      ),
    );

    _showLogoutConfirmation(context);
  }

  /// Show logout confirmation dialog
  Future<void> _showLogoutConfirmation(BuildContext context) async {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          elevation: 10,
          backgroundColor: Colors.transparent,
          child: Container(
            padding: EdgeInsets.all(28),
            decoration: _buildDialogDecoration(isDark, Colors.red),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildLogoutIcon(),
                SizedBox(height: 24),
                _buildDialogTitle('Logout Confirmation', isDark),
                SizedBox(height: 12),
                _buildLogoutMessage(isDark),
                SizedBox(height: 32),
                _buildLogoutButtons(dialogContext, isDark),
              ],
            ),
          ),
        );
      },
    );

    if (confirmed == true) {
      _performLogout(context);
    }
  }

  /// Build logout confirmation buttons
  Widget _buildLogoutButtons(BuildContext dialogContext, bool isDark) {
    return Row(
      children: [
        Expanded(
          child: _buildDialogButton(
            text: 'Cancel',
            onTap: () => Navigator.of(dialogContext).pop(false),
            isPrimary: false,
            isDark: isDark,
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _buildDialogButton(
            text: 'Logout',
            onTap: () => Navigator.of(dialogContext).pop(true),
            isPrimary: true,
            isDark: isDark,
            buttonColor: Colors.red,
          ),
        ),
      ],
    );
  }

  /// Perform logout operation
  Future<void> _performLogout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Loginscreen()),
      );
    } catch (e) {
      _showSnackBar('Error logging out: $e', Colors.red);
    }
  }

  /// Initiate logout process
  Future<void> _logout(BuildContext context) async {
    _showRatingDialog(context);
  }

  // Helper methods for building dialog components

  /// Build common dialog decoration
  BoxDecoration _buildDialogDecoration(bool isDark, Color accentColor) {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors:
            isDark
                ? [Color(0xFF2D2D2D), Color(0xFF1A1A1A)]
                : [Colors.white, Color(0xFFFAFAFA)],
      ),
      borderRadius: BorderRadius.circular(24),
      boxShadow: [
        BoxShadow(
          color: accentColor.withOpacity(0.2),
          blurRadius: 30,
          offset: Offset(0, 10),
        ),
      ],
    );
  }

  /// Build rating icon
  Widget _buildRatingIcon() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColor.accentColor.withOpacity(0.2),
            AppColor.accentColor.withOpacity(0.1),
          ],
        ),
        shape: BoxShape.circle,
      ),
      child: Icon(Icons.star_rounded, size: 42, color: AppColor.accentColor),
    );
  }

  /// Build logout icon
  Widget _buildLogoutIcon() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.red.withOpacity(0.2), Colors.red.withOpacity(0.1)],
        ),
        shape: BoxShape.circle,
      ),
      child: Icon(Icons.logout_rounded, size: 50, color: Colors.red),
    );
  }

  /// Build dialog title
  Widget _buildDialogTitle(String title, bool isDark) {
    return Text(
      title,
      style: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: isDark ? Colors.white : Color(0xFF1A202C),
      ),
    );
  }

  /// Build rating description
  Widget _buildRatingDescription(bool isDark) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: Text(
        'How would you rate your experience with our app?',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 13,
          fontWeight: FontWeight.w400,
          color: isDark ? Colors.white.withOpacity(0.7) : Color(0xFF64748B),
          height: 1.4,
        ),
      ),
    );
  }

  /// Build logout message
  Widget _buildLogoutMessage(bool isDark) {
    return Text(
      'Are you sure you want to logout from your account?',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: isDark ? Colors.white.withOpacity(0.7) : Color(0xFF64748B),
        height: 1.5,
      ),
    );
  }

  /// Build reusable dialog button
  Widget _buildDialogButton({
    required String text,
    required VoidCallback? onTap,
    required bool isPrimary,
    required bool isDark,
    bool isEnabled = true,
    Color? buttonColor,
  }) {
    final effectiveColor = buttonColor ?? AppColor.accentColor;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isEnabled ? onTap : null,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            gradient:
                isPrimary && isEnabled
                    ? LinearGradient(
                      colors: [effectiveColor, effectiveColor.withOpacity(0.8)],
                    )
                    : null,
            color:
                isPrimary && !isEnabled
                    ? (isDark
                        ? Colors.white.withOpacity(0.1)
                        : Colors.grey[300])
                    : (!isPrimary
                        ? (isDark
                            ? Colors.white.withOpacity(0.08)
                            : Colors.grey[200])
                        : null),
            borderRadius: BorderRadius.circular(14),
            border:
                !isPrimary
                    ? Border.all(
                      color:
                          isDark
                              ? Colors.white.withOpacity(0.15)
                              : Colors.grey[300]!,
                      width: 1.5,
                    )
                    : null,
            boxShadow:
                isPrimary && isEnabled
                    ? [
                      BoxShadow(
                        color: effectiveColor.withOpacity(0.3),
                        blurRadius: 12,
                        offset: Offset(0, 6),
                      ),
                    ]
                    : null,
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 15,
              fontWeight: isPrimary ? FontWeight.w700 : FontWeight.w600,
              color: _getButtonTextColor(isPrimary, isEnabled, isDark),
            ),
          ),
        ),
      ),
    );
  }

  /// Get button text color based on state
  Color _getButtonTextColor(bool isPrimary, bool isEnabled, bool isDark) {
    if (isPrimary) {
      return isEnabled
          ? Colors.white
          : (isDark ? Colors.white.withOpacity(0.3) : Colors.grey[500]!);
    }
    return isDark ? Colors.white.withOpacity(0.7) : Color(0xFF64748B);
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Color(0xFF121212) : Colors.grey[50],
      appBar: _buildAppBar(isDark),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          _buildProfileSection(user, isDark),
          SizedBox(height: 30),
          _buildSectionHeader('Security'),
          SizedBox(height: 15),
          _buildPasswordTile(),
          SizedBox(height: 30),
          _buildSectionHeader('Appearance'),
          SizedBox(height: 15),
          _buildDarkModeToggle(isDark),
          SizedBox(height: 10),
          _buildRemindersToggle(isDark),
          SizedBox(height: 10),
          _buildThemeTile(),
          SizedBox(height: 30),
          _buildSectionHeader('Account'),
          SizedBox(height: 15),
          _buildLogoutTile(),
        ],
      ),
    );
  }

  /// Build app bar
  PreferredSizeWidget _buildAppBar(bool isDark) {
    return AppBar(
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
    );
  }

  /// Build section header
  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.grey[700],
      ),
    );
  }

  /// Build profile section
  Widget _buildProfileSection(User? user, bool isDark) {
    return GestureDetector(
      onTap: () async {
        final result = await showDialog<String>(
          context: context,
          builder: (context) => ProfileDialog(),
        );

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
            _buildProfileAvatar(),
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
            Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }

  /// Build profile avatar
  Widget _buildProfileAvatar() {
    if (_profilePhotoBase64 != null) {
      return CircleAvatar(
        radius: 35,
        backgroundImage: MemoryImage(base64Decode(_profilePhotoBase64!)),
      );
    }

    return CircleAvatar(
      radius: 35,
      backgroundColor: AppColor.accentColor.withOpacity(0.2),
      child: Icon(Icons.person, size: 40, color: AppColor.accentColor),
    );
  }

  /// Build change password tile
  Widget _buildPasswordTile() {
    return _buildSettingsTile(
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
    );
  }

  /// Build theme color tile
  Widget _buildThemeTile() {
    return _buildSettingsTile(
      context: context,
      icon: Icons.palette_outlined,
      title: 'Theme Color',
      subtitle: 'Customize your app color theme',
      onTap: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ThemeSelectorScreen()),
        );

        if (result == true && mounted) {
          setState(() {});
        }
      },
    );
  }

  /// Build logout tile
  Widget _buildLogoutTile() {
    return _buildSettingsTile(
      context: context,
      icon: Icons.logout,
      title: 'Logout',
      subtitle: 'Sign out of your account',
      iconColor: Colors.red,
      onTap: () => _logout(context),
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
