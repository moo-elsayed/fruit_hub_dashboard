import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fruit_hub_dashboard/core/helpers/extensions.dart';
import 'package:fruit_hub_dashboard/core/theming/app_text_styles.dart';

class LeaderboardRankBadge extends StatelessWidget {
  const LeaderboardRankBadge({super.key, required this.rank});

  final int rank;

  @override
  Widget build(BuildContext context) {
    if (rank == 1) {
      return Text('🥇', style: AppTextStyles.font18Bold);
    }
    if (rank == 2) {
      return Text('🥈', style: AppTextStyles.font18Bold);
    }
    if (rank == 3) {
      return Text('🥉', style: AppTextStyles.font18Bold);
    }

    return Container(
      width: 22.r,
      height: 22.r,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: context.colors.border.withValues(alpha: 0.5),
        shape: BoxShape.circle,
      ),
      child: Text(
        '$rank',
        style: AppTextStyles.font11Bold.copyWith(color: context.colors.subText),
      ),
    );
  }
}
