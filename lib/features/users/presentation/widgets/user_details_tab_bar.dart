import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fruit_hub_dashboard/core/helpers/app_strings.dart';
import 'package:fruit_hub_dashboard/core/helpers/extensions.dart';
import 'package:fruit_hub_dashboard/core/theming/app_palette.dart';
import 'package:fruit_hub_dashboard/core/theming/app_text_styles.dart';

class UserDetailsTabBar extends StatelessWidget {
  const UserDetailsTabBar({
    super.key,
    required this.tabController,
    required this.cartItemsCount,
    required this.favoritesCount,
  });

  final TabController tabController;
  final int cartItemsCount;
  final int favoritesCount;

  @override
  Widget build(BuildContext context) => SliverAppBar(
    pinned: true,
    primary: false,
    automaticallyImplyLeading: false,
    backgroundColor: context.colors.background,
    elevation: 0,
    scrolledUnderElevation: 0,
    toolbarHeight: 0,
    bottom: PreferredSize(
      preferredSize: Size.fromHeight(50.h),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: context.colors.surface,
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(color: context.colors.border),
          ),
          child: TabBar(
            controller: tabController,
            dividerColor: Colors.transparent,
            padding: EdgeInsets.all(3.w),
            labelPadding: EdgeInsets.symmetric(horizontal: 4.w),
            indicatorSize: TabBarIndicatorSize.tab,
            indicator: BoxDecoration(
              color: context.colors.primary,
              borderRadius: BorderRadius.circular(7.r),
            ),
            labelColor: AppPalette.white,
            unselectedLabelColor: context.colors.subText,
            labelStyle: AppTextStyles.font12SemiBold,
            unselectedLabelStyle: AppTextStyles.font12Regular,
            tabs: [
              Tab(
                height: 34.h,
                text: '${AppStrings.cartItems} ($cartItemsCount)',
              ),
              Tab(
                height: 34.h,
                text: '${AppStrings.favorites} ($favoritesCount)',
              ),
              Tab(height: 34.h, text: AppStrings.notifications),
            ],
          ),
        ),
      ),
    ),
  );
}
