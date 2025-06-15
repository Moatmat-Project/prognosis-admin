import 'package:dartz/dartz.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:moatmat_admin/Core/errors/exceptions.dart';
import 'package:moatmat_admin/Features/notifications/domain/entities/app_notification.dart';


abstract class NotificationsRepository {
  ///
  Future<Either<Failure, Unit>> initializeLocalNotification();

  ///
  Future<Either<Failure, Unit>> initializeFirebaseNotification();

  ///
  Future<Either<Failure, List<AppNotification>>> getNotifications();

  ///
  Future<Either<Failure, Unit>> clearNotifications();

  ///
  Future<Either<Failure, Unit>> deleteNotification({required int notificationId});

  ///
  Future<Either<Failure, Unit>> displayNotification({
    required AppNotification notification,
    bool oneTimeNotification = false,
    NotificationDetails? details,
  });

  ///
  Future<Either<Failure, Unit>> displayFirebaseNotification({
    required RemoteMessage message,
  });

  ///
  Future<Either<Failure, Unit>> cancelNotification({
    required int id,
  });

  ///
  Future<Either<Failure, Unit>> createNotificationsChannel({
    required AndroidNotificationChannel channel,
  });

  ///
  Future<Either<Failure, Unit>> subscribeToTopic({
    required String topic,
  });

  ///
  Future<Either<Failure, Unit>> unsubscribeToTopic({
    required String topic,
  });

  ///
  Future<Either<Failure, String>> getDeviceToken();

  ///
  Future<Either<Failure, String>> refreshDeviceToken();

  ///
  Future<Either<Failure, Unit>> deleteDeviceToken();

  ///

  /// Registers or updates the device token for the current user.
  Future<Either<Failure, Unit>> registerDeviceToken({
    required String deviceToken,
    required String platform,
  });

  /// Sends a notification to a list of topics.
  Future<Either<Failure, Unit>> sendNotificationByTopics({
    required AppNotification notification,
    required List<String> topics,
  });

  /// Sends a notification to a list of user IDs.
  Future<Either<Failure, Unit>> sendNotificationByUsers({
    required AppNotification notification,
    required List<String> userIds,
  });
}
