import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruit_hub_dashboard/core/network/network_response.dart';

import '../../../domain/entities/notification_entity.dart';
import '../../../domain/entities/send_notification_input_entity.dart';
import '../../../domain/use_cases/get_user_notifications_use_case.dart';
import '../../../domain/use_cases/send_user_notification_use_case.dart';

part 'user_notifications_state.dart';

class UserNotificationsCubit extends Cubit<UserNotificationsState> {
  UserNotificationsCubit(
    this._getUserNotificationsUseCase,
    this._sendUserNotificationUseCase,
  ) : super(UserNotificationsInitial());

  final GetUserNotificationsUseCase _getUserNotificationsUseCase;
  final SendUserNotificationUseCase _sendUserNotificationUseCase;

  List<NotificationEntity> _notifications = [];

  Future<void> getUserNotifications(String userId) async {
    emit(UserNotificationsLoading());
    final response = await _getUserNotificationsUseCase.call(userId);
    switch (response) {
      case NetworkSuccess(data: final notifications):
        _notifications = List.of(notifications ?? []);
        emit(UserNotificationsSuccess(List.unmodifiable(_notifications)));
      case NetworkFailure(failure: final failure):
        emit(UserNotificationsFailure(failure.error));
    }
  }

  Future<void> sendNotification(SendNotificationInputEntity input) async {
    emit(SendNotificationLoading());
    final response = await _sendUserNotificationUseCase.call(input);
    switch (response) {
      case NetworkSuccess(data: final newNotification):
        if (newNotification != null) {
          _notifications.insert(0, newNotification);
        }
        emit(SendNotificationSuccess());
        emit(UserNotificationsSuccess(List.unmodifiable(_notifications)));
      case NetworkFailure(failure: final failure):
        emit(SendNotificationFailure(failure.error));
    }
  }
}
