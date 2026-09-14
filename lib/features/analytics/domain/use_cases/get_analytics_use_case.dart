import 'package:fruit_hub_dashboard/core/network/network_response.dart';
import 'package:fruit_hub_dashboard/features/analytics/domain/entities/analytics_data_entity.dart';
import 'package:fruit_hub_dashboard/features/analytics/domain/repo/analytics_repo.dart';

class GetAnalyticsUseCase {
  GetAnalyticsUseCase(this._analyticsRepo);

  final AnalyticsRepo _analyticsRepo;

  Future<NetworkResponse<AnalyticsDataEntity>> call({
    required DateTime from,
    required DateTime to,
  }) => _analyticsRepo.getAnalytics(from: from, to: to);
}
