import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fruit_hub_dashboard/core/enums/user_search_by.dart';
import 'package:fruit_hub_dashboard/core/helpers/app_strings.dart';
import 'package:fruit_hub_dashboard/core/helpers/di.dart';
import 'package:fruit_hub_dashboard/core/helpers/extensions.dart';
import 'package:fruit_hub_dashboard/core/widgets/custom_app_bar.dart';
import 'package:fruit_hub_dashboard/core/widgets/custom_keyboard_unfocus.dart';
import 'package:fruit_hub_dashboard/core/widgets/search_text_field.dart';

import '../managers/users_search_cubit/users_search_cubit.dart';
import '../widgets/users_search_empty_view.dart';
import '../widgets/users_search_filter_chips.dart';
import '../widgets/users_search_results_list.dart';
import '../widgets/users_skeleton_list.dart';

class UsersSearchView extends StatefulWidget {
  const UsersSearchView({super.key});

  @override
  State<UsersSearchView> createState() => _UsersSearchViewState();
}

class _UsersSearchViewState extends State<UsersSearchView> {
  late final TextEditingController _searchController;
  late final FocusNode _focusNode;
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _focusNode = FocusNode();
    Future.delayed(const Duration(milliseconds: 350), () {
      if (mounted) {
        _focusNode.requestFocus();
      }
    });
  }

  void _onSearchChanged(String? query, UsersSearchCubit cubit) {
    _debounceTimer?.cancel();
    final cleanQuery = query?.trim() ?? '';
    if (cleanQuery.isEmpty) {
      cubit.clearSearch();
      return;
    }
    _debounceTimer = Timer(const Duration(milliseconds: 350), () {
      cubit.searchUsers(cleanQuery);
    });
  }

  void _onClearSearch(UsersSearchCubit cubit) {
    _debounceTimer?.cancel();
    cubit.clearSearch();
  }

  void _onFilterSelected(UserSearchBy by, UsersSearchCubit cubit) {
    if (cubit.currentSearchBy == by) return;
    _debounceTimer?.cancel();
    _searchController.clear();
    cubit.setSearchBy(by);
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) => getIt.get<UsersSearchCubit>(),
    child: Builder(
      builder: (context) {
        final cubit = context.read<UsersSearchCubit>();
        return Scaffold(
          appBar: CustomAppBar(
            title: AppStrings.search,
            showArrowBack: true,
            onTap: () => context.pop(),
          ),
          body: CustomKeyboardUnfocus(
            child: Column(
              children: [
                SizedBox(height: 12.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Hero(
                    tag: 'search_bar_hero_tag',
                    child: Material(
                      color: Colors.transparent,
                      child: SearchTextField(
                        focusNode: _focusNode,
                        controller: _searchController,
                        hint: AppStrings.searchUsers,
                        onChanged: (query) => _onSearchChanged(query, cubit),
                        onClear: () => _onClearSearch(cubit),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 12.h),
                BlocBuilder<UsersSearchCubit, UsersSearchState>(
                  buildWhen: (previous, current) =>
                      previous.searchBy != current.searchBy,
                  builder: (context, state) => UsersSearchFilterChips(
                    selectedSearchBy: state.searchBy,
                    onSelected: (by) => _onFilterSelected(by, cubit),
                  ),
                ),
                SizedBox(height: 8.h),
                Expanded(
                  child: BlocBuilder<UsersSearchCubit, UsersSearchState>(
                    builder: (context, state) => switch (state) {
                      UsersSearchInitial() => UsersSearchEmptyView(
                        icon: Icons.search_rounded,
                        message: AppStrings.typeToSearchUsers,
                      ),
                      UsersSearchLoading() => const UsersSkeletonList(),
                      UsersSearchFailure(:final message) =>
                        UsersSearchEmptyView(
                          icon: Icons.error_outline_rounded,
                          message: message,
                        ),
                      UsersSearchSuccess(:final users) =>
                        users.isEmpty
                            ? UsersSearchEmptyView(
                                icon: Icons.person_off_outlined,
                                message: AppStrings.noSearchResultsFound,
                              )
                            : UsersSearchResultsList(users: users),
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ),
  );
}
