import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class RecurringPatternWidget extends StatefulWidget {
  final Map<String, dynamic> recurringData;
  final Function(Map<String, dynamic>) onRecurringChanged;

  const RecurringPatternWidget({
    super.key,
    required this.recurringData,
    required this.onRecurringChanged,
  });

  @override
  State<RecurringPatternWidget> createState() => _RecurringPatternWidgetState();
}

class _RecurringPatternWidgetState extends State<RecurringPatternWidget> {
  late bool _isRecurring;
  late String _recurringType;
  late List<String> _selectedDays;
  late DateTime? _endDate;

  final List<String> _recurringTypes = [
    'Daily',
    'Weekly',
    'Monthly',
    'Custom',
  ];

  final List<Map<String, String>> _weekDays = [
    {'short': 'Mon', 'full': 'Monday'},
    {'short': 'Tue', 'full': 'Tuesday'},
    {'short': 'Wed', 'full': 'Wednesday'},
    {'short': 'Thu', 'full': 'Thursday'},
    {'short': 'Fri', 'full': 'Friday'},
    {'short': 'Sat', 'full': 'Saturday'},
    {'short': 'Sun', 'full': 'Sunday'},
  ];

  @override
  void initState() {
    super.initState();
    _initializeSettings();
  }

  void _initializeSettings() {
    _isRecurring = widget.recurringData['enabled'] as bool? ?? false;
    _recurringType = widget.recurringData['type'] as String? ?? 'Weekly';
    _selectedDays =
        (widget.recurringData['days'] as List<dynamic>?)?.cast<String>() ?? [];
    _endDate = widget.recurringData['endDate'] as DateTime?;
  }

  void _updateRecurring() {
    final updatedData = {
      'enabled': _isRecurring,
      'type': _recurringType,
      'days': _selectedDays,
      'endDate': _endDate,
    };
    widget.onRecurringChanged(updatedData);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildRecurringToggle(),
          if (_isRecurring) ...[
            SizedBox(height: 2.h),
            _buildRecurringTypeOptions(),
            if (_recurringType == 'Weekly' || _recurringType == 'Custom') ...[
              SizedBox(height: 2.h),
              _buildWeekDaySelection(),
            ],
            SizedBox(height: 2.h),
            _buildEndDateSelection(),
          ],
        ],
      ),
    );
  }

  Widget _buildRecurringToggle() {
    return Row(
      children: [
        CustomIconWidget(
          iconName: 'repeat',
          color: Theme.of(context).colorScheme.primary,
          size: 24,
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: Text(
            'Repeat',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
        Switch(
          value: _isRecurring,
          onChanged: (value) {
            setState(() {
              _isRecurring = value;
            });
            _updateRecurring();
          },
        ),
      ],
    );
  }

  Widget _buildRecurringTypeOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Repeat every',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
        ),
        SizedBox(height: 1.h),
        Row(
          children: _recurringTypes.map((type) {
            final isSelected = type == _recurringType;

            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                    right: type != _recurringTypes.last ? 2.w : 0),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _recurringType = type;
                      if (type == 'Daily') {
                        _selectedDays.clear();
                      } else if (type == 'Weekly' && _selectedDays.isEmpty) {
                        _selectedDays.add('Monday');
                      }
                    });
                    _updateRecurring();
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 1.5.h),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.outline,
                      ),
                    ),
                    child: Text(
                      type,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: isSelected
                                ? Theme.of(context).colorScheme.onPrimary
                                : Theme.of(context).colorScheme.onSurface,
                            fontWeight:
                                isSelected ? FontWeight.w500 : FontWeight.w400,
                          ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildWeekDaySelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Repeat on',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
        ),
        SizedBox(height: 1.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: _weekDays.map((day) {
            final isSelected = _selectedDays.contains(day['full']);

            return GestureDetector(
              onTap: () {
                setState(() {
                  if (isSelected) {
                    _selectedDays.remove(day['full']);
                  } else {
                    _selectedDays.add(day['full']!);
                  }
                });
                _updateRecurring();
              },
              child: Container(
                width: 10.w,
                height: 5.h,
                decoration: BoxDecoration(
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.outline,
                  ),
                ),
                child: Center(
                  child: Text(
                    day['short']!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: isSelected
                              ? Theme.of(context).colorScheme.onPrimary
                              : Theme.of(context).colorScheme.onSurface,
                          fontWeight:
                              isSelected ? FontWeight.w500 : FontWeight.w400,
                        ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildEndDateSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'End date (optional)',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
        ),
        SizedBox(height: 1.h),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: _selectEndDate,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: Theme.of(context).colorScheme.outline),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'calendar_today',
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withValues(alpha: 0.6),
                        size: 20,
                      ),
                      SizedBox(width: 3.w),
                      Text(
                        _endDate != null
                            ? '${_endDate!.day}/${_endDate!.month}/${_endDate!.year}'
                            : 'Select end date',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: _endDate != null
                                  ? Theme.of(context).colorScheme.onSurface
                                  : Theme.of(context)
                                      .colorScheme
                                      .onSurface
                                      .withValues(alpha: 0.6),
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (_endDate != null) ...[
              SizedBox(width: 2.w),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _endDate = null;
                  });
                  _updateRecurring();
                },
                child: Container(
                  padding: EdgeInsets.all(1.h),
                  decoration: BoxDecoration(
                    color: Theme.of(context)
                        .colorScheme
                        .error
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: CustomIconWidget(
                    iconName: 'close',
                    color: Theme.of(context).colorScheme.error,
                    size: 20,
                  ),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }

  Future<void> _selectEndDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _endDate ?? DateTime.now().add(const Duration(days: 30)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null) {
      setState(() {
        _endDate = picked;
      });
      _updateRecurring();
    }
  }
}
