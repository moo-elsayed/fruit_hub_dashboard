import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fruit_hub_dashboard/core/theming/app_colors.dart';
import 'package:fruit_hub_dashboard/core/theming/app_text_styles.dart';

class CustomSwitchContainer extends StatefulWidget {
  const CustomSwitchContainer({
    super.key,
    required this.onChanged,
    required this.text,
  });

  final ValueChanged<bool> onChanged;
  final String text;

  @override
  State<CustomSwitchContainer> createState() => _CustomSwitchContainerState();
}

class _CustomSwitchContainerState extends State<CustomSwitchContainer> {
  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        border: Border.all(color: buildColor(_isChecked)),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(widget.text, style: buildTextStyle(_isChecked)),
          SizedBox(
            width: 53.w,
            child: CupertinoSwitch(
              activeTrackColor: Colors.green,
              inactiveTrackColor: Colors.grey,
              value: _isChecked,
              onChanged: (value) {
                setState(() {
                  _isChecked = value;
                });
                widget.onChanged(value);
              },
            ),
          ),
        ],
      ),
    );
  }

  Color buildColor(bool isChecked) =>
      isChecked ? AppColors.color2D9F5D : AppColors.color949D9E;

  TextStyle buildTextStyle(bool isChecked) => isChecked
      ? AppTextStyles.font13color2D9F5DSemiBold
      : AppTextStyles.font13color949D9ESemiBold;
}
