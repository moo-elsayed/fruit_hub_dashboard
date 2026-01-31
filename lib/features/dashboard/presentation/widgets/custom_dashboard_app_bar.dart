import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../../../../core/helpers/extentions.dart';
import '../../../../core/routing/routes.dart';
import '../../../../core/services/authentication/auth_service.dart';
import '../../../../core/theming/app_text_styles.dart';
import '../../../../core/widgets/app_toasts.dart';
import '../../../../core/widgets/custom_confirmation_dialog.dart';
import '../../../auth/presentation/managers/signout_cubit/sign_out_cubit.dart';

class CustomDashboardAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const CustomDashboardAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) => BlocListener<SignOutCubit, SignOutState>(
      listener: (context, state) {
        if (state is SignOutSuccess) {
          AppToast.showToast(
            context: context,
            title: 'Logged out successfully',
            type: .success,
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
              textStyle: AppTextStyles.font19color0C0D0DBold,
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
                  title: 'Are you sure you want to log out?',
                  textConfirmButton: 'Yes',
                  textCancelButton: 'No',
                  onConfirm: () async {
                    final SignOutService signOutService = context
                        .read<SignOutCubit>();
                    signOutService.signOut();
                  },
                ),
              );
            },
            child: const Icon(Icons.logout, color: Colors.black),
          ),
          Gap(12.w),
        ],
      ),
    );
}
