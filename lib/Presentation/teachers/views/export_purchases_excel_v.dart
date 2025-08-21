import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:moatmat_admin/Features/purchase/domain/entities/purchase_item.dart';
import 'package:moatmat_admin/Presentation/teachers/views/manage_teacher_purchases_view.dart';
import 'package:moatmat_admin/Presentation/teachers/state/export_purchases_bloc/export_purchases_bloc.dart';

class ExportPurchasesExcelView extends StatefulWidget {
  const ExportPurchasesExcelView({
    super.key,
    required this.purchases,
    required this.teacherEmail,
  });
  final List<PurchaseItem> purchases;
  final String teacherEmail;

  @override
  State<ExportPurchasesExcelView> createState() => _ExportPurchasesExcelViewState();
}

class _ExportPurchasesExcelViewState extends State<ExportPurchasesExcelView> {
  late DateTime _starting;
  late DateTime _ending;

  DateTime _parseMMDDToCurrentYear(String mmdd) {
    final now = DateTime.now();
    final parsed = DateFormat('MM/dd').parse(mmdd);
    return DateTime(now.year, parsed.month, parsed.day);
  }

  @override
  void initState() {
    super.initState();

    if (widget.purchases.isEmpty) {
      final now = DateTime.now();
      _starting = DateTime(now.year, 1, 1);
      _ending = DateTime(now.year, 12, 31);
    } else {
      final sortedDates = widget.purchases.map((p) => _parseMMDDToCurrentYear(p.dayAndMoth)).toList()..sort((a, b) => a.compareTo(b)); // ascending

      _starting = sortedDates.first;
      _ending = sortedDates.last;
    }
    // context.read<ExportPurchasesBloc>().add(
    //       ChangeRangeFiltersEvent(starting: _starting, ending: _ending),
    //     );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "تصدير ملف excel",
          style: TextStyle(
            fontSize: 16,
          ),
        ),
      ),
      body: BlocConsumer<ExportPurchasesBloc, ExportPurchasesInitial>(
        listener: (context, state) {
          if (state.message != null) {
            Fluttertoast.showToast(msg: state.message!);
          }
        },
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(
              child: CupertinoActivityIndicator(),
            );
          }
          return Column(
            children: [
              TimeRangeWidget(
                starting: _starting,
                ending: _ending,
                onChangeStartingDate: (date) {
                  setState(() {
                    _starting = date;
                    if (_ending.isBefore(_starting)) {
                      _ending = _starting;
                    }
                  });
                  context.read<ExportPurchasesBloc>().add(
                        ChangeRangeFiltersEvent(starting: _starting, ending: _ending),
                      );
                },
                onChangeEndingDate: (date) {
                  setState(() {
                    _ending = date;
                    if (_ending.isBefore(_starting)) {
                      _starting = _ending;
                    }
                  });
                  context.read<ExportPurchasesBloc>().add(
                        ChangeRangeFiltersEvent(starting: _starting, ending: _ending),
                      );
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                child: Text('تصدير عمليات الشراء للاشتراكات'),
                onPressed: () {
                  // filter data on date
                  final filtered = widget.purchases.where((p) {
                    final d = _parseMMDDToCurrentYear(p.dayAndMoth);
                    return !d.isBefore(_starting) && !d.isAfter(_ending);
                  }).toList();
                  //
                  context.read<ExportPurchasesBloc>().add(
                        ExportPurchasesRequested(purchases: filtered, exportType: 'teacher', email: widget.teacherEmail),
                      );
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                child: Text('تصدير عمليات الشراء للاختبارات'),
                onPressed: () {
                  // filter data on date
                  final filtered = widget.purchases.where((p) {
                    final d = _parseMMDDToCurrentYear(p.dayAndMoth);
                    return !d.isBefore(_starting) && !d.isAfter(_ending);
                  }).toList();
                  //
                  context.read<ExportPurchasesBloc>().add(
                        ExportPurchasesRequested(purchases: filtered, email: widget.teacherEmail),
                      );
                },
              ),
              SizedBox(height: 20),
            ],
          );
        },
      ),
    );
  }
}
