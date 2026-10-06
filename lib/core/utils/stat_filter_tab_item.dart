import 'package:flutter/widgets.dart';

class StatFilterTabItem {
  const StatFilterTabItem({
    required this.title,
    required this.count,
    required this.icon,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  final String title;
  final int count;
  final IconData icon;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;
}
