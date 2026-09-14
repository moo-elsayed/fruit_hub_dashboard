import 'package:fruit_hub_dashboard/core/network/network_response.dart';
import 'package:fruit_hub_dashboard/features/analytics/data/models/analytics_data_model.dart';

abstract class AnalyticsRemoteDataSource {
  Future<NetworkResponse<AnalyticsDataModel>> getAnalytics({
    required DateTime from,
    required DateTime to,
  });
}
