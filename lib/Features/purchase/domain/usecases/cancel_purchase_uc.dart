import 'package:dartz/dartz.dart';
import 'package:moatmat_admin/Features/banks/domain/entities/bank.dart';
import 'package:moatmat_admin/Features/purchase/domain/repository/purchases_rep.dart';

import '../entities/purchase_item.dart';

class CancelPurchaseUC {
  final PurchasesRepository repository;

  CancelPurchaseUC({required this.repository});

  Future<Either<Exception, Unit>> call({required PurchaseItem item}) {
    return repository.cancelPurchase(item: item);
  }
}
