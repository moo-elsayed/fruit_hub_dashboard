import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fruit_hub_dashboard/core/helpers/app_strings.dart';
import 'package:fruit_hub_dashboard/core/helpers/di.dart';
import 'package:fruit_hub_dashboard/core/helpers/extensions.dart';
import 'package:fruit_hub_dashboard/core/theming/app_text_styles.dart';
import 'package:fruit_hub_dashboard/core/widgets/custom_app_bar.dart';

import '../../domain/entities/dashboard_user_entity.dart';
import '../managers/user_notifications_cubit/user_notifications_cubit.dart';
import '../widgets/send_notification_bottom_sheet.dart';
import '../widgets/user_cart_items_list.dart';
import '../widgets/user_favorites_list.dart';
import '../widgets/user_notifications_list.dart';
import '../widgets/user_profile_header.dart';

class UserDetailsView extends StatefulWidget {
  const UserDetailsView({super.key, required this.user});

  final DashboardUserEntity user;

  @override
  State<UserDetailsView> createState() => _UserDetailsViewState();
}

class _UserDetailsViewState extends State<UserDetailsView>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) =>
        getIt.get<UserNotificationsCubit>()
          ..getUserNotifications(widget.user.uid),
    child: Builder(
      builder: (context) => Scaffold(
        appBar: CustomAppBar(
          title: AppStrings.userDetails,
          showArrowBack: true,
          onTap: () => context.pop(),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Column(
            spacing: 16.h,
            children: [
              UserProfileHeader(
                user: widget.user,
                onSendNotification: () => SendNotificationBottomSheet.show(
                  context,
                  userId: widget.user.uid,
                  userName: widget.user.name,
                  cubit: context.read<UserNotificationsCubit>(),
                ),
              ),
              DecoratedBox(
                decoration: BoxDecoration(
                  color: context.colors.surface,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: context.colors.border),
                ),
                child: TabBar(
                  controller: _tabController,
                  indicatorColor: context.colors.primary,
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelColor: context.colors.primary,
                  unselectedLabelColor: context.colors.subText,
                  labelStyle: AppTextStyles.font13SemiBold,
                  unselectedLabelStyle: AppTextStyles.font13Regular,
                  tabs: [
                    Tab(
                      text:
                          '${AppStrings.cartItems} (${widget.user.cartItems.length})',
                    ),
                    Tab(
                      text:
                          '${AppStrings.favorites} (${widget.user.favoriteIds.length})',
                    ),
                    const Tab(text: AppStrings.notifications),
                  ],
                ),
              ),
              AnimatedBuilder(
                animation: _tabController,
                builder: (context, _) => switch (_tabController.index) {
                  0 => UserCartItemsList(cartItems: widget.user.cartItems),
                  1 => UserFavoritesList(favoriteIds: widget.user.favoriteIds),
                  2 => const UserNotificationsList(),
                  _ => const SizedBox.shrink(),
                },
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
