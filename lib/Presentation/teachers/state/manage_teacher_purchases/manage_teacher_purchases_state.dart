part of 'manage_teacher_purchases_bloc.dart';

final class ManageTeacherPurchasesState extends Equatable {
  const ManageTeacherPurchasesState({
    required this.isLoading,
    required this.teacher,
    required this.message,
    required this.items,
  });
  final bool isLoading;
  final String teacher;
  final String? message;
  final List<PurchaseItem> items;

  factory ManageTeacherPurchasesState.loading({ManageTeacherPurchasesState? state}) {
    return ManageTeacherPurchasesState(
      isLoading: true,
      teacher: state?.teacher ?? "",
      message: null,
      items: state?.items ?? [],
    );
  }

  ManageTeacherPurchasesState toLoading() {
    return ManageTeacherPurchasesState(
      isLoading: true,
      teacher: teacher,
      message: message,
      items: items,
    );
  }

  ManageTeacherPurchasesState toInitial({
    required List<PurchaseItem> items,
    String? teacher,
    String? message,
  }) {
    return ManageTeacherPurchasesState(
      isLoading: false,
      teacher: teacher ?? this.teacher,
      message: message ?? this.message,
      items: items,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        teacher,
        message,
        items,
      ];
}
