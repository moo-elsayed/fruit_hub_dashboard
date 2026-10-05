import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fruit_hub_dashboard/core/helpers/extensions.dart';
import 'package:fruit_hub_dashboard/core/routing/routes.dart';

import '../../domain/entities/app_user_entity.dart';
import 'user_card_item.dart';

class UsersSearchResultsList extends StatelessWidget {
  const UsersSearchResultsList({super.key, required this.users});

  final List<AppUserEntity> users;

  @override
  Widget build(BuildContext context) => ListView.separated(
    padding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 12.h),
    itemCount: users.length,
    separatorBuilder: (context, index) => SizedBox(height: 8.h),
    itemBuilder: (context, index) {
      final user = users[index];
      return UserCardItem(
        user: user,
        onTap: () => context.pushNamed(Routes.userDetailsView, arguments: user),
      );
    },
  );
}
