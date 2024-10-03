import 'package:dartz/dartz.dart';
import 'package:moatmat_admin/Core/errors/exceptions.dart';
import 'package:moatmat_admin/Features/outer_tests/data/models/outer_test_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entities/outer_test.dart';

abstract class OuterTestsDatasource {
  // get outer tests
  Future<List<OuterTest>> getOuterTests({required String? material});
  //
  // get outer test
  Future<OuterTest> getOuterTestById({required int id});
  //
  // delete outer test
  Future<Unit> deleteOuterTest({required int id});
  //
  // add outer test
  Future<Unit> addOuterTest({required OuterTest test});
  //
  // update outer test
  Future<Unit> updateOuterTest({required OuterTest test});
}

class OuterTestsDatasourceImplements implements OuterTestsDatasource {
  @override
  Future<Unit> addOuterTest({required OuterTest test}) async {
    //
    final json = OuterTestModel.fromClass(test).toJson();
    //
    await Supabase.instance.client.from("outer_tests").insert(json);
    //
    return unit;
  }

  @override
  Future<Unit> deleteOuterTest({required int id}) async {
    //
    await Supabase.instance.client.from("outer_tests").delete().eq("id", id);
    //
    return unit;
  }

  @override
  Future<OuterTest> getOuterTestById({required int id}) async {
    final response = await Supabase.instance.client.from("outer_tests").select().limit(1);
    if (response.isNotEmpty) {
      final List<OuterTest> tests = response.map((e) => OuterTestModel.fromJson(e)).toList();
      return tests.first;
    }
    throw NotFoundException();
  }

  @override
  Future<List<OuterTest>> getOuterTests({required String? material}) async {
    //
    final PostgrestList response;
    if (material != null) {
      response = await Supabase.instance.client.from("outer_tests").select().eq("information->>material", material);
    } else {
      response = await Supabase.instance.client.from("outer_tests").select();
    }
    //
    final List<OuterTest> tests = response.map((e) => OuterTestModel.fromJson(e)).toList();
    //
    return tests;
  }

  @override
  Future<Unit> updateOuterTest({required OuterTest test}) async {
    //
    final json = OuterTestModel.fromClass(test).toJson();
    //
    await Supabase.instance.client.from("outer_tests").update(json).eq("id", test.id);
    //
    return unit;
  }
}
