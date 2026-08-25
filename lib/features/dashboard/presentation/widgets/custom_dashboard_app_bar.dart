import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/cupertino.dart';
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
          title: AnimatedTextKit(
            animatedTexts: [
              TypewriterAnimatedText(
                'Welcome to dashboard',
                textStyle: AppTextStyles.font19Bold.copyWith(
                  color: context.colors.mainText,
                ),
                speed: const Duration(milliseconds: 200),
              ),
            ],
            totalRepeatCount: 1,
            pause: const Duration(milliseconds: 1000),
            displayFullTextOnTap: true,
            stopPauseOnTap: true,
          ),
          centerTitle: true,
          actions: [
            GestureDetector(
              onTap: () {
                showCupertinoDialog(
                  context: context,
                  builder: (_) => CustomConfirmationDialog(
                    title: AppStrings.logOutConfirmation,
                    textConfirmButton: 'Yes',
                    textCancelButton: 'No',
                    onConfirm: () async {
                      await context.read<SignOutCubit>().signOut();
                    },
                  ),
                );
              },
              child: Icon(Icons.logout, color: context.colors.mainText),
            ),
            Gap(12.w),
          ],
        ),
      );
}
