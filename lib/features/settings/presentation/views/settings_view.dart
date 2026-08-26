import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fruit_hub_dashboard/core/helpers/di.dart';
import 'package:fruit_hub_dashboard/core/helpers/extensions.dart';
import 'package:fruit_hub_dashboard/core/widgets/custom_app_bar.dart';
import 'package:fruit_hub_dashboard/features/settings/presentation/widgets/delivery_fees_container.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../../core/theming/app_text_styles.dart';
import '../managers/settings_cubit/settings_cubit.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (context) => getIt<SettingsCubit>()..fetchShippingConfig(),
    child: Scaffold(
      appBar: CustomAppBar(
        title: 'Settings',
        showArrowBack: true,
        onTap: () => context.pop(),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
        child: BlocBuilder<SettingsCubit, SettingsState>(
          buildWhen: (previous, current) =>
              current is FetchingShippingConfigSuccess ||
              current is FetchingShippingConfigLoading ||
              current is FetchingShippingConfigFailure,
          builder: (context, state) {
            if (state is FetchingShippingConfigSuccess) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'General Configuration',
                    style: AppTextStyles.font18Bold.copyWith(
                      color: context.colors.mainText,
                    ),
                  ),
                  Gap(20.h),
                  DeliveryFeesContainer(
                        shippingCost: state.shippingConfigEntity.shippingCost,
                      )
                      .animate(delay: const Duration(milliseconds: 50))
                      .slideY(begin: 0.15, duration: 300.ms)
                      .fadeIn(duration: 300.ms),
                ],
              );
            }
            if (state is FetchingShippingConfigFailure) {
              return Center(
                child: Text(
                  state.error,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.font14Regular.copyWith(
                    color: context.colors.error,
                  ),
                ),
              );
            } else {
              return Skeletonizer(
                enabled: true,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'General Configuration',
                      style: AppTextStyles.font18Bold.copyWith(
                        color: context.colors.mainText,
                      ),
                    ),
                    Gap(20.h),
                    const DeliveryFeesContainer(shippingCost: 0),
                  ],
                ),
              );
            }
          },
        ),
      ),
    ),
  );
}
