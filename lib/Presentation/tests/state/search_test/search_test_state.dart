part of 'search_test_cubit.dart';

sealed class SearchTestState extends Equatable {
  const SearchTestState();

  @override
  List<Object> get props => [];
}

final class SearchTestLoading extends SearchTestState {}

final class SearchTestError extends SearchTestState {
  final String error;

  const SearchTestError({required this.error});
}

final class SearchTestInitial extends SearchTestState {
  final List<Test> tests;

  const SearchTestInitial({required this.tests});

  @override
  List<Object> get props => [tests];
}
