import 'package:dartz/dartz.dart';

import '../entities/result.dart';
import '../repository/students_repo.dart';

class AddResultsUC {
  final StudentsRepository repository;

  AddResultsUC({required this.repository});

  Future<Either<Exception, Unit>> call({
    required List<Result> results,
  }) {
    return repository.addResults(
      results: results,
    );
  }
}
