import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fruit_hub_dashboard/core/helpers/extensions.dart';
import 'package:fruit_hub_dashboard/core/routing/routes.dart';

import '../../domain/entities/dashboard_user_entity.dart';
import 'user_card_item.dart';

class UsersSearchResultsList extends StatelessWidget {
  const UsersSearchResultsList({super.key, required this.users});

  final List<DashboardUserEntity> users;

  @override
  Widget build(BuildContext context) => ListView.separated(
    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
    itemCount: users.length,
    separatorBuilder: (context, index) => SizedBox(height: 10.h),
    itemBuilder: (context, index) {
      final user = users[index];
      return UserCardItem(
        user: user,
        onTap: () => context.pushNamed(Routes.userDetailsView, arguments: user),
      );
    },
  );
}
