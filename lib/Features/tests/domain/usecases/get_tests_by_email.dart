import 'package:dartz/dartz.dart';
import 'package:moatmat_admin/Features/tests/domain/entities/test/test.dart';
import 'package:moatmat_admin/Features/tests/domain/repositories/tests_repository.dart';

class GetTestsByEmail {
  final TestsRepository repository;

  GetTestsByEmail({required this.repository});

  Future<Either<Exception, List<Test>>> call({required String email}) async {
    return await repository.getTestsByEmail(email:email);
  }
}