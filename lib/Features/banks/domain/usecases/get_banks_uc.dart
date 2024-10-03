import 'package:dartz/dartz.dart';
import 'package:moatmat_admin/Features/banks/domain/entities/bank.dart';
import 'package:moatmat_admin/Features/banks/domain/repository/banks_repository.dart';
import 'package:moatmat_admin/Features/tests/domain/repositories/tests_repository.dart';

class GetBanksUC {
  final BanksRepository repository;

  GetBanksUC({required this.repository});

  Future<Either<Exception, List<Bank>>> call({
     String? material,
  }) async {
    return await repository.getBanks(material: material);
  }
}
