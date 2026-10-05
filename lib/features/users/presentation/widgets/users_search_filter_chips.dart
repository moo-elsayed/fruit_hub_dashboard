import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fruit_hub_dashboard/core/enums/user_search_by.dart';
import 'package:fruit_hub_dashboard/core/widgets/search_filter_chip.dart';

class UsersSearchFilterChips extends StatelessWidget {
  const UsersSearchFilterChips({
    super.key,
    required this.selectedSearchBy,
    required this.onSelected,
  });

  final UserSearchBy selectedSearchBy;
  final ValueChanged<UserSearchBy> onSelected;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    padding: EdgeInsets.symmetric(horizontal: 16.w),
    child: Row(
      spacing: 8.w,
      children: UserSearchBy.values.map((searchBy) {
        final isSelected = selectedSearchBy == searchBy;
        return SearchFilterChip(
          label: searchBy.label,
          icon: switch (searchBy) {
            UserSearchBy.name => Icons.person_outline_rounded,
            UserSearchBy.email => Icons.mail_outline_rounded,
            UserSearchBy.phone => Icons.phone_outlined,
          },
          isSelected: isSelected,
          onTap: () => onSelected(searchBy),
        );
      }).toList(),
    ),
  );
}
