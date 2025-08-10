import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class DurationSelectorWidget extends StatefulWidget {
  final int selectedDuration;
  final Function(int) onDurationChanged;

  const DurationSelectorWidget({
    super.key,
    required this.selectedDuration,
    required this.onDurationChanged,
  });

  @override
  State<DurationSelectorWidget> createState() => _DurationSelectorWidgetState();
}

class _DurationSelectorWidgetState extends State<DurationSelectorWidget> {
  final List<int> _presetDurations = [15, 30, 60, 120]; // in minutes
  final TextEditingController _customController = TextEditingController();
  bool _showCustomInput = false;

  @override
  void initState() {
    super.initState();
    if (!_presetDurations.contains(widget.selectedDuration)) {
      _showCustomInput = true;
      _customController.text = widget.selectedDuration.toString();
    }
  }

  @override
  void dispose() {
    _customController.dispose();
    super.dispose();
  }

  String _formatDuration(int minutes) {
    if (minutes < 60) {
      return '${minutes}min';
    } else {
      final hours = minutes ~/ 60;
      final remainingMinutes = minutes % 60;
      return remainingMinutes == 0
          ? '${hours}h'
          : '${hours}h ${remainingMinutes}m';
    }
  }

  void _selectPresetDuration(int duration) {
    setState(() {
      _showCustomInput = false;
    });
    widget.onDurationChanged(duration);
  }

  void _toggleCustomInput() {
    setState(() {
      _showCustomInput = !_showCustomInput;
      if (_showCustomInput) {
        _customController.text = widget.selectedDuration.toString();
      }
    });
  }

  void _applyCustomDuration() {
    final customDuration = int.tryParse(_customController.text);
    if (customDuration != null && customDuration > 0 && customDuration <= 480) {
      widget.onDurationChanged(customDuration);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid duration (1-480 minutes)'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Duration',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppTheme.lightTheme.colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 2.h),
        Wrap(
          spacing: 2.w,
          runSpacing: 1.h,
          children: [
            ..._presetDurations.map((duration) {
              final isSelected =
                  widget.selectedDuration == duration && !_showCustomInput;
              return GestureDetector(
                onTap: () => _selectPresetDuration(duration),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppTheme.lightTheme.colorScheme.primary
                        : AppTheme.lightTheme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected
                          ? AppTheme.lightTheme.colorScheme.primary
                          : AppTheme.lightTheme.colorScheme.outline
                              .withValues(alpha: 0.3),
                    ),
                  ),
                  child: Text(
                    _formatDuration(duration),
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: isSelected
                          ? AppTheme.lightTheme.colorScheme.onPrimary
                          : AppTheme.lightTheme.colorScheme.onSurface,
                      fontWeight:
                          isSelected ? FontWeight.w500 : FontWeight.w400,
                    ),
                  ),
                ),
              );
            }),
            GestureDetector(
              onTap: _toggleCustomInput,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: _showCustomInput
                      ? AppTheme.lightTheme.colorScheme.primary
                      : AppTheme.lightTheme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: _showCustomInput
                        ? AppTheme.lightTheme.colorScheme.primary
                        : AppTheme.lightTheme.colorScheme.outline
                            .withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomIconWidget(
                      iconName: 'edit',
                      color: _showCustomInput
                          ? AppTheme.lightTheme.colorScheme.onPrimary
                          : AppTheme.lightTheme.colorScheme.onSurface,
                      size: 16,
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      'Custom',
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: _showCustomInput
                            ? AppTheme.lightTheme.colorScheme.onPrimary
                            : AppTheme.lightTheme.colorScheme.onSurface,
                        fontWeight: _showCustomInput
                            ? FontWeight.w500
                            : FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        if (_showCustomInput) ...[
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _customController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: 'Enter minutes',
                    suffixText: 'min',
                  ),
                  onFieldSubmitted: (_) => _applyCustomDuration(),
                ),
              ),
              SizedBox(width: 2.w),
              ElevatedButton(
                onPressed: _applyCustomDuration,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                ),
                child: Text('Apply'),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
