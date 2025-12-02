part of 'settings_cubit.dart';

@immutable
sealed class SettingsState {}

final class SettingsInitial extends SettingsState {}

final class FetchingShippingConfigLoading extends SettingsState {}

final class FetchingShippingConfigSuccess extends SettingsState {
  FetchingShippingConfigSuccess(this.shippingConfigEntity);

  final ShippingConfigEntity shippingConfigEntity;
}

final class FetchingShippingConfigFailure extends SettingsState {
  FetchingShippingConfigFailure(this.error);

  final String error;
}

final class UpdatingShippingConfigLoading extends SettingsState {}

final class UpdatingShippingConfigSuccess extends SettingsState {}

final class UpdatingShippingConfigFailure extends SettingsState {
  UpdatingShippingConfigFailure(this.error);

  final String error;
}
