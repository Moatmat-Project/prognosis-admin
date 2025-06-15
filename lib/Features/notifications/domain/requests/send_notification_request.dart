import 'package:flutter/material.dart';
import 'package:moatmat_admin/Features/notifications/domain/entities/app_notification.dart';
import 'package:moatmat_admin/Features/notifications/domain/entities/notifications_topic.dart';

class SendNotificationRequest {
  final String? userId;
  final NotificationsTopic? topic;
  final AppNotification notification;

  SendNotificationRequest({
    required this.notification,
    required this.topic,
    required this.userId,
  });

  Map toBody() {
    debugPrint("subtitle in request are : ${notification.subtitle}");
    return {
      //
      // 'user_id': userId,
      // 'topic': topic?.id,
      'condition': "'1' in topics || '2' in topics",
      //
      'title': notification.title,
      'subtitle': notification.subtitle,
      'html': notification.html,
      'image_url': notification.imageUrl,
    };
  }
}
