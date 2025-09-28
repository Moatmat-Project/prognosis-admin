import 'package:dartz/dartz.dart';
import 'package:moatmat_admin/Features/banks/domain/entities/bank.dart';
import 'package:moatmat_admin/Features/banks/domain/repository/banks_repository.dart';
 
class GetBanksUC {
  final BanksRepository repository;

  GetBanksUC({required this.repository});

  Future<Either<Exception, List<Bank>>> call() async {
    return await repository.getBanks();
  }
}
