import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class WeekHeaderWidget extends StatelessWidget {
  final DateTime currentWeek;
  final VoidCallback onPreviousWeek;
  final VoidCallback onNextWeek;
  final VoidCallback onDatePicker;

  const WeekHeaderWidget({
    super.key,
    required this.currentWeek,
    required this.onPreviousWeek,
    required this.onNextWeek,
    required this.onDatePicker,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final startOfWeek = _getStartOfWeek(currentWeek);
    final endOfWeek = _getEndOfWeek(currentWeek);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.outline.withValues(alpha: 0.2),
            width: 1.0,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: onPreviousWeek,
            child: Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(
                  color: theme.colorScheme.outline.withValues(alpha: 0.3),
                ),
              ),
              child: CustomIconWidget(
                iconName: 'chevron_left',
                color: theme.colorScheme.onSurface,
                size: 20,
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: onDatePicker,
              child: Column(
                children: [
                  Text(
                    _formatWeekRange(startOfWeek, endOfWeek),
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    _formatMonthYear(currentWeek),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: onNextWeek,
            child: Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(
                  color: theme.colorScheme.outline.withValues(alpha: 0.3),
                ),
              ),
              child: CustomIconWidget(
                iconName: 'chevron_right',
                color: theme.colorScheme.onSurface,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  DateTime _getStartOfWeek(DateTime date) {
    final daysFromMonday = date.weekday - 1;
    return date.subtract(Duration(days: daysFromMonday));
  }

  DateTime _getEndOfWeek(DateTime date) {
    final daysFromMonday = date.weekday - 1;
    return date.add(Duration(days: 6 - daysFromMonday));
  }

  String _formatWeekRange(DateTime start, DateTime end) {
    final startDay = start.day;
    final endDay = end.day;

    if (start.month == end.month) {
      return '$startDay - $endDay';
    } else {
      final startMonth = _getMonthAbbreviation(start.month);
      final endMonth = _getMonthAbbreviation(end.month);
      return '$startMonth $startDay - $endMonth $endDay';
    }
  }

  String _formatMonthYear(DateTime date) {
    final month = _getMonthName(date.month);
    return '$month ${date.year}';
  }

  String _getMonthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return months[month - 1];
  }

  String _getMonthAbbreviation(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return months[month - 1];
  }
}
