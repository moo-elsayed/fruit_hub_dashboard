import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fruit_hub_dashboard/core/helpers/app_strings.dart';
import 'package:fruit_hub_dashboard/core/theming/app_palette.dart';
import 'package:fruit_hub_dashboard/core/utils/stat_filter_tab_item.dart';
import 'package:fruit_hub_dashboard/core/widgets/stat_filter_tab.dart';

import '../managers/users_cubit/users_cubit.dart';

class UsersStatsHeader extends StatelessWidget {
  const UsersStatsHeader({
    super.key,
    required this.totalCount,
    required this.verifiedCount,
    required this.activeCartCount,
    required this.activeFilter,
    required this.onSelectFilter,
  });

  final int totalCount;
  final int verifiedCount;
  final int activeCartCount;
  final UserFilterType activeFilter;
  final ValueChanged<UserFilterType> onSelectFilter;

  List<StatFilterTabItem> get _items => [
    StatFilterTabItem(
      title: AppStrings.all,
      count: totalCount,
      icon: Icons.people_alt_rounded,
      color: AppPalette.info,
      isSelected: activeFilter == UserFilterType.all,
      onTap: () => onSelectFilter(UserFilterType.all),
    ),
    StatFilterTabItem(
      title: AppStrings.verifiedUsers,
      count: verifiedCount,
      icon: Icons.verified_rounded,
      color: AppPalette.accentGreen,
      isSelected: activeFilter == UserFilterType.verified,
      onTap: () => onSelectFilter(UserFilterType.verified),
    ),
    StatFilterTabItem(
      title: AppStrings.activeCarts,
      count: activeCartCount,
      icon: Icons.shopping_cart_rounded,
      color: AppPalette.secondaryOrange,
      isSelected: activeFilter == UserFilterType.withCart,
      onTap: () => onSelectFilter(UserFilterType.withCart),
    ),
  ];

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    padding: EdgeInsets.symmetric(horizontal: 16.w),
    child: Row(
      spacing: 8.w,
      children: _items.map((item) => StatFilterTab(item: item)).toList(),
    ),
  );
}
