import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';
import './widgets/empty_state_widget.dart';
import './widgets/leaderboard_list_item.dart';
import './widgets/leaderboard_tab_bar.dart';
import './widgets/team_challenge_card.dart';
import './widgets/user_rank_card.dart';

class SocialLeaderboard extends StatefulWidget {
  const SocialLeaderboard({super.key});

  @override
  State<SocialLeaderboard> createState() => _SocialLeaderboardState();
}

class _SocialLeaderboardState extends State<SocialLeaderboard>
    with TickerProviderStateMixin {
  late TabController _tabController;
  int _currentBottomIndex = 1;

  // Mock data for current user
  late Map<String, dynamic> _currentUser;

  // Mock data for friends leaderboard
  final List<Map<String, dynamic>> _friendsData = [
    {
      "id": "friend_1",
      "username": "Sarah Chen",
      "avatar":
          "https://images.unsplash.com/photo-1668049221607-1f2df20621cc",
      "avatarSemanticLabel":
          "Portrait of a young Asian woman with long black hair wearing a white top, smiling outdoors",
      "steps": 52340,
      "level": 12,
      "rankChange": 2,
      "isOnline": true,
      "title": "Elite Adventurer",
      "xp": 2450,
      "nextLevelXP": 3000,
    },
    {
      "id": "friend_2",
      "username": "Mike Rodriguez",
      "avatar":
          "https://img.rocket.new/generatedImages/rocket_gen_img_1b9a68aeb-1762248921203.png",
      "avatarSemanticLabel":
          "Headshot of a Hispanic man with short dark hair and beard wearing a gray t-shirt",
      "steps": 48920,
      "level": 11,
      "rankChange": -1,
      "isOnline": false,
      "title": "Expert Hiker",
      "xp": 1890,
      "nextLevelXP": 2500,
    },
    {
      "id": "friend_3",
      "username": "Emma Wilson",
      "avatar":
          "https://images.unsplash.com/photo-1643490745292-add829bc6f15",
      "avatarSemanticLabel":
          "Portrait of a young woman with blonde hair wearing a light blue sweater, smiling at the camera",
      "steps": 47150,
      "level": 10,
      "rankChange": 0,
      "isOnline": true,
      "title": "Advanced Walker",
      "xp": 1200,
      "nextLevelXP": 2000,
    },
    {
      "id": "friend_4",
      "username": "David Kim",
      "avatar":
          "https://img.rocket.new/generatedImages/rocket_gen_img_1ebebdcd4-1762274009418.png",
      "avatarSemanticLabel":
          "Professional photo of an Asian man with glasses wearing a dark suit jacket",
      "steps": 45280,
      "level": 9,
      "rankChange": 3,
      "isOnline": false,
    },
    {
      "id": "friend_5",
      "username": "Lisa Thompson",
      "avatar":
          "https://images.unsplash.com/photo-1645143077850-f2b15914f4e0",
      "avatarSemanticLabel":
          "Portrait of a woman with curly brown hair wearing a red top, smiling warmly",
      "steps": 43890,
      "level": 8,
      "rankChange": -2,
      "isOnline": true,
    },
  ];

  // Mock data for global leaderboard
  final List<Map<String, dynamic>> _globalData = [
    {
      "id": "global_1",
      "username": "FitnessKing2024",
      "avatar":
          "https://images.unsplash.com/photo-1587401095394-725003c9bea1",
      "avatarSemanticLabel":
          "Athletic man in workout clothes doing exercise outdoors with city skyline in background",
      "steps": 78450,
      "level": 18,
      "rankChange": 1,
      "isOnline": true,
      "title": "Legendary Walker",
      "xp": 8750,
      "nextLevelXP": 10000,
    },
    {
      "id": "global_2",
      "username": "RunnerGirl",
      "avatar":
          "https://images.unsplash.com/photo-1576921874520-1c3fa53f2674",
      "avatarSemanticLabel":
          "Young woman in athletic wear running on a trail with trees in the background",
      "steps": 76230,
      "level": 17,
      "rankChange": -1,
      "isOnline": false,
      "title": "Master Explorer",
      "xp": 7230,
      "nextLevelXP": 8500,
    },
    {
      "id": "global_3",
      "username": "StepMaster",
      "avatar":
          "https://images.unsplash.com/photo-1680310381169-5ccb4b532517",
      "avatarSemanticLabel":
          "Middle-aged man in fitness attire holding a water bottle after workout",
      "steps": 72890,
      "level": 16,
      "rankChange": 2,
      "isOnline": true,
    },
    {
      "id": "global_4",
      "username": "WalkWarrior",
      "avatar":
          "https://images.unsplash.com/photo-1696453685422-34d5c0ddd4c3",
      "avatarSemanticLabel":
          "Woman in hiking gear standing on a mountain trail with scenic valley view behind her",
      "steps": 68750,
      "level": 15,
      "rankChange": 0,
      "isOnline": true,
    },
    {
      "id": "global_5",
      "username": "ActiveLife",
      "avatar":
          "https://images.unsplash.com/photo-1687699875541-f073e9086676",
      "avatarSemanticLabel":
          "Senior man in casual sportswear walking in a park with green trees around",
      "steps": 65420,
      "level": 14,
      "rankChange": -1,
      "isOnline": false,
    },
  ];

  // Mock data for team challenges
  final List<Map<String, dynamic>> _teamsData = [
    {
      "id": "team_1",
      "name": "Morning Walkers",
      "challengeName": "100K Steps Challenge",
      "currentSteps": 87450,
      "targetSteps": 100000,
      "members": [
        {
          "id": "member_1",
          "avatar":
              "https://images.unsplash.com/photo-1684598273403-ff8b167b8aa9",
          "avatarSemanticLabel":
              "Portrait of a young Asian woman with long black hair wearing a white top",
        },
        {
          "id": "member_2",
          "avatar":
              "https://img.rocket.new/generatedImages/rocket_gen_img_1a05eed4a-1762274040165.png",
          "avatarSemanticLabel":
              "Headshot of a Hispanic man with short dark hair and beard",
        },
        {
          "id": "member_3",
          "avatar":
              "https://images.unsplash.com/photo-1682887101248-bd942bfb98b3",
          "avatarSemanticLabel":
              "Portrait of a young woman with blonde hair wearing a light blue sweater",
        },
      ],
    },
    {
      "id": "team_2",
      "name": "Fitness Fanatics",
      "challengeName": "Weekly Distance Goal",
      "currentSteps": 156780,
      "targetSteps": 150000,
      "members": [
        {
          "id": "member_4",
          "avatar":
              "https://img.rocket.new/generatedImages/rocket_gen_img_1ebebdcd4-1762274009418.png",
          "avatarSemanticLabel":
              "Professional photo of an Asian man with glasses wearing a dark suit jacket",
        },
        {
          "id": "member_5",
          "avatar":
              "https://images.unsplash.com/photo-1708789353435-9c9f05f5b01b",
          "avatarSemanticLabel":
              "Portrait of a woman with curly brown hair wearing a red top",
        },
        {
          "id": "member_6",
          "avatar":
              "https://images.unsplash.com/photo-1648569732638-a73c16796edd",
          "avatarSemanticLabel":
              "Athletic man in workout clothes doing exercise outdoors",
        },
      ],
    },
    {
      "id": "team_3",
      "name": "Step Squad",
      "challengeName": "Monthly Marathon",
      "currentSteps": 234560,
      "targetSteps": 300000,
      "members": [
        {
          "id": "member_7",
          "avatar":
              "https://images.unsplash.com/photo-1724686341534-6eb1bfa1fc6a",
          "avatarSemanticLabel":
              "Young woman in athletic wear running on a trail",
        },
        {
          "id": "member_8",
          "avatar":
              "https://images.unsplash.com/photo-1680310381169-5ccb4b532517",
          "avatarSemanticLabel":
              "Middle-aged man in fitness attire holding a water bottle",
        },
      ],
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadUserData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('user_username') ?? 'Adventurer';
    final avatar = prefs.getString('user_avatar') ?? 'https://images.unsplash.com/photo-1705408115513-3ff15ef55a8d';
    final level = prefs.getInt('user_level') ?? 1;
    final totalSteps = prefs.getInt('user_total_steps') ?? 0;

    setState(() {
      _currentUser = {
        "id": "current_user",
        "username": username,
        "avatar": avatar,
        "avatarSemanticLabel": "User avatar",
        "rank": _calculateRank(totalSteps),
        "level": level,
        "weeklySteps": totalSteps, // For now, using total as weekly
        "rankChange": 0, // Could be calculated based on previous rankings
        "title": _getRankTitle(_calculateRank(totalSteps)),
        "xp": prefs.getInt('user_xp') ?? 0,
        "nextLevelXP": level * 1000, // Simple XP system
      };
    });
  }

  int _calculateRank(int totalSteps) {
    // Simple ranking system based on total steps
    if (totalSteps >= 1000000) return 1;
    if (totalSteps >= 500000) return 2;
    if (totalSteps >= 250000) return 3;
    if (totalSteps >= 100000) return 4;
    if (totalSteps >= 50000) return 5;
    if (totalSteps >= 25000) return 6;
    if (totalSteps >= 10000) return 7;
    if (totalSteps >= 5000) return 8;
    if (totalSteps >= 1000) return 9;
    return 10;
  }

  String _getRankTitle(int rank) {
    const titles = [
      'Legendary Walker',
      'Master Explorer',
      'Elite Adventurer',
      'Expert Hiker',
      'Advanced Walker',
      'Skilled Trekker',
      'Apprentice Explorer',
      'Novice Adventurer',
      'Beginner Walker',
      'Rookie',
    ];
    return (rank - 1 < titles.length) ? titles[rank - 1] : 'Rookie';
  }

  Future<void> _refreshData() async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Leaderboard updated!'),
          backgroundColor: AppTheme.lightTheme.colorScheme.primary,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }
  }

  void _showUserProfile(Map<String, dynamic> user) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 70.h,
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              width: 10.w,
              height: 0.5.h,
              margin: EdgeInsets.symmetric(vertical: 2.h),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(4.w),
                child: Column(
                  children: [
                    Container(
                      width: 25.w,
                      height: 25.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppTheme.lightTheme.colorScheme.primary,
                          width: 3,
                        ),
                      ),
                      child: ClipOval(
                        child: CustomImageWidget(
                          imageUrl: user["avatar"] as String,
                          width: 25.w,
                          height: 25.w,
                          fit: BoxFit.cover,
                          semanticLabel: user["avatarSemanticLabel"] as String,
                        ),
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      user["username"] as String,
                      style: GoogleFonts.poppins(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.lightTheme.colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      "Level ${user["level"]} • ${user["steps"]} steps",
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.pop(context);
                              _sendMessage(user);
                            },
                            icon: CustomIconWidget(
                              iconName: 'message',
                              color: AppTheme.lightTheme.colorScheme.onPrimary,
                              size: 18,
                            ),
                            label: const Text('Message'),
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              Navigator.pop(context);
                              _sendChallenge(user);
                            },
                            icon: CustomIconWidget(
                              iconName: 'sports_martial_arts',
                              color: AppTheme.lightTheme.colorScheme.primary,
                              size: 18,
                            ),
                            label: const Text('Challenge'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _sendMessage(Map<String, dynamic> user) {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening chat with ${user["username"]}...'),
        backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
      ),
    );
  }

  void _sendChallenge(Map<String, dynamic> user) {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Challenge sent to ${user["username"]}!'),
        backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
      ),
    );
  }

  void _addFriends() {
    HapticFeedback.lightImpact();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 60.h,
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              width: 10.w,
              height: 0.5.h,
              margin: EdgeInsets.symmetric(vertical: 2.h),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(4.w),
              child: Column(
                children: [
                  Text(
                    'Add Friends',
                    style: GoogleFonts.poppins(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Search by username or email',
                      prefixIcon: CustomIconWidget(
                        iconName: 'search',
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        size: 20,
                      ),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Opening contacts...')),
                            );
                          },
                          icon: CustomIconWidget(
                            iconName: 'contacts',
                            color: AppTheme.lightTheme.colorScheme.primary,
                            size: 18,
                          ),
                          label: const Text('From Contacts'),
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Sharing invite link...')),
                            );
                          },
                          icon: CustomIconWidget(
                            iconName: 'share',
                            color: AppTheme.lightTheme.colorScheme.primary,
                            size: 18,
                          ),
                          label: const Text('Invite'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _viewTeamDetails(Map<String, dynamic> team) {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening ${team["name"]} details...'),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      ),
    );
  }

  Widget _buildTabContent(int index) {
    switch (index) {
      case 0: // Friends
        return _friendsData.isEmpty
            ? EmptyStateWidget(
                title: "No Friends Yet",
                subtitle:
                    "Add friends to see their progress and compete together!",
                iconName: "person_add",
                buttonText: "Add Friends",
                onButtonPressed: _addFriends,
              )
            : ListView.builder(
                padding: EdgeInsets.only(bottom: 2.h),
                itemCount: _friendsData.length,
                itemBuilder: (context, index) {
                  final user = _friendsData[index];
                  return LeaderboardListItem(
                    user: user,
                    index: index,
                    isFriendsTab: true,
                    onMessage: () => _sendMessage(user),
                    onChallenge: () => _sendChallenge(user),
                    onViewProfile: () => _showUserProfile(user),
                    onTap: () => _showUserProfile(user),
                  );
                },
              );

      case 1: // Global
        return ListView.builder(
          padding: EdgeInsets.only(bottom: 2.h),
          itemCount: _globalData.length,
          itemBuilder: (context, index) {
            final user = _globalData[index];
            return LeaderboardListItem(
              user: user,
              index: index,
              onTap: () => _showUserProfile(user),
            );
          },
        );

      case 2: // Teams
        return _teamsData.isEmpty
            ? EmptyStateWidget(
                title: "No Team Challenges",
                subtitle:
                    "Join or create team challenges to compete with groups!",
                iconName: "groups",
                buttonText: "Find Teams",
                onButtonPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Opening team browser...')),
                  );
                },
              )
            : ListView.builder(
                padding: EdgeInsets.only(bottom: 2.h),
                itemCount: _teamsData.length,
                itemBuilder: (context, index) {
                  final team = _teamsData[index];
                  return TeamChallengeCard(
                    team: team,
                    onTap: () => _viewTeamDetails(team),
                  );
                },
              );

      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Leaderboard',
        variant: CustomAppBarVariant.social,
      ),
      body: Column(
        children: [
          // User's current rank card
          UserRankCard(userData: _currentUser),

          // Tab bar
          LeaderboardTabBar(
            tabController: _tabController,
            tabs: const ['Friends', 'Global', 'Teams'],
          ),

          // Tab content
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refreshData,
              color: AppTheme.lightTheme.colorScheme.primary,
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildTabContent(0), // Friends
                  _buildTabContent(1), // Global
                  _buildTabContent(2), // Teams
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: AnimatedBuilder(
        animation: _tabController,
        builder: (context, child) {
          return _tabController.index == 0
              ? FloatingActionButton(
                  onPressed: _addFriends,
                  child: CustomIconWidget(
                    iconName: 'person_add',
                    color: AppTheme.lightTheme.colorScheme.onTertiary,
                    size: 24,
                  ),
                )
              : const SizedBox.shrink();
        },
      ),
      bottomNavigationBar: CustomBottomBar(
        currentIndex: _currentBottomIndex,
        onTap: (index) {
          setState(() {
            _currentBottomIndex = index;
          });
        },
      ),
    );
  }
}
