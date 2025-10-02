import 'package:moatmat_admin/Features/banks/domain/entities/bank_properties.dart';
import 'package:moatmat_admin/Features/banks/domain/entities/bank_options.dart';
import 'package:moatmat_admin/Features/tests/domain/entities/question/question.dart';

import 'bank_information.dart';

class Bank {
  final int id;
  final String teacherEmail;
  final BankInformation information;
  final BankProperties? properties;
  final BankOptions options;
  final List<Question> questions;
  
  Bank({
    required this.id,
    required this.teacherEmail,
    required this.information,
    this.properties,
    required this.options,
    required this.questions,
  });

  Bank copyWith({
    int? id,
    String? teacherEmail,
    BankInformation? information,
    BankProperties? properties,
    BankOptions? options,
    List<Question>? questions,
  }) {
    return Bank(
      id: id ?? this.id,
      teacherEmail: teacherEmail ?? this.teacherEmail,
      information: information ?? this.information,
      properties: properties ?? this.properties,
      options: options ?? this.options,
      questions: questions ?? this.questions,
    );
  }
}
