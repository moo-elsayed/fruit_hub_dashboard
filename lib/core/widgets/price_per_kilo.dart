import 'package:flutter/material.dart';
import '../helpers/functions.dart';
import '../theming/app_text_styles.dart';

class PricePerKilo extends StatelessWidget {
  const PricePerKilo({super.key, required this.price});

  final double price;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: "${getPrice(price)} pounds",
            style: AppTextStyles.font13colorF4A91FSemiBold,
          ),
          TextSpan(
            text: " / kilo",
            style: AppTextStyles.font13colorF8C76DSemiBold,
          ),
        ],
      ),
    );
  }
}
