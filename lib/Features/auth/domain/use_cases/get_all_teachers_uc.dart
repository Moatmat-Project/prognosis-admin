import 'package:dartz/dartz.dart';
import 'package:moatmat_admin/Features/auth/domain/repository/teachers_repository.dart';

import '../entites/teacher_data.dart';

class GetAllTeachersUC {
  final TeacherRepository repository;

  GetAllTeachersUC({required this.repository});

  Future<Either<Exception, List<TeacherData>>> call() {
    return repository.getALlTeachers();
  }
}
