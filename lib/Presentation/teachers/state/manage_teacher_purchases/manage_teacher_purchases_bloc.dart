import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:moatmat_admin/Core/errors/exceptions.dart';
import 'package:moatmat_admin/Features/auth/domain/entites/teacher_data.dart';
import 'package:moatmat_admin/Features/auth/domain/use_cases/get_user_data.dart';
import 'package:moatmat_admin/Features/purchase/domain/entities/purchase_item.dart';
import 'package:moatmat_admin/Features/purchase/domain/usecases/cancel_purchase_uc.dart';
import 'package:moatmat_admin/Features/purchase/domain/usecases/create_teacher_purchase_uc.dart';
import 'package:moatmat_admin/Features/students/domain/entities/user_data.dart';

import '../../../../Core/injection/app_inj.dart';
import '../../../../Features/purchase/domain/usecases/teacher_purchases_uc.dart';

part 'manage_teacher_purchases_event.dart';
part 'manage_teacher_purchases_state.dart';

class ManageTeacherPurchasesBloc extends Bloc<ManageTeacherPurchasesEvent, ManageTeacherPurchasesState> {
  TeacherData? teacher;
  ManageTeacherPurchasesBloc() : super(ManageTeacherPurchasesLoadingState()) {
    on<ManageTeacherPurchasesLoadEvent>(onManageTeacherPurchasesLoadEvent);
    on<ManageTeacherPurchasesCancelSubscriptionEvent>(onManageTeacherPurchasesCancelSubscriptionEvent);
    on<ManageTeacherPurchasesStartAddPurchaseEvent>(onManageTeacherPurchasesStartAddPurchaseEvent);
    on<ManageTeacherPurchasesAddPurchaseEvent>(onManageTeacherPurchasesAddPurchaseEvent);
  }
  onManageTeacherPurchasesLoadEvent(ManageTeacherPurchasesLoadEvent event, Emitter<ManageTeacherPurchasesState> emit) async {
    //
    emit(ManageTeacherPurchasesLoadingState());
    //
    teacher = event.teacher;
    //
    var res = await locator<TeacherPurchasesUC>().call(email: event.teacher.email);
    //
    res.fold(
      (l) {
        emit(ManageTeacherPurchasesInitialState(items: [], message: l.toString()));
      },
      (r) {
        emit(ManageTeacherPurchasesInitialState(items: r));
      },
    );
  }

  onManageTeacherPurchasesStartAddPurchaseEvent(ManageTeacherPurchasesStartAddPurchaseEvent event, Emitter<ManageTeacherPurchasesState> emit) async {
    emit(ManageTeacherPurchasesAddPurchaseState(isLoading: false));
  }

  onManageTeacherPurchasesAddPurchaseEvent(ManageTeacherPurchasesAddPurchaseEvent event, Emitter<ManageTeacherPurchasesState> emit) async {
    emit(ManageTeacherPurchasesAddPurchaseState(isLoading: true));
    if (!event.confirmed) {
      final response = await locator<GetUserDataUC>().call(id: event.id, isUuid: false);
      response.fold(
        (l) {
          if (l is NotFoundFailure) {
            Fluttertoast.showToast(msg: l.text);
          }
          emit(ManageTeacherPurchasesAddPurchaseState(isLoading: false));
        },
        (r) {
          emit(ManageTeacherPurchasesAddPurchaseState(isLoading: false, student: r));
        },
      );
    } else {
      final response = await locator<CreateTeacherPurchaseUC>().call(
        item: PurchaseItem(
          uuid: event.userData!.uuid,
          userName: event.userData!.name,
          amount: teacher!.price,
          itemType: "teacher",
          itemId: teacher!.email,
          dayAndMoth: "${DateTime.now().day}/${DateTime.now().month}",
        ),
      );
      await response.fold(
        (l) {
          if (l is DuplicatedSubscriptionException) {
            Fluttertoast.showToast(msg: "الطالب ضمن مشتركين المعلم!");
          } else {
            Fluttertoast.showToast(msg: l.toString());
          }
          emit(ManageTeacherPurchasesAddPurchaseState(isLoading: false));
        },
        (r) async {
          Fluttertoast.showToast(msg: "تم الاضافة بنجاح");
          await onManageTeacherPurchasesLoadEvent(
            ManageTeacherPurchasesLoadEvent(teacher: teacher!),
            emit,
          );
        },
      );
    }
  }

  onManageTeacherPurchasesCancelSubscriptionEvent(ManageTeacherPurchasesCancelSubscriptionEvent event, Emitter<ManageTeacherPurchasesState> emit) async {
    //
    emit(ManageTeacherPurchasesLoadingState());

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
    var res = await locator<TeacherPurchasesUC>().call(email: teacher!.email);
    //
    res.fold(
      (l) {
        emit(ManageTeacherPurchasesInitialState(items: [], message: l.toString()));
      },
      (r) {
        emit(ManageTeacherPurchasesInitialState(items: r));
      },
    );
  }
}
