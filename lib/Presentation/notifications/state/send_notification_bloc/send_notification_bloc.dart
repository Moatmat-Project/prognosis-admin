import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moatmat_admin/Features/notifications/domain/requests/send_notification_to_topics_request.dart';
import 'package:moatmat_admin/Features/notifications/domain/requests/send_notification_to_users_request.dart';
import 'package:moatmat_admin/Features/notifications/domain/usecases/send_notification_to_topics_usecase.dart';
import 'package:moatmat_admin/Features/notifications/domain/usecases/send_notification_to_users_usecase.dart';
import 'package:moatmat_admin/Features/notifications/domain/entities/app_notification.dart';
import 'package:moatmat_admin/Features/notifications/domain/usecases/upload_notification_image_usecase.dart';
import 'package:share_plus/share_plus.dart';

part 'send_notification_event.dart';
part 'send_notification_state.dart';

class SendNotificationBloc extends Bloc<SendNotificationEvent, SendNotificationState> {
  final SendNotificationToUsersUsecase _sendNotificationToUsersUsecase;
  final SendNotificationToTopicsUsecase _sendNotificationToTopicsUsecase;
  final UploadNotificationImageUsecase _uploadNotificationImageUsecase;

  SendNotificationBloc({
    required UploadNotificationImageUsecase uploadNotificationImageUsecase,
    required SendNotificationToUsersUsecase sendNotificationToUsersUsecase,
    required SendNotificationToTopicsUsecase sendNotificationToTopicsUsecase,
  })  : _sendNotificationToUsersUsecase = sendNotificationToUsersUsecase,
        _sendNotificationToTopicsUsecase = sendNotificationToTopicsUsecase,
        _uploadNotificationImageUsecase = uploadNotificationImageUsecase,
        super(SendNotificationInitial()) {
    on<SendNotificationToUsers>(_onSendNotificationToUsers);
    on<SendNotificationToTopics>(_onSendNotificationToTopics);
  }

  Future<void> _onSendNotificationToUsers(
    SendNotificationToUsers event,
    Emitter<SendNotificationState> emit,
  ) async {
    emit(SendNotificationLoading());

    if (event.imageFile != null) {
      final result = await _uploadNotificationImageUsecase(imageFile: event.imageFile!);
      result.fold(
        (failure) => emit(SendNotificationFailure("خطأ اثناء تحميل صورة الإشعار")),
        (imageUrl) async {
          final notification = event.notification.copyWith(imageUrl: imageUrl);
          final request = SendNotificationToUsersRequest(notification: notification, userIds: event.userIds);
          final result = await _sendNotificationToUsersUsecase(sendNotificationRequest: request);
          result.fold(
            (failure) => emit(SendNotificationFailure("خطأ اثناء ارسال الإشعار")),
            (_) => emit(SendNotificationSuccess()),
          );
        },
      );
    }
  }

  Future<void> _onSendNotificationToTopics(
    SendNotificationToTopics event,
    Emitter<SendNotificationState> emit,
  ) async {
    emit(SendNotificationLoading());
    if (event.imageFile != null) {
      final result = await _uploadNotificationImageUsecase(imageFile: event.imageFile!);
      result.fold(
        (failure) => emit(SendNotificationFailure("خطأ اثناء تحميل صورة الإشعار")),
        (imageUrl) async {
          final notification = event.notification.copyWith(imageUrl: imageUrl);
          final request = SendNotificationToTopicsRequest(notification: notification, topics: event.topics);
          final result = await _sendNotificationToTopicsUsecase(sendNotificationRequest: request);
          result.fold(
            (failure) => emit(SendNotificationFailure("خطأ اثناء ارسال الإشعار")),
            (_) => emit(SendNotificationSuccess()),
          );
        },
      );
    }
  }
}
