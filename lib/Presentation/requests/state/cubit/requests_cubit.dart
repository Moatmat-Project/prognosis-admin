import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:moatmat_admin/Core/injection/app_inj.dart';
import 'package:moatmat_admin/Features/requests/domain/usecases/delete_request_uc.dart';
import 'package:moatmat_admin/Features/requests/domain/usecases/get_requests_uc.dart';

import '../../../../Features/requests/domain/entities/request.dart';

part 'requests_state.dart';

class RequestsCubit extends Cubit<RequestsState> {
  RequestsCubit() : super(RequestsLoading());

  init() async {
    //
    emit(RequestsLoading());
    //
    var res = await locator<GetRequestsUC>().call();
    //
    res.fold(
      (l) => emit(RequestsError(error: l.toString())),
      (r) => emit(RequestsInitial(requests: r)),
    );
  }

  deleteRequest(TeacherRequest request) async {
    //
    emit(RequestsLoading());
    //
    await locator<DeleteRequestUC>().call(request: request);
    //
    init();
  }
}
