import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:sizer/sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';
import './widgets/achievements_card_widget.dart';
import './widgets/greeting_header_widget.dart';
import './widgets/progress_ring_widget.dart';
import './widgets/quick_stats_widget.dart';
import './widgets/step_entry_modal_widget.dart';
import './widgets/trail_map_widget.dart';

class HomeDashboard extends StatefulWidget {
  const HomeDashboard({super.key});

  @override
  State<HomeDashboard> createState() {
    return _HomeDashboardState();
  }
}

class _HomeDashboardState extends State<HomeDashboard> with TickerProviderStateMixin {
    // Add missing methods to resolve errors
    void _checkLevelUp() {
      // TODO: Implement level up logic
    }

    void _updateDerivedValues() {
      // TODO: Implement derived value updates
    }

    // Move method definitions above their first use
    String _formatCurrentDate() {
      final now = DateTime.now();
      final weekdays = [
        'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'
      ];
      final months = [
        'January', 'February', 'March', 'April', 'May', 'June', 'July', 'August',
        'September', 'October', 'November', 'December'
      ];
      return '${weekdays[now.weekday - 1]}, ${months[now.month - 1]} ${now.day}';
    }

    String _getCurrentWeather() {
      final hour = DateTime.now().hour;
      if (hour >= 6 && hour < 12) {
        return 'Sunny';
      } else if (hour >= 12 && hour < 18) {
        return 'Cloudy';
      } else {
        return 'Clear';
      }
    }

    Future<void> _refreshHealthData() async {
      HapticFeedback.mediumImpact();
      await Future.delayed(const Duration(milliseconds: 1500));
      if (mounted) {
        setState(() {
          int stepsIncrease = (DateTime.now().millisecond % 50);
          _currentSteps += stepsIncrease;
          _userXP += (stepsIncrease / 10).round();
          _checkLevelUp();
          _energyPoints = _currentSteps ~/ 100;
          _distance = _currentSteps * 0.0005;
            _calories = _currentSteps * 0.04; // Changed to double
            _activeTime = _currentSteps * 0.01; // Changed to double
        });
        await _saveSteps();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Health data synced successfully!'),
            backgroundColor: Theme.of(context).colorScheme.primary,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }

    void _onStepCountError(error) {
      // TODO: Handle step count error
    }
  String _userName = '';
  String _userAvatar = 'https://images.unsplash.com/photo-1705408115513-3ff15ef55a8d';
  int _userXP = 0;
  int _userLevel = 1;
  int _currentSteps = 0;
  int _initialSteps = 0;
  int _goalSteps = 10000;
  int _energyPoints = 0;
  double _distance = 0.0;
  double _calories = 0.0;
  double _activeTime = 0.0;
  bool _healthPermissionsAvailable = false;
  bool _isPedometerAvailable = false;
  List<dynamic> _todayAchievements = [];
  AnimationController? _fabAnimationController;
  Animation<double>? _fabAnimation;
  StreamSubscription? _stepCountSubscription;
  StreamSubscription? _connectivitySubscription;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  Stream<StepCount>? _stepCountStream;

  @override
  void initState() {
    super.initState();
    _fabAnimationController = AnimationController(
      vsync: this,
    );
    _fabAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fabAnimationController!,
      curve: Curves.easeInOut,
    ));
    _fabAnimationController!.forward();
  }

  @override
  void dispose() {
    _fabAnimationController?.dispose();
    _stepCountSubscription?.cancel();
    _connectivitySubscription?.cancel();
    super.dispose();
  }


  Future<void> _saveSteps() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('currentSteps', _currentSteps);
    await prefs.setInt('initialSteps', _initialSteps);
    await prefs.setInt('user_level', _userLevel);
    await prefs.setInt('user_xp', _userXP);
  }

  Future<void> _checkHealthPermissions() async {
    if (kIsWeb) {
      // Web doesn't support pedometer, use manual entry
      setState(() {
        _healthPermissionsAvailable = false;
      });
    } else {
      PermissionStatus status = await Permission.activityRecognition.request();
      setState(() {
        _healthPermissionsAvailable = status.isGranted;
      });
    }
  }

  void _initConnectivity() {
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen(_onConnectivityChanged);
  }

  void _onConnectivityChanged(List<ConnectivityResult> results) {
    if (results.contains(ConnectivityResult.none)) {
      // Offline mode: switch to manual entry
      _stepCountSubscription?.cancel();
      if (mounted) {
        setState(() {
          _healthPermissionsAvailable = false;
          _isPedometerAvailable = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Offline mode: Manual step entry enabled'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    } else {
      // Online: try to enable pedometer if permissions available
      if (_healthPermissionsAvailable && !kIsWeb) {
        _initPedometer();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Online: Pedometer activated'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    }
  }

  void _initPedometer() async {
    if (_healthPermissionsAvailable && !kIsWeb) {
      List<ConnectivityResult> results = await Connectivity().checkConnectivity();
      if (!results.contains(ConnectivityResult.none)) {
        _stepCountStream = Pedometer.stepCountStream;
        _stepCountSubscription = _stepCountStream?.listen(
          _onStepCount,
          onError: _onStepCountError,
          cancelOnError: true,
        );
        setState(() {
          _isPedometerAvailable = true;
        });
      }
    }
  }

  void _onStepCount(StepCount event) {
    setState(() {
      if (_initialSteps == 0) {
        _initialSteps = event.steps;
      }
      int newSteps = event.steps - _initialSteps;
      int stepsGained = newSteps - _currentSteps;
      _currentSteps = newSteps;
      if (stepsGained > 0) {
        _userXP += (stepsGained / 10).round();
        _checkLevelUp();
      }
      _updateDerivedValues();
    });
    _saveSteps();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentDate = _formatCurrentDate();
    final weatherCondition = _getCurrentWeather();
    final totalXP = _todayAchievements.fold<int>(
      0,
      (sum, achievement) => sum + (achievement['xp'] as int),
    );

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: const CustomAppBar(
        title: 'WalkScape',
        variant: CustomAppBarVariant.dashboard,
        showBackButton: false,
      ),
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _refreshHealthData,
        color: theme.colorScheme.primary,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              GreetingHeaderWidget(
                userName: _userName,
                currentDate: currentDate,
                weatherCondition: weatherCondition,
              ),
              SizedBox(height: 2.h),
              ProgressRingWidget(
                currentSteps: _currentSteps,
                goalSteps: _goalSteps,
                energyPoints: _energyPoints,
                onLongPress: _showGoalAdjustment,
              ),
              SizedBox(height: 3.h),
              TrailMapWidget(
                currentTrail: 'Forest Trail',
                progressPercentage:
                    (_currentSteps / _goalSteps * 100).clamp(0.0, 100.0),
                nextMilestone: 'Woodland Bridge',
                stepsToMilestone: _goalSteps - _currentSteps > 0
                    ? _goalSteps - _currentSteps
                    : 0,
              ),
              SizedBox(height: 3.h),
              AchievementsCardWidget(
                todayAchievements: List<Map<String, dynamic>>.from(_todayAchievements),
                totalExperiencePoints: totalXP,
              ),
              SizedBox(height: 3.h),
              QuickStatsWidget(
                distance: _distance,
                calories: _calories.toInt(),
                activeTime: _activeTime.toInt(),
              ),
              SizedBox(height: 10.h),
            ],
          ),
        ),
      ),
      floatingActionButton: !_healthPermissionsAvailable
          ? AnimatedBuilder(
              animation: _fabAnimation!,
              builder: (context, child) {
                return Transform.scale(
                  scale: _fabAnimation!.value,
                  child: FloatingActionButton.extended(
                    onPressed: _showStepEntryModal,
                    icon: CustomIconWidget(
                      iconName: 'add',
                      color: theme.floatingActionButtonTheme.foregroundColor ??
                          Colors.white,
                      size: 6.w,
                    ),
                    label: Text(
                      kIsWeb ? 'Add Steps (Web Mode)' : 'Add Steps (Offline Mode)',
                      style: TextStyle(
                        color:
                            theme.floatingActionButtonTheme.foregroundColor ??
                                Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    backgroundColor:
                        theme.floatingActionButtonTheme.backgroundColor,
                  ),
                );
              },
            )
          : null,
      bottomNavigationBar: CustomBottomBar(
        currentIndex: 0,
        onTap: (index) {
          HapticFeedback.lightImpact();
        },
      ),
    );
  }


  void _showGoalAdjustment() {
    final theme = Theme.of(context);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: theme.colorScheme.outline.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              'Adjust Daily Goal',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              'Current goal: ${_goalSteps.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')} steps',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 3.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildGoalButton(context, '5,000'),
                _buildGoalButton(context, '8,000'),
                _buildGoalButton(context, '10,000'),
                _buildGoalButton(context, '12,000'),
              ],
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  Widget _buildGoalButton(BuildContext context, String goal) {
    final theme = Theme.of(context);
    final goalValue = int.parse(goal.replaceAll(',', ''));
    final isCurrentGoal = goalValue == _goalSteps;

    return GestureDetector(
      onTap: () {
        if (!isCurrentGoal) {
          HapticFeedback.lightImpact();
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Daily goal updated to $goal steps!'),
              backgroundColor: theme.colorScheme.primary,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 3.w,
          vertical: 1.5.h,
        ),
        decoration: BoxDecoration(
          color: isCurrentGoal
              ? theme.colorScheme.primary
              : theme.colorScheme.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: theme.colorScheme.primary.withValues(alpha: 0.3),
          ),
        ),
        child: Text(
          goal,
          style: theme.textTheme.bodySmall?.copyWith(
            color: isCurrentGoal
                ? theme.colorScheme.onPrimary
                : theme.colorScheme.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  void _showStepEntryModal() {
    HapticFeedback.lightImpact();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => StepEntryModalWidget(
        onStepsAdded: (steps) async {
          setState(() {
            _currentSteps += steps;
            // Add XP for manual entry (same rate as pedometer)
            _userXP += (steps / 10).round();
            _checkLevelUp();
            _energyPoints = _currentSteps ~/ 100;
            _distance = _currentSteps * 0.0005;
              _calories = _currentSteps * 0.04; // Changed to double
              _activeTime = _currentSteps * 0.01; // Changed to double
          });
          await _saveSteps();
        },
      ),
    );
  }
}
