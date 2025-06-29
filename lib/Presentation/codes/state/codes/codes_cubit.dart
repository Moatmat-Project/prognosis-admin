import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:moatmat_admin/Core/injection/app_inj.dart';
import 'package:moatmat_admin/Features/code/domain/entites/code_data.dart';
import 'package:moatmat_admin/Features/code/domain/use_cases/generate_code_uc.dart';
import 'package:moatmat_admin/Features/code/domain/use_cases/generate_codes_uc.dart';

part 'codes_state.dart';

class CodesCubit extends Cubit<CodesState> {
  CodesCubit() : super(CodesInitial());
  List<CodeData> codes = [];

  init() {
    emit(CodesInitial());
  }

  generateCodes({required int count, required int amount}) async {
    //
    emit(CodesLoading());
    //
    var res = await locator<GenerateCodesUC>().call(
      count: count,
      amount: amount,
    );
    //
    //
    res.fold(
      (l) => emit(CodesError(error: l.toString())),
      (r) {
        codes = r;
        emit(CodesGenerateCodes(codes: r));
      },
    );
  }
}
