import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import './time_block_card_widget.dart';

class WeeklyGridWidget extends StatelessWidget {
  final DateTime currentWeek;
  final List<Map<String, dynamic>> timeBlocks;
  final Function(Map<String, dynamic>) onTimeBlockTap;
  final Function(Map<String, dynamic>) onTimeBlockLongPress;
  final Function(DateTime, int) onEmptySlotTap;
  final Set<String> selectedBlocks;
  final double zoomLevel;

  const WeeklyGridWidget({
    super.key,
    required this.currentWeek,
    required this.timeBlocks,
    required this.onTimeBlockTap,
    required this.onTimeBlockLongPress,
    required this.onEmptySlotTap,
    required this.selectedBlocks,
    this.zoomLevel = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final startOfWeek = _getStartOfWeek(currentWeek);
    final hourHeight = (6.h * zoomLevel).clamp(4.h, 12.h);

    return SingleChildScrollView(
      child: Column(
        children: [
          // Time grid
          SizedBox(
            height: (24 * hourHeight),
            child: Row(
              children: [
                // Time labels column
                Container(
                  width: 15.w,
                  child: Column(
                    children: List.generate(24, (hour) {
                      return Container(
                        height: hourHeight,
                        alignment: Alignment.topCenter,
                        padding: EdgeInsets.only(top: 1.h),
                        child: Text(
                          _formatHour(hour),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface
                                .withValues(alpha: 0.6),
                            fontSize: 10.sp,
                          ),
                        ),
                      );
                    }),
                  ),
                ),
                // Days columns
                Expanded(
                  child: Row(
                    children: List.generate(7, (dayIndex) {
                      final date = startOfWeek.add(Duration(days: dayIndex));
                      final dayBlocks = _getBlocksForDay(date);

                      return Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border(
                              left: BorderSide(
                                color: theme.colorScheme.outline
                                    .withValues(alpha: 0.1),
                                width: 0.5,
                              ),
                            ),
                          ),
                          child: Stack(
                            children: [
                              // Hour grid lines
                              Column(
                                children: List.generate(24, (hour) {
                                  return GestureDetector(
                                    onTap: () => onEmptySlotTap(date, hour),
                                    child: Container(
                                      height: hourHeight,
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                            color: theme.colorScheme.outline
                                                .withValues(alpha: 0.1),
                                            width: 0.5,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                              ),
                              // Time blocks
                              ...dayBlocks.map((block) {
                                final startTime =
                                    block["startTime"] as DateTime;
                                final endTime = block["endTime"] as DateTime;
                                final startHour =
                                    startTime.hour + (startTime.minute / 60.0);
                                final duration =
                                    endTime.difference(startTime).inMinutes /
                                        60.0;

                                return Positioned(
                                  top: startHour * hourHeight,
                                  left: 1.w,
                                  right: 1.w,
                                  height: (duration * hourHeight)
                                      .clamp(3.h, double.infinity),
                                  child: TimeBlockCardWidget(
                                    timeBlock: block,
                                    onTap: () => onTimeBlockTap(block),
                                    onLongPress: () =>
                                        onTimeBlockLongPress(block),
                                    isSelected:
                                        selectedBlocks.contains(block["id"]),
                                  ),
                                );
                              }).toList(),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ],
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

  List<Map<String, dynamic>> _getBlocksForDay(DateTime date) {
    return timeBlocks.where((block) {
      final blockDate = block["startTime"] as DateTime;
      return _isSameDay(blockDate, date);
    }).toList();
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  String _formatHour(int hour) {
    if (hour == 0) return '12 AM';
    if (hour < 12) return '$hour AM';
    if (hour == 12) return '12 PM';
    return '${hour - 12} PM';
  }
}
