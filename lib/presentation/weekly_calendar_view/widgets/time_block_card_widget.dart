import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class TimeBlockCardWidget extends StatelessWidget {
  final Map<String, dynamic> timeBlock;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final bool isSelected;

  const TimeBlockCardWidget({
    super.key,
    required this.timeBlock,
    required this.onTap,
    required this.onLongPress,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final blockColor = _getBlockColor(timeBlock["category"] as String);

    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 0.5.w, vertical: 0.2.h),
        padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: blockColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(6.0),
          border: Border.all(
            color: isSelected
                ? theme.colorScheme.primary
                : blockColor.withValues(alpha: 0.3),
            width: isSelected ? 2.0 : 1.0,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Container(
                  width: 3.w,
                  height: 3.w,
                  decoration: BoxDecoration(
                    color: blockColor,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: Text(
                    timeBlock["title"] as String,
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            SizedBox(height: 0.5.h),
            Text(
              _formatTimeRange(
                timeBlock["startTime"] as DateTime,
                timeBlock["endTime"] as DateTime,
              ),
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                fontSize: 10.sp,
              ),
            ),
            if (timeBlock["description"] != null &&
                (timeBlock["description"] as String).isNotEmpty) ...[
              SizedBox(height: 0.3.h),
              Text(
                timeBlock["description"] as String,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  fontSize: 9.sp,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _getBlockColor(String category) {
    switch (category.toLowerCase()) {
      case 'work':
        return const Color(0xFF2563EB);
      case 'personal':
        return const Color(0xFF059669);
      case 'meeting':
        return const Color(0xFFD97706);
      case 'break':
        return const Color(0xFF7C3AED);
      case 'exercise':
        return const Color(0xFFDC2626);
      case 'study':
        return const Color(0xFF0891B2);
      default:
        return const Color(0xFF64748B);
    }
  }

  String _formatTimeRange(DateTime start, DateTime end) {
    final startHour = start.hour;
    final startMinute = start.minute;
    final endHour = end.hour;
    final endMinute = end.minute;

    final startPeriod = startHour >= 12 ? 'PM' : 'AM';
    final endPeriod = endHour >= 12 ? 'PM' : 'AM';

    final startHour12 =
        startHour == 0 ? 12 : (startHour > 12 ? startHour - 12 : startHour);
    final endHour12 =
        endHour == 0 ? 12 : (endHour > 12 ? endHour - 12 : endHour);

    final startTime = startMinute == 0
        ? '$startHour12$startPeriod'
        : '$startHour12:${startMinute.toString().padLeft(2, '0')}$startPeriod';

    final endTime = endMinute == 0
        ? '$endHour12$endPeriod'
        : '$endHour12:${endMinute.toString().padLeft(2, '0')}$endPeriod';

    return '$startTime - $endTime';
  }
}
