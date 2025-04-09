part of 'teachers_manager_cubit.dart';

sealed class TeachersManagerState extends Equatable {
  const TeachersManagerState();

  @override
  List<Object> get props => [];
}

final class TeachersManagerLoading extends TeachersManagerState {}
//

final class TeachersManagerError extends TeachersManagerState {
  final String? error;

  const TeachersManagerError({required this.error});
}

//
final class TeachersManagerInitial extends TeachersManagerState {
  final List<TeacherData> teachers;

  const TeachersManagerInitial({required this.teachers});

  @override
  List<Object> get props => [teachers];
}
