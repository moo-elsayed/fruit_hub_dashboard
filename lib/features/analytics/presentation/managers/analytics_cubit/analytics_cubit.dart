import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruit_hub_dashboard/core/network/network_response.dart';
import 'package:fruit_hub_dashboard/features/analytics/domain/entities/analytics_data_entity.dart';
import 'package:fruit_hub_dashboard/features/analytics/domain/use_cases/get_analytics_use_case.dart';

part 'analytics_state.dart';

class AnalyticsCubit extends Cubit<AnalyticsState> {
  AnalyticsCubit(this._getAnalyticsUseCase) : super(AnalyticsInitial());

  final GetAnalyticsUseCase _getAnalyticsUseCase;

  AnalyticsDataEntity? _cachedData;
  late DateTime _currentFrom;
  late DateTime _currentTo;

  AnalyticsDataEntity? get cachedData => _cachedData;

  Future<void> loadAnalytics({
    required DateTime from,
    required DateTime to,
  }) async {
    _currentFrom = from;
    _currentTo = to;

    emit(AnalyticsLoading());

    final response = await _getAnalyticsUseCase(from: from, to: to);
    if (isClosed) return;

    switch (response) {
      case NetworkSuccess<AnalyticsDataEntity>():
        _cachedData = response.data;
        emit(
          AnalyticsSuccess(data: response.data ?? const AnalyticsDataEntity()),
        );
      case NetworkFailure<AnalyticsDataEntity>():
        emit(AnalyticsFailure(message: response.error));
    }
  }

  Future<void> refresh() async {
    if (!isClosed) {
      await loadAnalytics(from: _currentFrom, to: _currentTo);
    }
  }
}
