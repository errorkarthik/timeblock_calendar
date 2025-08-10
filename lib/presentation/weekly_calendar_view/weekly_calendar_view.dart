import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/time_block_preview_modal.dart';
import './widgets/week_days_header_widget.dart';
import './widgets/week_header_widget.dart';
import './widgets/weekly_grid_widget.dart';

class WeeklyCalendarView extends StatefulWidget {
  const WeeklyCalendarView({super.key});

  @override
  State<WeeklyCalendarView> createState() => _WeeklyCalendarViewState();
}

class _WeeklyCalendarViewState extends State<WeeklyCalendarView>
    with TickerProviderStateMixin {
  DateTime _currentWeek = DateTime.now();
  double _zoomLevel = 1.0;
  bool _isMultiSelectMode = false;
  Set<String> _selectedBlocks = {};
  Map<String, dynamic>? _selectedTimeBlock;
  bool _showPreviewModal = false;
  late AnimationController _modalAnimationController;
  late Animation<double> _modalAnimation;

  // Mock data for time blocks
  final List<Map<String, dynamic>> _timeBlocks = [
    {
      "id": "1",
      "title": "Team Standup Meeting",
      "description":
          "Daily sync with development team to discuss progress and blockers",
      "category": "Meeting",
      "location": "Conference Room A",
      "startTime": DateTime(2025, 8, 11, 9, 0),
      "endTime": DateTime(2025, 8, 11, 9, 30),
    },
    {
      "id": "2",
      "title": "Project Development",
      "description": "Working on the new mobile app features and bug fixes",
      "category": "Work",
      "location": "Office Desk",
      "startTime": DateTime(2025, 8, 11, 10, 0),
      "endTime": DateTime(2025, 8, 11, 12, 0),
    },
    {
      "id": "3",
      "title": "Lunch Break",
      "description": "Lunch with colleagues at the nearby restaurant",
      "category": "Break",
      "location": "Restaurant",
      "startTime": DateTime(2025, 8, 11, 12, 0),
      "endTime": DateTime(2025, 8, 11, 13, 0),
    },
    {
      "id": "4",
      "title": "Client Presentation",
      "description":
          "Presenting quarterly results and future roadmap to key clients",
      "category": "Meeting",
      "location": "Boardroom",
      "startTime": DateTime(2025, 8, 11, 14, 0),
      "endTime": DateTime(2025, 8, 11, 15, 30),
    },
    {
      "id": "5",
      "title": "Gym Workout",
      "description": "Cardio and strength training session",
      "category": "Exercise",
      "location": "Fitness Center",
      "startTime": DateTime(2025, 8, 12, 7, 0),
      "endTime": DateTime(2025, 8, 12, 8, 30),
    },
    {
      "id": "6",
      "title": "Code Review",
      "description":
          "Reviewing pull requests and providing feedback to team members",
      "category": "Work",
      "location": "Office",
      "startTime": DateTime(2025, 8, 12, 10, 0),
      "endTime": DateTime(2025, 8, 12, 11, 0),
    },
    {
      "id": "7",
      "title": "Study Session",
      "description":
          "Learning new Flutter widgets and state management patterns",
      "category": "Study",
      "location": "Home Office",
      "startTime": DateTime(2025, 8, 13, 19, 0),
      "endTime": DateTime(2025, 8, 13, 21, 0),
    },
    {
      "id": "8",
      "title": "Family Dinner",
      "description": "Weekly family gathering and catching up",
      "category": "Personal",
      "location": "Home",
      "startTime": DateTime(2025, 8, 14, 18, 0),
      "endTime": DateTime(2025, 8, 14, 20, 0),
    },
    {
      "id": "9",
      "title": "Weekend Planning",
      "description": "Planning activities and tasks for the upcoming weekend",
      "category": "Personal",
      "location": "Home",
      "startTime": DateTime(2025, 8, 15, 9, 0),
      "endTime": DateTime(2025, 8, 15, 10, 0),
    },
    {
      "id": "10",
      "title": "Morning Jog",
      "description": "5km run in the park to start the day fresh",
      "category": "Exercise",
      "location": "Central Park",
      "startTime": DateTime(2025, 8, 16, 6, 30),
      "endTime": DateTime(2025, 8, 16, 7, 30),
    },
  ];

  @override
  void initState() {
    super.initState();
    _modalAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _modalAnimation = CurvedAnimation(
      parent: _modalAnimationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _modalAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Weekly Calendar',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        backgroundColor: theme.colorScheme.surface,
        foregroundColor: theme.colorScheme.onSurface,
        elevation: 1.0,
        actions: [
          if (_isMultiSelectMode) ...[
            IconButton(
              onPressed:
                  _selectedBlocks.isNotEmpty ? _deleteSelectedBlocks : null,
              icon: CustomIconWidget(
                iconName: 'delete',
                color: _selectedBlocks.isNotEmpty
                    ? theme.colorScheme.error
                    : theme.colorScheme.onSurface.withValues(alpha: 0.4),
                size: 24,
              ),
              tooltip: 'Delete Selected',
            ),
            IconButton(
              onPressed: _exitMultiSelectMode,
              icon: CustomIconWidget(
                iconName: 'close',
                color: theme.colorScheme.onSurface,
                size: 24,
              ),
              tooltip: 'Exit Selection',
            ),
          ] else ...[
            PopupMenuButton<String>(
              onSelected: _handleMenuAction,
              icon: CustomIconWidget(
                iconName: 'more_vert',
                color: theme.colorScheme.onSurface,
                size: 24,
              ),
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'today',
                  child: Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'today',
                        color: theme.colorScheme.onSurface,
                        size: 20,
                      ),
                      SizedBox(width: 3.w),
                      Text('Go to Today'),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'daily',
                  child: Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'view_day',
                        color: theme.colorScheme.onSurface,
                        size: 20,
                      ),
                      SizedBox(width: 3.w),
                      Text('Daily View'),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'create',
                  child: Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'add',
                        color: theme.colorScheme.onSurface,
                        size: 20,
                      ),
                      SizedBox(width: 3.w),
                      Text('Create Time Block'),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ],
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: theme.brightness == Brightness.light
              ? Brightness.dark
              : Brightness.light,
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshCalendarData,
        child: Stack(
          children: [
            Column(
              children: [
                WeekHeaderWidget(
                  currentWeek: _currentWeek,
                  onPreviousWeek: _goToPreviousWeek,
                  onNextWeek: _goToNextWeek,
                  onDatePicker: _showDatePicker,
                ),
                WeekDaysHeaderWidget(
                  currentWeek: _currentWeek,
                ),
                Expanded(
                  child: GestureDetector(
                    onScaleUpdate: _handleScaleUpdate,
                    child: WeeklyGridWidget(
                      currentWeek: _currentWeek,
                      timeBlocks: _timeBlocks,
                      onTimeBlockTap: _handleTimeBlockTap,
                      onTimeBlockLongPress: _handleTimeBlockLongPress,
                      onEmptySlotTap: _handleEmptySlotTap,
                      selectedBlocks: _selectedBlocks,
                      zoomLevel: _zoomLevel,
                    ),
                  ),
                ),
              ],
            ),
            if (_showPreviewModal && _selectedTimeBlock != null)
              GestureDetector(
                onTap: _closePreviewModal,
                child: Container(
                  color: Colors.black.withValues(alpha: 0.5),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 1),
                        end: Offset.zero,
                      ).animate(_modalAnimation),
                      child: TimeBlockPreviewModal(
                        timeBlock: _selectedTimeBlock!,
                        onEdit: _editTimeBlock,
                        onDelete: _deleteTimeBlock,
                        onClose: _closePreviewModal,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: _isMultiSelectMode
          ? null
          : FloatingActionButton(
              onPressed: _createTimeBlock,
              tooltip: 'Create Time Block',
              child: CustomIconWidget(
                iconName: 'add',
                color: theme.colorScheme.onPrimary,
                size: 24,
              ),
            ),
    );
  }

  void _goToPreviousWeek() {
    HapticFeedback.lightImpact();
    setState(() {
      _currentWeek = _currentWeek.subtract(const Duration(days: 7));
    });
  }

  void _goToNextWeek() {
    HapticFeedback.lightImpact();
    setState(() {
      _currentWeek = _currentWeek.add(const Duration(days: 7));
    });
  }

  void _showDatePicker() async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: _currentWeek,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (selectedDate != null) {
      HapticFeedback.lightImpact();
      setState(() {
        _currentWeek = selectedDate;
      });
    }
  }

  void _handleScaleUpdate(ScaleUpdateDetails details) {
    if (details.scale != 1.0) {
      setState(() {
        _zoomLevel = (_zoomLevel * details.scale).clamp(0.5, 3.0);
      });
    }
  }

  void _handleTimeBlockTap(Map<String, dynamic> timeBlock) {
    HapticFeedback.lightImpact();

    if (_isMultiSelectMode) {
      _toggleBlockSelection(timeBlock["id"] as String);
    } else {
      _showTimeBlockPreview(timeBlock);
    }
  }

  void _handleTimeBlockLongPress(Map<String, dynamic> timeBlock) {
    HapticFeedback.mediumImpact();

    if (!_isMultiSelectMode) {
      _enterMultiSelectMode();
    }
    _toggleBlockSelection(timeBlock["id"] as String);
  }

  void _handleEmptySlotTap(DateTime date, int hour) {
    HapticFeedback.lightImpact();

    if (_isMultiSelectMode) {
      _exitMultiSelectMode();
    } else {
      Navigator.pushNamed(context, '/create-time-block');
    }
  }

  void _toggleBlockSelection(String blockId) {
    setState(() {
      if (_selectedBlocks.contains(blockId)) {
        _selectedBlocks.remove(blockId);
      } else {
        _selectedBlocks.add(blockId);
      }

      if (_selectedBlocks.isEmpty) {
        _exitMultiSelectMode();
      }
    });
  }

  void _enterMultiSelectMode() {
    setState(() {
      _isMultiSelectMode = true;
    });
  }

  void _exitMultiSelectMode() {
    setState(() {
      _isMultiSelectMode = false;
      _selectedBlocks.clear();
    });
  }

  void _deleteSelectedBlocks() {
    HapticFeedback.mediumImpact();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Time Blocks'),
        content: Text(
            'Are you sure you want to delete ${_selectedBlocks.length} selected time block(s)?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _timeBlocks.removeWhere(
                    (block) => _selectedBlocks.contains(block["id"]));
              });
              _exitMultiSelectMode();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content:
                      Text('${_selectedBlocks.length} time blocks deleted'),
                ),
              );
            },
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showTimeBlockPreview(Map<String, dynamic> timeBlock) {
    setState(() {
      _selectedTimeBlock = timeBlock;
      _showPreviewModal = true;
    });
    _modalAnimationController.forward();
  }

  void _closePreviewModal() {
    _modalAnimationController.reverse().then((_) {
      setState(() {
        _showPreviewModal = false;
        _selectedTimeBlock = null;
      });
    });
  }

  void _editTimeBlock() {
    _closePreviewModal();
    Navigator.pushNamed(context, '/edit-time-block');
  }

  void _deleteTimeBlock() {
    HapticFeedback.mediumImpact();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Time Block'),
        content: Text(
            'Are you sure you want to delete "${_selectedTimeBlock!["title"]}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _timeBlocks.removeWhere(
                    (block) => block["id"] == _selectedTimeBlock!["id"]);
              });
              Navigator.pop(context);
              _closePreviewModal();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Time block deleted'),
                ),
              );
            },
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _createTimeBlock() {
    Navigator.pushNamed(context, '/create-time-block');
  }

  void _handleMenuAction(String action) {
    switch (action) {
      case 'today':
        setState(() {
          _currentWeek = DateTime.now();
        });
        break;
      case 'daily':
        Navigator.pushNamed(context, '/daily-calendar-view');
        break;
      case 'create':
        Navigator.pushNamed(context, '/create-time-block');
        break;
    }
  }

  Future<void> _refreshCalendarData() async {
    HapticFeedback.lightImpact();

    // Simulate network refresh
    await Future.delayed(const Duration(milliseconds: 1500));

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              CustomIconWidget(
                iconName: 'check_circle',
                color: Colors.white,
                size: 20,
              ),
              SizedBox(width: 2.w),
              Text('Calendar updated'),
            ],
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }
}
