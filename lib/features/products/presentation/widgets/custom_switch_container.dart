import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fruit_hub_dashboard/core/helpers/extensions.dart';
import 'package:fruit_hub_dashboard/core/theming/app_text_styles.dart';

class CustomSwitchContainer extends StatefulWidget {
  const CustomSwitchContainer({
    super.key,
    required this.onChanged,
    required this.text,
    required this.isChecked,
  });

  final ValueChanged<bool> onChanged;
  final String text;
  final bool isChecked;

  @override
  State<CustomSwitchContainer> createState() => _CustomSwitchContainerState();
}

class _CustomSwitchContainerState extends State<CustomSwitchContainer> {
  late bool _isChecked;

  @override
  void initState() {
    super.initState();
    _isChecked = widget.isChecked;
  }

  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
    decoration: BoxDecoration(
      border: Border.all(
        color: _isChecked ? context.colors.primary : context.colors.border,
      ),
      borderRadius: BorderRadius.circular(8.r),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          widget.text,
          style: AppTextStyles.font13SemiBold.copyWith(
            color: _isChecked ? context.colors.primary : context.colors.subText,
          ),
        ),
        SizedBox(
          width: 53.w,
          child: CupertinoSwitch(
            activeTrackColor: context.colors.primary,
            inactiveTrackColor: context.colors.border,
            value: _isChecked,
            onChanged: (value) {
              setState(() => _isChecked = value);
              widget.onChanged(value);
            },
          ),
        ),
      ],
    ),
  );
}
