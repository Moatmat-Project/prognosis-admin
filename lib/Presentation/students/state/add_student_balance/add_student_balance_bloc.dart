import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:moatmat_admin/Features/students/domain/entities/user_data.dart';
import 'package:moatmat_admin/Features/students/domain/usecases/add_student_balance_uc.dart';

import '../../../../Core/errors/exceptions.dart';
import '../../../../Core/injection/app_inj.dart';
import '../../../../Features/auth/domain/use_cases/get_user_data.dart';

part 'add_student_balance_event.dart';
part 'add_student_balance_state.dart';

class AddStudentBalanceBloc extends Bloc<AddStudentBalanceEvent, AddStudentBalanceState> {
  AddStudentBalanceBloc() : super(AddStudentBalanceState.initial()) {
    on<AddStudentBalanceSubmitFieldsEvent>(onAddStudentBalanceSubmitFieldsEvent);
  }
  onAddStudentBalanceSubmitFieldsEvent(AddStudentBalanceSubmitFieldsEvent event, Emitter<AddStudentBalanceState> emit) async {
    emit(AddStudentBalanceState.loading());
    if (!event.confirmed) {
      final response = await locator<GetUserDataUC>().call(id: event.studentId, isUuid: false);
      response.fold(
        (l) {
          if (l is NotFoundFailure) {
            Fluttertoast.showToast(msg: l.text);
          }
          emit(AddStudentBalanceState.initial());
        },
        (r) {
          emit(AddStudentBalanceState.confirmation(r));
        },
      );
    } else {
      final response = await locator<AddStudentBalanceUC>().call(
        studentId: event.studentId,
        amount: event.amount,
      );
      await response.fold(
        (l) {
          if (l is NotFoundException) {
            Fluttertoast.showToast(msg: NotFoundFailure().text);
          }
          Fluttertoast.showToast(msg: l.toString());
          emit(AddStudentBalanceState.initial());
        },
        (r) async {
          Fluttertoast.showToast(msg: "تم شحن الرصيد بنجاح");
          emit(AddStudentBalanceState.success());
        },
      );
    }
  }
}
