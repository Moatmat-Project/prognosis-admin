import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../Core/injection/app_inj.dart';
import '../../../../Features/outer_tests/domain/entities/outer_test.dart';
import '../../../../Features/outer_tests/domain/usecases/delete_outer_test_uc.dart';
import '../../../../Features/outer_tests/domain/usecases/get_outer_tests_uc.dart';
import '../../../../Features/students/domain/entities/result.dart';

part 'explore_outer_tests_state.dart';

class ExploreOuterTestsCubit extends Cubit<ExploreOuterTestsState> {
  ExploreOuterTestsCubit() : super(ExploreOuterTestsLoading());
  String material = "";
  List<Result> results = [];
  init({String? material}) async {
    //
    this.material = material ?? this.material;
    //
    emit(ExploreOuterTestsLoading());
    //
    final res = await locator<GetOuterTestsUseCase>().call(material: this.material);
    //
    res.fold(
      (l) {
        print(l);
      },
      (r) {
        //
        emit(ExploreOuterTestsInitial(
          tests: r,
        ));
      },
    );
    //
  }

  deleteTest(int id) async {
    //
    emit(ExploreOuterTestsLoading());
    //
    await locator<DeleteOuterTestUseCase>().call(id: id);
    //
    init(material: material);
    //
  }
}
