import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class TimeBlockPreviewModal extends StatelessWidget {
  final Map<String, dynamic> timeBlock;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onClose;

  const TimeBlockPreviewModal({
    super.key,
    required this.timeBlock,
    required this.onEdit,
    required this.onDelete,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final blockColor = _getBlockColor(timeBlock["category"] as String);

    return Container(
      padding: EdgeInsets.all(6.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 10.0,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle bar
          Center(
            child: Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: theme.colorScheme.outline.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2.0),
              ),
            ),
          ),
          SizedBox(height: 3.h),

          // Header with category and close button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 4.w,
                    height: 4.w,
                    decoration: BoxDecoration(
                      color: blockColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Text(
                    timeBlock["category"] as String,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: blockColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: onClose,
                child: Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: theme.colorScheme.outline.withValues(alpha: 0.2),
                    ),
                  ),
                  child: CustomIconWidget(
                    iconName: 'close',
                    color: theme.colorScheme.onSurface,
                    size: 18,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),

          // Title
          Text(
            timeBlock["title"] as String,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 2.h),

          // Time
          Row(
            children: [
              CustomIconWidget(
                iconName: 'access_time',
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                size: 20,
              ),
              SizedBox(width: 3.w),
              Text(
                _formatTimeRange(
                  timeBlock["startTime"] as DateTime,
                  timeBlock["endTime"] as DateTime,
                ),
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),

          // Description (if available)
          if (timeBlock["description"] != null &&
              (timeBlock["description"] as String).isNotEmpty) ...[
            SizedBox(height: 2.h),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomIconWidget(
                  iconName: 'description',
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  size: 20,
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Text(
                    timeBlock["description"] as String,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                    ),
                  ),
                ),
              ],
            ),
          ],

          // Location (if available)
          if (timeBlock["location"] != null &&
              (timeBlock["location"] as String).isNotEmpty) ...[
            SizedBox(height: 2.h),
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'location_on',
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  size: 20,
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Text(
                    timeBlock["location"] as String,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                    ),
                  ),
                ),
              ],
            ),
          ],

          SizedBox(height: 4.h),

          // Action buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onEdit,
                  icon: CustomIconWidget(
                    iconName: 'edit',
                    color: theme.colorScheme.primary,
                    size: 18,
                  ),
                  label: Text('Edit'),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 3.h),
                    side: BorderSide(color: theme.colorScheme.primary),
                  ),
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onDelete,
                  icon: CustomIconWidget(
                    iconName: 'delete',
                    color: theme.colorScheme.error,
                    size: 18,
                  ),
                  label: Text('Delete'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: theme.colorScheme.error,
                    padding: EdgeInsets.symmetric(vertical: 3.h),
                    side: BorderSide(color: theme.colorScheme.error),
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 2.h),
        ],
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
        ? '$startHour12:00 $startPeriod'
        : '$startHour12:${startMinute.toString().padLeft(2, '0')} $startPeriod';

    final endTime = endMinute == 0
        ? '$endHour12:00 $endPeriod'
        : '$endHour12:${endMinute.toString().padLeft(2, '0')} $endPeriod';

    final duration = end.difference(start);
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;

    String durationText = '';
    if (hours > 0) {
      durationText = '${hours}h';
      if (minutes > 0) durationText += ' ${minutes}m';
    } else {
      durationText = '${minutes}m';
    }

    return '$startTime - $endTime ($durationText)';
  }
}
