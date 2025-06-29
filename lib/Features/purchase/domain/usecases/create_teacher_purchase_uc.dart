import 'package:dartz/dartz.dart';
import 'package:moatmat_admin/Features/purchase/domain/repository/purchases_rep.dart';
import '../entities/purchase_item.dart';

class CreateTeacherPurchaseUC {
  final PurchasesRepository repository;

  CreateTeacherPurchaseUC({required this.repository});

  Future<Either<Exception, Unit>> call({required PurchaseItem item}) {
    return repository.createTeacherPurchase(item: item);
  }
}
