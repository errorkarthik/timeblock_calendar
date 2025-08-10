import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class TimelineWidget extends StatelessWidget {
  final List<Map<String, dynamic>> timeBlocks;
  final Function(String) onEmptySlotTap;
  final Function(Map<String, dynamic>) onTimeBlockTap;
  final Function(Map<String, dynamic>) onTimeBlockLongPress;

  const TimelineWidget({
    super.key,
    required this.timeBlocks,
    required this.onEmptySlotTap,
    required this.onTimeBlockTap,
    required this.onTimeBlockLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final now = DateTime.now();
    final currentHour = now.hour;
    final currentMinute = now.minute;

    return Container(
      width: double.infinity,
      child: Column(
        children: List.generate(18, (index) {
          final hour = index + 6; // Start from 6 AM
          final timeString = _formatHour(hour);
          final isCurrentHour = hour == currentHour;
          final currentTimePosition =
              isCurrentHour ? (currentMinute / 60.0) : 0.0;

          return Container(
            height: 8.h,
            child: Stack(
              children: [
                // Hour line and label
                Row(
                  children: [
                    // Time label
                    Container(
                      width: 15.w,
                      padding: EdgeInsets.only(right: 2.w),
                      child: Text(
                        timeString,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: isCurrentHour
                              ? colorScheme.primary
                              : colorScheme.onSurface.withAlpha(153),
                          fontWeight:
                              isCurrentHour ? FontWeight.w600 : FontWeight.w400,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ),

                    // Timeline line
                    Expanded(
                      child: Container(
                        height: 1,
                        color: colorScheme.outline.withAlpha(51),
                      ),
                    ),
                  ],
                ),

                // Current time indicator
                if (isCurrentHour)
                  Positioned(
                    left: 15.w,
                    top: (8.h * currentTimePosition) - 1,
                    right: 0,
                    child: Container(
                      height: 2,
                      decoration: BoxDecoration(
                        color: colorScheme.primary,
                        borderRadius: BorderRadius.circular(1),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: colorScheme.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                          Expanded(
                            child: Container(
                              height: 2,
                              color: colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                // Time blocks for this hour
                ..._buildTimeBlocksForHour(hour, colorScheme, theme),

                // Empty slot tap area
                Positioned(
                  left: 15.w,
                  top: 0,
                  right: 0,
                  bottom: 0,
                  child: GestureDetector(
                    onTap: () => onEmptySlotTap(timeString),
                    child: Container(
                      color: Colors.transparent,
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  List<Widget> _buildTimeBlocksForHour(
      int hour, ColorScheme colorScheme, ThemeData theme) {
    final blocksForHour = timeBlocks.where((block) {
      final startTime = block['startTime'] as String? ?? '09:00';
      final startHour = int.tryParse(startTime.split(':')[0]) ?? 9;
      return startHour == hour;
    }).toList();

    return blocksForHour.map((block) {
      final startTime = block['startTime'] as String? ?? '09:00';
      final endTime = block['endTime'] as String? ?? '10:00';
      final startMinute = int.tryParse(startTime.split(':')[1]) ?? 0;
      final endHour = int.tryParse(endTime.split(':')[0]) ?? hour + 1;
      final endMinute = int.tryParse(endTime.split(':')[1]) ?? 0;

      final startPosition = (startMinute / 60.0) * 8.h;
      final duration = _calculateBlockDuration(startTime, endTime);
      final blockHeight = (duration / 60.0) * 8.h;

      return Positioned(
        left: 17.w,
        top: startPosition,
        right: 2.w,
        child: Container(
          height: blockHeight,
          child: _buildTimeBlockCard(block, theme, colorScheme),
        ),
      );
    }).toList();
  }

  Widget _buildTimeBlockCard(
      Map<String, dynamic> block, ThemeData theme, ColorScheme colorScheme) {
    final String title = block['title'] as String? ?? 'Untitled';
    final String category = block['category'] as String? ?? 'General';
    final Color blockColor = _getCategoryColor(category, colorScheme);

    return GestureDetector(
      onTap: () => onTimeBlockTap(block),
      onLongPress: () => onTimeBlockLongPress(block),
      child: Container(
        padding: EdgeInsets.all(2.w),
        decoration: BoxDecoration(
          color: blockColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: blockColor,
            width: 1.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CustomIconWidget(
                  iconName: _getCategoryIcon(category),
                  color: blockColor,
                  size: 14,
                ),
                SizedBox(width: 1.w),
                Expanded(
                  child: Text(
                    title,
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            if (title.length > 15) ...[
              SizedBox(height: 0.5.h),
              Text(
                category,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: colorScheme.onSurface.withAlpha(179),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatHour(int hour) {
    if (hour == 0) return '12 AM';
    if (hour < 12) return '$hour AM';
    if (hour == 12) return '12 PM';
    return '${hour - 12} PM';
  }

  double _calculateBlockDuration(String startTime, String endTime) {
    try {
      final start = _parseTime(startTime);
      final end = _parseTime(endTime);
      return end.difference(start).inMinutes.toDouble();
    } catch (e) {
      return 60.0; // Default 1 hour
    }
  }

  DateTime _parseTime(String time) {
    final parts = time.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);
    return DateTime(2024, 1, 1, hour, minute);
  }

  Color _getCategoryColor(String category, ColorScheme colorScheme) {
    switch (category.toLowerCase()) {
      case 'work':
        return colorScheme.primary;
      case 'personal':
        return colorScheme.tertiary;
      case 'meeting':
        return const Color(0xFFFF6B6B);
      case 'exercise':
        return const Color(0xFF4ECDC4);
      case 'study':
        return const Color(0xFFFFE66D);
      default:
        return colorScheme.secondary;
    }
  }

  String _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'work':
        return 'work';
      case 'personal':
        return 'person';
      case 'meeting':
        return 'groups';
      case 'exercise':
        return 'fitness_center';
      case 'study':
        return 'school';
      default:
        return 'event';
    }
  }
}
