import 'package:dartz/dartz.dart';
import 'package:moatmat_admin/Features/buckets/domain/repository/buckets_repo.dart';
import 'package:moatmat_admin/Features/tests/domain/entities/test/test.dart';

class DeleteFileUC {
  final BucketsRepository repository;

  DeleteFileUC({required this.repository});

  Future<Either<Exception, Unit>> call({
    required String link,
    required String bucket,
  }) async {
    return await repository.deleteFile(link: link, bucket: bucket);
  }
}
