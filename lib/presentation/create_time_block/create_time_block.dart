import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/category_selection_widget.dart';
import './widgets/description_input_widget.dart';
import './widgets/duration_selector_widget.dart';
import './widgets/priority_toggle_widget.dart';
import './widgets/recurring_options_widget.dart';
import './widgets/task_title_input_widget.dart';
import './widgets/time_selection_widget.dart';

class CreateTimeBlock extends StatefulWidget {
  const CreateTimeBlock({super.key});

  @override
  State<CreateTimeBlock> createState() => _CreateTimeBlockState();
}

class _CreateTimeBlockState extends State<CreateTimeBlock>
    with TickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Form state
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _startTime = TimeOfDay.now();
  TimeOfDay _endTime = TimeOfDay.now().replacing(
    hour: (TimeOfDay.now().hour + 1) % 24,
  );
  int _selectedDuration = 60;
  String _selectedCategory = 'Work';
  String _selectedPriority = 'Medium';
  String _selectedRecurrence = 'None';
  DateTime? _endDate;
  bool _isFormValid = false;
  bool _isSaving = false;

  // Mock data for recent tasks
  final List<String> _recentTasks = [
    'Team Meeting',
    'Project Review',
    'Client Call',
    'Code Review',
    'Design Session',
    'Planning Meeting',
    'Workout',
    'Lunch Break',
  ];

  // Mock data for templates
  final List<Map<String, dynamic>> _templates = [
    {
      'name': 'Daily Standup',
      'duration': 30,
      'category': 'Work',
      'priority': 'High',
    },
    {
      'name': 'Workout Session',
      'duration': 60,
      'category': 'Exercise',
      'priority': 'Medium',
    },
    {
      'name': 'Lunch Break',
      'duration': 45,
      'category': 'Personal',
      'priority': 'Low',
    },
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _titleController.addListener(_validateForm);
    _updateEndTimeFromDuration();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _animationController.forward();
  }

  void _validateForm() {
    final isValid = _titleController.text.trim().isNotEmpty;
    if (isValid != _isFormValid) {
      setState(() {
        _isFormValid = isValid;
      });
    }
  }

  void _updateEndTimeFromDuration() {
    final startMinutes = _startTime.hour * 60 + _startTime.minute;
    final endMinutes = startMinutes + _selectedDuration;
    final endHour = (endMinutes ~/ 60) % 24;
    final endMinute = endMinutes % 60;

    setState(() {
      _endTime = TimeOfDay(hour: endHour, minute: endMinute);
    });
  }

  void _onStartTimeChanged(TimeOfDay newTime) {
    setState(() {
      _startTime = newTime;
    });
    _updateEndTimeFromDuration();
  }

  void _onEndTimeChanged(TimeOfDay newTime) {
    setState(() {
      _endTime = newTime;
    });
    _updateDurationFromTimes();
  }

  void _updateDurationFromTimes() {
    final startMinutes = _startTime.hour * 60 + _startTime.minute;
    final endMinutes = _endTime.hour * 60 + _endTime.minute;
    final duration = endMinutes - startMinutes;

    if (duration > 0) {
      setState(() {
        _selectedDuration = duration;
      });
    }
  }

  void _onDurationChanged(int newDuration) {
    setState(() {
      _selectedDuration = newDuration;
    });
    _updateEndTimeFromDuration();
  }

  Future<void> _saveTimeBlock() async {
    if (!_formKey.currentState!.validate() || !_isFormValid) return;

    setState(() {
      _isSaving = true;
    });

    // Haptic feedback
    HapticFeedback.mediumImpact();

    try {
      // Simulate API call
      await Future.delayed(const Duration(milliseconds: 1500));

      // Show success animation
      _showSuccessAnimation();

      // Navigate back after delay
      await Future.delayed(const Duration(milliseconds: 2000));

      if (mounted) {
        Navigator.of(context).pop();
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
                Text('Time block created successfully!'),
              ],
            ),
            backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to create time block. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  void _showSuccessAnimation() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: const Duration(milliseconds: 800),
                builder: (context, value, child) {
                  return Transform.scale(
                    scale: value,
                    child: Container(
                      padding: EdgeInsets.all(4.w),
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.tertiary,
                        shape: BoxShape.circle,
                      ),
                      child: CustomIconWidget(
                        iconName: 'check',
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 3.h),
              Text(
                'Time Block Created!',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.lightTheme.colorScheme.tertiary,
                ),
              ),
              SizedBox(height: 1.h),
              Text(
                'Your task has been scheduled successfully',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurface
                      .withValues(alpha: 0.7),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveAsTemplate() {
    if (!_isFormValid) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Save as Template'),
        content:
            Text('Save "${_titleController.text}" as a reusable template?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Template saved successfully!'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  void _loadTemplate(Map<String, dynamic> template) {
    setState(() {
      _titleController.text = template['name'];
      _selectedDuration = template['duration'];
      _selectedCategory = template['category'];
      _selectedPriority = template['priority'];
    });
    _updateEndTimeFromDuration();
    _validateForm();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('Create Time Block'),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: CustomIconWidget(
            iconName: 'close',
            color: AppTheme.lightTheme.colorScheme.onSurface,
            size: 24,
          ),
        ),
        actions: [
          if (_templates.isNotEmpty)
            PopupMenuButton<Map<String, dynamic>>(
              icon: CustomIconWidget(
                iconName: 'bookmark_outline',
                color: AppTheme.lightTheme.colorScheme.onSurface,
                size: 24,
              ),
              tooltip: 'Load Template',
              onSelected: _loadTemplate,
              itemBuilder: (context) => _templates.map((template) {
                return PopupMenuItem(
                  value: template,
                  child: Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'bookmark',
                        color: AppTheme.lightTheme.colorScheme.primary,
                        size: 18,
                      ),
                      SizedBox(width: 2.w),
                      Text(template['name']),
                    ],
                  ),
                );
              }).toList(),
            ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TaskTitleInputWidget(
                    controller: _titleController,
                    onChanged: (value) => _validateForm(),
                    recentTasks: _recentTasks,
                  ),
                  SizedBox(height: 4.h),
                  TimeSelectionWidget(
                    selectedDate: _selectedDate,
                    startTime: _startTime,
                    endTime: _endTime,
                    onStartTimeChanged: _onStartTimeChanged,
                    onEndTimeChanged: _onEndTimeChanged,
                  ),
                  SizedBox(height: 4.h),
                  DurationSelectorWidget(
                    selectedDuration: _selectedDuration,
                    onDurationChanged: _onDurationChanged,
                  ),
                  SizedBox(height: 4.h),
                  CategorySelectionWidget(
                    selectedCategory: _selectedCategory,
                    onCategoryChanged: (category) {
                      setState(() {
                        _selectedCategory = category;
                      });
                    },
                  ),
                  SizedBox(height: 4.h),
                  DescriptionInputWidget(
                    controller: _descriptionController,
                    onChanged: (value) {},
                  ),
                  SizedBox(height: 4.h),
                  PriorityToggleWidget(
                    selectedPriority: _selectedPriority,
                    onPriorityChanged: (priority) {
                      setState(() {
                        _selectedPriority = priority;
                      });
                    },
                  ),
                  SizedBox(height: 4.h),
                  RecurringOptionsWidget(
                    selectedRecurrence: _selectedRecurrence,
                    endDate: _endDate,
                    onRecurrenceChanged: (recurrence) {
                      setState(() {
                        _selectedRecurrence = recurrence;
                      });
                    },
                    onEndDateChanged: (date) {
                      setState(() {
                        _endDate = date;
                      });
                    },
                  ),
                  SizedBox(height: 8.h),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          border: Border(
            top: BorderSide(
              color: AppTheme.lightTheme.colorScheme.outline
                  .withValues(alpha: 0.2),
            ),
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed:
                          _isFormValid && !_isSaving ? _saveAsTemplate : null,
                      icon: CustomIconWidget(
                        iconName: 'bookmark_add',
                        color: _isFormValid && !_isSaving
                            ? AppTheme.lightTheme.colorScheme.primary
                            : AppTheme.lightTheme.colorScheme.onSurface
                                .withValues(alpha: 0.4),
                        size: 18,
                      ),
                      label: Text('Save Template'),
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton.icon(
                      onPressed:
                          _isFormValid && !_isSaving ? _saveTimeBlock : null,
                      icon: _isSaving
                          ? SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppTheme.lightTheme.colorScheme.onPrimary,
                                ),
                              ),
                            )
                          : CustomIconWidget(
                              iconName: 'add',
                              color: AppTheme.lightTheme.colorScheme.onPrimary,
                              size: 18,
                            ),
                      label: Text(_isSaving ? 'Creating...' : 'Create Block'),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 3.h),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
