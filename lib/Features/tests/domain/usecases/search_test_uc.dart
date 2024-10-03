import 'package:dartz/dartz.dart';
import 'package:moatmat_admin/Features/tests/domain/repositories/tests_repository.dart';

import '../entities/test/test.dart';

class SearchTestUC {
  final TestsRepository repository;

  SearchTestUC({required this.repository});

  Future<Either<Exception, List<Test>>> call({required String keyword}) async {
    return await repository.searchTest(keyword: keyword);
  }
}
