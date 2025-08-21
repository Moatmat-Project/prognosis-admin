import 'package:moatmat_admin/Features/purchase/data/datasources/purchased_items_ds.dart';
import 'package:moatmat_admin/Features/purchase/data/repository/purhcases_repo_impl.dart';
import 'package:moatmat_admin/Features/purchase/domain/usecases/bank_purchases_uc.dart';
import 'package:moatmat_admin/Features/purchase/domain/usecases/get_test_purchase_by_ids_uc.dart';
import '../../Features/purchase/domain/repository/purchases_rep.dart';
import '../../Features/purchase/domain/usecases/cancel_purchase_uc.dart';
import '../../Features/purchase/domain/usecases/create_teacher_purchase_uc.dart';
import '../../Features/purchase/domain/usecases/teacher_purchases_uc.dart';
import '../../Features/purchase/domain/usecases/test_purchases_uc.dart';
import 'app_inj.dart';

purchasesInjector() {
  injectDS();
  injectRepo();
  injectUC();
}

void injectUC() {
  locator.registerFactory<TestPurchasesUC>(
    () => TestPurchasesUC(
      repository: locator(),
    ),
  );
  locator.registerFactory<BankPurchasesUC>(
    () => BankPurchasesUC(
      repository: locator(),
    ),
  );
  locator.registerFactory<CreateTeacherPurchaseUC>(
    () => CreateTeacherPurchaseUC(
      repository: locator(),
    ),
  );
  locator.registerFactory<TeacherPurchasesUC>(
    () => TeacherPurchasesUC(
      repository: locator(),
    ),
  );
  locator.registerFactory<CancelPurchaseUC>(
    () => CancelPurchaseUC(
      repository: locator(),
    ),
  );
  locator.registerFactory<GetTestPurchasesByIdsUC>(
    () => GetTestPurchasesByIdsUC(
      repository: locator(),
    ),
  );
}

void injectRepo() {
  locator.registerFactory<PurchasesRepository>(
    () => PurchasesRepositoryImpl(
      dataSource: locator(),
    ),
  );
}

void injectDS() {
  locator.registerFactory<PurchasedItemsDS>(
    () => PurchasedItemsDSImpl(),
  );
}
