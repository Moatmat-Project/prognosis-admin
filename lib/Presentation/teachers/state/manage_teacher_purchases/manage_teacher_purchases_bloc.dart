import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:moatmat_admin/Features/auth/domain/entites/teacher_data.dart';
import 'package:moatmat_admin/Features/purchase/domain/entities/purchase_item.dart';
import 'package:moatmat_admin/Features/purchase/domain/usecases/cancel_purchase_uc.dart';

import '../../../../Core/injection/app_inj.dart';
import '../../../../Features/purchase/domain/usecases/teacher_purchases_uc.dart';

part 'manage_teacher_purchases_event.dart';
part 'manage_teacher_purchases_state.dart';

class ManageTeacherPurchasesBloc extends Bloc<ManageTeacherPurchasesEvent, ManageTeacherPurchasesState> {
  ManageTeacherPurchasesBloc() : super(ManageTeacherPurchasesState.loading()) {
    on<ManageTeacherPurchasesLoadEvent>(onManageTeacherPurchasesLoadEvent);
    on<ManageTeacherPurchasesCancelSubscriptionEvent>(onManageTeacherPurchasesCancelSubscriptionEvent);
  }
  onManageTeacherPurchasesLoadEvent(ManageTeacherPurchasesLoadEvent event, Emitter<ManageTeacherPurchasesState> emit) async {
    //
    emit(state.toLoading());
    //
    var res = await locator<TeacherPurchasesUC>().call(email: event.teacher.email);
    //
    res.fold(
      (l) {
        emit(state.toInitial(items: [], message: l.toString(), teacher: event.teacher.email));
      },
      (r) {
        emit(state.toInitial(items: r, teacher: event.teacher.email));
      },
    );
  }

  onManageTeacherPurchasesCancelSubscriptionEvent(ManageTeacherPurchasesCancelSubscriptionEvent event, Emitter<ManageTeacherPurchasesState> emit) async {
    //
    emit(state.toLoading());

    //
    await locator<CancelPurchaseUC>().call(item: event.item).then((res) {
      res.fold(
        (l) {
          Fluttertoast.showToast(msg: l.toString());
        },
        (r) {
          Fluttertoast.showToast(msg: "تم الغاء الاشتراك بنحاح");
        },
      );
    });

    //
    var res = await locator<TeacherPurchasesUC>().call(email: state.teacher);
    //
    res.fold(
      (l) {
        emit(state.toInitial(items: [], message: l.toString()));
      },
      (r) {
        emit(state.toInitial(items: r));
      },
    );
  }
}
