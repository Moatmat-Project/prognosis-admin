import 'package:dartz/dartz.dart';
import '../entities/group.dart';
import '../repository/groups_repository.dart';

class GetTeacherGroupsUc {
  final GroupsRepository repository;

  GetTeacherGroupsUc({required this.repository});

  Future<Either<Exception, List<Group>>> call({required String teacherEmail}) {
    return repository.getTeacherGroups(teacherEmail: teacherEmail);
  }
}
