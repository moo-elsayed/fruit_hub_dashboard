import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fruit_hub_dashboard/core/helpers/extensions.dart';
import 'package:fruit_hub_dashboard/core/theming/app_text_styles.dart';
import 'package:gap/gap.dart';

class CustomSwitchContainer extends StatefulWidget {
  const CustomSwitchContainer({
    super.key,
    required this.onChanged,
    required this.text,
    required this.isChecked,
    this.icon,
  });

  final ValueChanged<bool> onChanged;
  final String text;
  final bool isChecked;
  final IconData? icon;

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

  void _toggle() {
    setState(() => _isChecked = !_isChecked);
    widget.onChanged(_isChecked);
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: _toggle,
    behavior: HitTestBehavior.opaque,
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: context.colors.surface,
        border: Border.all(
          color: _isChecked
              ? context.colors.primary.withValues(alpha: 0.5)
              : context.colors.border,
          width: 1.2,
        ),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.icon != null) ...[
                Icon(
                  widget.icon,
                  size: 18.sp,
                  color: _isChecked
                      ? context.colors.primary
                      : context.colors.subText,
                ),
                Gap(6.w),
              ],
              Text(
                widget.text,
                style: AppTextStyles.font13SemiBold.copyWith(
                  color: _isChecked
                      ? context.colors.primary
                      : context.colors.mainText,
                ),
              ),
            ],
          ),
          IgnorePointer(
            child: Transform.scale(
              scale: 0.8,
              child: CupertinoSwitch(
                activeTrackColor: context.colors.primary,
                inactiveTrackColor: context.colors.border,
                value: _isChecked,
                onChanged: null,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
