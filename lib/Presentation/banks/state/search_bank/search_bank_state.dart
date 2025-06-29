part of 'search_bank_cubit.dart';

sealed class SearchBankState extends Equatable {
  const SearchBankState();

  @override
  List<Object> get props => [];
}

final class SearchBankLoading extends SearchBankState {}

final class SearchBankError extends SearchBankState {
  final String error;

  const SearchBankError({required this.error});
}

final class SearchBankInitial extends SearchBankState {
  final List<Bank> banks;

  const SearchBankInitial({required this.banks});

  @override
  List<Object> get props => [banks];
}
