import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/users_page_entity.dart';
import 'dashboard_user_model.dart';

class UsersPageModel {
  const UsersPageModel({
    required this.users,
    required this.hasMore,
    this.lastDocument,
  });

  final List<DashboardUserModel> users;
  final bool hasMore;
  final DocumentSnapshot? lastDocument;

  UsersPageEntity toEntity() => UsersPageEntity(
    users: users.map((u) => u.toEntity()).toList(),
    hasMore: hasMore,
    lastDocument: lastDocument,
  );
}
