import 'package:flutter/material.dart';
import '../presentation/splashscreen/splash_screen.dart';
import '../presentation/achievement/achievement_gallery.dart';
import '../presentation/home_dashboard/home_dashboard.dart';
import '../presentation/user/user_profile.dart';
import '../presentation/user/profile_creation_screen.dart';
import '../presentation/social_leaderboard/social_leaderboard.dart';


const String homeRoute = '/home';
const String profileRoute = '/profile';
const String settingsRoute = '/settings';
const String initial = '/';
const String splash = '/splash-screen';
const String achievementGallery = '/achievement-gallery';
const String homeDashboard = '/home-dashboard';
const String userProfile = '/user-profile';
const String profileCreation = '/profile-creation';
const String socialLeaderboard = '/social-leaderboard';

final Map<String, WidgetBuilder> routes = {
  initial: (context) => const HomeDashboard(),
  splash: (context) => const SplashScreen(),
  achievementGallery: (context) => const AchievementGallery(),
  homeDashboard: (context) => const HomeDashboard(),
  userProfile: (context) => const UserProfile(),
  profileCreation: (context) => const ProfileCreationScreen(),
  socialLeaderboard: (context) => const SocialLeaderboard(),
  // Add more routes as needed
};
