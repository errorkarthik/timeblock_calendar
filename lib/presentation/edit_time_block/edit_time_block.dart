import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/action_buttons_widget.dart';
import './widgets/recurring_pattern_widget.dart';
import './widgets/reminder_settings_widget.dart';
import './widgets/time_block_form_widget.dart';

class EditTimeBlock extends StatefulWidget {
  const EditTimeBlock({super.key});

  @override
  State<EditTimeBlock> createState() => _EditTimeBlockState();
}

class _EditTimeBlockState extends State<EditTimeBlock>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = false;
  bool _hasUnsavedChanges = false;

  // Mock data for existing time block
  final Map<String, dynamic> _mockTimeBlockData = {
    "id": 1,
    "title": "Team Meeting",
    "description":
        "Weekly team sync to discuss project progress and upcoming milestones",
    "date": DateTime.now(),
    "startTime": const TimeOfDay(hour: 10, minute: 0),
    "endTime": const TimeOfDay(hour: 11, minute: 30),
    "category": "Work",
    "priority": 2,
    "color": 0xFF2563EB,
    "reminder": {
      "enabled": true,
      "minutes": 15,
      "type": "Notification",
    },
    "recurring": {
      "enabled": true,
      "type": "Weekly",
      "days": ["Monday"],
      "endDate": null,
    },
  };

  late Map<String, dynamic> _currentTimeBlockData;
  late Map<String, dynamic> _currentReminderData;
  late Map<String, dynamic> _currentRecurringData;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _initializeData();
  }

  void _initializeData() {
    _currentTimeBlockData = Map<String, dynamic>.from(_mockTimeBlockData);
    _currentReminderData = Map<String, dynamic>.from(
      (_mockTimeBlockData['reminder'] as Map<String, dynamic>?) ?? {},
    );
    _currentRecurringData = Map<String, dynamic>.from(
      (_mockTimeBlockData['recurring'] as Map<String, dynamic>?) ?? {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: _buildAppBar(),
        body: Column(
          children: [
            _buildTabBar(),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildBasicDetailsTab(),
                  _buildReminderTab(),
                  _buildRecurringTab(),
                ],
              ),
            ),
            ActionButtonsWidget(
              onSave: _saveTimeBlock,
              onDelete: _deleteTimeBlock,
              onCancel: _cancelEditing,
              isLoading: _isLoading,
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text(
        'Edit Time Block',
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
      ),
      leading: IconButton(
        icon: CustomIconWidget(
          iconName: 'arrow_back_ios',
          color: Theme.of(context).colorScheme.onSurface,
          size: 24,
        ),
        onPressed: () => _onWillPop().then((shouldPop) {
          if (shouldPop) Navigator.of(context).pop();
        }),
      ),
      actions: [
        if (_hasUnsavedChanges)
          Container(
            margin: EdgeInsets.only(right: 4.w),
            child: Center(
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
      ],
      elevation: 1,
      backgroundColor: Theme.of(context).colorScheme.surface,
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: Theme.of(context).colorScheme.surface,
      child: TabBar(
        controller: _tabController,
        labelColor: Theme.of(context).colorScheme.primary,
        unselectedLabelColor:
            Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
        indicatorColor: Theme.of(context).colorScheme.primary,
        indicatorWeight: 2,
        tabs: const [
          Tab(
            icon: Icon(Icons.edit),
            text: 'Details',
          ),
          Tab(
            icon: Icon(Icons.notifications),
            text: 'Reminder',
          ),
          Tab(
            icon: Icon(Icons.repeat),
            text: 'Recurring',
          ),
        ],
      ),
    );
  }

  Widget _buildBasicDetailsTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: TimeBlockFormWidget(
        timeBlockData: _currentTimeBlockData,
        onDataChanged: (updatedData) {
          setState(() {
            _currentTimeBlockData.addAll(updatedData);
            _hasUnsavedChanges = true;
          });
        },
      ),
    );
  }

  Widget _buildReminderTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Reminder Settings',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Set up notifications to remind you about this time block',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.7),
                ),
          ),
          SizedBox(height: 3.h),
          ReminderSettingsWidget(
            reminderData: _currentReminderData,
            onReminderChanged: (updatedData) {
              setState(() {
                _currentReminderData.addAll(updatedData);
                _hasUnsavedChanges = true;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRecurringTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recurring Pattern',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Set up a recurring schedule for this time block',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.7),
                ),
          ),
          SizedBox(height: 3.h),
          RecurringPatternWidget(
            recurringData: _currentRecurringData,
            onRecurringChanged: (updatedData) {
              setState(() {
                _currentRecurringData.addAll(updatedData);
                _hasUnsavedChanges = true;
              });
            },
          ),
        ],
      ),
    );
  }

  Future<void> _saveTimeBlock() async {
    if (_currentTimeBlockData['title']?.toString().trim().isEmpty ?? true) {
      _showErrorSnackBar('Please enter a title for the time block');
      return;
    }

    // Validate time logic
    final startTime = _currentTimeBlockData['startTime'] as TimeOfDay;
    final endTime = _currentTimeBlockData['endTime'] as TimeOfDay;

    if (endTime.hour < startTime.hour ||
        (endTime.hour == startTime.hour &&
            endTime.minute <= startTime.minute)) {
      _showErrorSnackBar('End time must be after start time');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // Combine all data
      final finalData = {
        ..._currentTimeBlockData,
        'reminder': _currentReminderData,
        'recurring': _currentRecurringData,
        'lastModified': DateTime.now(),
      };

      HapticFeedback.lightImpact();
      _showSuccessSnackBar('Time block updated successfully');

      setState(() {
        _hasUnsavedChanges = false;
      });

      // Navigate back after a short delay
      await Future.delayed(const Duration(milliseconds: 500));
      if (mounted) {
        Navigator.of(context).pop(finalData);
      }
    } catch (e) {
      _showErrorSnackBar('Failed to update time block. Please try again.');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _deleteTimeBlock() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      HapticFeedback.lightImpact();
      _showSuccessSnackBar('Time block deleted successfully');

      setState(() {
        _hasUnsavedChanges = false;
      });

      // Navigate back after a short delay
      await Future.delayed(const Duration(milliseconds: 500));
      if (mounted) {
        Navigator.of(context).pop({'deleted': true});
      }
    } catch (e) {
      _showErrorSnackBar('Failed to delete time block. Please try again.');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _cancelEditing() {
    if (_hasUnsavedChanges) {
      _showUnsavedChangesDialog();
    } else {
      Navigator.of(context).pop();
    }
  }

  Future<bool> _onWillPop() async {
    if (_hasUnsavedChanges) {
      final shouldPop = await _showUnsavedChangesDialog();
      return shouldPop ?? false;
    }
    return true;
  }

  Future<bool?> _showUnsavedChangesDialog() {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              CustomIconWidget(
                iconName: 'warning',
                color: Theme.of(context).colorScheme.primary,
                size: 24,
              ),
              SizedBox(width: 3.w),
              Text(
                'Unsaved Changes',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
          content: Text(
            'You have unsaved changes. Are you sure you want to leave without saving?',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(
                'Stay',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
              ),
              child: Text(
                'Leave',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            CustomIconWidget(
              iconName: 'check_circle',
              color: Colors.white,
              size: 20,
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            CustomIconWidget(
              iconName: 'error',
              color: Colors.white,
              size: 20,
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
