import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/app_export.dart';

void main() async {
  
  
  WidgetsFlutterBinding.ensureInitialized();

   /* await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);

FirebaseDatabase database = FirebaseDatabase.instance;*/

  // Check if profile is created
  final prefs = await SharedPreferences.getInstance();
  final profileCreated = prefs.getBool('profile_created') ?? false;
  final initialRoute = profileCreated ? homeDashboard : profileCreation;

  // No error widget logic

  // Device orientation lock
  Future.wait([
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
  ]).then((value) {
    runApp(MyApp(initialRoute: initialRoute));
  });
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, screenType) {
      return MaterialApp(
        title: 'walkscape',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.light,
        // 🚨 CRITICAL: NEVER REMOVE OR MODIFY
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaler: TextScaler.linear(1.0),
            ),
            child: child!,
          );
        },
        // 🚨 END CRITICAL SECTION
        debugShowCheckedModeBanner: false,
        routes: routes,
        initialRoute: initialRoute,
      );
    });
  }
}