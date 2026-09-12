import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fruit_hub_dashboard/core/helpers/backend_endpoints.dart';
import 'package:fruit_hub_dashboard/core/network/api_helper.dart';
import 'package:fruit_hub_dashboard/core/network/network_response.dart';

import '../../../../../core/enums/user_filter_type.dart';
import '../../../../../core/enums/user_search_by.dart';
import '../../models/dashboard_user_model.dart';
import '../../models/notification_model.dart';
import '../../models/send_notification_input_model.dart';
import '../../models/users_page_model.dart';
import '../../models/users_stats_model.dart';
import 'users_remote_data_source.dart';

class UsersRemoteDataSourceImp implements UsersRemoteDataSource {
  UsersRemoteDataSourceImp({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;
  static const String _usersCollection = BackendEndpoints.usersCollection;
  static const String _notificationsCollection = 'notifications';

  @override
  Future<NetworkResponse<UsersPageModel>> getUsers({
    int limit = 15,
    DocumentSnapshot? lastDocument,
    UserFilterType filter = UserFilterType.all,
  }) async => ApiHelper.executeSafely(() async {
    Query query = _firestore.collection(_usersCollection);

    if (filter == UserFilterType.verified) {
      query = query.where('isVerified', isEqualTo: true);
    } else if (filter == UserFilterType.withCart) {
      query = query.where('cartItems', isNotEqualTo: []);
    }

    query = query.limit(limit);

    if (lastDocument != null) {
      query = query.startAfterDocument(lastDocument);
    }

    final snapshot = await query.get();
    final users = snapshot.docs
        .map(
          (doc) => DashboardUserModel.fromFirestore(
            doc.data() as Map<String, dynamic>,
            doc.id,
          ),
        )
        .toList();

    final hasMore = snapshot.docs.length == limit;
    final newLastDoc = snapshot.docs.isNotEmpty ? snapshot.docs.last : null;

    return UsersPageModel(
      users: users,
      hasMore: hasMore,
      lastDocument: newLastDoc,
    );
  }, functionName: 'getUsers');

  @override
  Future<NetworkResponse<UsersStatsModel>> getUsersStats() async =>
      ApiHelper.executeSafely(() async {
        final results = await Future.wait([
          _firestore.collection(_usersCollection).count().get(),
          _firestore
              .collection(_usersCollection)
              .where('isVerified', isEqualTo: true)
              .count()
              .get(),
          _firestore
              .collection(_usersCollection)
              .where('cartItems', isNotEqualTo: [])
              .count()
              .get(),
        ]);

        final totalCount = results[0].count ?? 0;
        final verifiedCount = results[1].count ?? 0;
        final activeCartCount = results[2].count ?? 0;

        return UsersStatsModel(
          totalCount: totalCount,
          verifiedCount: verifiedCount,
          activeCartCount: activeCartCount,
        );
      }, functionName: 'getUsersStats');

  @override
  Future<NetworkResponse<List<NotificationModel>>> getUserNotifications(
    String userId,
  ) async => ApiHelper.executeSafely(() async {
    final snapshot = await _firestore
        .collection(_usersCollection)
        .doc(userId)
        .collection(_notificationsCollection)
        .orderBy('createdAt', descending: true)
        .get();

    final notifications = snapshot.docs
        .map((doc) => NotificationModel.fromFirestore(doc.data(), doc.id))
        .toList();
    return notifications;
  }, functionName: 'getUserNotifications');

  @override
  Future<NetworkResponse<List<DashboardUserModel>>> searchUsers({
    required String query,
    required UserSearchBy searchBy,
    int limit = 30,
  }) async => ApiHelper.executeSafely(() async {
    final cleanQuery = query.trim();
    if (cleanQuery.isEmpty) return <DashboardUserModel>[];

    Query queryRef = _firestore.collection(_usersCollection);

    switch (searchBy) {
      case UserSearchBy.email:
        final emailQuery = cleanQuery.toLowerCase();
        queryRef = queryRef
            .where('email', isGreaterThanOrEqualTo: emailQuery)
            .where('email', isLessThanOrEqualTo: '$emailQuery\uf8ff');
      case UserSearchBy.phone:
        queryRef = queryRef
            .where('phone', isGreaterThanOrEqualTo: cleanQuery)
            .where('phone', isLessThanOrEqualTo: '$cleanQuery\uf8ff');
      case UserSearchBy.name:
        queryRef = queryRef
            .where('name', isGreaterThanOrEqualTo: cleanQuery)
            .where('name', isLessThanOrEqualTo: '$cleanQuery\uf8ff');
    }

    queryRef = queryRef.limit(limit);
    final snapshot = await queryRef.get();

    return snapshot.docs
        .map(
          (doc) => DashboardUserModel.fromFirestore(
            doc.data() as Map<String, dynamic>,
            doc.id,
          ),
        )
        .toList();
  }, functionName: 'searchUsers');

  @override
  Future<NetworkResponse<void>> sendNotification(
    SendNotificationInputModel input,
  ) async => ApiHelper.executeSafely(() async {
    await _firestore
        .collection(_usersCollection)
        .doc(input.userId)
        .collection(_notificationsCollection)
        .add(input.toJson());
  }, functionName: 'sendNotification');
}
