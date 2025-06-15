part of 'send_notification_bloc.dart';

abstract class SendNotificationEvent extends Equatable {
  const SendNotificationEvent();

  @override
  List<Object> get props => [];
}

class SendNotificationToUsers extends SendNotificationEvent {
  final List<String> userIds;
  final AppNotification notification;

  const SendNotificationToUsers({
    required this.userIds,
    required this.notification,
  });

  @override
  List<Object> get props => [userIds, notification];
}

class SendNotificationToTopics extends SendNotificationEvent {
  final List<String> topics;
  final AppNotification notification;

  const SendNotificationToTopics({
    required this.topics,
    required this.notification,
  });

  @override
  List<Object> get props => [topics, notification];
}
