import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fruit_hub_dashboard/core/cubits/app_language_cubit.dart';
import 'package:fruit_hub_dashboard/core/helpers/app_strings.dart';
import 'package:fruit_hub_dashboard/core/helpers/extensions.dart';
import 'package:fruit_hub_dashboard/core/theming/app_palette.dart';
import 'package:fruit_hub_dashboard/core/theming/app_text_styles.dart';
import 'package:fruit_hub_dashboard/core/theming/app_theme_cubit.dart';
import 'package:fruit_hub_dashboard/core/utils/custom_bottom_sheet_selection_item.dart';
import 'package:fruit_hub_dashboard/core/widgets/custom_bottom_sheet.dart';
import 'package:gap/gap.dart';

class SettingsPreferencesCard extends StatelessWidget {
  const SettingsPreferencesCard({super.key});

  String _themeLabel(ThemeMode mode) => switch (mode) {
    ThemeMode.light => AppStrings.light,
    ThemeMode.dark => AppStrings.dark,
    ThemeMode.system => AppStrings.system,
  };

  List<CustomBottomSheetSelectionItem<String>> _getLanguageItems(
    BuildContext context,
  ) => [
    CustomBottomSheetSelectionItem<String>(
      title: AppStrings.arabic,
      icon: Icons.language_rounded,
      value: 'ar',
      isSelected: context.isArabic,
      onTap: () {
        context.read<AppLanguageCubit>().changeLanguage('ar');
      },
    ),
    CustomBottomSheetSelectionItem<String>(
      title: AppStrings.english,
      icon: Icons.language_rounded,
      value: 'en',
      isSelected: !context.isArabic,
      onTap: () {
        context.read<AppLanguageCubit>().changeLanguage('en');
      },
    ),
  ];

  List<CustomBottomSheetSelectionItem<ThemeMode>> _getThemeItems(
    BuildContext context,
  ) {
    final currentTheme = context.read<AppThemeCubit>().state;
    return [
      CustomBottomSheetSelectionItem<ThemeMode>(
        title: AppStrings.light,
        icon: Icons.wb_sunny_outlined,
        value: ThemeMode.light,
        isSelected: currentTheme == ThemeMode.light,
        onTap: () {
          context.read<AppThemeCubit>().changeTheme(ThemeMode.light);
        },
      ),
      CustomBottomSheetSelectionItem<ThemeMode>(
        title: AppStrings.dark,
        icon: Icons.nightlight_round_outlined,
        value: ThemeMode.dark,
        isSelected: currentTheme == ThemeMode.dark,
        onTap: () {
          context.read<AppThemeCubit>().changeTheme(ThemeMode.dark);
        },
      ),
      CustomBottomSheetSelectionItem<ThemeMode>(
        title: AppStrings.system,
        icon: Icons.brightness_auto_outlined,
        value: ThemeMode.system,
        isSelected: currentTheme == ThemeMode.system,
        onTap: () {
          context.read<AppThemeCubit>().changeTheme(ThemeMode.system);
        },
      ),
    ];
  }

  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
    decoration: BoxDecoration(
      color: context.colors.surface,
      borderRadius: BorderRadius.circular(16.r),
      border: Border.all(color: context.colors.border, width: 1),
      boxShadow: [
        BoxShadow(
          color: AppPalette.black.withValues(alpha: 0.04),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Column(
      children: [
        _PreferenceTile(
          icon: Icons.language_rounded,
          title: AppStrings.language,
          trailingText: context.isArabic
              ? AppStrings.arabic
              : AppStrings.english,
          onTap: () => CustomBottomSheet.show(
            context: context,
            title: AppStrings.selectLanguage,
            items: _getLanguageItems(context),
          ),
        ),
        Divider(
          height: 1,
          thickness: 1,
          color: context.colors.border.withValues(alpha: 0.6),
        ),
        BlocBuilder<AppThemeCubit, ThemeMode>(
          builder: (context, themeMode) => _PreferenceTile(
            icon: Icons.color_lens_outlined,
            title: AppStrings.theme,
            trailingText: _themeLabel(themeMode),
            onTap: () => CustomBottomSheet.show(
              context: context,
              title: AppStrings.theme,
              items: _getThemeItems(context),
            ),
          ),
        ),
      ],
    ),
  );
}

class _PreferenceTile extends StatelessWidget {
  const _PreferenceTile({
    required this.icon,
    required this.title,
    required this.trailingText,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String trailingText;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(12.r),
    child: Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 4.w),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: context.colors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(icon, size: 20.sp, color: context.colors.primary),
          ),
          Gap(14.w),
          Expanded(
            child: Text(
              title,
              style: AppTextStyles.font14Medium.copyWith(
                color: context.colors.mainText,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Text(
            trailingText,
            style: AppTextStyles.font13Regular.copyWith(
              color: context.colors.subText,
            ),
          ),
          Gap(8.w),
          Icon(
            Icons.arrow_forward_ios_rounded,
            size: 14.sp,
            color: context.colors.subText,
          ),
        ],
      ),
    ),
  );
}
