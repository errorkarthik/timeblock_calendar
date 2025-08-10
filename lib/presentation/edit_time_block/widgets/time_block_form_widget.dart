import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class TimeBlockFormWidget extends StatefulWidget {
  final Map<String, dynamic> timeBlockData;
  final Function(Map<String, dynamic>) onDataChanged;

  const TimeBlockFormWidget({
    super.key,
    required this.timeBlockData,
    required this.onDataChanged,
  });

  @override
  State<TimeBlockFormWidget> createState() => _TimeBlockFormWidgetState();
}

class _TimeBlockFormWidgetState extends State<TimeBlockFormWidget> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late DateTime _selectedDate;
  late TimeOfDay _startTime;
  late TimeOfDay _endTime;
  late String _selectedCategory;
  late int _selectedPriority;
  late Color _selectedColor;

  final List<String> _categories = [
    'Work',
    'Personal',
    'Health',
    'Education',
    'Social',
    'Travel',
    'Other'
  ];

  final List<Color> _colorOptions = [
    const Color(0xFF2563EB),
    const Color(0xFF059669),
    const Color(0xFFD97706),
    const Color(0xFFDC2626),
    const Color(0xFF7C3AED),
    const Color(0xFFDB2777),
    const Color(0xFF0891B2),
    const Color(0xFF65A30D),
  ];

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    _titleController = TextEditingController(
        text: widget.timeBlockData['title'] as String? ?? '');
    _descriptionController = TextEditingController(
        text: widget.timeBlockData['description'] as String? ?? '');

    _selectedDate = widget.timeBlockData['date'] as DateTime? ?? DateTime.now();
    _startTime =
        widget.timeBlockData['startTime'] as TimeOfDay? ?? TimeOfDay.now();
    _endTime = widget.timeBlockData['endTime'] as TimeOfDay? ??
        TimeOfDay(
            hour: TimeOfDay.now().hour + 1, minute: TimeOfDay.now().minute);
    _selectedCategory = widget.timeBlockData['category'] as String? ?? 'Work';
    _selectedPriority = widget.timeBlockData['priority'] as int? ?? 1;
    _selectedColor = Color(widget.timeBlockData['color'] as int? ?? 0xFF2563EB);
  }

  void _updateData() {
    final updatedData = {
      'title': _titleController.text,
      'description': _descriptionController.text,
      'date': _selectedDate,
      'startTime': _startTime,
      'endTime': _endTime,
      'category': _selectedCategory,
      'priority': _selectedPriority,
      'color': _selectedColor.value,
    };
    widget.onDataChanged(updatedData);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTitleField(),
        SizedBox(height: 3.h),
        _buildTimeSection(),
        SizedBox(height: 3.h),
        _buildCategorySection(),
        SizedBox(height: 3.h),
        _buildPrioritySection(),
        SizedBox(height: 3.h),
        _buildColorSection(),
        SizedBox(height: 3.h),
        _buildDescriptionField(),
      ],
    );
  }

  Widget _buildTitleField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Title',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        SizedBox(height: 1.h),
        TextFormField(
          controller: _titleController,
          decoration: const InputDecoration(
            hintText: 'Enter time block title',
          ),
          onChanged: (value) => _updateData(),
        ),
      ],
    );
  }

  Widget _buildTimeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Time',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        SizedBox(height: 1.h),
        Row(
          children: [
            Expanded(
              child: _buildTimeField(
                label: 'Start Time',
                time: _startTime,
                onTap: () => _selectTime(true),
              ),
            ),
            SizedBox(width: 4.w),
            Expanded(
              child: _buildTimeField(
                label: 'End Time',
                time: _endTime,
                onTap: () => _selectTime(false),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTimeField({
    required String label,
    required TimeOfDay time,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).colorScheme.outline),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            SizedBox(height: 0.5.h),
            Text(
              time.format(context),
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Category',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        SizedBox(height: 1.h),
        SizedBox(
          height: 6.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _categories.length,
            itemBuilder: (context, index) {
              final category = _categories[index];
              final isSelected = category == _selectedCategory;

              return Padding(
                padding: EdgeInsets.only(right: 2.w),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedCategory = category;
                    });
                    _updateData();
                  },
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
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
                      category,
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
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPrioritySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Priority',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        SizedBox(height: 1.h),
        Row(
          children: List.generate(3, (index) {
            final priority = index + 1;
            final isSelected = priority == _selectedPriority;

            return Padding(
              padding: EdgeInsets.only(right: 2.w),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedPriority = priority;
                  });
                  _updateData();
                },
                child: Container(
                  width: 12.w,
                  height: 6.h,
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
                      priority.toString(),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: isSelected
                                ? Theme.of(context).colorScheme.onPrimary
                                : Theme.of(context).colorScheme.onSurface,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildColorSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Color',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        SizedBox(height: 1.h),
        Wrap(
          spacing: 2.w,
          runSpacing: 1.h,
          children: _colorOptions.map((color) {
            final isSelected = color.value == _selectedColor.value;

            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedColor = color;
                });
                _updateData();
              },
              child: Container(
                width: 12.w,
                height: 6.h,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(8),
                  border: isSelected
                      ? Border.all(
                          color: Theme.of(context).colorScheme.onSurface,
                          width: 3,
                        )
                      : null,
                ),
                child: isSelected
                    ? Center(
                        child: CustomIconWidget(
                          iconName: 'check',
                          color: Colors.white,
                          size: 20,
                        ),
                      )
                    : null,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildDescriptionField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Description',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        SizedBox(height: 1.h),
        TextFormField(
          controller: _descriptionController,
          maxLines: 4,
          decoration: const InputDecoration(
            hintText: 'Add description (optional)',
          ),
          onChanged: (value) => _updateData(),
        ),
      ],
    );
  }

  Future<void> _selectTime(bool isStartTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isStartTime ? _startTime : _endTime,
    );

    if (picked != null) {
      setState(() {
        if (isStartTime) {
          _startTime = picked;
          // Auto-adjust end time if it's before start time
          if (_endTime.hour < _startTime.hour ||
              (_endTime.hour == _startTime.hour &&
                  _endTime.minute <= _startTime.minute)) {
            _endTime = TimeOfDay(
              hour: _startTime.hour + 1 > 23 ? 23 : _startTime.hour + 1,
              minute: _startTime.minute,
            );
          }
        } else {
          _endTime = picked;
        }
      });
      _updateData();
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
