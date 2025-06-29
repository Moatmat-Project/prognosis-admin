import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:moatmat_admin/Core/injection/app_inj.dart';
import 'package:moatmat_admin/Features/banks/domain/usecases/search_bank_uc.dart';

import '../../../../Features/banks/domain/entities/bank.dart';

part 'search_bank_state.dart';

class SearchBankCubit extends Cubit<SearchBankState> {
  SearchBankCubit() : super(SearchBankLoading());

  search(String keyword) async {
    //
    emit(SearchBankLoading());
    //
    var res = await locator<SearchBankUC>().call(keyword: keyword);
    //
    res.fold(
      (l) {
        emit(SearchBankError(error: l.toString()));
      },
      (r) {
        emit(SearchBankInitial(banks: r));
      },
    );
  }
}
