import 'package:moatmat_admin/Core/injection/app_inj.dart';
import 'package:moatmat_admin/Features/schools/data/datasources/school_remote_data_source.dart';
import 'package:moatmat_admin/Features/schools/data/repository/school_repository_impl.dart';
import 'package:moatmat_admin/Features/schools/domain/repository/school_repository.dart';
import 'package:moatmat_admin/Features/schools/domain/usecases/add_school_uc.dart';
import 'package:moatmat_admin/Features/schools/domain/usecases/delete_school_uc.dart';
import 'package:moatmat_admin/Features/schools/domain/usecases/fetch_all_schools_uc.dart';
import 'package:moatmat_admin/Features/schools/domain/usecases/update_school_uc.dart';

injectSchools() {
  injectDS();
  injectRepo();
  injectUC();
}

void injectUC() {
  locator.registerFactory<AddSchoolUC>(
    () => AddSchoolUC(
      locator(),
    ),
  );
  locator.registerFactory<UpdateSchoolUC>(
    () => UpdateSchoolUC(
      locator(),
    ),
  );
  locator.registerFactory<DeleteSchoolUC>(
    () => DeleteSchoolUC(
      locator(),
    ),
  );
  locator.registerFactory<FetchAllSchoolsUC>(
    () => FetchAllSchoolsUC(
      locator(),
    ),
  );
}

void injectRepo() {
  locator.registerFactory<SchoolRepository>(
    () => SchoolRepositoryImpl(
      remoteDataSource: locator(),
    ),
  );
}

void injectDS() {
  locator.registerFactory<SchoolRemoteDataSource>(
    () => SchoolRemoteDataSourceImpl(),
  );
}
