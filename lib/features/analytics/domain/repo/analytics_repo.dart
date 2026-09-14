import 'package:fruit_hub_dashboard/core/network/network_response.dart';
import 'package:fruit_hub_dashboard/features/analytics/domain/entities/analytics_data_entity.dart';

abstract class AnalyticsRepo {
  Future<NetworkResponse<AnalyticsDataEntity>> getAnalytics({
    required DateTime from,
    required DateTime to,
  });
}
