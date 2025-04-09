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
final class ManageTeacherPurchasesCancelSubscriptionEvent extends ManageTeacherPurchasesEvent {
  const ManageTeacherPurchasesCancelSubscriptionEvent({required this.item});
  final PurchaseItem item;
  @override
  List<Object> get props => [];
}
