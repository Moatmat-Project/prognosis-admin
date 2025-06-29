import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:moatmat_admin/Features/tests/domain/entities/test/test.dart';

import '../../../../Core/injection/app_inj.dart';
import '../../../../Features/tests/domain/usecases/search_test_uc.dart';

part 'search_test_state.dart';

class SearchTestCubit extends Cubit<SearchTestState> {
  SearchTestCubit() : super(SearchTestLoading());

  search(String keyword) async {
    //
    emit(SearchTestLoading());
    //
    var res = await locator<SearchTestUC>().call(keyword: keyword);
    //
    res.fold(
      (l) {
        emit(SearchTestError(error: l.toString()));
      },
      (r) {
        emit(SearchTestInitial(tests: r));
      },
    );
  }
}
