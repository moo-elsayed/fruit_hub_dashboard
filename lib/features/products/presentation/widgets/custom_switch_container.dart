import 'package:flutter/material.dart';
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
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      decoration: BoxDecoration(
        color: context.colors.surface,
        border: Border.all(
          color: _isChecked ? context.colors.primary : context.colors.border,
          width: 1.2,
        ),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
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
          Expanded(
            child: Text(
              widget.text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.font13SemiBold.copyWith(
                color: _isChecked
                    ? context.colors.primary
                    : context.colors.mainText,
              ),
            ),
          ),
          Gap(6.w),
          IgnorePointer(
            child: SizedBox(
              height: 42.h,
              width: 50.w,
              child: FittedBox(
                fit: BoxFit.contain,
                child: Switch.adaptive(
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  activeThumbColor: context.colors.primary,
                  activeTrackColor: context.colors.primary,
                  trackOutlineColor: WidgetStatePropertyAll(
                    context.colors.border,
                  ),
                  value: _isChecked,
                  onChanged: null,
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
