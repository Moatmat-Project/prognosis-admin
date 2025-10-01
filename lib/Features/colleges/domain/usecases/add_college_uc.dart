import 'package:dartz/dartz.dart';
import 'package:moatmat_admin/Core/error/failures.dart';
import 'package:moatmat_admin/Core/usecase/usecase.dart';
import 'package:moatmat_admin/Features/colleges/domain/entities/college.dart';
import 'package:moatmat_admin/Features/colleges/domain/repository/college_repository.dart';

class AddCollegeUC implements UseCase<void, College> {
  final CollegeRepository repository;

  AddCollegeUC(this.repository);

  @override
  Future<Either<Failure, void>> call(College college) async {
    return await repository.addCollege(college);
  }
}
