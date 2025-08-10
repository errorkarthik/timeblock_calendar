import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum CustomTabBarVariant {
  standard,
  segmented,
  pills,
  underlined,
}

class CustomTabBar extends StatelessWidget implements PreferredSizeWidget {
  final List<String> tabs;
  final int currentIndex;
  final ValueChanged<int>? onTap;
  final CustomTabBarVariant variant;
  final Color? backgroundColor;
  final Color? selectedColor;
  final Color? unselectedColor;
  final Color? indicatorColor;
  final bool isScrollable;
  final EdgeInsetsGeometry? padding;

  const CustomTabBar({
    super.key,
    required this.tabs,
    this.currentIndex = 0,
    this.onTap,
    this.variant = CustomTabBarVariant.standard,
    this.backgroundColor,
    this.selectedColor,
    this.unselectedColor,
    this.indicatorColor,
    this.isScrollable = false,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    switch (variant) {
      case CustomTabBarVariant.standard:
        return _buildStandardTabBar(context, theme, colorScheme);
      case CustomTabBarVariant.segmented:
        return _buildSegmentedTabBar(context, theme, colorScheme);
      case CustomTabBarVariant.pills:
        return _buildPillsTabBar(context, theme, colorScheme);
      case CustomTabBarVariant.underlined:
        return _buildUnderlinedTabBar(context, theme, colorScheme);
    }
  }

  Widget _buildStandardTabBar(
      BuildContext context, ThemeData theme, ColorScheme colorScheme) {
    return Container(
      color: backgroundColor ?? colorScheme.surface,
      padding: padding ?? EdgeInsets.zero,
      child: TabBar(
        tabs: _getDefaultTabs().map((tab) => Tab(text: tab)).toList(),
        isScrollable: isScrollable,
        labelColor: selectedColor ?? colorScheme.primary,
        unselectedLabelColor:
            unselectedColor ?? colorScheme.onSurface.withValues(alpha: 0.6),
        indicatorColor: indicatorColor ?? colorScheme.primary,
        indicatorWeight: 2.0,
        onTap: (index) {
          HapticFeedback.lightImpact();
          _handleTabNavigation(context, index);
          onTap?.call(index);
        },
      ),
    );
  }

  Widget _buildSegmentedTabBar(
      BuildContext context, ThemeData theme, ColorScheme colorScheme) {
    return Container(
      margin: padding ?? const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.2),
          width: 1.0,
        ),
      ),
      child: Row(
        children: _getDefaultTabs().asMap().entries.map((entry) {
          final index = entry.key;
          final tab = entry.value;
          final isSelected = currentIndex == index;
          final isFirst = index == 0;
          final isLast = index == _getDefaultTabs().length - 1;

          return Expanded(
            child: GestureDetector(
              onTap: () {
                HapticFeedback.lightImpact();
                _handleTabNavigation(context, index);
                onTap?.call(index);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                decoration: BoxDecoration(
                  color: isSelected
                      ? (selectedColor ?? colorScheme.primary)
                      : Colors.transparent,
                  borderRadius: BorderRadius.horizontal(
                    left: isFirst ? const Radius.circular(12.0) : Radius.zero,
                    right: isLast ? const Radius.circular(12.0) : Radius.zero,
                  ),
                ),
                child: Text(
                  tab,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    color: isSelected
                        ? colorScheme.onPrimary
                        : (unselectedColor ?? colorScheme.onSurface),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildPillsTabBar(
      BuildContext context, ThemeData theme, ColorScheme colorScheme) {
    return Container(
      padding: padding ?? const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: _getDefaultTabs().asMap().entries.map((entry) {
            final index = entry.key;
            final tab = entry.value;
            final isSelected = currentIndex == index;

            return Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  _handleTabNavigation(context, index);
                  onTap?.call(index);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 10.0),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? (selectedColor ?? colorScheme.primary)
                        : colorScheme.surface,
                    borderRadius: BorderRadius.circular(20.0),
                    border: Border.all(
                      color: isSelected
                          ? (selectedColor ?? colorScheme.primary)
                          : colorScheme.outline.withValues(alpha: 0.2),
                      width: 1.0,
                    ),
                  ),
                  child: Text(
                    tab,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight:
                          isSelected ? FontWeight.w500 : FontWeight.w400,
                      color: isSelected
                          ? colorScheme.onPrimary
                          : (unselectedColor ?? colorScheme.onSurface),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildUnderlinedTabBar(
      BuildContext context, ThemeData theme, ColorScheme colorScheme) {
    return Container(
      color: backgroundColor ?? colorScheme.surface,
      padding: padding ?? EdgeInsets.zero,
      child: Column(
        children: [
          Row(
            children: _getDefaultTabs().asMap().entries.map((entry) {
              final index = entry.key;
              final tab = entry.value;
              final isSelected = currentIndex == index;

              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    _handleTabNavigation(context, index);
                    onTap?.call(index);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Text(
                      tab,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w400,
                        color: isSelected
                            ? (selectedColor ?? colorScheme.primary)
                            : (unselectedColor ??
                                colorScheme.onSurface.withValues(alpha: 0.6)),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          Container(
            height: 2.0,
            child: Row(
              children: _getDefaultTabs().asMap().entries.map((entry) {
                final index = entry.key;
                final isSelected = currentIndex == index;

                return Expanded(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                    color: isSelected
                        ? (indicatorColor ?? colorScheme.primary)
                        : Colors.transparent,
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  List<String> _getDefaultTabs() {
    if (tabs.isNotEmpty) return tabs;
    return ['Daily', 'Weekly'];
  }

  void _handleTabNavigation(BuildContext context, int index) {
    final defaultTabs = _getDefaultTabs();
    if (index < defaultTabs.length) {
      switch (defaultTabs[index].toLowerCase()) {
        case 'daily':
          Navigator.pushNamed(context, '/daily-calendar-view');
          break;
        case 'weekly':
          Navigator.pushNamed(context, '/weekly-calendar-view');
          break;
        case 'create':
          Navigator.pushNamed(context, '/create-time-block');
          break;
        case 'edit':
          Navigator.pushNamed(context, '/edit-time-block');
          break;
      }
    }
  }

  @override
  Size get preferredSize => const Size.fromHeight(48.0);
}
