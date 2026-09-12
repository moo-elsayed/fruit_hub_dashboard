import 'package:flutter/material.dart';

class CustomBottomSheetSelectionItem<T> {
  const CustomBottomSheetSelectionItem({
    required this.title,
    this.subtitle,
    this.icon,
    this.value,
    this.isSelected = false,
    required this.onTap,
  });

  final String title;
  final String? subtitle;
  final IconData? icon;
  final T? value;
  final bool isSelected;
  final VoidCallback onTap;
}
