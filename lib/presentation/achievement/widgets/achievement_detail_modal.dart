import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import '../../../core/app_export.dart';

String getAchievementEmoji(String category) {
  switch (category.toLowerCase()) {
    case 'steps':
      return '👣';
    case 'streaks':
      return '🔥';
    case 'trails':
      return '⛰️';
    case 'social':
      return '🤝';
    case 'events':
      return '🎊';
    default:
      return '🏅';
  }
}

String getMotivationalMessage(String category) {
  switch (category.toLowerCase()) {
    case 'steps':
      return 'Every step brings you closer!';
    case 'streaks':
      return 'Keep your streak alive!';
    case 'trails':
      return 'Adventure is just ahead!';
    case 'social':
      return 'Invite friends for more fun!';
    case 'events':
      return 'Special event, special you!';
    default:
      return 'You are closer than you think!';
  }
}

class AchievementDetailModal extends StatelessWidget {
  final Map<String, dynamic> achievement;

  const AchievementDetailModal({
    super.key,
    required this.achievement,
  });

  Color _getCategoryColor(String category, ThemeData theme) {
    switch (category.toLowerCase()) {
      case 'steps':
        return theme.colorScheme.primary;
      case 'streaks':
        return theme.colorScheme.secondary;
      case 'trails':
        return theme.colorScheme.tertiary;
      case 'social':
        return Colors.purple;
      case 'events':
        return Colors.orange;
      default:
        return theme.colorScheme.primary;
    }
  }

  Color _getRarityColor(String rarity, ThemeData theme) {
    switch (rarity.toLowerCase()) {
      case 'common':
        return Colors.grey;
      case 'rare':
        return Colors.blue;
      case 'epic':
        return Colors.purple;
      case 'legendary':
        return Colors.orange;
      default:
        return theme.colorScheme.primary;
    }
  }

  String _formatFullDate(DateTime date) {
    return '${date.month}/${date.day}/${date.year}';
  }

  void _shareAchievement(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sharing "${achievement['title']}" achievement...'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Widget _buildStatRow(BuildContext context, String label, String value) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.5.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressSection(BuildContext context, double progress) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            'Progress',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: theme.colorScheme.outline.withOpacity(0.2),
            valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
            minHeight: 1.h,
          ),
          SizedBox(height: 1.h),
          Text(
            '${(progress * 100).toInt()}% Complete',
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (achievement['requirement'] != null) ...[
            SizedBox(height: 1.h),
            Text(
              achievement['requirement'] as String,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatisticsSection(BuildContext context) {
    final theme = Theme.of(context);
    final stats = achievement['statistics'] as Map<String, dynamic>? ?? {};
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.secondary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            'Achievement Statistics',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          if (achievement['unlockedDate'] != null)
            _buildStatRow(
              context,
              'Unlocked',
              _formatFullDate(achievement['unlockedDate'] as DateTime),
            ),
          if (stats['stepsWhenEarned'] != null)
            _buildStatRow(
              context,
              'Steps When Earned',
              '${stats['stepsWhenEarned']}',
            ),
          if (stats['daysToComplete'] != null)
            _buildStatRow(
              context,
              'Days to Complete',
              '${stats['daysToComplete']}',
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEarned = achievement['isEarned'] as bool;
    final progress = achievement['progress'] as double? ?? 0.0;
    final emoji = getAchievementEmoji(achievement['category'] as String);
    return Stack(
      children: [
        Container(
          height: 70.h,
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              // Handle bar
              Container(
                margin: EdgeInsets.only(top: 1.h),
                width: 10.w,
                height: 0.5.h,
                decoration: BoxDecoration(
                  color: theme.colorScheme.outline.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(6.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Large Badge Display with emoji
                      Container(
                        width: 30.w,
                        height: 30.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: isEarned
                              ? LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    theme.colorScheme.primary.withOpacity(0.2),
                                    theme.colorScheme.secondary.withOpacity(0.2),
                                  ],
                                )
                              : null,
                          color: !isEarned
                              ? theme.colorScheme.onSurface.withOpacity(0.1)
                              : null,
                        ),
                        child: isEarned
                            ? Stack(
                                alignment: Alignment.center,
                                children: [
                                  CustomImageWidget(
                                    imageUrl: achievement['badgeImage'] as String,
                                    width: 25.w,
                                    height: 25.w,
                                    fit: BoxFit.contain,
                                    semanticLabel: achievement['semanticLabel'] as String,
                                  ),
                                  if ((achievement['justUnlocked'] ?? false))
                                    Positioned(
                                      child: Text('🎉', style: TextStyle(fontSize: 40)),
                                    ),
                                ],
                              )
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CustomIconWidget(
                                    iconName: 'lock_outline',
                                    size: 15.w,
                                    color: theme.colorScheme.onSurface.withOpacity(0.4),
                                  ),
                                  SizedBox(height: 1.h),
                                  Text(
                                    emoji,
                                    style: TextStyle(fontSize: 28),
                                  ),
                                ],
                              ),
                      ),
                      SizedBox(height: 3.h),
                      // Achievement Title with emoji
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(emoji, style: TextStyle(fontSize: 22)),
                          SizedBox(width: 1.w),
                          Flexible(
                            child: Text(
                              achievement['title'] as String,
                              style: theme.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: isEarned
                                    ? theme.colorScheme.onSurface
                                    : theme.colorScheme.onSurface.withOpacity(0.7),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 1.h),
                      // Category and Rarity
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 3.w, vertical: 1.h),
                            decoration: BoxDecoration(
                              color: _getCategoryColor(
                                      achievement['category'] as String, theme)
                                  .withOpacity(0.1),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              achievement['category'] as String,
                              style: theme.textTheme.labelMedium?.copyWith(
                                color: _getCategoryColor(
                                    achievement['category'] as String, theme),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          if (achievement['rarity'] != null) ...[
                            SizedBox(width: 2.w),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 3.w, vertical: 1.h),
                              decoration: BoxDecoration(
                                color: _getRarityColor(
                                        achievement['rarity'] as String, theme)
                                    .withOpacity(0.1),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomIconWidget(
                                    iconName: 'star',
                                    size: 3.w,
                                    color: _getRarityColor(
                                        achievement['rarity'] as String, theme),
                                  ),
                                  SizedBox(width: 1.w),
                                  Text(
                                    (achievement['rarity'] as String).toUpperCase(),
                                    style: theme.textTheme.labelSmall?.copyWith(
                                      color: _getRarityColor(
                                          achievement['rarity'] as String, theme),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                      SizedBox(height: 3.h),
                      // Progress Section
                      _buildProgressSection(context, progress),
                      SizedBox(height: 3.h),
                      // Statistics Section
                      _buildStatisticsSection(context),
                      SizedBox(height: 3.h),
                      // Motivational Message
                      Text(
                        getMotivationalMessage(achievement['category'] as String),
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 3.h),
                      // Action Buttons
                      if (isEarned) ...[
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () {
                                  HapticFeedback.lightImpact();
                                  _shareAchievement(context);
                                },
                                icon: CustomIconWidget(
                                  iconName: 'share',
                                  size: 4.w,
                                  color: theme.colorScheme.primary,
                                ),
                                label: const Text('Share'),
                              ),
                            ),
                            SizedBox(width: 4.w),
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  HapticFeedback.lightImpact();
                                  Navigator.pop(context);
                                },
                                icon: CustomIconWidget(
                                  iconName: 'close',
                                  size: 4.w,
                                  color: theme.colorScheme.onPrimary,
                                ),
                                label: const Text('Close'),
                              ),
                            ),
                          ],
                        ),
                      ] else ...[
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              HapticFeedback.lightImpact();
                              Navigator.pop(context);
                            },
                            child: const Text('Close'),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        // Confetti overlay for newly unlocked achievement
        if (isEarned && (achievement['justUnlocked'] ?? false))
          Positioned.fill(
            child: IgnorePointer(
              child: Center(
                child: Text('🎊', style: TextStyle(fontSize: 60)),
              ),
            ),
          ),
      ],
    );
  }
}
