import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fruit_hub_dashboard/core/widgets/app_toasts.dart';
import 'package:gap/gap.dart';
import '../../../../core/helpers/validator.dart';
import '../../../../core/theming/app_colors.dart';
import '../../../../core/theming/app_text_styles.dart';
import '../../../../core/widgets/custom_material_button.dart';
import '../../../../core/widgets/text_form_field_helper.dart';
import '../../domain/entities/shipping_config_entity.dart';
import '../managers/settings_cubit/settings_cubit.dart';

class DeliveryFeesContainer extends StatefulWidget {
  const DeliveryFeesContainer({super.key, required this.shippingCost});

  final double shippingCost;

  @override
  State<DeliveryFeesContainer> createState() => _DeliveryFeesContainerState();
}

class _DeliveryFeesContainerState extends State<DeliveryFeesContainer> {
  late GlobalKey<FormState> _formKey;
  late TextEditingController _shippingCostController;
  late double currentShippingCost = widget.shippingCost;
  late ValueNotifier<double> _shippingCostNotifier = ValueNotifier(
    currentShippingCost,
  );

  void _updateCurrentShippingCost() {
    currentShippingCost = double.parse(_shippingCostController.text);
    _shippingCostNotifier.value = currentShippingCost;
  }

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    _shippingCostController = TextEditingController();
    _shippingCostNotifier = ValueNotifier(currentShippingCost);
  }

  @override
  void dispose() {
    _shippingCostController.dispose();
    _shippingCostNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
      behavior: .opaque,
      child: Container(
        padding: .all(20.r),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: .circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.07),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: .start,
            spacing: 16.h,
            children: [
              Text("Delivery Fees", style: AppTextStyles.font16color0C0D0DBold),
              ValueListenableBuilder<double>(
                valueListenable: _shippingCostNotifier,
                builder: (context, value, child) {
                  return TextFormFieldHelper(
                    controller: _shippingCostController,
                    onValidate: Validator.validateNumber,
                    hint: value.toString(),
                    suffixWidget: Column(
                      mainAxisAlignment: .center,
                      children: [
                        Text("EGP", style: AppTextStyles.font13GreyRegular),
                      ],
                    ),
                    keyboardType: const .numberWithOptions(decimal: true),
                  );
                },
              ),
              Gap(8.h),
              Align(
                alignment: .center,
                child: BlocConsumer<SettingsCubit, SettingsState>(
                  listener: (context, state) {
                    if (state is UpdatingShippingConfigSuccess) {
                      _updateCurrentShippingCost();
                      AppToast.showToast(
                        context: context,
                        title: "Success",
                        type: .success,
                      );
                    }
                  },
                  buildWhen: (previous, current) =>
                      current is UpdatingShippingConfigSuccess ||
                      current is UpdatingShippingConfigFailure ||
                      current is UpdatingShippingConfigLoading,
                  builder: (context, state) {
                    return CustomMaterialButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          var cost = double.parse(_shippingCostController.text);
                          if (cost == currentShippingCost) {
                            return;
                          }
                          context.read<SettingsCubit>().updateShippingConfig(
                            ShippingConfigEntity(shippingCost: cost),
                          );
                        }
                      },
                      isLoading: state is UpdatingShippingConfigLoading,
                      text: "Save Changes",
                      textStyle: AppTextStyles.font16WhiteBold,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
