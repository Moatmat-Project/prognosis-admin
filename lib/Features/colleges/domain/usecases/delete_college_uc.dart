import 'package:dartz/dartz.dart';
import 'package:moatmat_admin/Core/error/failures.dart';
import 'package:moatmat_admin/Core/usecase/usecase.dart';
import 'package:moatmat_admin/Features/colleges/domain/repository/college_repository.dart';

class DeleteCollegeUC implements UseCase<void, int> {
  final CollegeRepository repository;

  DeleteCollegeUC(this.repository);

  @override
  Future<Either<Failure, void>> call(int id) async {
    return await repository.deleteCollege(id);
  }
}
