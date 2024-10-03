import 'package:dartz/dartz.dart';
import 'package:moatmat_admin/Core/errors/exceptions.dart';
import 'package:moatmat_admin/Features/outer_tests/data/datasources/outer_tests_datasource.dart';
import 'package:moatmat_admin/Features/outer_tests/domain/entities/outer_test.dart';
import 'package:moatmat_admin/Features/outer_tests/domain/repository/outer_tests_repository.dart';

class OuterTestsRepositoryImplement implements OuterTestsRepository {
  final OuterTestsDatasource datasource;

  OuterTestsRepositoryImplement({required this.datasource});
  @override
  Future<Either<Failure, Unit>> addOuterTest({required OuterTest test}) async {
    try {
      await datasource.addOuterTest(test: test);
      return right(unit);
    } on Exception {
      return left(const AnonFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteOuterTest({required int id}) async {
    try {
      await datasource.deleteOuterTest(id: id);
      return right(unit);
    } on Exception {
      return left(const AnonFailure());
    }
  }

  @override
  Future<Either<Failure, OuterTest>> getOuterTestById({required int id}) async {
    try {
      final res = await datasource.getOuterTestById(id: id);
      return right(res);
    } on Exception {
      return left(const AnonFailure());
    }
  }

  @override
  Future<Either<Failure, List<OuterTest>>> getOuterTests({required String? material}) async {
    try {
      final res = await datasource.getOuterTests(material:material);
      return right(res);
    } on Exception {
      return left(const AnonFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> updateOuterTest({required OuterTest test}) async {
    try {
      await datasource.updateOuterTest(test: test);
      return right(unit);
    } on Exception {
      return left(const AnonFailure());
    }
  }
}
