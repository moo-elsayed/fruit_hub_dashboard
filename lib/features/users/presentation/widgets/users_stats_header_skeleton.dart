import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../managers/users_cubit/users_cubit.dart';
import 'users_stats_header.dart';

class UsersStatsHeaderSkeleton extends StatelessWidget {
  const UsersStatsHeaderSkeleton({super.key});

  @override
  Widget build(BuildContext context) => const Skeletonizer(
    enabled: true,
    child: UsersStatsHeader(
      totalCount: 88,
      verifiedCount: 44,
      activeCartCount: 22,
      activeFilter: UserFilterType.all,
      onSelectFilter: _noop,
    ),
  );

  static void _noop(UserFilterType _) {}
}
