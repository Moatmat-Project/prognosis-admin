import 'package:firebase_messaging/firebase_messaging.dart';

class AppNotification {
  final int id;
  final String title;
  final String? body;
  final String? sender;
  final String? html;
  final String? imageUrl;
  final DateTime date;
  final bool seen;

  bool isValid() {
    return title.isNotEmpty;
  }

  AppNotification copyWith({
    int? id,
    String? title,
    String? body, 
    String? sender,
    String? html,
    String? imageUrl,
    DateTime? date,
    bool? seen,
  }) {
    return AppNotification(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      sender: sender ?? this.sender,
      html: html ?? this.html,
      imageUrl: imageUrl ?? this.imageUrl,
      date: date ?? this.date,
      seen: seen ?? this.seen,
    );
  }

  factory AppNotification.fromRemoteMessage(RemoteMessage message) {
    DateTime date = DateTime.now();
    if (message.data["date"] != null) {
      date = DateTime.parse(message.data["date"]);
    }
    return AppNotification(
      id: DateTime.now().millisecondsSinceEpoch,
      title: message.data["title"] ?? '',
      body: message.data["body"],
      sender: message.data["sender"],
      html: message.data["html"],
      imageUrl: message.data["image_url"],
      date: date,
    );
  }
  factory AppNotification.empty() {
    return AppNotification(
      id: 0,
      title: '',
      body: '',
      sender: '',
      html: '',
      imageUrl: "",
      date: DateTime.now(),
    );
  }

  AppNotification({
    required this.id,
    required this.title,
    this.body,
    this.sender,
    this.html,
    this.imageUrl,
    this.seen = false,
    required this.date,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'body': body,
      'sender': sender,
      'image_url': imageUrl,
      'html': html,
      'date': date.toIso8601String(),
    };
  }

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      id: 1,
      title: json['title'] ?? '',
      body: json['body'],
      sender: json['sender'],
      html: json['html'],
      imageUrl: json['image_url'],
      seen: json['seen'] ?? false,
      date: json['date'] != null ? DateTime.parse(json['date']) : DateTime.now(),
    );
  }
}
