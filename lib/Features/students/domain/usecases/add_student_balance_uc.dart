import 'package:dartz/dartz.dart';
import '../repository/students_repo.dart';

class AddStudentBalanceUC {
  final StudentsRepository repository;

  AddStudentBalanceUC({required this.repository});

  Future<Either<Exception, Unit>> call({
    required String studentId,
    required int amount,
  }) {
    return repository.addStudentBalance(
      studentId: studentId,
      amount: amount,
    );
  }
}
