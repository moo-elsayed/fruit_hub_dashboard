part of 'analytics_cubit.dart';

sealed class AnalyticsState extends Equatable {
  const AnalyticsState();

  @override
  List<Object?> get props => [];
}

final class AnalyticsInitial extends AnalyticsState {}

final class AnalyticsLoading extends AnalyticsState {}

final class AnalyticsSuccess extends AnalyticsState {
  const AnalyticsSuccess({required this.data});

  final AnalyticsDataEntity data;

  @override
  List<Object?> get props => [data];
}

final class AnalyticsFailure extends AnalyticsState {
  const AnalyticsFailure({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}
