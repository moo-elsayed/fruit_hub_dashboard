import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../core/theming/app_colors.dart';
import '../../../../generated/assets.dart';

class CustomCheckBox extends StatefulWidget {
  const CustomCheckBox({super.key, required this.onChanged});

  final ValueChanged<bool> onChanged;

  @override
  State<CustomCheckBox> createState() => _CustomCheckBoxState();
}

class _CustomCheckBoxState extends State<CustomCheckBox> {
  bool _value = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _value = !_value;
        widget.onChanged(_value);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        width: 24.w,
        height: 24.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color: !_value ? AppColors.colorDDDFDF : AppColors.color1B5E37,
            width: 1.5,
          ),
          color: _value ? AppColors.color1B5E37 : Colors.white,
        ),
        child: _value
            ? Center(
                child: SvgPicture.asset(
                  Assets.iconsCheck,
                  width: 16.w,
                  height: 16.h,
                ),
              )
            : null,
      ),
    );
  }
}
