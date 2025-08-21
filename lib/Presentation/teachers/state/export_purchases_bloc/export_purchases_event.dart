part of 'export_purchases_bloc.dart';

abstract class ExportPurchasesEvent extends Equatable {
  const ExportPurchasesEvent();

  @override
  List<Object?> get props => [];
}

class ExportPurchasesRequested extends ExportPurchasesEvent {
  final List<PurchaseItem> purchases;
  final String exportType;
  final String email;

  const ExportPurchasesRequested({
    required this.purchases,
    this.exportType ='test',
    required this.email,
  });

  @override
  List<Object?> get props => [purchases, exportType, email];
}

class ChangeRangeFiltersEvent extends ExportPurchasesEvent {
  const ChangeRangeFiltersEvent({this.starting, this.ending});
  final DateTime? starting, ending;
  @override
  List<Object> get props => [];
}
