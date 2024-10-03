import 'package:dartz/dartz.dart';

import '../../../../Core/errors/exceptions.dart';
import '../entites/code_data.dart';
import '../repository/codes_repository.dart';

class GenerateCodesUC {
  final CodesRepository repository;

  GenerateCodesUC({required this.repository});
  Future<Either<Exception, List<CodeData>>> call({
    required int count,
    required int amount,
  }) async {
    return repository.generateCodes(count: count, amount: amount);
  }
}
