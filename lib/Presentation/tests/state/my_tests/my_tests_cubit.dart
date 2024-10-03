import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:moatmat_admin/Core/injection/app_inj.dart';
import 'package:moatmat_admin/Features/tests/domain/entities/test/test.dart';
import 'package:moatmat_admin/Features/tests/domain/usecases/delete_test_uc.dart';
import 'package:moatmat_admin/Features/tests/domain/usecases/get_tests_uc.dart';

part 'my_tests_state.dart';

class MyTestsCubit extends Cubit<MyTestsState> {
  MyTestsCubit() : super(MyTestsLoading());
  //
  late String material;
  //
  init({String? material}) async {
    //
    this.material = material ?? this.material;
    //
    emit(MyTestsLoading());
    var res = await locator<GetTestsUC>().call(material: this.material);
    res.fold(
      (l) => emit(MyTestsError(exception: l)),
      (r) => emit(MyTestsInitial(tests: List.from(r))),
    );
  }

  update() async {
    emit(MyTestsLoading());
    var res = await locator<GetTestsUC>().call(material: material);
    res.fold(
      (l) => emit(MyTestsError(exception: l)),
      (r) => emit(MyTestsInitial(tests: List.from(r))),
    );
  }

  Future<void> deleteTest(Test test) async {
    var res = await locator<DeleteTestsUC>().call(testId: test.id);
    res.fold(
      (l) => emit(MyTestsError(exception: l)),
      (r) => update(),
    );
    return;
  }
}
