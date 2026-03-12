import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';
import './widget/avatar_customization_modal.dart';
import './widget/profile_header_widget.dart';
import './widget/settings_section_widget.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  int _currentBottomNavIndex = 3;
  bool _isLoading = false;

  // Mock user data
  Map<String, dynamic> userData = {
    "id": "user_001",
    "username": "AdventureSeeker",
    "email": "user@walkscape.com",
    "avatar":
        "https://images.unsplash.com/photo-1705408115513-3ff15ef55a8d",
    "avatarSemanticLabel":
        "Young woman with curly brown hair wearing a white t-shirt, smiling outdoors",
    "level": 12,
    "currentXP": 2450,
    "nextLevelXP": 3000,
    "totalSteps": 125847,
    "totalDistance": 62.4,
    "completedAdventures": 8,
    "currentAvatarId": "avatar_1",
    "currentThemeId": "forest_trail",
    "currentThemeName": "Forest Trail",
    "joinDate": "2024-03-15",
    "lastActive": "2025-11-06",
    "preferences": {
      "notifications": {
        "achievements": true,
        "dailyReminders": true,
        "socialUpdates": false,
        "weeklyReports": true,
      },
      "privacy": {
        "profileVisibility": "friends",
        "shareProgress": true,
        "showInLeaderboard": true,
      },
      "app": {
        "darkMode": false,
        "units": "imperial",
        "language": "english",
        "hapticFeedback": true,
      }
    }
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: const CustomAppBar(
        title: 'Profile',
        variant: CustomAppBarVariant.profile,
        showBackButton: false,
      ),
      body: RefreshIndicator(
        onRefresh: _refreshProfile,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    SizedBox(height: 2.h),

                    // Profile Header
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4.w),
                      child: ProfileHeaderWidget(
                        userData: userData,
                        onAvatarTap: _showAvatarCustomization,
                      ),
                    ),

                    SizedBox(height: 3.h),

                    // Account Settings Section
                    SettingsSectionWidget(
                      title: 'Account Settings',
                      items: _getAccountSettingsItems(),
                      onItemTap: _handleAccountSettingsTap,
                    ),

                    // Avatar Customization Section
                    SettingsSectionWidget(
                      title: 'Avatar Customization',
                      items: _getAvatarCustomizationItems(),
                      onItemTap: _handleAvatarCustomizationTap,
                    ),

                    // Notifications Section
                    SettingsSectionWidget(
                      title: 'Notifications',
                      items: _getNotificationItems(),
                      onItemTap: _handleNotificationTap,
                    ),

                    // Privacy Section
                    SettingsSectionWidget(
                      title: 'Privacy',
                      items: _getPrivacyItems(),
                      onItemTap: _handlePrivacyTap,
                    ),

                    // App Preferences Section
                    SettingsSectionWidget(
                      title: 'App Preferences',
                      items: _getAppPreferencesItems(),
                      onItemTap: _handleAppPreferencesTap,
                    ),

                    // Account Actions Section
                    SettingsSectionWidget(
                      title: 'Account Actions',
                      items: _getAccountActionsItems(),
                      onItemTap: _handleAccountActionsTap,
                    ),

                    SizedBox(height: 10.h),
                  ],
                ),
              ),
      ),
      bottomNavigationBar: CustomBottomBar(
        currentIndex: _currentBottomNavIndex,
        onTap: (index) => setState(() => _currentBottomNavIndex = index),
      ),
    );
  }

  List<Map<String, dynamic>> _getAccountSettingsItems() {
    final theme = Theme.of(context);

    return [
      {
        "key": "email",
        "title": "Email Address",
        "subtitle": userData["email"],
        "icon": "email",
        "iconColor": theme.colorScheme.primary,
        "hasDisclosure": true,
      },
      {
        "key": "password",
        "title": "Change Password",
        "icon": "lock",
        "iconColor": theme.colorScheme.secondary,
        "hasDisclosure": true,
      },
      {
        "key": "health_data",
        "title": "Health Data Permissions",
        "subtitle": "Manage HealthKit & Google Fit access",
        "icon": "health_and_safety",
        "iconColor": theme.colorScheme.tertiary,
        "hasDisclosure": true,
      },
      {
        "key": "subscription",
        "title": "Subscription Status",
        "subtitle": "Free Plan",
        "icon": "card_membership",
        "iconColor": theme.colorScheme.primary,
        "hasDisclosure": true,
      },
    ];
  }

  List<Map<String, dynamic>> _getAvatarCustomizationItems() {
    final theme = Theme.of(context);

    return [
      {
        "key": "customize_avatar",
        "title": "Customize Avatar",
        "subtitle": "Change appearance and unlock new items",
        "icon": "person",
        "iconColor": theme.colorScheme.primary,
        "hasDisclosure": true,
      },
      {
        "key": "trail_themes",
        "title": "Trail Themes",
        "subtitle": "Current: ${userData["currentThemeName"]}",
        "icon": "landscape",
        "iconColor": theme.colorScheme.secondary,
        "hasDisclosure": true,
      },
      {
        "key": "unlocked_items",
        "title": "Unlocked Items",
        "subtitle": "View your collection",
        "icon": "inventory",
        "iconColor": theme.colorScheme.tertiary,
        "hasDisclosure": true,
      },
    ];
  }

  List<Map<String, dynamic>> _getNotificationItems() {
    final theme = Theme.of(context);
    final prefs =
        userData["preferences"]["notifications"] as Map<String, dynamic>;

    return [
      {
        "key": "achievements",
        "title": "Achievement Notifications",
        "subtitle": "Get notified when you earn badges",
        "icon": "emoji_events",
        "iconColor": theme.colorScheme.tertiary,
        "hasSwitch": true,
        "switchValue": prefs["achievements"],
        "hasDisclosure": false,
      },
      {
        "key": "daily_reminders",
        "title": "Daily Reminders",
        "subtitle": "Motivational quotes and step goals",
        "icon": "notifications",
        "iconColor": theme.colorScheme.primary,
        "hasSwitch": true,
        "switchValue": prefs["dailyReminders"],
        "hasDisclosure": false,
      },
      {
        "key": "social_updates",
        "title": "Social Updates",
        "subtitle": "Friend activities and challenges",
        "icon": "people",
        "iconColor": theme.colorScheme.secondary,
        "hasSwitch": true,
        "switchValue": prefs["socialUpdates"],
        "hasDisclosure": false,
      },
      {
        "key": "weekly_reports",
        "title": "Weekly Reports",
        "subtitle": "Progress summaries every Sunday",
        "icon": "assessment",
        "iconColor": theme.colorScheme.primary,
        "hasSwitch": true,
        "switchValue": prefs["weeklyReports"],
        "hasDisclosure": false,
      },
      {
        "key": "notification_schedule",
        "title": "Notification Schedule",
        "subtitle": "Set quiet hours and frequency",
        "icon": "schedule",
        "iconColor": theme.colorScheme.secondary,
        "hasDisclosure": true,
      },
    ];
  }

  List<Map<String, dynamic>> _getPrivacyItems() {
    final theme = Theme.of(context);
    final prefs = userData["preferences"]["privacy"] as Map<String, dynamic>;

    return [
      {
        "key": "profile_visibility",
        "title": "Profile Visibility",
        "subtitle":
            "Currently: ${(prefs["profileVisibility"] as String).toUpperCase()}",
        "icon": "visibility",
        "iconColor": theme.colorScheme.primary,
        "hasDisclosure": true,
      },
      {
        "key": "share_progress",
        "title": "Share Progress",
        "subtitle": "Allow friends to see your activities",
        "icon": "share",
        "iconColor": theme.colorScheme.secondary,
        "hasSwitch": true,
        "switchValue": prefs["shareProgress"],
        "hasDisclosure": false,
      },
      {
        "key": "leaderboard",
        "title": "Show in Leaderboard",
        "subtitle": "Appear in global and friend rankings",
        "icon": "leaderboard",
        "iconColor": theme.colorScheme.tertiary,
        "hasSwitch": true,
        "switchValue": prefs["showInLeaderboard"],
        "hasDisclosure": false,
      },
      {
        "key": "data_export",
        "title": "Export My Data",
        "subtitle": "Download your activity history",
        "icon": "download",
        "iconColor": theme.colorScheme.primary,
        "hasDisclosure": true,
      },
    ];
  }

  List<Map<String, dynamic>> _getAppPreferencesItems() {
    final theme = Theme.of(context);
    final prefs = userData["preferences"]["app"] as Map<String, dynamic>;

    return [
      {
        "key": "dark_mode",
        "title": "Dark Mode",
        "subtitle": "Switch to dark theme",
        "icon": "dark_mode",
        "iconColor": theme.colorScheme.primary,
        "hasSwitch": true,
        "switchValue": prefs["darkMode"],
        "hasDisclosure": false,
      },
      {
        "key": "units",
        "title": "Units",
        "subtitle": "Currently: ${(prefs["units"] as String).toUpperCase()}",
        "icon": "straighten",
        "iconColor": theme.colorScheme.secondary,
        "hasDisclosure": true,
      },
      {
        "key": "language",
        "title": "Language",
        "subtitle": "Currently: ${(prefs["language"] as String).toUpperCase()}",
        "icon": "language",
        "iconColor": theme.colorScheme.tertiary,
        "hasDisclosure": true,
      },
      {
        "key": "haptic_feedback",
        "title": "Haptic Feedback",
        "subtitle": "Vibration for interactions",
        "icon": "vibration",
        "iconColor": theme.colorScheme.primary,
        "hasSwitch": true,
        "switchValue": prefs["hapticFeedback"],
        "hasDisclosure": false,
      },
      {
        "key": "backup_sync",
        "title": "Backup & Sync",
        "subtitle": "Cloud save settings",
        "icon": "cloud_sync",
        "iconColor": theme.colorScheme.secondary,
        "hasDisclosure": true,
      },
    ];
  }

  List<Map<String, dynamic>> _getAccountActionsItems() {
    final theme = Theme.of(context);

    return [
      {
        "key": "help_support",
        "title": "Help & Support",
        "subtitle": "FAQs, contact us, tutorials",
        "icon": "help",
        "iconColor": theme.colorScheme.primary,
        "hasDisclosure": true,
      },
      {
        "key": "about",
        "title": "About WalkScape",
        "subtitle": "Version 1.0.0, terms & privacy",
        "icon": "info",
        "iconColor": theme.colorScheme.secondary,
        "hasDisclosure": true,
      },
      {
        "key": "logout",
        "title": "Logout",
        "subtitle": "Sign out of your account",
        "icon": "logout",
        "iconColor": theme.colorScheme.error,
        "hasDisclosure": true,
      },
      {
        "key": "delete_account",
        "title": "Delete Account",
        "subtitle": "Permanently remove your account",
        "icon": "delete_forever",
        "iconColor": theme.colorScheme.error,
        "hasDisclosure": true,
      },
    ];
  }

  Future<void> _refreshProfile() async {
    setState(() => _isLoading = true);

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    // Update last active timestamp
    setState(() {
      userData["lastActive"] = DateTime.now().toString().split(' ')[0];
      _isLoading = false;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully')),
      );
    }
  }

  void _showAvatarCustomization() {
    HapticFeedback.lightImpact();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AvatarCustomizationModal(
        userData: userData,
        onAvatarUpdate: (updatedData) {
          setState(() => userData = updatedData);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Avatar updated successfully!')),
          );
        },
      ),
    );
  }

  void _handleAccountSettingsTap(String key) {
    HapticFeedback.lightImpact();

    switch (key) {
      case 'email':
        _showEmailChangeDialog();
        break;
      case 'password':
        _showPasswordChangeDialog();
        break;
      case 'health_data':
        _showHealthDataPermissions();
        break;
      case 'subscription':
        _showSubscriptionDetails();
        break;
    }
  }

  void _handleAvatarCustomizationTap(String key) {
    HapticFeedback.lightImpact();

    switch (key) {
      case 'customize_avatar':
        _showAvatarCustomization();
        break;
      case 'trail_themes':
        _showTrailThemes();
        break;
      case 'unlocked_items':
        _showUnlockedItems();
        break;
    }
  }

  void _handleNotificationTap(String key) {
    HapticFeedback.lightImpact();

    final prefs =
        userData["preferences"]["notifications"] as Map<String, dynamic>;

    switch (key) {
      case 'achievements':
      case 'daily_reminders':
      case 'social_updates':
      case 'weekly_reports':
        setState(() {
          prefs[key == 'daily_reminders'
              ? 'dailyReminders'
              : key == 'social_updates'
                  ? 'socialUpdates'
                  : key == 'weekly_reports'
                      ? 'weeklyReports'
                      : key] = !prefs[key == 'daily_reminders'
              ? 'dailyReminders'
              : key == 'social_updates'
                  ? 'socialUpdates'
                  : key == 'weekly_reports'
                      ? 'weeklyReports'
                      : key];
        });
        break;
      case 'notification_schedule':
        _showNotificationSchedule();
        break;
    }
  }

  void _handlePrivacyTap(String key) {
    HapticFeedback.lightImpact();

    final prefs = userData["preferences"]["privacy"] as Map<String, dynamic>;

    switch (key) {
      case 'profile_visibility':
        _showProfileVisibilityOptions();
        break;
      case 'share_progress':
      case 'leaderboard':
        setState(() {
          prefs[
              key == 'share_progress'
                  ? 'shareProgress'
                  : 'showInLeaderboard'] = !prefs[
              key == 'share_progress' ? 'shareProgress' : 'showInLeaderboard'];
        });
        break;
      case 'data_export':
        _exportUserData();
        break;
    }
  }

  void _handleAppPreferencesTap(String key) {
    HapticFeedback.lightImpact();

    final prefs = userData["preferences"]["app"] as Map<String, dynamic>;

    switch (key) {
      case 'dark_mode':
      case 'haptic_feedback':
        setState(() {
          prefs[key == 'dark_mode' ? 'darkMode' : 'hapticFeedback'] =
              !prefs[key == 'dark_mode' ? 'darkMode' : 'hapticFeedback'];
        });
        break;
      case 'units':
        _showUnitsOptions();
        break;
      case 'language':
        _showLanguageOptions();
        break;
      case 'backup_sync':
        _showBackupSyncOptions();
        break;
    }
  }

  void _handleAccountActionsTap(String key) {
    HapticFeedback.lightImpact();

    switch (key) {
      case 'help_support':
        _showHelpSupport();
        break;
      case 'about':
        _showAboutDialog();
        break;
      case 'logout':
        _showLogoutConfirmation();
        break;
      case 'delete_account':
        _showDeleteAccountConfirmation();
        break;
    }
  }

  // Dialog and modal methods
  void _showEmailChangeDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change Email Address'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Current Email',
                enabled: false,
              ),
              controller:
                  TextEditingController(text: userData["email"] as String),
            ),
            const SizedBox(height: 16),
            const TextField(
              decoration: InputDecoration(
                labelText: 'New Email Address',
                hintText: 'Enter new email',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Email change request sent!')),
              );
            },
            child: const Text('Send Verification'),
          ),
        ],
      ),
    );
  }

  void _showPasswordChangeDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change Password'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Current Password',
              ),
            ),
            SizedBox(height: 16),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'New Password',
              ),
            ),
            SizedBox(height: 16),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Confirm New Password',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Password updated successfully!')),
              );
            },
            child: const Text('Update Password'),
          ),
        ],
      ),
    );
  }

  void _showHealthDataPermissions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Health Data Permissions',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            const ListTile(
              leading: Icon(Icons.check_circle, color: Colors.green),
              title: Text('HealthKit (iOS)'),
              subtitle: Text('Step counting enabled'),
            ),
            const ListTile(
              leading: Icon(Icons.check_circle, color: Colors.green),
              title: Text('Google Fit (Android)'),
              subtitle: Text('Activity tracking enabled'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Manage Permissions'),
            ),
          ],
        ),
      ),
    );
  }

  void _showSubscriptionDetails() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Subscription Status',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            const Text('You are currently on the Free Plan'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Upgrade to Premium'),
            ),
          ],
        ),
      ),
    );
  }

  void _showTrailThemes() {
    _showAvatarCustomization();
  }

  void _showUnlockedItems() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Unlocked Items',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            const Text('You have unlocked 12 items so far!'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('View Collection'),
            ),
          ],
        ),
      ),
    );
  }

  void _showNotificationSchedule() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Notification Schedule',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            const ListTile(
              title: Text('Quiet Hours'),
              subtitle: Text('10:00 PM - 7:00 AM'),
              trailing: Icon(Icons.chevron_right),
            ),
            const ListTile(
              title: Text('Reminder Frequency'),
              subtitle: Text('Every 2 hours'),
              trailing: Icon(Icons.chevron_right),
            ),
          ],
        ),
      ),
    );
  }

  void _showProfileVisibilityOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Profile Visibility',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            const ListTile(
              title: Text('Public'),
              subtitle: Text('Anyone can see your profile'),
            ),
            const ListTile(
              title: Text('Friends Only'),
              subtitle: Text('Only friends can see your profile'),
            ),
            const ListTile(
              title: Text('Private'),
              subtitle: Text('Only you can see your profile'),
            ),
          ],
        ),
      ),
    );
  }

  void _exportUserData() {
    // No error or info message
  }

  void _showUnitsOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Units',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            const ListTile(
              title: Text('Imperial'),
              subtitle: Text('Miles, feet, pounds'),
            ),
            const ListTile(
              title: Text('Metric'),
              subtitle: Text('Kilometers, meters, kilograms'),
            ),
          ],
        ),
      ),
    );
  }

  void _showLanguageOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Language',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            const ListTile(
              title: Text('English'),
            ),
            const ListTile(
              title: Text('Spanish'),
            ),
            const ListTile(
              title: Text('French'),
            ),
          ],
        ),
      ),
    );
  }

  void _showBackupSyncOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Backup & Sync',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            const ListTile(
              title: Text('Auto Backup'),
              subtitle: Text('Automatically backup your data'),
              trailing: Icon(Icons.toggle_on),
            ),
            const ListTile(
              title: Text('Sync Frequency'),
              subtitle: Text('Every hour'),
            ),
          ],
        ),
      ),
    );
  }

  void _showHelpSupport() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Help & Support',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            const ListTile(
              leading: Icon(Icons.help_outline),
              title: Text('FAQs'),
              trailing: Icon(Icons.chevron_right),
            ),
            const ListTile(
              leading: Icon(Icons.contact_support),
              title: Text('Contact Support'),
              trailing: Icon(Icons.chevron_right),
            ),
            const ListTile(
              leading: Icon(Icons.video_library),
              title: Text('Video Tutorials'),
              trailing: Icon(Icons.chevron_right),
            ),
          ],
        ),
      ),
    );
  }

  void _showAboutDialog() {
    // No dialog
  }

  void _showLogoutConfirmation() {
    // No dialog
  }

  void _showDeleteAccountConfirmation() {
    // No dialog
  }
}
