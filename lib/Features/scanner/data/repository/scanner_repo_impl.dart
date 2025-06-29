
import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';

import '../../../students/domain/entities/result.dart';
import '../../domain/repository/scanner_repo.dart';
import '../datasources/scanner_remote_ds.dart';

class ScannerRepositoryImpl implements ScannerRepository {
  final ScannerRemoteDataSource dataSource;

  ScannerRepositoryImpl({required this.dataSource});

  @override
  Future<Either<Exception, Unit>> deleteOuterTest({
    required String name,
  }) async {
    try {
      final res = await dataSource.deleteOuterTest(name: name);
      return right(res);
    } on Exception catch (e) {
      return left(e);
    }
  }

  @override
  Future<Either<Exception, List<Result>>> getOuterTests({required String material}) async {
    try {
      final res = await dataSource.getOuterTests(material:material);
      return right(res);
    } on Exception catch (e) {
      return left(e);
    }
  }
}
