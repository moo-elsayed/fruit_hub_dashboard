import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fruit_hub_dashboard/core/network/network_response.dart';

import '../../../../core/enums/user_filter_type.dart';
import '../../../../core/enums/user_search_by.dart';
import '../../domain/entities/dashboard_user_entity.dart';
import '../../domain/entities/notification_entity.dart';
import '../../domain/entities/send_notification_input_entity.dart';
import '../../domain/entities/users_page_entity.dart';
import '../../domain/entities/users_stats_entity.dart';
import '../../domain/repo/users_repo.dart';
import '../data_sources/remote/users_remote_data_source.dart';
import '../models/send_notification_input_model.dart';

class UsersRepoImp implements UsersRepo {
  UsersRepoImp(this._remoteDataSource);

  final UsersRemoteDataSource _remoteDataSource;

  @override
  Future<NetworkResponse<UsersPageEntity>> getUsers({
    int limit = 15,
    DocumentSnapshot? lastDocument,
    UserFilterType filter = UserFilterType.all,
  }) async {
    final response = await _remoteDataSource.getUsers(
      limit: limit,
      lastDocument: lastDocument,
      filter: filter,
    );
    return switch (response) {
      NetworkSuccess(data: final pageModel) => NetworkSuccess(
        pageModel?.toEntity() ??
            const UsersPageEntity(users: [], hasMore: false),
      ),
      NetworkFailure(failure: final failure) => NetworkFailure(failure),
    };
  }

  @override
  Future<NetworkResponse<UsersStatsEntity>> getUsersStats() async {
    final response = await _remoteDataSource.getUsersStats();
    return switch (response) {
      NetworkSuccess(data: final statsModel) => NetworkSuccess(
        statsModel?.toEntity() ?? const UsersStatsEntity(),
      ),
      NetworkFailure(failure: final failure) => NetworkFailure(failure),
    };
  }

  @override
  Future<NetworkResponse<List<NotificationEntity>>> getUserNotifications(
    String userId,
  ) async {
    final response = await _remoteDataSource.getUserNotifications(userId);
    return switch (response) {
      NetworkSuccess(data: final notifications) => NetworkSuccess(
        notifications?.map((e) => e.toEntity()).toList() ?? [],
      ),
      NetworkFailure(failure: final failure) => NetworkFailure(failure),
    };
  }

  @override
  Future<NetworkResponse<List<DashboardUserEntity>>> searchUsers({
    required String query,
    required UserSearchBy searchBy,
    int limit = 30,
  }) async {
    final response = await _remoteDataSource.searchUsers(
      query: query,
      searchBy: searchBy,
      limit: limit,
    );
    return switch (response) {
      NetworkSuccess(data: final users) => NetworkSuccess(
        users?.map((e) => e.toEntity()).toList() ?? [],
      ),
      NetworkFailure(failure: final failure) => NetworkFailure(failure),
    };
  }

  @override
  Future<NetworkResponse<NotificationEntity>> sendNotification(
    SendNotificationInputEntity input,
  ) async {
    final model = SendNotificationInputModel.fromEntity(input);
    final response = await _remoteDataSource.sendNotification(model);
    return switch (response) {
      NetworkSuccess(data: final notificationModel) => NetworkSuccess(
        notificationModel?.toEntity(),
      ),
      NetworkFailure(failure: final failure) => NetworkFailure(failure),
    };
  }
}
