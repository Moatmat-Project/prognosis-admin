// ignore_for_file: constant_identifier_names

import '../../../students/domain/entities/user_data.dart';

class PaperSettings {
  final String title;
  final DateTime date;
  final PaperType type;
  final List<int?> selections;
  final List<List<int>> answers;
  final int formsCount;

  PaperSettings({
    required this.title,
    required this.date,
    required this.type,
    required this.selections,
    required this.answers,
    required this.formsCount,
  });

  PaperSettings copyWith({
    String? title,
    DateTime? date,
    PaperType? type,
    List<int?>? selections,
    List<List<int>>? answers,
    int? formsCount,
  }) {
    return PaperSettings(
      title: title ?? this.title,
      date: date ?? this.date,
      type: type ?? this.type,
      selections: selections ?? this.selections,
      answers: answers ?? this.answers,
      formsCount: formsCount ?? this.formsCount,
    );
  }
}

enum PaperType { A4, A5, A6 }
