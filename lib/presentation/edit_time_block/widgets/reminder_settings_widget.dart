import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class ReminderSettingsWidget extends StatefulWidget {
  final Map<String, dynamic> reminderData;
  final Function(Map<String, dynamic>) onReminderChanged;

  const ReminderSettingsWidget({
    super.key,
    required this.reminderData,
    required this.onReminderChanged,
  });

  @override
  State<ReminderSettingsWidget> createState() => _ReminderSettingsWidgetState();
}

class _ReminderSettingsWidgetState extends State<ReminderSettingsWidget> {
  late bool _isReminderEnabled;
  late int _reminderMinutes;
  late String _reminderType;

  final List<Map<String, dynamic>> _reminderOptions = [
    {'label': '5 minutes before', 'value': 5},
    {'label': '10 minutes before', 'value': 10},
    {'label': '15 minutes before', 'value': 15},
    {'label': '30 minutes before', 'value': 30},
    {'label': '1 hour before', 'value': 60},
    {'label': '2 hours before', 'value': 120},
  ];

  final List<String> _reminderTypes = [
    'Notification',
    'Email',
    'Both',
  ];

  @override
  void initState() {
    super.initState();
    _initializeSettings();
  }

  void _initializeSettings() {
    _isReminderEnabled = widget.reminderData['enabled'] as bool? ?? false;
    _reminderMinutes = widget.reminderData['minutes'] as int? ?? 15;
    _reminderType = widget.reminderData['type'] as String? ?? 'Notification';
  }

  void _updateReminder() {
    final updatedData = {
      'enabled': _isReminderEnabled,
      'minutes': _reminderMinutes,
      'type': _reminderType,
    };
    widget.onReminderChanged(updatedData);
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
          _buildReminderToggle(),
          if (_isReminderEnabled) ...[
            SizedBox(height: 2.h),
            _buildReminderTimeOptions(),
            SizedBox(height: 2.h),
            _buildReminderTypeOptions(),
          ],
        ],
      ),
    );
  }

  Widget _buildReminderToggle() {
    return Row(
      children: [
        CustomIconWidget(
          iconName: 'notifications',
          color: Theme.of(context).colorScheme.primary,
          size: 24,
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: Text(
            'Set Reminder',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
        Switch(
          value: _isReminderEnabled,
          onChanged: (value) {
            setState(() {
              _isReminderEnabled = value;
            });
            _updateReminder();
          },
        ),
      ],
    );
  }

  Widget _buildReminderTimeOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Remind me',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
        ),
        SizedBox(height: 1.h),
        Wrap(
          spacing: 2.w,
          runSpacing: 1.h,
          children: _reminderOptions.map((option) {
            final isSelected = option['value'] == _reminderMinutes;

            return GestureDetector(
              onTap: () {
                setState(() {
                  _reminderMinutes = option['value'] as int;
                });
                _updateReminder();
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.outline,
                  ),
                ),
                child: Text(
                  option['label'] as String,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: isSelected
                            ? Theme.of(context).colorScheme.onPrimary
                            : Theme.of(context).colorScheme.onSurface,
                        fontWeight:
                            isSelected ? FontWeight.w500 : FontWeight.w400,
                      ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildReminderTypeOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Reminder type',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
        ),
        SizedBox(height: 1.h),
        Row(
          children: _reminderTypes.map((type) {
            final isSelected = type == _reminderType;

            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                    right: type != _reminderTypes.last ? 2.w : 0),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _reminderType = type;
                    });
                    _updateReminder();
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
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
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
}
