import '../../../groups/domain/entities/group.dart';
import 'teacher_options.dart';

class TeacherData {
  final String name;
  final String email;
  final int price;
  final String purchaseDescription;
  final TeacherOptions options;
  //
  final String? description;
  final String? image;
  //
  Map<String, dynamic> banksFolders;
  Map<String, dynamic> testsFolders;
  //
  List<Group> groups;

  TeacherData({
    required this.name,
    required this.email,
    required this.options,
    required this.description,
    required this.image,
    required this.purchaseDescription,
    required this.price,
    required this.banksFolders,
    required this.testsFolders,
    required this.groups,
  });

  TeacherData copyWith({
    String? name,
    String? email,
    String? purchaseDescription,
    TeacherOptions? options,
    String? description,
    String? image,
    int? price,
    Map<String, dynamic>? banksFolders,
    Map<String, dynamic>? testsFolders,
    List<Group>? groups,
  }) {
    return TeacherData(
      name: name ?? this.name,
      email: email ?? this.email,
      options: options ?? this.options,
      purchaseDescription: purchaseDescription ?? this.purchaseDescription,
      price: price ?? this.price,
      description: description ?? this.description,
      image: image ?? this.image,
      testsFolders: testsFolders ?? this.testsFolders,
      banksFolders: banksFolders ?? this.banksFolders,
      groups: groups ?? this.groups,
    );
  }
}
