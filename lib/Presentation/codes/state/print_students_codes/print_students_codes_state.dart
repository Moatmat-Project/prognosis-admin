part of 'print_students_codes_bloc.dart';

sealed class PrintStudentsCodesState extends Equatable {
  const PrintStudentsCodesState();

  @override
  List<Object> get props => [];
}

final class PrintStudentsCodesLoading extends PrintStudentsCodesState {}

final class PrintStudentsCodesInitial extends PrintStudentsCodesState {}

final class PrintStudentsCodesExploreStudents extends PrintStudentsCodesState {
  final List<(String, UserData?)> users;
  const PrintStudentsCodesExploreStudents(this.users);
}

final class PrintStudentsCodesSuccess extends PrintStudentsCodesState {
  final Uint8List bytes;
  const PrintStudentsCodesSuccess(this.bytes);
}
