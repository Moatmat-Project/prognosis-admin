import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../Core/injection/app_inj.dart';
import '../../../../Features/outer_tests/domain/entities/outer_test.dart';
import '../../../../Features/outer_tests/domain/usecases/get_outer_test_by_id_uc.dart';

part 'outer_test_information_state.dart';

class OuterTestInformationCubit extends Cubit<OuterTestInformationState> {
  OuterTestInformationCubit() : super(OuterTestInformationLoading());

  init({OuterTest? test, int? testId}) async {
    //
    print("1");
    //
    emit(OuterTestInformationLoading());
    //
    if (test == null) {
      print("2");
      //
      var res1 = await locator<GetOuterTestByIdUseCase>().call(
        id: testId!,
      );
      //
      res1.fold(
        (l) {
          print(l);
        },
        (r) {
          emit(
            OuterTestInformationInitial(
              test: r,
            ),
          );
        },
      );
    } else {
      emit(
        OuterTestInformationInitial(
          test: test,
        ),
      );
    }
    //
  }
}
