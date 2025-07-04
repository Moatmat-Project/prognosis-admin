import 'package:dartz/dartz.dart';
import 'package:moatmat_admin/Core/errors/exceptions.dart';
import 'package:moatmat_admin/Features/notifications/domain/repositories/notifications_repository.dart';

class MarkNotificationSeen {
  final NotificationsRepository repository;

  MarkNotificationSeen({required this.repository});

  Future<Either<Failure, Unit>> call(String notificationId) async {
    return await repository.markNotificationAsSeen(notificationId);
  }
}