import 'package:dartz/dartz.dart';
import 'package:moatmat_admin/Core/errors/exceptions.dart';
import 'package:moatmat_admin/Core/injection/app_inj.dart';
import 'package:moatmat_admin/Features/auth/domain/entites/teacher_data.dart';
import 'package:moatmat_admin/Features/students/data/models/result_m.dart';
import 'package:moatmat_admin/Features/students/data/models/user_data_m.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../auth/domain/use_cases/get_users_data_by_ids.dart';
import '../../../banks/domain/entities/bank.dart';
import '../../../banks/domain/usecases/get_bank_by_id_uc.dart';
import '../../../outer_tests/domain/entities/outer_test.dart';
import '../../../outer_tests/domain/usecases/get_outer_test_by_id_uc.dart';
import '../../../tests/domain/entities/test/test.dart';
import '../../../tests/domain/usecases/get_test_by_id_uc.dart';
import '../../domain/entities/result.dart';
import '../../domain/entities/user_data.dart';
import '../../domain/usecases/get_repository_details_uc.dart';
import '../responses/get_my_students_statistics_response.dart';

abstract class StudentsDS {
  //
  // get my students
  Future<List<UserData>> getMyStudents({
    required bool update,
  });
  //
  Future<Unit> addStudentBalance({required int amount, required String studentId});
  //
  Future<GetMyStudentsStatisticsResponse> getMyStudentsStatistics({
    required List<UserData> students,
  });
  // get my students
  Future<List<UserData>> getMyStudentsByIds({
    required List<String> ids,
  });
  // get my students
  Future<List<UserData>> getRepositoryStudents({
    required Test? test,
    required OuterTest? outerTest,
    required Bank? bank,
    required bool update,
  });
  //
  // search in my students
  Future<List<UserData>> searchInMyStudents({
    required String text,
    required bool update,
  });
  //
  // get student results
  Future<List<Result>> getStudentResults({
    required String id,
    required bool update,
  });
  //
  // get test results
  Future<List<Result>> getRepositoryResults({
    required Test? test,
    required OuterTest? outerTest,
    required Bank? bank,
    required bool update,
  });
  // delete test results
  Future<Unit> deleteRepositoryResults({
    required List<int>? results,
    int? testId,
    int? bankId,
    int? outerTestId,
  });
  //
  Future<double> getRepositoryAverage({
    required String? testId,
    required String? bankId,
    required String? outerTestId,
    required bool update,
  });
  Future<Unit> addResults({
    required List<Result> results,
  });

  //
}

class StudentsDSimpl implements StudentsDS {
  const StudentsDSimpl();

  @override
  Future<List<UserData>> getRepositoryStudents({
    required Test? test,
    required OuterTest? outerTest,
    required Bank? bank,
    required bool update,
  }) async {
    //
    final client = Supabase.instance.client;
    // get result using tests ids
    final List<Map> myResultsData;
    //
    if (test != null) {
      myResultsData = await client.from("results").select().eq("test_id", test.id).order("id");
    } else if (outerTest != null) {
      myResultsData = await client.from("results").select().eq("outer_test_id", outerTest.id).order("id");
    } else {
      myResultsData = await client.from("results").select().eq("bank_id", bank!.id).order("id");
    }
    //
    // getting users ids
    final List<Map> myUsers;
    //
    myUsers = await client.from("users_data").select().inFilter("uuid", myResultsData.map((e) => e["user_id"]).toList());
    //
    return myUsers.map((e) => UserDataModel.fromJson(e)).toList();
  }

  @override
  Future<List<UserData>> getMyStudents({required bool update}) async {
    //
    // final client = client;
    final client = Supabase.instance.client;
    //
    // getting users ids
    final List<Map> myUsers;
    //
    myUsers = await client.from("users_data").select();
    //
    List<UserData> users = myUsers.map((e) {
      return UserDataModel.fromJson(e);
    }).toList();
    //
    return users;
  }

  @override
  Future<List<Result>> getStudentResults({
    required String id,
    required bool update,
  }) async {
    //
    final client = Supabase.instance.client;
    //
    final List<Map> res;
    //
    res = await client.from("results").select().eq("user_id", id).order("id");
    //
    if (res.isNotEmpty) {
      //
      List<Result> results = res.map((e) => ResultModel.fromJson(e)).toList();
      //
      results = results.where((e) => e.userId == id).toList();
      //
      return res.map((e) => ResultModel.fromJson(e)).toList();
    }
    //
    return [];
  }

  @override
  Future<List<Result>> getRepositoryResults({
    required Test? test,
    required OuterTest? outerTest,
    required Bank? bank,
    required bool update,
  }) async {
    //
    final client = Supabase.instance.client;
    //
    final List<Map> res;
    //
    if (test != null) {
      res = await client.from("results").select().eq("test_id", test.id).order("id");
    } else if (outerTest != null) {
      res = await client.from("results").select().eq("outer_test_id", outerTest.id).order("id");
    } else {
      res = await client.from("results").select().eq("bank_id", bank!.id).order("id");
    }
    //
    if (res.isNotEmpty) {
      var list = res.map((e) => ResultModel.fromJson(e)).toList();
      //
      return list;
    }
    //
    return [];
  }

  @override
  Future<List<UserData>> searchInMyStudents({
    required String text,
    required bool update,
  }) async {
    //
    // final client = client;
    final client = Supabase.instance.client;
    //
    final teacherData = locator<TeacherData>();
    //
    // get my tests ids
    final List<Map> myTestsIds;
    //
    myTestsIds = await client.from("tests").select().eq("teacher_email", teacherData.email);
    //
    // get result using tests ids
    final List<Map> myResults;
    //
    myResults = await client.from("results").select().inFilter("test_id", myTestsIds.map((e) => e["id"]).toList());
    //
    // getting users ids
    final List<Map> myUsers;
    //
    myUsers = await client.from("users_data").select().or("email.contains.$text").inFilter("uuid", myResults.map((e) => e["user_id"]).toList()).order("name");
    //
    return myUsers.map((e) => UserDataModel.fromJson(e)).toList();
  }

  @override
  Future<double> getRepositoryAverage({
    required String? testId,
    required String? bankId,
    required String? outerTestId,
    required bool update,
  }) async {
    //
    late double average;
    // get bank/test
    final Either getRepositoryRes;
    final PostgrestList resultsRes;
    // get
    final client = Supabase.instance.client;
    //

    if (testId != null) {
      // get repository
      getRepositoryRes = await locator<GetTestByIdUC>().call(
        testId: int.parse(testId),
        update: update,
      );
      // get results
      resultsRes = await client.from("results").select().eq("test_id", testId);
    } else if (outerTestId != null) {
      // get repository
      getRepositoryRes = await locator<GetOuterTestByIdUseCase>().call(
        id: int.parse(outerTestId),
      );
      // get results
      resultsRes = await client.from("results").select().eq("outer_test_id", outerTestId);
    } else {
      // get repository
      getRepositoryRes = await locator<GetBankByIdUC>().call(
        bankId: int.parse(bankId!),
        update: update,
      );
      // get results
      resultsRes = await client.from("results").select().eq("bank_id", bankId);
    }
    //
    if (getRepositoryRes.isRight() && resultsRes.isNotEmpty) {
      //
      List<Result> results = [];
      //
      results = resultsRes.map((e) => ResultModel.fromJson(e)).toList();
      //
      getRepositoryRes.fold(
        (l) {},
        (r) {
          final details = locator<GetRepositoryDetailsUC>().call(
            test: testId != null ? r : null,
            bank: bankId != null ? r : null,
            outerTest: outerTestId != null ? r : null,
            results: results,
            update: update,
          );
          average = details.averageMark;
        },
      );
    }
    //
    return average * 100;
  }

  @override
  Future<Unit> deleteRepositoryResults({
    required List<int>? results,
    int? testId,
    int? outerTestId,
    int? bankId,
  }) async {
    //
    if (results == null) return unit;
    //
    if (results.isEmpty) return unit;
    //
    final client = Supabase.instance.client;
    //
    if (outerTestId != null) {
      await client.from("results").delete().inFilter("id", results).eq("outer_test_id", outerTestId);
    }
    //
    if (bankId != null) {
      await client.from("results").delete().inFilter("id", results).eq("bank_id", bankId);
    }
    //
    if (testId != null) {
      await client.from("results").delete().inFilter("id", results).eq("test_id", testId);
    }
    //
    return unit;
  }

  @override
  Future<Unit> addResults({required List<Result> results}) async {
    //
    final client = Supabase.instance.client;
    //
    List<UserData> usersData = [];
    //
    if (results.first.userId.isEmpty) {
      await locator<GetUsersDataByIdsUC>().call(ids: results.map((e) => e.userNumber).toList(), isUuid: false).then((response) {
        response.fold(
          (l) {},
          (r) {
            usersData = r;
          },
        );
      });
    }
    //
    List list = results.map((Result e) {
      UserData? userData = usersData.where((data) {
        String modifiedUserNumber = e.userNumber.toString().substring(1);
        return data.id == modifiedUserNumber;
      }).firstOrNull;
      return ResultModel.fromClass(e.copyWith(userId: userData?.uuid)).toJson();
    }).toList();
    //
    await client.from("results").insert(list);
    //
    return unit;
  }

  @override
  Future<List<UserData>> getMyStudentsByIds({required List<String> ids}) {
    // TODO: implement getMyStudentsByIds
    throw UnimplementedError();
  }

  @override
  Future<GetMyStudentsStatisticsResponse> getMyStudentsStatistics({
    required List<UserData> students,
  }) async {
    final client = Supabase.instance.client;
    //
    final List<Map<String, dynamic>> testsJson = await client
        //
        .from("tests")
        .select("id , information->>title");

    //
    final List<Map<String, dynamic>> resultsJson = await client
        //
        .from("results")
        .select("user_id,mark,date,test_id,answers")
        .not("test_id", "is", null);

    //
    final List<Result> results = resultsJson.map((e) => ResultModel.fromStatisticsQuery(e)).toList();
    //
    results.removeWhere((e) => e.answers.any((e) => e == null));

    // Store user marks
    Map<String, List<StudentTestMarkDetails>> userMarksHolder = {};
    for (var r in results) {
      userMarksHolder.putIfAbsent(r.userId, () => []).add(
            StudentTestMarkDetails(
              testId: r.testId ?? -1,
              mark: r.mark,
              date: r.date,
            ),
          );
    }

    // Generate student row details
    final List<StudentRowDetails> rows = students.map((s) {
      List<StudentTestMarkDetails> marks = userMarksHolder[s.uuid] ?? [];
      //
      // Step 1: Group by ID
      Map<int, List<StudentTestMarkDetails>> grouped = {};
      for (var mark in marks) {
        int id = mark.testId;
        grouped.putIfAbsent(id, () => []).add(mark);
      }
      //
      // Step 2: Sort each group by date
      grouped.forEach((id, list) {
        list.sort((a, b) => a.date.compareTo(b.date)); // Oldest first
      });
      //
      // Step 3: Extract the oldest item from each group
      List<StudentTestMarkDetails> newMarks = grouped.values.map((list) => list.first).toList();

      //
      return StudentRowDetails(
        name: s.name,
        userId: s.id,
        marks: newMarks,
      );
    }).toList();

    return GetMyStudentsStatisticsResponse(
      rows: rows,
      tests: testsJson.map((e) {
        return (
          e['id'] as int,
          e['title'] as String,
        );
      }).toList(),
    );
  }

  @override
  Future<Unit> addStudentBalance({required int amount, required String studentId}) async {
    //
    final client = Supabase.instance.client;
    //
    final response = await client.from("users_data").select().eq("id", studentId);
    //
    if (response.isEmpty) {
      throw UserNotFoundException();
    }
    //
    final UserDataModel userData = UserDataModel.fromJson(response.first);
    //
    final newBalance = userData.balance + amount;
    //
    await client.from("users_data").update({"balance": newBalance}).eq("id", studentId);
    //
    return unit;
  }
}
