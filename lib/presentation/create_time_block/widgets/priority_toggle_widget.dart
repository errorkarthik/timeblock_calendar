import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PriorityToggleWidget extends StatefulWidget {
  final String selectedPriority;
  final Function(String) onPriorityChanged;

  const PriorityToggleWidget({
    super.key,
    required this.selectedPriority,
    required this.onPriorityChanged,
  });

  @override
  State<PriorityToggleWidget> createState() => _PriorityToggleWidgetState();
}

class _PriorityToggleWidgetState extends State<PriorityToggleWidget> {
  final List<Map<String, dynamic>> _priorities = [
    {
      'name': 'Low',
      'icon': 'keyboard_arrow_down',
      'color': const Color(0xFF059669),
      'description': 'Nice to have',
    },
    {
      'name': 'Medium',
      'icon': 'remove',
      'color': const Color(0xFFD97706),
      'description': 'Important',
    },
    {
      'name': 'High',
      'icon': 'keyboard_arrow_up',
      'color': const Color(0xFFDC2626),
      'description': 'Urgent',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Priority Level',
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
          child: Row(
            children: _priorities.asMap().entries.map((entry) {
              final index = entry.key;
              final priority = entry.value;
              final isSelected = widget.selectedPriority == priority['name'];
              final isFirst = index == 0;
              final isLast = index == _priorities.length - 1;

              return Expanded(
                child: GestureDetector(
                  onTap: () => widget.onPriorityChanged(priority['name']),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                    padding: EdgeInsets.symmetric(vertical: 3.h),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? (priority['color'] as Color).withValues(alpha: 0.1)
                          : Colors.transparent,
                      borderRadius: BorderRadius.horizontal(
                        left: isFirst ? const Radius.circular(12) : Radius.zero,
                        right: isLast ? const Radius.circular(12) : Radius.zero,
                      ),
                      border: isSelected
                          ? Border.all(
                              color: priority['color'] as Color,
                              width: 1.5,
                            )
                          : null,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.all(1.5.w),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? (priority['color'] as Color)
                                : (priority['color'] as Color)
                                    .withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: CustomIconWidget(
                            iconName: priority['icon'],
                            color: isSelected
                                ? Colors.white
                                : (priority['color'] as Color),
                            size: 18,
                          ),
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          priority['name'],
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            color: isSelected
                                ? (priority['color'] as Color)
                                : AppTheme.lightTheme.colorScheme.onSurface,
                            fontWeight:
                                isSelected ? FontWeight.w600 : FontWeight.w400,
                          ),
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          priority['description'],
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: isSelected
                                ? (priority['color'] as Color)
                                    .withValues(alpha: 0.8)
                                : AppTheme.lightTheme.colorScheme.onSurface
                                    .withValues(alpha: 0.6),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        SizedBox(height: 1.h),
        Container(
          padding: EdgeInsets.all(3.w),
          decoration: BoxDecoration(
            color:
                AppTheme.lightTheme.colorScheme.surface.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: AppTheme.lightTheme.colorScheme.outline
                  .withValues(alpha: 0.1),
            ),
          ),
          child: Row(
            children: [
              CustomIconWidget(
                iconName: 'info_outline',
                color: AppTheme.lightTheme.colorScheme.onSurface
                    .withValues(alpha: 0.6),
                size: 16,
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: Text(
                  'Priority affects notification timing and visual prominence in your calendar',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurface
                        .withValues(alpha: 0.7),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
