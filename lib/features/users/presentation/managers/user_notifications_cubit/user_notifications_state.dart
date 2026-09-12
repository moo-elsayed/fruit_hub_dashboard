part of 'user_notifications_cubit.dart';

sealed class UserNotificationsState {
  const UserNotificationsState();
}

final class UserNotificationsInitial extends UserNotificationsState {}

final class UserNotificationsLoading extends UserNotificationsState {}

final class UserNotificationsSuccess extends UserNotificationsState {
  const UserNotificationsSuccess(this.notifications);

  final List<NotificationEntity> notifications;
}

final class UserNotificationsFailure extends UserNotificationsState {
  const UserNotificationsFailure(this.message);

  final String message;
}

final class SendNotificationLoading extends UserNotificationsState {}

final class SendNotificationSuccess extends UserNotificationsState {}

final class SendNotificationFailure extends UserNotificationsState {
  const SendNotificationFailure(this.message);

  final String message;
}
