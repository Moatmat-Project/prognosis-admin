import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../Core/injection/app_inj.dart';
import '../../../auth/domain/entites/teacher_data.dart';
import '../../../students/data/models/result_m.dart';
import '../../../students/domain/entities/result.dart';

abstract class ScannerRemoteDataSource {
  //

  //
  Future<Unit> deleteOuterTest({required String name});
  //
  Future<List<Result>> getOuterTests({required String material});
}

class ScannerRemoteDataSourceImpl implements ScannerRemoteDataSource {
  //

  @override
  Future<Unit> deleteOuterTest({required String name}) async {
    await Supabase.instance.client
        .from("results")
        .delete()
        .eq("teacher_email", locator<TeacherData>().email)
        .eq("test_name", name)
        .isFilter("bank_id", null)
        .isFilter("test_id", null);
    return unit;
  }

  @override
  Future<List<Result>> getOuterTests({required String material}) async {
    //
    //
    List<Result> results = [];
    //
    final res = await Supabase.instance.client
        .from("results")
        .select()
        .isFilter("bank_id", null)
        .isFilter("test_id", null);
    //
    results = res.map((e) {
      return ResultModel.fromJson(e);
    }).toList();
    //
    return results;
  }
}
