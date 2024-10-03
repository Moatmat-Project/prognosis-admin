import 'package:dartz/dartz.dart';
import 'package:moatmat_admin/Features/groups/domain/entities/group_item.dart';

import '../entities/group.dart';

abstract class GroupsRepository {
  // get groups
  Future<Either<Exception, List<Group>>> getGroups();
  // get groups
  Future<Either<Exception, List<Group>>> getTeacherGroups({required String teacherEmail});
  // add group
  Future<Either<Exception, Unit>> addGroup({
    required Group group,
  });
  // add to group
  Future<Either<Exception, Unit>> addToGroup({
    required int groupId,
    required GroupItem item,
  });
  // remove form group
  Future<Either<Exception, Unit>> removeFromGroup({
    required int groupId,
    required int itemId,
  });
  // remove form group
  Future<Either<Exception, Unit>> removeGroup({
    required int groupId,
  });
}
