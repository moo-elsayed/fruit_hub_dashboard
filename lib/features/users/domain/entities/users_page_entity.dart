import 'package:cloud_firestore/cloud_firestore.dart';

import 'dashboard_user_entity.dart';

class UsersPageEntity {
  const UsersPageEntity({
    required this.users,
    required this.hasMore,
    this.lastDocument,
  });

  final List<DashboardUserEntity> users;
  final bool hasMore;
  final DocumentSnapshot? lastDocument;
}
