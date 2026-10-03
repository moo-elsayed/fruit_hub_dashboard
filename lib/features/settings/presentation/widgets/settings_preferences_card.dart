import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fruit_hub_dashboard/core/cubits/app_language_cubit.dart';
import 'package:fruit_hub_dashboard/core/helpers/app_strings.dart';
import 'package:fruit_hub_dashboard/core/helpers/extensions.dart';
import 'package:fruit_hub_dashboard/core/theming/app_palette.dart';
import 'package:fruit_hub_dashboard/core/theming/app_theme_cubit.dart';
import 'package:fruit_hub_dashboard/core/utils/custom_bottom_sheet_selection_item.dart';
import 'package:fruit_hub_dashboard/core/widgets/custom_bottom_sheet.dart';
import 'package:fruit_hub_dashboard/features/settings/presentation/widgets/settings_preference_tile.dart';

class SettingsPreferencesCard extends StatelessWidget {
  const SettingsPreferencesCard({super.key});

  void _showLanguageBottomSheet(BuildContext context) {
    final isArabic = context.isArabic;
    CustomBottomSheet.show(
      context: context,
      title: AppStrings.selectLanguage,
      items: [
        CustomBottomSheetSelectionItem<String>(
          title: AppStrings.arabic,
          icon: Icons.language_rounded,
          value: 'ar',
          isSelected: isArabic,
          onTap: () => context.read<AppLanguageCubit>().changeLanguage('ar'),
        ),
        CustomBottomSheetSelectionItem<String>(
          title: AppStrings.english,
          icon: Icons.language_rounded,
          value: 'en',
          isSelected: !isArabic,
          onTap: () => context.read<AppLanguageCubit>().changeLanguage('en'),
        ),
      ],
    );
  }

  void _showThemeBottomSheet(BuildContext context, ThemeMode currentTheme) {
    final themeOptions = [
      (ThemeMode.light, AppStrings.light, Icons.wb_sunny_outlined),
      (ThemeMode.dark, AppStrings.dark, Icons.nightlight_round_outlined),
      (ThemeMode.system, AppStrings.system, Icons.brightness_auto_outlined),
    ];

    CustomBottomSheet.show(
      context: context,
      title: AppStrings.theme,
      items: [
        for (final (mode, title, icon) in themeOptions)
          CustomBottomSheetSelectionItem<ThemeMode>(
            title: title,
            icon: icon,
            value: mode,
            isSelected: currentTheme == mode,
            onTap: () => context.read<AppThemeCubit>().changeTheme(mode),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
    decoration: BoxDecoration(
      color: context.colors.surface,
      borderRadius: BorderRadius.circular(16.r),
      border: Border.all(color: context.colors.border),
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
        SettingsPreferenceTile(
          icon: Icons.language_rounded,
          title: AppStrings.language,
          trailingText: context.isArabic
              ? AppStrings.arabic
              : AppStrings.english,
          onTap: () => _showLanguageBottomSheet(context),
        ),
        Divider(
          height: 1,
          thickness: 1,
          endIndent: 4.w,
          indent: 4.w,
          color: context.colors.border.withValues(alpha: 0.6),
        ),
        BlocBuilder<AppThemeCubit, ThemeMode>(
          builder: (context, themeMode) => SettingsPreferenceTile(
            icon: Icons.color_lens_outlined,
            title: AppStrings.theme,
            trailingText: themeMode.label,
            onTap: () => _showThemeBottomSheet(context, themeMode),
          ),
        ),
      ],
    ),
  );
}
