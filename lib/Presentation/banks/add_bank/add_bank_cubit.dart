import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:moatmat_admin/Core/errors/exceptions.dart';
import 'package:moatmat_admin/Features/auth/domain/entites/teacher_data.dart';
import 'package:moatmat_admin/Features/banks/domain/entities/bank_information.dart';
import 'package:moatmat_admin/Features/banks/domain/entities/bank_properties.dart';
import 'package:moatmat_admin/Features/banks/domain/entities/bank_options.dart';
import 'package:moatmat_admin/Features/banks/domain/usecases/update_bank_uc.dart';
import 'package:moatmat_admin/Features/banks/domain/usecases/upload_bank_uc.dart';
import 'package:moatmat_admin/Features/requests/domain/entities/request.dart';
import 'package:moatmat_admin/Features/schools/domain/entites/school.dart';
import 'package:moatmat_admin/Features/schools/domain/usecases/fetch_all_schools_uc.dart';
import 'package:moatmat_admin/Features/auth/domain/use_cases/update_user_data_uc.dart';
 import '../../../../Core/injection/app_inj.dart';
import '../../../../Core/services/questions_cash_s.dart';
import '../../../../Features/banks/domain/entities/bank.dart';
import '../../../../Features/requests/domain/usecases/send_request_uc.dart';
import '../../../../Features/tests/domain/entities/question/question.dart';

part 'add_bank_state.dart';

class AddBankCubit extends Cubit<AddBankState> {
  AddBankCubit() : super(const AddBankLoading());
  Bank? bank;
  BankInformation? information;
  BankProperties? properties;
  List<Question> questions = [];
  TeacherRequest request = TeacherRequest(
    id: 0,
    teacherData: locator<TeacherData>(),
    files: [],
    date: DateTime.now(),
  );

  init({Bank? bank}) async {
    //
    this.bank = bank;
    //
    emit(const AddBankLoading());
    //
    Future.microtask(() {
      if (bank == null) {}
      //
      information = bank?.information;
      //
      if (this.bank != null) {
        information = information!.copyWith(
          teacher: this.bank?.teacherEmail,
        );
      }
      //
      questions = [];
      if (bank != null) {
        for (int i = 0; i < bank.questions.length; i++) {
          questions.add(bank.questions[i].copyWith(id: i + 1));
        }
        QuestionsCashS.clearQuestions("bank");
      }
      emitBankInformation();
    });
  }

  // cash
  loadQuestions() async {
    //
    emit(const AddBankLoading());
    //
    questions = await QuestionsCashS.loadQuestions("bank");
    //
    emitBankQuestions();
  }

  // actions
  setBankInformation({required BankInformation information}) {
    this.information = information;
    emitBankProperties();
  }

  setTestProperties({required BankProperties properties}) {
    this.properties = properties;

    emitBankQuestions();
  }

  setBankQuestions({required Question question}) {
    List<Question> newList = List<Question>.from(questions)..add(question);
    questions = newList;
    //
    QuestionsCashS.cashQuestions(questions, "bank");
    //
    emit(AddBankQuestions(questions: newList));
  }

  updateBankQuestions({required Question question, required int index}) {
    //
    questions[index] = question;
    //
    List<Question> newList = [];
    //
    for (int i = 0; i < questions.length; i++) {
      newList.add(questions[i].copyWith(id: i + 1));
    }
    //
    questions = newList;
    //
    emit(AddBankQuestions(questions: newList));
  }

  updateBankRequest({required String text, required List<String> files}) {
    request = request.copyWith(
      files: files,
      text: text,
    );
  }

  removeQuestion(int index) {
    questions.removeAt(index);

    List<Question> newList = [];
    //
    for (int i = 0; i < questions.length; i++) {
      newList.add(questions[i].copyWith(id: i + 1));
    }
    questions = newList;

    emit(AddBankQuestions(questions: newList));
  }

  //
  uploadBank() async {
    emit(const AddBankLoading());
    //
    if (bank != null) {
      bank = bank!.copyWith(
        id: bank!.id,
        teacherEmail: information!.teacher,
        properties: properties!,
        information: information!,
        questions: questions,
      );
      // upload Bank information
      var res = await locator<UpdateBankUC>().call(bank: bank!);
      //
      res.fold(
        (l) => emit(AddBankError(exception: l)),
        (r) async {
          await for (var b in r) {
            emit(AddBankLoading(details: b));
          }
          emit(AddBankDone());
        },
      );
    } else {
      bank = Bank(
        id: 0,
        teacherEmail: information!.teacher,
        information: information!,
        properties: properties,
        options: BankOptions(
          scrollable: properties?.scrollable ?? false,
          visible: properties?.visible ?? false,
          downloadable: false,
        ),
        questions: questions,
      );
      // upload Bank information
      var res = await locator<UploadBankUC>().call(bank: bank!);
      //
      res.fold(
        (l) => emit(AddBankError(exception: l)),
        (r) async {
          await for (var b in r) {
            emit(AddBankLoading(details: b));
          }
          
          // Update teacher's college ID if collegeId is provided
          if (information?.collegeId != null) {
            try {
              final currentTeacher = locator<TeacherData>();
              final updatedTeacher = currentTeacher.copyWith(
                collegeId: int.tryParse(information!.collegeId!),
              );
              
              await locator<UpdateTeacherDataUC>().call(teacherData: updatedTeacher);
            } catch (e) {
              // Log error but don't fail the bank upload
              print('Failed to update teacher college ID: $e');
            }
          }
          
          emit(AddBankDone());
        },
      );
    }

    //s
  }

  uploadBankRequest() async {
    //
    bank = Bank(
      id: 0,
      teacherEmail: bank!.information.teacher,
      information: information!,
      properties: properties,
      options: BankOptions(
        scrollable: properties?.scrollable ?? false,
        visible: properties?.visible ?? false,
        downloadable: false,
      ),
      questions: [],
    );
    //
    emit(const AddBankLoading());
    //
    request = request.copyWith(bank: bank);
    //
    var res = await locator<SendRequestUC>().call(request);
    //
    res.fold((l) => emit(AddBankError(exception: l)), (r) async {
      await for (var msg in r) {
        emit(AddBankLoading(details: msg));
      }
      emit(AddBankDone());
    });
  }

  // views
  Future<void> emitBankInformation() async {
    final response = await locator<FetchAllSchoolsUC>().call();
    response.fold(
      (l) {
        emit(AddBankError(exception: AnonException()));
      },
      (r) {
        emit(AddBankInformation(information: information, schools: r));
      },
    );
  }

  emitBankProperties() {
    emit(AddBankProperties(properties: properties));
  }

  emitBankQuestions() {
    if (!locator<TeacherData>().options.allowInsert && bank == null) {
      emit(AddBankPickFiles(files: request.files));
      return;
    }

    List<Question> newQuestions = List<Question>.from(questions);
    emit(AddBankQuestions(questions: newQuestions));
  }
}
