import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fruit_hub_dashboard/core/helpers/app_strings.dart';
import 'package:fruit_hub_dashboard/core/helpers/di.dart';
import 'package:fruit_hub_dashboard/core/helpers/extensions.dart';
import 'package:fruit_hub_dashboard/core/widgets/custom_app_bar.dart';

import '../../domain/entities/dashboard_user_entity.dart';
import '../managers/user_notifications_cubit/user_notifications_cubit.dart';
import '../widgets/send_notification_bottom_sheet.dart';
import '../widgets/user_cart_items_list.dart';
import '../widgets/user_details_tab_bar.dart';
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
  late final ScrollController _scrollController;

  static const int _scrollThreshold = 7;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  bool _isTabScrollable(int index, int notificationsCount) => switch (index) {
    0 => widget.user.cartItems.length > _scrollThreshold,
    1 => widget.user.favoriteIds.length > _scrollThreshold,
    2 => notificationsCount > _scrollThreshold,
    _ => false,
  };

  void _resetHeaderOffsetIfNeeded(bool isScrollable) {
    if (!isScrollable &&
        _scrollController.hasClients &&
        _scrollController.offset > 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients && _scrollController.offset > 0) {
          _scrollController.animateTo(
            0,
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOut,
          );
        }
      });
    }
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
        body: BlocBuilder<UserNotificationsCubit, UserNotificationsState>(
          buildWhen: (previous, current) =>
              current is UserNotificationsSuccess ||
              current is UserNotificationsLoading,
          builder: (context, state) {
            final notificationsCount = state is UserNotificationsSuccess
                ? state.notifications.length
                : 0;

            return ListenableBuilder(
              listenable: _tabController,
              builder: (context, _) {
                final isScrollable = _isTabScrollable(
                  _tabController.index,
                  notificationsCount,
                );
                _resetHeaderOffsetIfNeeded(isScrollable);

                final scrollPhysics = isScrollable
                    ? const ClampingScrollPhysics()
                    : const NeverScrollableScrollPhysics();

                final isCartScrollable =
                    widget.user.cartItems.length > _scrollThreshold;
                final isFavoritesScrollable =
                    widget.user.favoriteIds.length > _scrollThreshold;
                final isNotificationsScrollable =
                    notificationsCount > _scrollThreshold;

                return NestedScrollView(
                  controller: _scrollController,
                  physics: scrollPhysics,
                  headerSliverBuilder: (context, innerBoxIsScrolled) => [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 8.h),
                        child: UserProfileHeader(
                          user: widget.user,
                          onSendNotification: () =>
                              SendNotificationBottomSheet.show(
                                context,
                                userId: widget.user.uid,
                                userName: widget.user.name,
                                cubit: context.read<UserNotificationsCubit>(),
                              ),
                        ),
                      ),
                    ),
                    UserDetailsTabBar(
                      tabController: _tabController,
                      cartItemsCount: widget.user.cartItems.length,
                      favoritesCount: widget.user.favoriteIds.length,
                    ),
                  ],
                  body: TabBarView(
                    controller: _tabController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      UserCartItemsList(
                        cartItems: widget.user.cartItems,
                        physics: isCartScrollable
                            ? const ClampingScrollPhysics()
                            : const NeverScrollableScrollPhysics(),
                      ),
                      UserFavoritesList(
                        favoriteIds: widget.user.favoriteIds,
                        physics: isFavoritesScrollable
                            ? const ClampingScrollPhysics()
                            : const NeverScrollableScrollPhysics(),
                      ),
                      UserNotificationsList(
                        physics: isNotificationsScrollable
                            ? const ClampingScrollPhysics()
                            : const NeverScrollableScrollPhysics(),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    ),
  );
}
