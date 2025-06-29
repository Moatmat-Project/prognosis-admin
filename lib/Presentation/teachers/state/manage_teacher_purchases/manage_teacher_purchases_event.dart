part of 'manage_teacher_purchases_bloc.dart';

sealed class ManageTeacherPurchasesEvent extends Equatable {
  const ManageTeacherPurchasesEvent();

  @override
  List<Object> get props => [];
}

final class ManageTeacherPurchasesLoadEvent extends ManageTeacherPurchasesEvent {
  const ManageTeacherPurchasesLoadEvent({required this.teacher});
  final TeacherData teacher;
  @override
  List<Object> get props => [];
}

final class ManageTeacherPurchasesStartAddPurchaseEvent extends ManageTeacherPurchasesEvent {
  const ManageTeacherPurchasesStartAddPurchaseEvent();
  @override
  List<Object> get props => [];
}

final class ManageTeacherPurchasesAddPurchaseEvent extends ManageTeacherPurchasesEvent {
  const ManageTeacherPurchasesAddPurchaseEvent({
    required this.id,
    this.confirmed = false,
    this.userData,
  });
  final String id;
  final UserData? userData;
  final bool confirmed;
  @override
  List<Object> get props => [];
}

final class ManageTeacherPurchasesCancelSubscriptionEvent extends ManageTeacherPurchasesEvent {
  const ManageTeacherPurchasesCancelSubscriptionEvent({required this.item});
  final PurchaseItem item;
  @override
  List<Object> get props => [];
}
