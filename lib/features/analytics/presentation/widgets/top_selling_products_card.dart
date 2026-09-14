import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fruit_hub_dashboard/core/helpers/app_strings.dart';
import 'package:fruit_hub_dashboard/core/helpers/extensions.dart';
import 'package:fruit_hub_dashboard/core/theming/app_palette.dart';
import 'package:fruit_hub_dashboard/core/theming/app_text_styles.dart';
import 'package:fruit_hub_dashboard/core/widgets/custom_network_image.dart';
import 'package:fruit_hub_dashboard/features/analytics/domain/entities/top_product_entity.dart';

import 'analytics_empty_state_card.dart';
import 'leaderboard_rank_badge.dart';

class TopSellingProductsCard extends StatelessWidget {
  const TopSellingProductsCard({super.key, required this.topProducts});

  final List<TopProductEntity> topProducts;

  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.all(16.r),
    decoration: BoxDecoration(
      color: context.colors.surface,
      borderRadius: BorderRadius.circular(16.r),
      border: Border.all(color: context.colors.border),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 16.h,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppStrings.topSellingProducts,
              style: AppTextStyles.font15Bold.copyWith(
                color: context.colors.mainText,
              ),
            ),
            Text(
              '${topProducts.length} ${AppStrings.products}',
              style: AppTextStyles.font12Medium.copyWith(
                color: context.colors.subText,
              ),
            ),
          ],
        ),
        if (topProducts.isEmpty)
          const AnalyticsEmptyStateCard()
        else
          ListView.separated(
            itemCount: topProducts.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            separatorBuilder: (context, index) =>
                Divider(color: context.colors.border, height: 16.h),
            itemBuilder: (context, index) => _ProductLeaderboardItem(
              rank: index + 1,
              product: topProducts[index],
            ),
          ),
      ],
    ),
  );
}

class _ProductLeaderboardItem extends StatelessWidget {
  const _ProductLeaderboardItem({required this.rank, required this.product});

  final int rank;
  final TopProductEntity product;

  @override
  Widget build(BuildContext context) => Row(
    spacing: 10.w,
    children: [
      LeaderboardRankBadge(rank: rank),
      ClipRRect(
        borderRadius: BorderRadius.circular(8.r),
        child: SizedBox(
          width: 44.r,
          height: 44.r,
          child: CustomNetworkImage(
            image: product.imagePath,
            fit: BoxFit.cover,
          ),
        ),
      ),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 2.h,
          children: [
            Text(
              product.name,
              style: AppTextStyles.font13Medium.copyWith(
                color: context.colors.mainText,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              '#${product.code}',
              style: AppTextStyles.font11Regular.copyWith(
                color: context.colors.subText,
              ),
            ),
          ],
        ),
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        spacing: 2.h,
        children: [
          Text(
            '${product.totalRevenue.toStringAsFixed(0)} ${AppStrings.pounds}',
            style: AppTextStyles.font13Bold.copyWith(
              color: AppPalette.primaryGreen,
            ),
          ),
          Text(
            '${product.totalQuantitySold} ${AppStrings.soldUnits}',
            style: AppTextStyles.font10Regular.copyWith(
              color: context.colors.subText.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    ],
  );
}
