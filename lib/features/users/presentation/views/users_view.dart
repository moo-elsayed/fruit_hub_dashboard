import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fruit_hub_dashboard/core/helpers/app_strings.dart';
import 'package:fruit_hub_dashboard/core/helpers/di.dart';
import 'package:fruit_hub_dashboard/core/helpers/extensions.dart';
import 'package:fruit_hub_dashboard/core/routing/routes.dart';
import 'package:fruit_hub_dashboard/core/theming/app_text_styles.dart';
import 'package:fruit_hub_dashboard/core/widgets/custom_app_bar.dart';
import 'package:fruit_hub_dashboard/core/widgets/custom_keyboard_unfocus.dart';
import 'package:fruit_hub_dashboard/core/widgets/search_text_field.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../managers/users_cubit/users_cubit.dart';
import '../widgets/user_card_item.dart';
import '../widgets/users_empty_state.dart';
import '../widgets/users_skeleton_list.dart';
import '../widgets/users_stats_header.dart';
import '../widgets/users_stats_header_skeleton.dart';

class UsersView extends StatefulWidget {
  const UsersView({super.key});

  @override
  State<UsersView> createState() => _UsersViewState();
}

class _UsersViewState extends State<UsersView> {
  late final ScrollController _scrollController;
  UsersCubit? _cubit;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _cubit?.loadMoreUsers();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (context) {
      final cubit = getIt.get<UsersCubit>()..initUsers();
      _cubit = cubit;
      return cubit;
    },
    child: Builder(
      builder: (context) => Scaffold(
        appBar: CustomAppBar(
          title: AppStrings.users,
          showArrowBack: true,
          onTap: () => context.pop(),
        ),
        body: CustomKeyboardUnfocus(
          child: Column(
            children: [
              SizedBox(height: 12.h),
              BlocBuilder<UsersCubit, UsersState>(
                buildWhen: (_, current) =>
                    current is UsersSuccess || current is UsersLoading,
                builder: (context, state) {
                  final cubit = context.read<UsersCubit>();
                  if (state is UsersSuccess) {
                    return UsersStatsHeader(
                      totalCount: state.totalCount,
                      verifiedCount: state.verifiedCount,
                      activeCartCount: state.activeCartCount,
                      activeFilter: state.activeFilter,
                      onSelectFilter: (filter) => cubit.setFilter(filter),
                    );
                  } else if (cubit.totalCount > 0) {
                    return UsersStatsHeader(
                      totalCount: cubit.totalCount,
                      verifiedCount: cubit.verifiedCount,
                      activeCartCount: cubit.activeCartCount,
                      activeFilter: cubit.activeFilter,
                      onSelectFilter: (filter) => cubit.setFilter(filter),
                    );
                  }
                  return const UsersStatsHeaderSkeleton();
                },
              ),
              SizedBox(height: 12.h),
              BlocBuilder<UsersCubit, UsersState>(
                buildWhen: (previous, current) =>
                    (previous is UsersLoading) != (current is UsersLoading),
                builder: (context, state) {
                  final isLoading = state is UsersLoading;
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Skeletonizer(
                      enabled: isLoading,
                      child: Hero(
                        tag: 'search_bar_hero_tag',
                        child: Material(
                          color: Colors.transparent,
                          child: SearchTextField(
                            readOnly: true,
                            enabled: !isLoading,
                            hint: AppStrings.searchUsers,
                            onTap: isLoading
                                ? null
                                : () =>
                                      context.pushNamed(Routes.usersSearchView),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 4.h),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () => context.read<UsersCubit>().initUsers(),
                  child: BlocBuilder<UsersCubit, UsersState>(
                    builder: (context, state) {
                      if (state is UsersLoading) {
                        return const UsersSkeletonList();
                      }

                      if (state is UsersFailure) {
                        return Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 48.h),
                            child: Text(
                              state.message,
                              style: AppTextStyles.font14Regular.copyWith(
                                color: context.colors.error,
                              ),
                            ),
                          ),
                        );
                      }

                      if (state is UsersSuccess) {
                        final users = state.users;
                        if (users.isEmpty) {
                          return const UsersEmptyState();
                        }

                        final hasLoadingFooter = state.isLoadingMore;
                        return ListView.separated(
                          controller: _scrollController,
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 6.h,
                          ),
                          itemCount: users.length + (hasLoadingFooter ? 1 : 0),
                          separatorBuilder: (_, _) => SizedBox(height: 10.h),
                          itemBuilder: (context, index) {
                            if (index >= users.length) {
                              return Padding(
                                padding: EdgeInsets.symmetric(vertical: 16.h),
                                child: const Center(
                                  child: CupertinoActivityIndicator(),
                                ),
                              );
                            }

                            final user = users[index];
                            return UserCardItem(
                              user: user,
                              onTap: () => context.pushNamed(
                                Routes.userDetailsView,
                                arguments: user,
                              ),
                            );
                          },
                        );
                      }

                      return const SizedBox.shrink();
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
