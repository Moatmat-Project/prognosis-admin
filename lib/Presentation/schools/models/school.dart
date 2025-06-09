class School {
  final int id;
  final SchoolInformation information;

  School({
    required this.id,
    required this.information,
  });
}

class SchoolInformation {
  final String name;
  final String description;

  SchoolInformation({
    required this.name,
    required this.description,
  });
}
