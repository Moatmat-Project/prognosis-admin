import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moatmat_admin/Features/schools/domain/entites/school.dart';
import 'package:moatmat_admin/Features/schools/domain/usecases/add_school_uc.dart';
import 'package:moatmat_admin/Features/schools/domain/usecases/delete_school_uc.dart';
import 'package:moatmat_admin/Features/schools/domain/usecases/fetch_all_schools_uc.dart';
import 'package:moatmat_admin/Features/schools/domain/usecases/update_school_uc.dart';

part 'school_event.dart';
part 'school_state.dart';

class SchoolBloc extends Bloc<SchoolEvent, SchoolState> {
  final FetchAllSchools _fetchAllSchools;
  final AddSchool _addSchool;
  final UpdateSchool _updateSchool;
  final DeleteSchool _deleteSchool;

  SchoolBloc({
    required FetchAllSchools fetchAllSchools,
    required AddSchool addSchool,
    required UpdateSchool updateSchool,
    required DeleteSchool deleteSchool,
  })  : _fetchAllSchools = fetchAllSchools,
        _addSchool = addSchool,
        _updateSchool = updateSchool,
        _deleteSchool = deleteSchool,
        super(SchoolInitial()) {
    on<FetchSchools>(_onFetchSchools);
    on<AddSchoolEvent>(_onAddSchool);
    on<UpdateSchoolEvent>(_onUpdateSchool);
    on<DeleteSchoolEvent>(_onDeleteSchool);
  }

  void _onFetchSchools(FetchSchools event, Emitter<SchoolState> emit) async {
    emit(SchoolLoading());
    final result = await _fetchAllSchools();
    result.fold(
      (failure) => emit(SchoolError(message: failure.text)),
      (schools) => emit(SchoolLoaded(schools: schools)),
    );
  }

  void _onAddSchool(AddSchoolEvent event, Emitter<SchoolState> emit) async {
    emit(SchoolLoading());
    final result = await _addSchool(AddSchoolParams(school: event.school));
    result.fold(
      (failure) => emit(SchoolError(message: failure.text)),
      (school) => emit(const SchoolActionSuccess(message: 'School added successfully')),
    );
  }

  void _onUpdateSchool(UpdateSchoolEvent event, Emitter<SchoolState> emit) async {
    emit(SchoolLoading());
    final result = await _updateSchool(UpdateSchoolParams(school: event.school));
    result.fold(
      (failure) => emit(SchoolError(message: failure.text)),
      (school) => emit(const SchoolActionSuccess(message: 'School updated successfully')),
    );
  }

  void _onDeleteSchool(DeleteSchoolEvent event, Emitter<SchoolState> emit) async {
    emit(SchoolLoading());
    final result = await _deleteSchool(DeleteSchoolParams(id: event.id));
    result.fold(
      (failure) => emit(SchoolError(message: failure.text)),
      (_) => emit(const SchoolActionSuccess(message: 'School deleted successfully')),
    );
  }
}
