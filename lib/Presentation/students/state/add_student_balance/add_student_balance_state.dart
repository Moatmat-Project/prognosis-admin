part of 'add_student_balance_bloc.dart';

final class AddStudentBalanceState extends Equatable {
  const AddStudentBalanceState({this.isLoading = false, this.message, this.user});
  final bool isLoading;
  final String? message;
  final UserData? user;

  factory AddStudentBalanceState.loading() => const AddStudentBalanceState(isLoading: true);
  factory AddStudentBalanceState.initial() => const AddStudentBalanceState(isLoading: false);
  factory AddStudentBalanceState.confirmation(UserData user) => AddStudentBalanceState(user: user);
  factory AddStudentBalanceState.success() => AddStudentBalanceState(message: "تم تحويل الرصيد بنجاح");

  @override
  List<Object?> get props => [
        isLoading,
        message,
        user,
      ];
}
