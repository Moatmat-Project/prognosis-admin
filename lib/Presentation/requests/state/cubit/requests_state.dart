part of 'requests_cubit.dart';

sealed class RequestsState extends Equatable {
  const RequestsState();

  @override
  List<Object> get props => [];
}

final class RequestsLoading extends RequestsState {}

final class RequestsError extends RequestsState {
  final String error;

  const RequestsError({required this.error});
}

final class RequestsInitial extends RequestsState {
  final List<TeacherRequest> requests;

  const RequestsInitial({required this.requests});
}

