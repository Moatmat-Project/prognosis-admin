import 'package:dartz/dartz.dart';
import 'package:moatmat_admin/Features/banks/domain/entities/bank.dart';
import 'package:moatmat_admin/Features/purchase/domain/repository/purchases_rep.dart';

import '../entities/purchase_item.dart';

class TeacherPurchasesUC {
  final PurchasesRepository repository;

  TeacherPurchasesUC({required this.repository});

  Future<Either<Exception, List<PurchaseItem>>> call({required String email}) {
    return repository.teacherPurchases(email: email);
  }
}
