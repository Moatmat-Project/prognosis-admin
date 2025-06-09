import 'package:moatmat_admin/Presentation/schools/models/school.dart';

class School {
  final int id;
  final SchoolInformation information;
  final DateTime createdAt;

  School({
    required this.id,
    required this.information,
    required this.createdAt,
  });
}
