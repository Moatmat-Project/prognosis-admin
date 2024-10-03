
import '../../Features/scanner/data/datasources/scanner_remote_ds.dart';
import '../../Features/scanner/data/repository/scanner_repo_impl.dart';
import '../../Features/scanner/domain/repository/scanner_repo.dart';
import '../../Features/scanner/domain/usecases/delete_outer_tests_uc.dart';
import '../../Features/scanner/domain/usecases/get_outer_tests_uc.dart';
import 'app_inj.dart';

injectScanner() {
  injectDS();
  injectRepo();
  injectUC();
}

void injectUC() {

  locator.registerFactory<DeleteOuterTestsUC>(
    () => DeleteOuterTestsUC(
      repository: locator(),
    ),
  );
  locator.registerFactory<GetOuterTestsUC>(
    () => GetOuterTestsUC(
      repository: locator(),
    ),
  );
}

void injectRepo() {
  locator.registerFactory<ScannerRepository>(
    () => ScannerRepositoryImpl(
      dataSource: locator(),
    ),
  );
}

void injectDS() {
  locator.registerFactory<ScannerRemoteDataSource>(
    () => ScannerRemoteDataSourceImpl(),
  );
}
