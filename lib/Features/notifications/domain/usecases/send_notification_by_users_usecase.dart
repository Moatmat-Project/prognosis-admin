import 'package:dartz/dartz.dart';
import 'package:moatmat_admin/Core/errors/exceptions.dart';
import 'package:moatmat_admin/Features/notifications/domain/entities/app_notification.dart';
import 'package:moatmat_admin/Features/notifications/domain/repositories/notifications_repository.dart';

class SendNotificationByUsersUsecase {
  final NotificationsRepository repository;
  SendNotificationByUsersUsecase({required this.repository});

  Future<Either<Failure, Unit>> call({
    required AppNotification notification,
    required List<String> userIds,
  }) async {
    return repository.sendNotificationByUsers(
      notification: notification,
      userIds: userIds,
    );
  }
}
