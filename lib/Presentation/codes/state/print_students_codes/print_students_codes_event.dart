part of 'print_students_codes_bloc.dart';

sealed class PrintStudentsCodesEvent extends Equatable {
  const PrintStudentsCodesEvent();

  @override
  List<Object> get props => [];
}

final class PrintStudentsSubmitTextCodesEvent extends PrintStudentsCodesEvent {
  const PrintStudentsSubmitTextCodesEvent({required this.text, required this.onPerPage});
  final bool onPerPage;
  final String text;
  @override
  List<Object> get props => [];
}

final class PrintCodesEvent extends PrintStudentsCodesEvent {
  const PrintCodesEvent({required this.users});
  final List<UserData?> users;
  @override
  List<Object> get props => [];
}
