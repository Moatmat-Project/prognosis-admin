import 'dart:typed_data';
import 'package:dartz/dartz.dart';

import '../../../students/domain/entities/result.dart';

abstract class ScannerRepository {
  //
  Future<Either<Exception, List<Result>>> getOuterTests(
      {required String material});
  //
  Future<Either<Exception, Unit>> deleteOuterTest({required String name});
  //
}
