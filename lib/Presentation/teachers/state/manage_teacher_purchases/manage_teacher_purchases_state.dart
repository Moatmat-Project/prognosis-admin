part of 'manage_teacher_purchases_bloc.dart';

sealed class ManageTeacherPurchasesState extends Equatable {
  const ManageTeacherPurchasesState();
  @override
  List<Object?> get props => [];
}

final class ManageTeacherPurchasesLoadingState extends ManageTeacherPurchasesState {
  const ManageTeacherPurchasesLoadingState();

  @override
  List<Object?> get props => [];
}

final class ManageTeacherPurchasesInitialState extends ManageTeacherPurchasesState {
  const ManageTeacherPurchasesInitialState({
    this.message,
    required List<PurchaseItem> items,
  }) : _items = items;

  final String? message;
  final List<PurchaseItem> _items;
  List<PurchaseItem> get items => _items;
  @override
  List<Object?> get props => [
        message,
        items,
      ];
}

final class ManageTeacherPurchasesAddPurchaseState extends ManageTeacherPurchasesState {
  const ManageTeacherPurchasesAddPurchaseState({
    required this.isLoading,
    this.student,
  });
  final bool isLoading;
  final UserData? student;
  @override
  List<Object?> get props => [isLoading, student];
}
