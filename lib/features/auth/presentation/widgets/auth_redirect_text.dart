import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../../../../core/theming/app_text_styles.dart';

class AuthRedirectText extends StatelessWidget {
  const AuthRedirectText({
    super.key,
    this.onTap,
    required this.question,
    required this.action,
  });

  final String question;
  final String action;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: question,
            style: AppTextStyles.font16color949D9ESemiBold,
          ),
          const TextSpan(text: ' '),
          TextSpan(
            text: action,
            style: AppTextStyles.font16color1B5E37ESemiBold,
            recognizer: TapGestureRecognizer()..onTap = onTap,
          ),
        ],
      ),
    );
  }
}
