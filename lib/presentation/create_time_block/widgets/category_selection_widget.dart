import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CategorySelectionWidget extends StatefulWidget {
  final String selectedCategory;
  final Function(String) onCategoryChanged;

  const CategorySelectionWidget({
    super.key,
    required this.selectedCategory,
    required this.onCategoryChanged,
  });

  @override
  State<CategorySelectionWidget> createState() =>
      _CategorySelectionWidgetState();
}

class _CategorySelectionWidgetState extends State<CategorySelectionWidget> {
  final List<Map<String, dynamic>> _categories = [
    {
      'name': 'Work',
      'icon': 'work',
      'color': const Color(0xFF2563EB),
    },
    {
      'name': 'Personal',
      'icon': 'person',
      'color': const Color(0xFF059669),
    },
    {
      'name': 'Health',
      'icon': 'favorite',
      'color': const Color(0xFFDC2626),
    },
    {
      'name': 'Learning',
      'icon': 'school',
      'color': const Color(0xFF7C3AED),
    },
    {
      'name': 'Social',
      'icon': 'people',
      'color': const Color(0xFFD97706),
    },
    {
      'name': 'Exercise',
      'icon': 'fitness_center',
      'color': const Color(0xFF059669),
    },
    {
      'name': 'Meeting',
      'icon': 'groups',
      'color': const Color(0xFF2563EB),
    },
    {
      'name': 'Travel',
      'icon': 'flight',
      'color': const Color(0xFF0891B2),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Category',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppTheme.lightTheme.colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 2.h),
        SizedBox(
          height: 12.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _categories.length,
            separatorBuilder: (context, index) => SizedBox(width: 3.w),
            itemBuilder: (context, index) {
              final category = _categories[index];
              final isSelected = widget.selectedCategory == category['name'];

              return GestureDetector(
                onTap: () => widget.onCategoryChanged(category['name']),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  width: 20.w,
                  padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? (category['color'] as Color).withValues(alpha: 0.1)
                        : AppTheme.lightTheme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected
                          ? (category['color'] as Color)
                          : AppTheme.lightTheme.colorScheme.outline
                              .withValues(alpha: 0.2),
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(2.w),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? (category['color'] as Color)
                              : (category['color'] as Color)
                                  .withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: CustomIconWidget(
                          iconName: category['icon'],
                          color: isSelected
                              ? Colors.white
                              : (category['color'] as Color),
                          size: 20,
                        ),
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        category['name'],
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: isSelected
                              ? (category['color'] as Color)
                              : AppTheme.lightTheme.colorScheme.onSurface,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.w400,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
