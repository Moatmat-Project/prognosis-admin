import 'package:dartz/dartz.dart';
import 'package:moatmat_admin/Core/errors/exceptions.dart';

import '../repositories/notifications_repository.dart';

class ClearNotificationsUsecase {
  final NotificationsRepository repository;

  ClearNotificationsUsecase({required this.repository});

  Future<Either<Failure, Unit>> call() async {
    return await repository.clearNotifications();
  }
}
