import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruit_hub_dashboard/core/network/network_response.dart';
import 'package:fruit_hub_dashboard/features/settings/domain/entities/shipping_config_entity.dart';
import 'package:fruit_hub_dashboard/features/settings/domain/use_cases/fetch_shipping_config_use_case.dart';
import 'package:fruit_hub_dashboard/features/settings/domain/use_cases/update_shipping_config_use_case.dart';

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit(
    this._fetchShippingConfigUseCase,
    this._updateShippingConfigUseCase,
  ) : super(SettingsInitial());
  final FetchShippingConfigUseCase _fetchShippingConfigUseCase;
  final UpdateShippingConfigUseCase _updateShippingConfigUseCase;

  Future<void> fetchShippingConfig() async {
    emit(FetchingShippingConfigLoading());
    final result = await _fetchShippingConfigUseCase();
    if (isClosed) return;
    switch (result) {
      case NetworkSuccess<ShippingConfigEntity>():
        emit(FetchingShippingConfigSuccess(result.data!));
      case NetworkFailure<ShippingConfigEntity>():
        emit(FetchingShippingConfigFailure(result.error));
    }
  }

  Future<void> updateShippingConfig(
    ShippingConfigEntity shippingConfigEntity,
  ) async {
    emit(UpdatingShippingConfigLoading());
    final result = await _updateShippingConfigUseCase(shippingConfigEntity);
    if (isClosed) return;
    switch (result) {
      case NetworkSuccess<void>():
        emit(UpdatingShippingConfigSuccess());
      case NetworkFailure<void>():
        emit(UpdatingShippingConfigFailure(result.error));
    }
  }
}
