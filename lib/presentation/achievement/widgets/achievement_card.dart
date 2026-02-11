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
      import 'package:flutter/material.dart';
      import 'package:flutter/services.dart';
      import 'package:sizer/sizer.dart';
      import '../../../core/app_export.dart';
        return 'Every step counts! Keep moving!';
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
      case 'streaks':
      String getMotivationalMessage(String category) {
        switch (category.toLowerCase()) {
          case 'steps':
            return 'Every step counts! Keep moving!';
          case 'streaks':
            return 'Keep your streak alive!';
          case 'trails':
            return 'Adventure awaits on the trail!';
          case 'social':
            return 'Invite friends for more fun!';
          case 'events':
            return 'Special event, special you!';
          default:
            return 'You are closer than you think!';
        }
      }
        return 'Keep your streak alive!';
      case 'trails':
        return 'Adventure awaits on the trail!';
      case 'social':
        return 'Invite friends for more fun!';
      case 'events':
        return 'Special event, special you!';
      default:
        return 'You are closer than you think!';
    }
  }
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AchievementCard extends StatelessWidget {
  final Map<String, dynamic> achievement;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  const AchievementCard({
    super.key,
    required this.achievement,
    required this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEarned = achievement['isEarned'] as bool;
    final progress = achievement['progress'] as double? ?? 0.0;
    final emoji = getAchievementEmoji(achievement['category'] as String);

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      onLongPress: isEarned && onLongPress != null
          ? () {
              HapticFeedback.mediumImpact();
              onLongPress!();
            }
          : null,
      child: Stack(
        children: [
          Card(
            elevation: isEarned ? 4.0 : 1.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(
                color: isEarned
                    ? theme.colorScheme.primary.withValues(alpha: 0.3)
                    : theme.colorScheme.outline.withValues(alpha: 0.2),
                width: isEarned ? 2.0 : 1.0,
              ),
            ),
            child: Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: isEarned
                    ? LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          theme.colorScheme.primary.withValues(alpha: 0.05),
                          theme.colorScheme.secondary.withValues(alpha: 0.05),
                        ],
                      )
                    : null,
          ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
              // Badge Icon/Image
              Expanded(
                flex: 3,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 15.w,
                      height: 15.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isEarned
                            ? theme.colorScheme.primary.withValues(alpha: 0.1)
                            : theme.colorScheme.onSurface
                                .withValues(alpha: 0.1),
                      ),
                      child: isEarned
                          ? CustomImageWidget(
                              imageUrl: achievement['badgeImage'] as String,
                              width: 12.w,
                              height: 12.w,
                              fit: BoxFit.contain,
                              semanticLabel:
                                  achievement['semanticLabel'] as String,
                            )
                          : CustomIconWidget(
                              iconName: 'lock_outline',
                              size: 8.w,
                              color: theme.colorScheme.onSurface
                                  .withValues(alpha: 0.4),
                            ),
                    ),
                    if (!isEarned && progress > 0)
                      Positioned(
                        bottom: 0,
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 600),
                          curve: Curves.easeInOut,
                          width: 16.w * progress,
                          height: 0.7.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2),
                            color: theme.colorScheme.primary.withOpacity(0.7),
                          ),
                        ),
                      ),
                    if (achievement['rarity'] == 'legendary')
                      Positioned(
                        top: 0,
                        right: 0,
                        child: Container(
                          padding: EdgeInsets.all(0.5.w),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.tertiary,
                            shape: BoxShape.circle,
                          ),
                          child: CustomIconWidget(
                            iconName: 'star',
                            size: 3.w,
                            color: theme.colorScheme.onTertiary,
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              SizedBox(height: 1.h),

              // Achievement Title
              Expanded(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      emoji,
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(width: 1.w),
                    Flexible(
                      child: Text(
                        achievement['title'] as String,
                        style: theme.textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: isEarned
                              ? theme.colorScheme.onSurface
                              : theme.colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),

              // Achievement Category
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: _getCategoryColor(
                          achievement['category'] as String, theme)
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  achievement['category'] as String,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: _getCategoryColor(
                        achievement['category'] as String, theme),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              if (isEarned && achievement['unlockedDate'] != null) ...[
                SizedBox(height: 0.5.h),
                Text(
                  'Unlocked ${_formatDate(achievement['unlockedDate'] as DateTime)}',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ] else if (!isEarned) ...[
                SizedBox(height: 0.5.h),
                Text(
                  getMotivationalMessage(achievement['category'] as String),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.primary.withValues(alpha: 0.7),
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
            ),
          ),
          // Confetti celebration overlay for newly earned achievements (example, can be improved with animation package)
          if (isEarned && (achievement['justUnlocked'] ?? false))
            Positioned.fill(
              child: IgnorePointer(
                child: Center(
                  child: Text(
                    '🎉',
                    style: TextStyle(fontSize: 48),
                  ),
                ),
              ),
            ),
        ],
      String _getAchievementEmoji(String category) {
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

      String _getMotivationalMessage(String category) {
        switch (category.toLowerCase()) {
          case 'steps':
            return 'Every step counts! Keep moving!';
          case 'streaks':
            return 'Keep your streak alive!';
          case 'trails':
            return 'Adventure awaits on the trail!';
          case 'social':
            return 'Invite friends for more fun!';
          case 'events':
            return 'Special event, special you!';
          default:
            return 'You are closer than you think!';
        }
      }
    );
  }

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

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date).inDays;

    if (difference == 0) {
      return 'Today';
    } else if (difference == 1) {
      return 'Yesterday';
    } else if (difference < 7) {
      return '${difference}d ago';
    } else if (difference < 30) {
      return '${(difference / 7).floor()}w ago';
    } else {
      return '${date.month}/${date.day}/${date.year}';
    }
  }
}
