import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theming/app_text_styles.dart';
import 'custom_check_box.dart';

class TermsAndConditions extends StatefulWidget {
  const TermsAndConditions({super.key, required this.onChanged});

  final ValueChanged<bool> onChanged;

  @override
  State<TermsAndConditions> createState() => _TermsAndConditionsState();
}

class _TermsAndConditionsState extends State<TermsAndConditions> {
  @override
  Widget build(BuildContext context) => Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 16.w,
      children: [
        CustomCheckBox(onChanged: widget.onChanged),
        Expanded(
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'By creating an account, you agree to',
                  style: AppTextStyles.font13color949D9ESemiBold,
                ),
                const TextSpan(text: ' '),
                TextSpan(
                  text: 'Our Terms and Conditions',
                  style: AppTextStyles.font13color2D9F5DSemiBold,
                ),
              ],
            ),
          ),
        ),
      ],
    );
}
