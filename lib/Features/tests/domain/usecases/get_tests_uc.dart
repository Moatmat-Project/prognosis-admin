import 'package:dartz/dartz.dart';
import 'package:moatmat_admin/Features/tests/domain/repositories/tests_repository.dart';

import '../entities/test/test.dart';

class GetTestsUC {
  final TestsRepository repository;

  GetTestsUC({required this.repository});

  Future<Either<Exception, List<Test>>> call({ String? material}) async {
    return await repository.getTests(material: material);
  }
}
