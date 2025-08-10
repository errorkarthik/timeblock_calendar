import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';
import '../../widgets/custom_icon_widget.dart';
import '../../widgets/custom_tab_bar.dart';
import './widgets/calendar_header_widget.dart';
import './widgets/create_time_block_bottom_sheet.dart';
import './widgets/time_block_widget.dart';
import './widgets/timeline_widget.dart';

class DailyCalendarView extends StatefulWidget {
  const DailyCalendarView({super.key});

  @override
  State<DailyCalendarView> createState() => _DailyCalendarViewState();
}

class _DailyCalendarViewState extends State<DailyCalendarView>
    with TickerProviderStateMixin {
  DateTime _selectedDate = DateTime.now();
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();
  bool _isRefreshing = false;

  // Mock data for time blocks
  final List<Map<String, dynamic>> _timeBlocks = [
    {
      'id': 1,
      'title': 'Morning Standup Meeting',
      'description': 'Daily team sync and planning session',
      'category': 'Meeting',
      'startTime': '09:00',
      'endTime': '09:30',
      'color': 0xFFFF6B6B,
      'date': '2025-08-10',
    },
    {
      'id': 2,
      'title': 'Deep Work - Flutter Development',
      'description': 'Focus time for coding and development tasks',
      'category': 'Work',
      'startTime': '10:00',
      'endTime': '12:00',
      'color': 0xFF2563EB,
      'date': '2025-08-10',
    },
    {
      'id': 3,
      'title': 'Lunch Break',
      'description': 'Time to recharge and have lunch',
      'category': 'Personal',
      'startTime': '12:00',
      'endTime': '13:00',
      'color': 0xFF059669,
      'date': '2025-08-10',
    },
    {
      'id': 4,
      'title': 'Client Presentation',
      'description': 'Present project progress to stakeholders',
      'category': 'Meeting',
      'startTime': '14:00',
      'endTime': '15:30',
      'color': 0xFFFF6B6B,
      'date': '2025-08-10',
    },
    {
      'id': 5,
      'title': 'Gym Workout',
      'description': 'Strength training and cardio session',
      'category': 'Exercise',
      'startTime': '18:00',
      'endTime': '19:30',
      'color': 0xFF4ECDC4,
      'date': '2025-08-10',
    },
    {
      'id': 6,
      'title': 'Study Session - Flutter Advanced',
      'description': 'Learning advanced Flutter concepts and patterns',
      'category': 'Study',
      'startTime': '20:00',
      'endTime': '21:30',
      'color': 0xFFFFE66D,
      'date': '2025-08-10',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _scrollToCurrentTime();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToCurrentTime() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final now = DateTime.now();
      final currentHour = now.hour;

      if (currentHour >= 6 && currentHour <= 23) {
        final scrollPosition = (currentHour - 6) * 8.h;
        _scrollController.animateTo(
          scrollPosition,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  List<Map<String, dynamic>> _getTimeBlocksForDate(DateTime date) {
    final dateString = date.toIso8601String().split('T')[0];
    return _timeBlocks
        .where((block) => (block['date'] as String) == dateString)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final todayBlocks = _getTimeBlocksForDate(_selectedDate);

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: CustomAppBar(
        title: 'TimeBlock Calendar',
        variant: CustomAppBarVariant.withTabs,
      ),
      body: Column(
        children: [
          // Custom Tab Bar outside of AppBar
          CustomTabBar(
            tabs: const ['Daily', 'Weekly'],
            currentIndex: 0,
            onTap: (index) {
              if (index == 1) {
                Navigator.pushNamed(context, '/weekly-calendar-view');
              }
            },
          ),

          // Calendar header with date navigation
          CalendarHeaderWidget(
            selectedDate: _selectedDate,
            onPreviousDay: () {
              setState(() {
                _selectedDate = _selectedDate.subtract(const Duration(days: 1));
              });
            },
            onNextDay: () {
              setState(() {
                _selectedDate = _selectedDate.add(const Duration(days: 1));
              });
            },
            onTodayPressed: () {
              setState(() {
                _selectedDate = DateTime.now();
              });
              _scrollToCurrentTime();
            },
          ),

          // Main timeline content
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refreshCalendarData,
              child: GestureDetector(
                onHorizontalDragEnd: (details) {
                  if (details.primaryVelocity != null) {
                    if (details.primaryVelocity! > 0) {
                      // Swipe right - previous day
                      setState(() {
                        _selectedDate =
                            _selectedDate.subtract(const Duration(days: 1));
                      });
                    } else if (details.primaryVelocity! < 0) {
                      // Swipe left - next day
                      setState(() {
                        _selectedDate =
                            _selectedDate.add(const Duration(days: 1));
                      });
                    }
                  }
                },
                child: SingleChildScrollView(
                  controller: _scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      // Timeline with time blocks
                      TimelineWidget(
                        timeBlocks: todayBlocks,
                        onEmptySlotTap: _showCreateTimeBlockSheet,
                        onTimeBlockTap: _handleTimeBlockTap,
                        onTimeBlockLongPress: _handleTimeBlockLongPress,
                      ),

                      // Time blocks list view (alternative view)
                      if (todayBlocks.isNotEmpty) ...[
                        SizedBox(height: 2.h),
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(horizontal: 4.w),
                          child: Text(
                            'Today\'s Schedule',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        SizedBox(height: 1.h),
                        ...todayBlocks.map((block) => TimeBlockWidget(
                              timeBlock: block,
                              onTap: () => _handleTimeBlockTap(block),
                              onLongPress: () =>
                                  _handleTimeBlockLongPress(block),
                              onEdit: () => _editTimeBlock(block),
                              onDelete: () => _deleteTimeBlock(block),
                              onDuplicate: () => _duplicateTimeBlock(block),
                              onChangeColor: () => _changeTimeBlockColor(block),
                            )),
                      ],

                      // Empty state
                      if (todayBlocks.isEmpty)
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(8.w),
                          child: Column(
                            children: [
                              CustomIconWidget(
                                iconName: 'event_available',
                                color: colorScheme.onSurface.withAlpha(77),
                                size: 64,
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                'No time blocks scheduled',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  color: colorScheme.onSurface.withAlpha(153),
                                ),
                              ),
                              SizedBox(height: 1.h),
                              Text(
                                'Tap on any time slot to create your first time block',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: colorScheme.onSurface.withAlpha(128),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),

                      SizedBox(height: 10.h), // Bottom padding for FAB
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateTimeBlockSheet(null),
        child: CustomIconWidget(
          iconName: 'add',
          color: colorScheme.onPrimary,
          size: 24,
        ),
      ),
      bottomNavigationBar: const CustomBottomBar(
        currentIndex: 0,
        variant: CustomBottomBarVariant.standard,
      ),
    );
  }

  Future<void> _refreshCalendarData() async {
    setState(() {
      _isRefreshing = true;
    });

    // Simulate network call
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _isRefreshing = false;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Calendar data refreshed'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _showCreateTimeBlockSheet(String? initialTime) {
    HapticFeedback.lightImpact();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CreateTimeBlockBottomSheet(
        initialTime: initialTime,
        onCreateBlock: _addTimeBlock,
      ),
    );
  }

  void _addTimeBlock(Map<String, dynamic> timeBlock) {
    setState(() {
      _timeBlocks.add(timeBlock);
    });

    HapticFeedback.mediumImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Time block "${timeBlock['title']}" created'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _timeBlocks
                  .removeWhere((block) => block['id'] == timeBlock['id']);
            });
          },
        ),
      ),
    );
  }

  void _handleTimeBlockTap(Map<String, dynamic> timeBlock) {
    HapticFeedback.lightImpact();
    Navigator.pushNamed(
      context,
      '/edit-time-block',
      arguments: timeBlock,
    );
  }

  void _handleTimeBlockLongPress(Map<String, dynamic> timeBlock) {
    HapticFeedback.mediumImpact();
    // Context menu is handled by TimeBlockWidget
  }

  void _editTimeBlock(Map<String, dynamic> timeBlock) {
    Navigator.pushNamed(
      context,
      '/edit-time-block',
      arguments: timeBlock,
    );
  }

  void _deleteTimeBlock(Map<String, dynamic> timeBlock) {
    setState(() {
      _timeBlocks.removeWhere((block) => block['id'] == timeBlock['id']);
    });

    HapticFeedback.mediumImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Time block "${timeBlock['title']}" deleted'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _timeBlocks.add(timeBlock);
            });
          },
        ),
      ),
    );
  }

  void _duplicateTimeBlock(Map<String, dynamic> timeBlock) {
    final duplicatedBlock = Map<String, dynamic>.from(timeBlock);
    duplicatedBlock['id'] = DateTime.now().millisecondsSinceEpoch;
    duplicatedBlock['title'] = '${timeBlock['title']} (Copy)';

    // Adjust time by 1 hour
    final startTime = timeBlock['startTime'] as String;
    final endTime = timeBlock['endTime'] as String;
    final startHour = int.parse(startTime.split(':')[0]);
    final endHour = int.parse(endTime.split(':')[0]);

    duplicatedBlock['startTime'] =
        '${(startHour + 1).toString().padLeft(2, '0')}:${startTime.split(':')[1]}';
    duplicatedBlock['endTime'] =
        '${(endHour + 1).toString().padLeft(2, '0')}:${endTime.split(':')[1]}';

    setState(() {
      _timeBlocks.add(duplicatedBlock);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Time block duplicated')),
    );
  }

  void _changeTimeBlockColor(Map<String, dynamic> timeBlock) {
    final colors = [
      0xFF2563EB,
      0xFF059669,
      0xFFFF6B6B,
      0xFF4ECDC4,
      0xFFFFE66D,
      0xFF9333EA,
    ];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choose Color'),
        content: Wrap(
          spacing: 3.w,
          runSpacing: 2.h,
          children: colors.map((colorValue) {
            final color = Color(colorValue);
            return GestureDetector(
              onTap: () {
                setState(() {
                  final index = _timeBlocks
                      .indexWhere((block) => block['id'] == timeBlock['id']);
                  if (index != -1) {
                    _timeBlocks[index]['color'] = colorValue;
                  }
                });
                Navigator.pop(context);
              },
              child: Container(
                width: 12.w,
                height: 6.h,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
