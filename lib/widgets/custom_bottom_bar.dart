import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum CustomBottomBarVariant {
  standard,
  floating,
  minimal,
}

class CustomBottomBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int>? onTap;
  final CustomBottomBarVariant variant;
  final Color? backgroundColor;
  final Color? selectedItemColor;
  final Color? unselectedItemColor;
  final double? elevation;

  const CustomBottomBar({
    super.key,
    this.currentIndex = 0,
    this.onTap,
    this.variant = CustomBottomBarVariant.standard,
    this.backgroundColor,
    this.selectedItemColor,
    this.unselectedItemColor,
    this.elevation,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    switch (variant) {
      case CustomBottomBarVariant.standard:
        return _buildStandardBottomBar(context, theme, colorScheme);
      case CustomBottomBarVariant.floating:
        return _buildFloatingBottomBar(context, theme, colorScheme);
      case CustomBottomBarVariant.minimal:
        return _buildMinimalBottomBar(context, theme, colorScheme);
    }
  }

  Widget _buildStandardBottomBar(
      BuildContext context, ThemeData theme, ColorScheme colorScheme) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) {
        HapticFeedback.lightImpact();
        _handleNavigation(context, index);
        onTap?.call(index);
      },
      type: BottomNavigationBarType.fixed,
      backgroundColor: backgroundColor ?? colorScheme.surface,
      selectedItemColor: selectedItemColor ?? colorScheme.primary,
      unselectedItemColor:
          unselectedItemColor ?? colorScheme.onSurface.withValues(alpha: 0.6),
      elevation: elevation ?? 4.0,
      items: _buildBottomNavItems(),
    );
  }

  Widget _buildFloatingBottomBar(
      BuildContext context, ThemeData theme, ColorScheme colorScheme) {
    return Container(
      margin: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: backgroundColor ?? colorScheme.surface,
        borderRadius: BorderRadius.circular(24.0),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 8.0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24.0),
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (index) {
            HapticFeedback.lightImpact();
            _handleNavigation(context, index);
            onTap?.call(index);
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          selectedItemColor: selectedItemColor ?? colorScheme.primary,
          unselectedItemColor: unselectedItemColor ??
              colorScheme.onSurface.withValues(alpha: 0.6),
          elevation: 0.0,
          items: _buildBottomNavItems(),
        ),
      ),
    );
  }

  Widget _buildMinimalBottomBar(
      BuildContext context, ThemeData theme, ColorScheme colorScheme) {
    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: backgroundColor ?? colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: colorScheme.outline.withValues(alpha: 0.2),
            width: 1.0,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: _buildMinimalNavItems(context, colorScheme),
      ),
    );
  }

  List<BottomNavigationBarItem> _buildBottomNavItems() {
    return const [
      BottomNavigationBarItem(
        icon: Icon(Icons.today),
        activeIcon: Icon(Icons.today),
        label: 'Daily',
        tooltip: 'Daily Calendar View',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.view_week),
        activeIcon: Icon(Icons.view_week),
        label: 'Weekly',
        tooltip: 'Weekly Calendar View',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.add_circle_outline),
        activeIcon: Icon(Icons.add_circle),
        label: 'Create',
        tooltip: 'Create Time Block',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.edit_outlined),
        activeIcon: Icon(Icons.edit),
        label: 'Edit',
        tooltip: 'Edit Time Block',
      ),
    ];
  }

  List<Widget> _buildMinimalNavItems(
      BuildContext context, ColorScheme colorScheme) {
    final items = [
      {'icon': Icons.today, 'label': 'Daily', 'index': 0},
      {'icon': Icons.view_week, 'label': 'Weekly', 'index': 1},
      {'icon': Icons.add_circle_outline, 'label': 'Create', 'index': 2},
      {'icon': Icons.edit_outlined, 'label': 'Edit', 'index': 3},
    ];

    return items.map((item) {
      final isSelected = currentIndex == item['index'];
      return GestureDetector(
        onTap: () {
          HapticFeedback.lightImpact();
          _handleNavigation(context, item['index'] as int);
          onTap?.call(item['index'] as int);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          decoration: BoxDecoration(
            color: isSelected
                ? (selectedItemColor ?? colorScheme.primary)
                    .withValues(alpha: 0.1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                item['icon'] as IconData,
                color: isSelected
                    ? (selectedItemColor ?? colorScheme.primary)
                    : (unselectedItemColor ??
                        colorScheme.onSurface.withValues(alpha: 0.6)),
                size: 24,
              ),
              const SizedBox(height: 4),
              Text(
                item['label'] as String,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
                  color: isSelected
                      ? (selectedItemColor ?? colorScheme.primary)
                      : (unselectedItemColor ??
                          colorScheme.onSurface.withValues(alpha: 0.6)),
                ),
              ),
            ],
          ),
        ),
      );
    }).toList();
  }

  void _handleNavigation(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/daily-calendar-view');
        break;
      case 1:
        Navigator.pushNamed(context, '/weekly-calendar-view');
        break;
      case 2:
        Navigator.pushNamed(context, '/create-time-block');
        break;
      case 3:
        Navigator.pushNamed(context, '/edit-time-block');
        break;
    }
  }
}
