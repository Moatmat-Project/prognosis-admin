part of 'codes_cubit.dart';

sealed class CodesState extends Equatable {
  const CodesState();

  @override
  List<Object> get props => [];
}

final class CodesLoading extends CodesState {}

final class CodesError extends CodesState {
  final String error;

  const CodesError({required this.error});
}

final class CodesInitial extends CodesState {}

final class CodesGenerateCode extends CodesState {
  final CodeData code;

  const CodesGenerateCode({required this.code});
}
final class CodesGenerateCodes extends CodesState {
  final List<CodeData> codes;

  const CodesGenerateCodes({required this.codes});
}
