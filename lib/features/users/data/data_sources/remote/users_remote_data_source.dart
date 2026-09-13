import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fruit_hub_dashboard/core/network/network_response.dart';

import '../../../../../core/enums/user_filter_type.dart';
import '../../../../../core/enums/user_search_by.dart';
import '../../models/dashboard_user_model.dart';
import '../../models/notification_model.dart';
import '../../models/send_notification_input_model.dart';
import '../../models/users_page_model.dart';
import '../../models/users_stats_model.dart';

abstract class UsersRemoteDataSource {
  Future<NetworkResponse<UsersPageModel>> getUsers({
    int limit = 15,
    DocumentSnapshot? lastDocument,
    UserFilterType filter = UserFilterType.all,
  });
  Future<NetworkResponse<UsersStatsModel>> getUsersStats();
  Future<NetworkResponse<List<DashboardUserModel>>> searchUsers({
    required String query,
    required UserSearchBy searchBy,
    int limit = 30,
  });
  Future<NetworkResponse<List<NotificationModel>>> getUserNotifications(
    String userId,
  );
  Future<NetworkResponse<NotificationModel>> sendNotification(
    SendNotificationInputModel input,
  );
}
