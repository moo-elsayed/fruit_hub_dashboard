import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BottomSheetSelectionItemEntity {
  const BottomSheetSelectionItemEntity({
    required this.title,
    this.isSelected = false,
    required this.onTap,
    required this.color,
  });

  final String title;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;
}
