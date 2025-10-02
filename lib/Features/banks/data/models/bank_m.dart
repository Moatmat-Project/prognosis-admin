import 'package:moatmat_admin/Features/banks/data/models/bank_properties_m.dart';
import 'package:moatmat_admin/Features/banks/data/models/bank_options_m.dart';
import 'package:moatmat_admin/Features/banks/data/models/information_m.dart';
import 'package:moatmat_admin/Features/banks/domain/entities/bank.dart';

import '../../../tests/data/models/question_m.dart';

class BankModel extends Bank {
  BankModel({
    required super.id,
    required super.teacherEmail,
    required super.information,
    super.properties,
    required super.options,
    required super.questions,
  });

  factory BankModel.fromJson(Map json) {
    return BankModel(
      id: json['id'] ?? 0,
      teacherEmail: json['teacher_email'],
      properties: json["properties"] != null ? BankPropertiesModel.fromJson(json["properties"]) : null,
      options: BankOptionsModel.fromJson(json["options"]),
      information: BankInformationModel.fromJson(json['information']),
      questions: List.generate(
        (json['questions'] as List).length,
        (i) => QuestionModel.fromJson(json['questions'][i]),
      ),
    );
  }

  factory BankModel.fromClass(Bank bank) {
    return BankModel(
      id: bank.id,
      teacherEmail: bank.teacherEmail,
      information: bank.information,
      properties: bank.properties,
      options: bank.options,
      questions: bank.questions,
    );
  }
  toJson() {
    return {
      "teacher_email": teacherEmail,
      "information": BankInformationModel.fromClass(information).toJson(),
      "properties": properties != null ? BankPropertiesModel.fromClass(properties!).toJson() : null,
      "options": BankOptionsModel.fromClass(options).toJson(),
      "questions": List.generate(
        questions.length,
        (i) => QuestionModel.fromClass(questions[i]).toJson(),
      ),
    };
  }

  toJsonWithId() {
    return {
      "id": id,
      "teacher_email": teacherEmail,
      "information": BankInformationModel.fromClass(information).toJson(),
      "properties": properties != null ? BankPropertiesModel.fromClass(properties!).toJson() : null,
      "options": BankOptionsModel.fromClass(options).toJson(),
      "questions": List.generate(
        questions.length,
        (i) => QuestionModel.fromClass(questions[i]).toJson(),
      ),
    };
  }
}
