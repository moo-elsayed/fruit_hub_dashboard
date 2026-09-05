import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fruit_hub_dashboard/core/helpers/app_strings.dart';
import 'package:fruit_hub_dashboard/core/helpers/extensions.dart';
import 'package:fruit_hub_dashboard/core/theming/app_palette.dart';
import 'package:fruit_hub_dashboard/core/widgets/custom_keyboard_unfocus.dart';
import 'package:fruit_hub_dashboard/features/settings/domain/entities/shipping_config_entity.dart';
import 'package:fruit_hub_dashboard/features/settings/presentation/managers/settings_cubit/settings_cubit.dart';
import 'package:gap/gap.dart';

import 'settings_currency_field.dart';
import 'settings_save_button.dart';

class DeliveryFeesContainer extends StatefulWidget {
  const DeliveryFeesContainer({super.key, required this.config});

  final ShippingConfigEntity config;

  @override
  State<DeliveryFeesContainer> createState() => _DeliveryFeesContainerState();
}

class _DeliveryFeesContainerState extends State<DeliveryFeesContainer> {
  late final GlobalKey<FormState> _formKey;
  late final TextEditingController _shippingCostController;
  late final TextEditingController _thresholdController;
  late ValueNotifier<ShippingConfigEntity> _configNotifier;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    _configNotifier = ValueNotifier(widget.config);
    _shippingCostController = TextEditingController(
      text: widget.config.shippingCost.toStringAsFixed(0),
    );
    _thresholdController = TextEditingController(
      text: widget.config.freeShippingThreshold.toStringAsFixed(0),
    );
  }

  @override
  void didUpdateWidget(covariant DeliveryFeesContainer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.config != widget.config) {
      _configNotifier.value = widget.config;
      _shippingCostController.text = widget.config.shippingCost.toStringAsFixed(
        0,
      );
      _thresholdController.text = widget.config.freeShippingThreshold
          .toStringAsFixed(0);
    }
  }

  @override
  void dispose() {
    _shippingCostController.dispose();
    _thresholdController.dispose();
    _configNotifier.dispose();
    super.dispose();
  }

  void _onSave() {
    if (_formKey.currentState!.validate()) {
      final cost =
          double.tryParse(_shippingCostController.text.trim()) ??
          _configNotifier.value.shippingCost;
      final threshold =
          double.tryParse(_thresholdController.text.trim()) ??
          _configNotifier.value.freeShippingThreshold;

      if (cost == _configNotifier.value.shippingCost &&
          threshold == _configNotifier.value.freeShippingThreshold) {
        return;
      }

      context.read<SettingsCubit>().updateShippingConfig(
        ShippingConfigEntity(
          shippingCost: cost,
          freeShippingThreshold: threshold,
        ),
      );
    }
  }

  void _onSuccess() {
    final cost =
        double.tryParse(_shippingCostController.text.trim()) ??
        _configNotifier.value.shippingCost;
    final threshold =
        double.tryParse(_thresholdController.text.trim()) ??
        _configNotifier.value.freeShippingThreshold;

    _configNotifier.value = ShippingConfigEntity(
      shippingCost: cost,
      freeShippingThreshold: threshold,
    );
  }

  @override
  Widget build(BuildContext context) => CustomKeyboardUnfocus(
    child: Container(
      padding: EdgeInsets.all(20.r),
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
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SettingsCurrencyField(
              title: AppStrings.deliveryFees,
              controller: _shippingCostController,
              hint: _configNotifier.value.shippingCost.toStringAsFixed(0),
            ),
            Gap(16.h),
            SettingsCurrencyField(
              title: AppStrings.freeShippingThreshold,
              subtitle: AppStrings.freeShippingThresholdHelp,
              controller: _thresholdController,
              hint: _configNotifier.value.freeShippingThreshold.toStringAsFixed(
                0,
              ),
            ),
            Gap(20.h),
            SettingsSaveButton(onSave: _onSave, onSuccess: _onSuccess),
          ],
        ),
      ),
    ),
  );
}
