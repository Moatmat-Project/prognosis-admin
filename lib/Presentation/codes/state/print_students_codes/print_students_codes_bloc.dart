import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:moatmat_admin/Core/functions/pdf/export_codes_pdf.dart';
import 'package:moatmat_admin/Core/injection/app_inj.dart';
import 'package:moatmat_admin/Features/auth/domain/use_cases/get_users_data_by_ids.dart';
import 'package:moatmat_admin/Features/students/domain/entities/user_data.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

part 'print_students_codes_event.dart';
part 'print_students_codes_state.dart';

class PrintStudentsCodesBloc extends Bloc<PrintStudentsCodesEvent, PrintStudentsCodesState> {
  PrintStudentsCodesBloc() : super(PrintStudentsCodesInitial()) {
    on<PrintCodesEvent>(onPrintCodesEvent);
    on<PrintStudentsSubmitTextCodesEvent>(onPrintStudentsSubmitTextCodesEvent);
  }
  bool onPerPage = false;

  onPrintStudentsSubmitTextCodesEvent(PrintStudentsSubmitTextCodesEvent event, Emitter<PrintStudentsCodesState> emit) async {
    //
    List<String> ids = (event.text.replaceAll(" ", "\n")).split("\n");
    ids.removeWhere((e) => e.isEmpty);
    //
    for (int i = 0; i < ids.length; i++) {
      ids[i] = ids[i].trim();
    }
    //
    onPerPage = event.onPerPage;

    // ///
    // if (kDebugMode) {
    //   final response = await locator<GetUsersDataByIdsUC>().call(ids: ids, isUuid: false);
    //   await response.fold(
    //     (l) {},
    //     (r) async {
    //       if (kDebugMode) {
    //         final file = await exportCodesPdf(codes: r, onPerPage: onPerPage);
    //         open(file);
    //         return;
    //       }
    //     },
    //   );
    //   return;
    // }

    ///
    emit(PrintStudentsCodesLoading());
    //

    final response = await locator<GetUsersDataByIdsUC>().call(ids: ids, isUuid: false);
    await response.fold(
      (l) {},
      (r) async {
        emit(PrintStudentsCodesExploreStudents(ids.map((e) {
          final user = r.where((user) => int.parse(user.id) == int.parse(e)).firstOrNull;
          return (e, user);
        }).toList()));
      },
    );
  }

  onPrintCodesEvent(PrintCodesEvent event, Emitter<PrintStudentsCodesState> emit) async {
    //
    if (event.users.every((e) => e == null)) {
      Fluttertoast.showToast(msg: "لا يوجد طلاب!");
      return;
    }
    //
    emit(PrintStudentsCodesLoading());
    //
    final file = await exportCodesPdf(codes: event.users.where((e) => e != null).toList().map<UserData>((e) => e!).toList(), onPerPage: onPerPage);
    //
    emit(PrintStudentsCodesSuccess(file));
  }
}

Future<String> save(Uint8List bytes) async {
  var directory = await getApplicationDocumentsDirectory();
  String filePath = '${directory.path}/students_qr_codes${DateTime.now().toString().replaceAll(" ", "_").replaceAll("-", "_")}.pdf';
  final file = File(filePath);
  file.createSync(recursive: true);
  await file.writeAsBytes(bytes);
  return filePath;
}

Future<void> share(Uint8List bytes) async {
  var filePath = await save(bytes);
  await Share.shareXFiles([XFile(filePath)]);
}

Future<void> open(Uint8List bytes) async {
  var filePath = await save(bytes);
  await OpenFile.open(filePath);
}
