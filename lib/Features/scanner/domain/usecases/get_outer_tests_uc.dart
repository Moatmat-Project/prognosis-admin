import 'package:dartz/dartz.dart';

import '../../../students/domain/entities/result.dart';
import '../repository/scanner_repo.dart';

class GetOuterTestsUC {
  final ScannerRepository repository;

  GetOuterTestsUC({required this.repository});

  Future<Either<Exception, List<Result>>> call(
      {required String material}) async {
    return repository.getOuterTests(material:material);
  }
}
