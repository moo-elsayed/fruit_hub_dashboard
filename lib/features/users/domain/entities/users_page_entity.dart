import 'package:cloud_firestore/cloud_firestore.dart';

import 'app_user_entity.dart';

class UsersPageEntity {
  const UsersPageEntity({
    required this.users,
    required this.hasMore,
    this.lastDocument,
  });

  final List<AppUserEntity> users;
  final bool hasMore;
  final DocumentSnapshot? lastDocument;
}
