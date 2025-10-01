import 'package:dartz/dartz.dart';
import 'package:moatmat_admin/Core/error/failures.dart';
import 'package:moatmat_admin/Core/usecase/usecase.dart';
import 'package:moatmat_admin/Features/colleges/domain/entities/college.dart';
import 'package:moatmat_admin/Features/colleges/domain/repository/college_repository.dart';

class GetAllCollegesUC implements UseCase<List<College>, NoParams> {
  final CollegeRepository repository;

  GetAllCollegesUC(this.repository);

  @override
  Future<Either<Failure, List<College>>> call(NoParams params) async {
    return await repository.getAllColleges();
  }
}
