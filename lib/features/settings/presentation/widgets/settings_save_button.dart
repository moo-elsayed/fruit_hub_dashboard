import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fruit_hub_dashboard/core/helpers/app_strings.dart';
import 'package:fruit_hub_dashboard/core/theming/app_palette.dart';
import 'package:fruit_hub_dashboard/core/theming/app_text_styles.dart';
import 'package:fruit_hub_dashboard/core/widgets/app_toasts.dart';
import 'package:fruit_hub_dashboard/core/widgets/custom_material_button.dart';
import 'package:fruit_hub_dashboard/features/settings/presentation/managers/settings_cubit/settings_cubit.dart';
import 'package:toastification/toastification.dart';

class SettingsSaveButton extends StatelessWidget {
  const SettingsSaveButton({
    super.key,
    required this.onSave,
    required this.onSuccess,
  });

  final VoidCallback onSave;
  final VoidCallback onSuccess;

  @override
  Widget build(BuildContext context) =>
      BlocConsumer<SettingsCubit, SettingsState>(
        listener: (context, state) {
          if (state is UpdatingShippingConfigSuccess) {
            onSuccess();
            AppToast.show(
              context: context,
              title: AppStrings.success,
              description: AppStrings.settingsUpdatedSuccessfully,
              type: ToastificationType.success,
            );
          }
        },
        buildWhen: (previous, current) =>
            current is UpdatingShippingConfigSuccess ||
            current is UpdatingShippingConfigFailure ||
            current is UpdatingShippingConfigLoading,
        builder: (context, state) => CustomMaterialButton(
          onPressed: onSave,
          maxWidth: true,
          isLoading: state is UpdatingShippingConfigLoading,
          text: AppStrings.saveChanges,
          borderRadius: BorderRadius.circular(10.r),
          textStyle: AppTextStyles.font15Bold.copyWith(
            color: AppPalette.white,
          ),
        ),
      );
}
