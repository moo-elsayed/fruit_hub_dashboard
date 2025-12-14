import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fruit_hub_dashboard/core/helpers/di.dart';
import 'package:fruit_hub_dashboard/core/helpers/extentions.dart';
import 'package:fruit_hub_dashboard/core/widgets/custom_app_bar.dart';
import 'package:fruit_hub_dashboard/features/settings/domain/use_cases/fetch_shipping_config_use_case.dart';
import 'package:fruit_hub_dashboard/features/settings/presentation/widgets/delivery_fees_container.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../../core/theming/app_text_styles.dart';
import '../../domain/use_cases/update_shipping_config_use_case.dart';
import '../managers/settings_cubit/settings_cubit.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SettingsCubit(
        getIt.get<FetchShippingConfigUseCase>(),
        getIt.get<UpdateShippingConfigUseCase>(),
      )..fetchShippingConfig(),
      child: Scaffold(
        appBar: CustomAppBar(
          title: "Settings",
          showArrowBack: true,
          onTap: () => context.pop(),
        ),
        body: Padding(
          padding: .symmetric(horizontal: 20.w, vertical: 24.h),
          child: BlocBuilder<SettingsCubit, SettingsState>(
            buildWhen: (previous, current) =>
                current is FetchingShippingConfigSuccess ||
                current is FetchingShippingConfigLoading ||
                current is FetchingShippingConfigFailure,
            builder: (context, state) {
              if (state is FetchingShippingConfigSuccess) {
                return Column(
                  crossAxisAlignment: .start,
                  children: [
                    Text(
                      "General Configuration",
                      style: AppTextStyles.font18color0C0D0DBold,
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
                return Center(child: Text(state.error, textAlign: .center));
              } else {
                return Skeletonizer(
                  enabled: true,
                  child: Column(
                    crossAxisAlignment: .start,
                    children: [
                      Text(
                        "General Configuration",
                        style: AppTextStyles.font18color0C0D0DBold,
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
}
