import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../domain/entities/dashboard_user_entity.dart';
import 'user_card_item.dart';

class UsersSkeletonList extends StatelessWidget {
  const UsersSkeletonList({super.key, this.itemCount = 6});

  final int itemCount;

  static const _dummyUser = DashboardUserEntity(
    name: 'محمد أحمد السيد',
    email: 'user.email@example.com',
    phone: '01012345678',
    uid: '',
  );

  @override
  Widget build(BuildContext context) => Skeletonizer(
    enabled: true,
    child: ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      itemCount: itemCount,
      separatorBuilder: (_, _) => SizedBox(height: 10.h),
      itemBuilder: (_, _) => UserCardItem(user: _dummyUser, onTap: () {}),
    ),
  );
}
