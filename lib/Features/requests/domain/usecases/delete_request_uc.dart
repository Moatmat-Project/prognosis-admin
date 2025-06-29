import 'package:dartz/dartz.dart';
import 'package:moatmat_admin/Features/requests/domain/entities/request.dart';
import 'package:moatmat_admin/Features/requests/domain/repository/requests_repo.dart';

class DeleteRequestUC {
  final RequestRepository repository;

  DeleteRequestUC({required this.repository});

  Future<Either<Exception, Unit>> call({required TeacherRequest request}) {
    return repository.deleteRequest(request: request);
  }
}
