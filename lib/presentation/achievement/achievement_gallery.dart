import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/achievement_card.dart';
import './widgets/achievement_detail_modal.dart';
import './widgets/achievement_filter_chips.dart';
import './widgets/achievement_search_bar.dart';
import './widgets/achievement_stats_header.dart';

class AchievementGallery extends StatefulWidget {
  const AchievementGallery({super.key});

  @override
  State<AchievementGallery> createState() => _AchievementGalleryState();
}

class _AchievementGalleryState extends State<AchievementGallery>
    with TickerProviderStateMixin {
  String _selectedFilter = 'All';
  String _searchQuery = '';
  bool _isSearchVisible = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  // Mock achievement data
  final List<Map<String, dynamic>> _allAchievements = [
    {
      'id': 1,
      'title': 'First Steps',
      'description':
          'Take your first 1,000 steps in WalkScape. Every journey begins with a single step!',
      'category': 'Steps',
      'rarity': 'common',
      'isEarned': true,
      'badgeImage':
          'https://img.rocket.new/generatedImages/rocket_gen_img_11c702718-1762440146559.png',
      'semanticLabel':
          'Golden footprint badge with green background representing first steps achievement',
      'unlockedDate': DateTime.now().subtract(const Duration(days: 15)),
      'points': 50,
      'statistics': {
        'stepsWhenEarned': 1000,
        'daysToComplete': 1,
      },
    },
    {
      'id': 2,
      'title': 'Marathon Walker',
      'description':
          'Walk 26.2 miles in a single day. Push your limits and achieve greatness!',
      'category': 'Steps',
      'rarity': 'legendary',
      'isEarned': true,
      'badgeImage':
          'https://images.unsplash.com/photo-1727866241882-df87cd3aa9f2',
      'semanticLabel':
          'Platinum marathon medal with blue ribbon and running figure silhouette',
      'unlockedDate': DateTime.now().subtract(const Duration(days: 3)),
      'points': 500,
      'statistics': {
        'stepsWhenEarned': 52400,
        'daysToComplete': 45,
      },
    },
    {
      'id': 3,
      'title': 'Week Warrior',
      'description':
          'Maintain a 7-day walking streak. Consistency is the key to success!',
      'category': 'Streaks',
      'rarity': 'rare',
      'isEarned': true,
      'badgeImage':
          'https://img.rocket.new/generatedImages/rocket_gen_img_12c8efd83-1762440142996.png',
      'semanticLabel':
          'Silver shield badge with seven stars representing weekly streak achievement',
      'unlockedDate': DateTime.now().subtract(const Duration(days: 8)),
      'points': 150,
      'statistics': {
        'stepsWhenEarned': 35000,
        'daysToComplete': 7,
      },
    },
    {
      'id': 4,
      'title': 'Mountain Conqueror',
      'description':
          'Complete the challenging Mountain Peak trail. Reach new heights in your fitness journey!',
      'category': 'Trails',
      'rarity': 'epic',
      'isEarned': false,
      'progress': 0.75,
      'requirement': 'Complete 15 more mountain trail segments',
      'points': 300,
    },
    {
      'id': 5,
      'title': 'Social Butterfly',
      'description':
          'Add 10 friends and complete a group challenge together. Fitness is better with friends!',
      'category': 'Social',
      'rarity': 'rare',
      'isEarned': false,
      'progress': 0.4,
      'requirement': 'Add 6 more friends and join a group challenge',
      'points': 200,
    },
    {
      'id': 6,
      'title': 'New Year Champion',
      'description':
          'Participate in the New Year fitness challenge and walk 100,000 steps in January.',
      'category': 'Events',
      'rarity': 'epic',
      'isEarned': true,
      'badgeImage':
          'https://images.unsplash.com/photo-1664208190302-5a112d347b0b',
      'semanticLabel':
          'Gold trophy with fireworks design and calendar showing January',
      'unlockedDate': DateTime.now().subtract(const Duration(days: 45)),
      'points': 400,
      'statistics': {
        'stepsWhenEarned': 100000,
        'daysToComplete': 31,
      },
    },
    {
      'id': 7,
      'title': 'Daily Dedication',
      'description':
          'Walk at least 5,000 steps every day for 30 consecutive days.',
      'category': 'Streaks',
      'rarity': 'epic',
      'isEarned': false,
      'progress': 0.6,
      'requirement': 'Continue streak for 12 more days',
      'points': 350,
    },
    {
      'id': 8,
      'title': 'City Explorer',
      'description':
          'Complete all segments of the City Run trail and discover urban fitness.',
      'category': 'Trails',
      'rarity': 'rare',
      'isEarned': true,
      'badgeImage':
          'https://images.unsplash.com/photo-1667482246354-48d79748ce33',
      'semanticLabel':
          'Bronze badge with city skyline silhouette and running path design',
      'unlockedDate': DateTime.now().subtract(const Duration(days: 22)),
      'points': 250,
      'statistics': {
        'stepsWhenEarned': 45000,
        'daysToComplete': 18,
      },
    },
    {
      'id': 9,
      'title': 'Step Master',
      'description':
          'Reach the milestone of 1 million total steps. You are a true walking champion!',
      'category': 'Steps',
      'rarity': 'legendary',
      'isEarned': false,
      'progress': 0.85,
      'requirement': 'Walk 150,000 more steps to unlock',
      'points': 1000,
    },
    {
      'id': 10,
      'title': 'Team Player',
      'description':
          'Help your team win 3 group challenges. Teamwork makes the dream work!',
      'category': 'Social',
      'rarity': 'epic',
      'isEarned': false,
      'progress': 0.33,
      'requirement': 'Win 2 more team challenges',
      'points': 300,
    },
  ];

  List<Map<String, dynamic>> _filteredAchievements = [];

  @override
  void initState() {
    super.initState();
    _filteredAchievements = _allAchievements;
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _filterAchievements() {
    setState(() {
      _filteredAchievements = _allAchievements.where((achievement) {
        // Filter by category
        bool matchesFilter = _selectedFilter == 'All' ||
            (_selectedFilter == 'Recent' && achievement['isEarned'] == true) ||
            achievement['category']
                .toString()
                .toLowerCase()
                .contains(_selectedFilter.toLowerCase());

        // Filter by search query
        bool matchesSearch = _searchQuery.isEmpty ||
            achievement['title']
                .toString()
                .toLowerCase()
                .contains(_searchQuery.toLowerCase()) ||
            achievement['description']
                .toString()
                .toLowerCase()
                .contains(_searchQuery.toLowerCase()) ||
            achievement['category']
                .toString()
                .toLowerCase()
                .contains(_searchQuery.toLowerCase());

        return matchesFilter && matchesSearch;
      }).toList();

      // Sort achievements: earned first, then by rarity, then by points
      _filteredAchievements.sort((a, b) {
        if (a['isEarned'] != b['isEarned']) {
          return b['isEarned'] ? 1 : -1;
        }

        final rarityOrder = {'common': 1, 'rare': 2, 'epic': 3, 'legendary': 4};
        final aRarity = rarityOrder[a['rarity']] ?? 0;
        final bRarity = rarityOrder[b['rarity']] ?? 0;

        if (aRarity != bRarity) {
          return bRarity.compareTo(aRarity);
        }

        return (b['points'] as int).compareTo(a['points'] as int);
      });
    });
  }

  void _onFilterChanged(String filter) {
    setState(() {
      _selectedFilter = filter;
    });
    _filterAchievements();
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
    _filterAchievements();
  }

  void _toggleSearch() {
    setState(() {
      _isSearchVisible = !_isSearchVisible;
      if (!_isSearchVisible) {
        _searchQuery = '';
        _filterAchievements();
      }
    });
  }

  void _showAchievementDetail(Map<String, dynamic> achievement) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AchievementDetailModal(achievement: achievement),
    );
  }

  void _shareAchievement(Map<String, dynamic> achievement) {
    HapticFeedback.mediumImpact();
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(6.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Share Achievement',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            SizedBox(height: 3.h),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'share',
                size: 6.w,
                color: Theme.of(context).colorScheme.primary,
              ),
              title: const Text('Share to Social Media'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        'Sharing "${achievement['title']}" achievement...'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'copy',
                size: 6.w,
                color: Theme.of(context).colorScheme.secondary,
              ),
              title: const Text('Copy Achievement Link'),
              onTap: () {
                Navigator.pop(context);
                Clipboard.setData(ClipboardData(
                  text:
                      'Check out my "${achievement['title']}" achievement in WalkScape!',
                ));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Achievement link copied to clipboard!'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _refreshAchievements() async {
    HapticFeedback.lightImpact();
    // Simulate checking for new achievements
    await Future.delayed(const Duration(seconds: 1));

    // Show celebration animation for newly earned achievements
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('🎉 Checking for new achievements...'),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
      ),
    );
  }

  int get _totalAchievements => _allAchievements.length;
  int get _earnedAchievements =>
      _allAchievements.where((a) => a['isEarned'] == true).length;
  int get _totalPoints => _allAchievements
      .where((a) => a['isEarned'] == true)
      .fold(0, (sum, a) => sum + (a['points'] as int));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Achievements',
        variant: CustomAppBarVariant.achievements,
        actions: [
          IconButton(
            onPressed: _toggleSearch,
            icon: CustomIconWidget(
              iconName: _isSearchVisible ? 'close' : 'search',
              size: 6.w,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: RefreshIndicator(
          onRefresh: _refreshAchievements,
          child: CustomScrollView(
            slivers: [
              // Stats Header
              SliverToBoxAdapter(
                child: AchievementStatsHeader(
                  totalAchievements: _totalAchievements,
                  earnedAchievements: _earnedAchievements,
                  totalPoints: _totalPoints,
                ),
              ),

              // Search Bar (if visible)
              if (_isSearchVisible)
                SliverToBoxAdapter(
                  child: AchievementSearchBar(
                    searchQuery: _searchQuery,
                    onSearchChanged: _onSearchChanged,
                    onClearSearch: () {
                      setState(() {
                        _searchQuery = '';
                      });
                      _filterAchievements();
                    },
                  ),
                ),

              // Filter Chips
              SliverToBoxAdapter(
                child: AchievementFilterChips(
                  selectedFilter: _selectedFilter,
                  onFilterChanged: _onFilterChanged,
                ),
              ),

              SliverToBoxAdapter(child: SizedBox(height: 2.h)),

              // Achievement Grid
              _filteredAchievements.isEmpty
                  ? SliverFillRemaining(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomIconWidget(
                              iconName: 'search_off',
                              size: 15.w,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withValues(alpha: 0.3),
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              'No achievements found',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withValues(alpha: 0.6),
                                  ),
                            ),
                            SizedBox(height: 1.h),
                            Text(
                              'Try adjusting your search or filters',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withValues(alpha: 0.5),
                                  ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : SliverPadding(
                      padding: EdgeInsets.symmetric(horizontal: 4.w),
                      sliver: SliverGrid(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.8,
                          crossAxisSpacing: 3.w,
                          mainAxisSpacing: 2.h,
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final achievement = _filteredAchievements[index];
                            return AchievementCard(
                              achievement: achievement,
                              onTap: () => _showAchievementDetail(achievement),
                              onLongPress: achievement['isEarned'] == true
                                  ? () => _shareAchievement(achievement)
                                  : null,
                            );
                          },
                          childCount: _filteredAchievements.length,
                        ),
                      ),
                    ),

              // Bottom padding for navigation bar
              SliverToBoxAdapter(child: SizedBox(height: 10.h)),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomBar(
        currentIndex: 2,
        onTap: (index) {
          if (index != 2) {
            // Navigate to other screens
            final routes = [
              '/home-dashboard',
              '/social-leaderboard',
              '/achievement-gallery',
              '/user-profile'
            ];
            if (index < routes.length) {
              Navigator.pushReplacementNamed(context, routes[index]);
            }
          }
        },
      ),
    );
  }
}

