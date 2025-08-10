import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class RecurringOptionsWidget extends StatefulWidget {
  final String selectedRecurrence;
  final DateTime? endDate;
  final Function(String) onRecurrenceChanged;
  final Function(DateTime?) onEndDateChanged;

  const RecurringOptionsWidget({
    super.key,
    required this.selectedRecurrence,
    required this.endDate,
    required this.onRecurrenceChanged,
    required this.onEndDateChanged,
  });

  @override
  State<RecurringOptionsWidget> createState() => _RecurringOptionsWidgetState();
}

class _RecurringOptionsWidgetState extends State<RecurringOptionsWidget> {
  final List<Map<String, dynamic>> _recurrenceOptions = [
    {
      'name': 'None',
      'icon': 'event',
      'description': 'One-time event',
    },
    {
      'name': 'Daily',
      'icon': 'today',
      'description': 'Every day',
    },
    {
      'name': 'Weekly',
      'icon': 'view_week',
      'description': 'Every week',
    },
    {
      'name': 'Monthly',
      'icon': 'calendar_month',
      'description': 'Every month',
    },
  ];

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate:
          widget.endDate ?? DateTime.now().add(const Duration(days: 30)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: AppTheme.lightTheme.colorScheme.primary,
                ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      widget.onEndDateChanged(picked);
    }
  }

  String _formatDate(DateTime date) {
    return '${date.month}/${date.day}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final hasRecurrence = widget.selectedRecurrence != 'None';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Repeat Options',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppTheme.lightTheme.colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 2.h),
        Container(
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppTheme.lightTheme.colorScheme.outline
                  .withValues(alpha: 0.2),
            ),
          ),
          child: Column(
            children: _recurrenceOptions.asMap().entries.map((entry) {
              final index = entry.key;
              final option = entry.value;
              final isSelected = widget.selectedRecurrence == option['name'];
              final isLast = index == _recurrenceOptions.length - 1;

              return Column(
                children: [
                  ListTile(
                    leading: Container(
                      padding: EdgeInsets.all(2.w),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppTheme.lightTheme.colorScheme.primary
                                .withValues(alpha: 0.1)
                            : AppTheme.lightTheme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: CustomIconWidget(
                        iconName: option['icon'],
                        color: isSelected
                            ? AppTheme.lightTheme.colorScheme.primary
                            : AppTheme.lightTheme.colorScheme.onSurface
                                .withValues(alpha: 0.6),
                        size: 20,
                      ),
                    ),
                    title: Text(
                      option['name'],
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w400,
                        color: isSelected
                            ? AppTheme.lightTheme.colorScheme.primary
                            : AppTheme.lightTheme.colorScheme.onSurface,
                      ),
                    ),
                    subtitle: Text(
                      option['description'],
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurface
                            .withValues(alpha: 0.6),
                      ),
                    ),
                    trailing: Radio<String>(
                      value: option['name'],
                      groupValue: widget.selectedRecurrence,
                      onChanged: (value) {
                        if (value != null) {
                          widget.onRecurrenceChanged(value);
                          if (value == 'None') {
                            widget.onEndDateChanged(null);
                          }
                        }
                      },
                      activeColor: AppTheme.lightTheme.colorScheme.primary,
                    ),
                    onTap: () {
                      widget.onRecurrenceChanged(option['name']);
                      if (option['name'] == 'None') {
                        widget.onEndDateChanged(null);
                      }
                    },
                  ),
                  if (!isLast)
                    Divider(
                      height: 1,
                      color: AppTheme.lightTheme.colorScheme.outline
                          .withValues(alpha: 0.1),
                    ),
                ],
              );
            }).toList(),
          ),
        ),
        if (hasRecurrence) ...[
          SizedBox(height: 2.h),
          Text(
            'End Date',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 1.h),
          GestureDetector(
            onTap: () => _selectEndDate(context),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 3.h),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'calendar_today',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 20,
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Text(
                      widget.endDate != null
                          ? 'Until ${_formatDate(widget.endDate!)}'
                          : 'Select end date',
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: widget.endDate != null
                            ? AppTheme.lightTheme.colorScheme.onSurface
                            : AppTheme.lightTheme.colorScheme.onSurface
                                .withValues(alpha: 0.6),
                      ),
                    ),
                  ),
                  CustomIconWidget(
                    iconName: 'keyboard_arrow_down',
                    color: AppTheme.lightTheme.colorScheme.onSurface
                        .withValues(alpha: 0.6),
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }
}
