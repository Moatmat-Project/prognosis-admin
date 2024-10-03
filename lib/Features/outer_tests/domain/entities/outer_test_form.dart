import 'package:equatable/equatable.dart';
import 'package:moatmat_admin/Features/outer_tests/domain/entities/outer_question.dart';

class OuterTestForm extends Equatable {
  final int id;
  final List<OuterQuestion> questions;

  const OuterTestForm({
    required this.id,
    required this.questions,
  });

  OuterTestForm copyWith({
    int? id,
    List<OuterQuestion>? questions,
  }) {
    return OuterTestForm(
      id: id ?? this.id,
      questions: questions ?? this.questions,
    );
  }

  @override
  List<Object?> get props => [questions.length];
}
