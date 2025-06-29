part of 'add_student_balance_bloc.dart';

sealed class AddStudentBalanceEvent extends Equatable {
  const AddStudentBalanceEvent();

  @override
  List<Object> get props => [];
}

final class AddStudentBalanceSubmitFieldsEvent extends AddStudentBalanceEvent {
  const AddStudentBalanceSubmitFieldsEvent({
    required this.studentId,
    required this.amount,
    required this.confirmed,
  });
  final String studentId;
  final int amount;
  final bool confirmed;
  @override
  List<Object> get props => [];
}
