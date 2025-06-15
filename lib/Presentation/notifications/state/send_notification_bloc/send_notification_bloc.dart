import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moatmat_admin/Features/notifications/domain/usecases/send_notification_by_topics_usecase.dart';
import 'package:moatmat_admin/Features/notifications/domain/usecases/send_notification_by_users_usecase.dart';


part 'send_notification_event.dart';
part 'send_notification_state.dart';

class SendNotificationBloc
    extends Bloc<SendNotificationEvent, SendNotificationState> {
  final SendNotificationByUsersUsecase _sendNotificationByUsersUsecase;
  final SendNotificationByTopicsUsecase _sendNotificationByTopicsUsecase;

  SendNotificationBloc({
    required SendNotificationByUsersUsecase sendNotificationByUsersUsecase,
    required SendNotificationByTopicsUsecase sendNotificationByTopicsUsecase,
  })  : _sendNotificationByUsersUsecase = sendNotificationByUsersUsecase,
        _sendNotificationByTopicsUsecase = sendNotificationByTopicsUsecase,
        super(SendNotificationInitial()) {
    on<SendNotificationToUsers>(_onSendNotificationToUsers);
    on<SendNotificationToTopics>(_onSendNotificationToTopics);
  }

  Future<void> _onSendNotificationToUsers(
    SendNotificationToUsers event,
    Emitter<SendNotificationState> emit,
  ) async {
    emit(SendNotificationLoading());

    final result = await _sendNotificationByUsersUsecase(
      userIds: event.userIds,
      notification: event.notification,
    );
    result.fold(
      (failure) => emit(SendNotificationFailure("خطأ اثناء ارسال الإشعار")),
      (_) => emit(SendNotificationSuccess()),
    );
  }

  Future<void> _onSendNotificationToTopics(
    SendNotificationToTopics event,
    Emitter<SendNotificationState> emit,
  ) async {
    emit(SendNotificationLoading());

    final result = await _sendNotificationByTopicsUsecase(
      topics: event.topics,
      notification: event.notification,
    );
    result.fold(
      (failure) => emit(SendNotificationFailure("خطأ اثناء ارسال الإشعار")),
      (_) => emit(SendNotificationSuccess()),
    );
  }
}
