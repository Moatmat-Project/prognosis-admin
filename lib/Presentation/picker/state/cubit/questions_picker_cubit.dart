import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../Core/injection/app_inj.dart';
import '../../../../Features/auth/domain/entites/teacher_data.dart';
import '../../../../Features/auth/domain/use_cases/get_all_teachers_uc.dart';
import '../../../../Features/banks/domain/entities/bank.dart';
import '../../../../Features/tests/domain/entities/question/question.dart';
import '../../../../Features/tests/domain/entities/test/test.dart';

part 'questions_picker_state.dart';

class QuestionsPickerCubit extends Cubit<QuestionsPickerState> {
  QuestionsPickerCubit() : super(QuestionsPickerLoading());
  //
  late List<Question> questions;
  //
  late String currentTeacher;
  late bool isTest;

  init() async {
    //
    questions = [];
    //
    emit(QuestionsPickerLoading());
    //
    pickTeachers();
  }

  pickTeachers() async {
    //
    final teachers = await locator<GetAllTeachersUC>().call();
    //
    teachers.fold(
      (l) {
        emit(const QuestionsPickerTeacher(teachers: []));
      },
      (r) {
        emit(QuestionsPickerTeacher(teachers: r));
      },
    );
  }

  //

  //
  setTeacher(String email) {
    //
    currentTeacher = email;
    //
    pickRepository();
  }

  //
  pickRepository() {
    //
    emit(QuestionsPickerLoading());
    //
    emit(QuestionsPickerRepository(teacher: currentTeacher));
  }

  setRepository({Bank? bank, Test? test}) {
    emit(QuestionsPickerQuestions(
      questions: bank?.questions ?? test!.questions,
    ));
  }

  //
  //
  addQuestion(Question q) {
    questions.add(q);
  }

  //
}
