import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fruit_hub_dashboard/core/theming/app_text_styles.dart';
import 'custom_check_box.dart';

class FeaturedWidget extends StatefulWidget {
  const FeaturedWidget({super.key, required this.onChanged});

  final ValueChanged<bool> onChanged;

  @override
  State<FeaturedWidget> createState() => _FeaturedWidgetState();
}

class _FeaturedWidgetState extends State<FeaturedWidget> {
  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 16.w,
      children: [
        CustomCheckBox(
          onChanged: (value) {
            setState(() {
              _isChecked = value;
            });
            widget.onChanged(value);
          },
        ),
        Text(
          "Featured",
          style: _isChecked
              ? AppTextStyles.font13color2D9F5DSemiBold
              : AppTextStyles.font13color949D9ESemiBold,
        ),
      ],
    );
  }
}
