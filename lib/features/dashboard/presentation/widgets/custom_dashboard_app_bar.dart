import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fruit_hub_dashboard/core/helpers/app_strings.dart';
import 'package:fruit_hub_dashboard/core/helpers/extensions.dart';
import 'package:fruit_hub_dashboard/core/routing/routes.dart';
import 'package:fruit_hub_dashboard/core/theming/app_text_styles.dart';
import 'package:fruit_hub_dashboard/core/widgets/app_toasts.dart';
import 'package:fruit_hub_dashboard/core/widgets/custom_confirmation_dialog.dart';
import 'package:gap/gap.dart';
import 'package:toastification/toastification.dart';

import '../../../auth/presentation/managers/signout_cubit/sign_out_cubit.dart';

class CustomDashboardAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const CustomDashboardAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) =>
      BlocListener<SignOutCubit, SignOutState>(
        listener: (context, state) {
          if (state is SignOutSuccess) {
            AppToast.show(
              context: context,
              title: AppStrings.loggedOutSuccessfully,
              type: ToastificationType.success,
            );
            context.pushNamedAndRemoveUntil(
              Routes.loginView,
              predicate: (Route<dynamic> route) => false,
              rootNavigator: true,
            );
          }
        },
        child: AppBar(
          backgroundColor: context.colors.background,
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: false,
          titleSpacing: 16.w,
          title: Row(
            children: [
              Container(
                width: 40.r,
                height: 40.r,
                decoration: BoxDecoration(
                  color: context.colors.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  Icons.dashboard_rounded,
                  color: context.colors.primary,
                  size: 22.sp,
                ),
              ),
              Gap(12.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    AppStrings.dashboard,
                    style: AppTextStyles.font18Bold.copyWith(
                      color: context.colors.mainText,
                      height: 1.1,
                    ),
                  ),
                  Gap(4.h),
                  Text(
                    AppStrings.admin,
                    style: AppTextStyles.font11Regular.copyWith(
                      color: context.colors.subText,
                      height: 1.1,
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => CustomConfirmationDialog.show(
                  context: context,
                  title: AppStrings.logOutConfirmation,
                  textConfirmButton: AppStrings.yes,
                  textCancelButton: AppStrings.no,
                  onConfirm: () async {
                    await context.read<SignOutCubit>().signOut();
                  },
                ),
                borderRadius: BorderRadius.circular(12.r),
                child: Ink(
                  padding: EdgeInsets.all(8.r),
                  decoration: BoxDecoration(
                    color: context.colors.surface,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: context.colors.border),
                  ),
                  child: Icon(
                    Icons.logout_rounded,
                    color: context.colors.error,
                    size: 20.sp,
                  ),
                ),
              ),
            ),
            Gap(16.w),
          ],
        ),
      );
}
