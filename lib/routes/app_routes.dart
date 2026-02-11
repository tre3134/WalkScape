import 'package:flutter/material.dart';
import '../presentation/splashscreen/splash_screen.dart';
import '../presentation/achievement/achievement_gallery.dart';
import '../presentation/home_dashboard/home_dashboard.dart';
import '../presentation/user/user_profile.dart';
import '../presentation/user/profile_creation_screen.dart';
import '../presentation/social_leaderboard/social_leaderboard.dart';

class AppRoutes {
  // Home route
  const String homeRoute = '/home';
  // Profile route
  const String profileRoute = '/profile';
  static const String initial = '/';
  static const String splash = '/splash-screen';
  static const String achievementGallery = '/achievement-gallery';
  static const String homeDashboard = '/home-dashboard';
  static const String userProfile = '/user-profile';
  static const String profileCreation = '/profile-creation';
  static const String socialLeaderboard = '/social-leaderboard';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const HomeDashboard(),
    splash: (context) => const SplashScreen(),
    achievementGallery: (context) => const AchievementGallery(),
    homeDashboard: (context) => const HomeDashboard(),
    userProfile: (context) => const UserProfile(),
    profileCreation: (context) => const ProfileCreationScreen(),
    socialLeaderboard: (context) => const SocialLeaderboard(),
    // Settings route
    const String settingsRoute = '/settings';
  };
}
