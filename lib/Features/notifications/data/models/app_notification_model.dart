import 'package:moatmat_admin/Features/notifications/domain/entities/app_notification.dart';

class AppNotificationModel extends AppNotification {
  AppNotificationModel({
    required super.id,
    required super.title,
    required super.body,
    required super.html,
    required super.date,
    required super.seen,
    super.imageUrl,
    super.sender,
  });

  factory AppNotificationModel.fromDatabaseJson(Map json) {
    return AppNotificationModel(
      id: json['id'],
      title: json['title'],
      body: json['body'],
      html: json['html'],
      date: DateTime.parse(json['date']),
      imageUrl: json['image_url'],
      seen: json['seen'] == 1 ? true : false,
      sender: json['sender'],
    );
  }

  Map<String, dynamic> toDatabaseJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'html': html,
      'image_url': imageUrl,
      'date': date.toIso8601String(),
      'seen': seen ? 1 : 0,
      'sender': sender,
    };
  }
}
