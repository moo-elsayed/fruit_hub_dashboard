import 'package:fruit_hub_dashboard/core/network/network_response.dart';
import 'package:fruit_hub_dashboard/features/analytics/data/data_sources/remote/analytics_remote_data_source.dart';
import 'package:fruit_hub_dashboard/features/analytics/data/models/analytics_data_model.dart';
import 'package:fruit_hub_dashboard/features/analytics/domain/entities/analytics_data_entity.dart';
import 'package:fruit_hub_dashboard/features/analytics/domain/repo/analytics_repo.dart';

class AnalyticsRepoImp implements AnalyticsRepo {
  AnalyticsRepoImp(this._dataSource);

  final AnalyticsRemoteDataSource _dataSource;

  @override
  Future<NetworkResponse<AnalyticsDataEntity>> getAnalytics({
    required DateTime from,
    required DateTime to,
  }) async {
    final response = await _dataSource.getAnalytics(from: from, to: to);
    switch (response) {
      case NetworkSuccess<AnalyticsDataModel>():
        return NetworkSuccess(
          response.data?.toEntity() ?? const AnalyticsDataEntity(),
        );
      case NetworkFailure<AnalyticsDataModel>():
        return NetworkFailure(response.failure);
    }
  }
}
