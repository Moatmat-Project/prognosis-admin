import 'package:dartz/dartz.dart';
import 'package:moatmat_admin/Core/injection/app_inj.dart';

import 'package:moatmat_admin/Features/buckets/domain/usecases/delete_test_files_uc.dart';
import 'package:moatmat_admin/Features/buckets/domain/usecases/upload_file_uc.dart';
import 'package:moatmat_admin/Features/tests/data/models/question_m.dart';
import 'package:moatmat_admin/Features/tests/data/models/test_m.dart';
import 'package:moatmat_admin/Features/tests/data/models/video_m.dart';
import 'package:moatmat_admin/Features/tests/domain/entities/test/test.dart';
import 'package:moatmat_admin/Features/tests/domain/entities/video.dart';
import 'package:moatmat_admin/Features/tests/domain/usecases/add_video_uc.dart';
import 'package:moatmat_admin/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class TestsRemoteDS {
  //
  Stream<String> uploadTest({
    required Test test,
  });

  //
  Stream<String> updateTest({
    required Test test,
  });
  //
  Future<Unit> deleteTest({
    required int testId,
  });
  //
  Future<Test?> getTestById({
    required int testId,
    required bool update,
  });
  Future<List<Test>> getTestsByIds({
    required List<int> ids,
    required bool update,
  });
  //
  Future<List<Test>> getMyTests({required String? material});
  //
  Future<List<Test>> searchTest({
    required String keyword,
  });
  //
  Future<int> addVideo({
    required Video video,
  });
}

class TestsRemoteDSImpl implements TestsRemoteDS {
  @override
  Stream<String> uploadTest({required Test test}) async* {
    //
    ErrorsCopier().addErrorLogs("starting uploading");
    //
    bool visible = test.properties.visible ?? false;
    //
    final client = Supabase.instance.client;
    //
    final json = TestModel.fromClass(test).toJson();
    //--------------------------------------------------------------------
    // set up test id
    var res = await client.from("tests").insert(json).select();
    //
    test = test.copyWith(
      id: res[0]["id"],
      properties: test.properties.copyWith(visible: false),
    );
    //--------------------------------------------------------------------
    //

    late Map model;
    await for (var newTest in uploadTestFile(test: test)) {
      if (newTest is String) {
        yield newTest;
      }
      if (newTest is Test) {
        //
        final properties = newTest.properties.copyWith(visible: visible);
        //
        model = TestModel.fromClass(
          newTest.copyWith(properties: properties),
        ).toJson();
        //
      }
    }
    //--------------------------------------------------------------------
    // update test
    await client.from("tests").update(model).eq("id", test.id);
    //
    ErrorsCopier().addErrorLogs("finish uploading test");
    //
    yield "unit";
  }

  Stream<dynamic> uploadTestFile({required Test test}) async* {
    //
    ErrorsCopier().addErrorLogs("starting uploading test files");
    //
    int length = test.questions.length;
    int filesLength = test.information.files?.length ?? 0;
    //
    var newTest = test;
    //
    ErrorsCopier().addErrorLogs("tests remote datasource:uploading video");
    // upload test videos
    for (int i = 0; i < (newTest.information.videos ?? []).length; i++) {
      //
      yield "رفع ملف المقطع رقم (${i + 1}/$filesLength)";
      //
      var res = await locator<UploadFileUC>().call(
        bucket: "tests",
        material: newTest.information.material,
        id: newTest.id.toString(),
        path: newTest.information.videos![i].url,
      );
      res.fold(
        (l) {
          ErrorsCopier().addErrorLogs("left $l");
        },
        (r) async {
          ErrorsCopier().addErrorLogs("right $r");
          ErrorsCopier().addErrorLogs("starting swap:");
          ErrorsCopier().addErrorLogs("before swap:${newTest.information.videos}");
          //
          List<Video> newVideos = newTest.information.videos ?? [];
          //
          int index = newVideos.indexOf(newTest.information.videos![i]);
          //
          var res = await locator<AddVideoUc>().call(video: newVideos[index]);
          res.fold(
            (l) {
              ErrorsCopier().addErrorLogs("left $l");
              newVideos.removeAt(index);
            },
            (id) {
              newVideos[index] = VideoModel.fromClass(newVideos[index]).copyWith(
                url: r,
                id: id,
              );
              // replace links
              newTest = newTest.copyWith(
                information: newTest.information.copyWith(
                  videos: newVideos,
                ),
              );
              //
            },
          );
          //
          ErrorsCopier().addErrorLogs("after swap:${newTest.information.videos}");
          ErrorsCopier().addErrorLogs("finish swap.");
        },
      );
      //
    }
    // upload test images
    for (int i = 0; i < (newTest.information.images ?? []).length; i++) {
      //
      yield "رفع ملف الصورة رقم (${i + 1}/$filesLength)";
      //
      var res = await locator<UploadFileUC>().call(
        bucket: "tests",
        material: newTest.information.material,
        id: newTest.id.toString(),
        path: newTest.information.images![i],
      );
      res.fold(
        (l) {},
        (r) {
          //
          List<String> newImages = newTest.information.images ?? [];
          //
          int index = newImages.indexOf(newTest.information.images![i]);
          //
          newImages[index] = r;
          //
          // replace links
          newTest = newTest.copyWith(
            information: newTest.information.copyWith(
              images: newImages,
            ),
          );
        },
      );
      //
    }
    //
    // upload test files
    for (int i = 0; i < filesLength; i++) {
      //
      yield "رفع ملف pdf رقم (${i + 1}/$filesLength)";
      //
      // files
      bool con = newTest.information.files?[i] != null;
      if (con) {
        var res = await locator<UploadFileUC>().call(
          id: newTest.id.toString(),
          bucket: "tests",
          material: newTest.information.material,
          path: newTest.information.files![i],
        );
        res.fold(
          (l) {},
          (r) {
            //
            List<String> newFiles = newTest.information.files ?? [];
            //
            int index = newFiles.indexOf(newTest.information.files![i]);
            //
            newFiles[index] = r;
            //
            // replace links
            newTest = newTest.copyWith(
              information: newTest.information.copyWith(
                files: newFiles,
              ),
            );
          },
        );
      }
      //
    }

    // questions files
    for (int i = 0; i < newTest.questions.length; i++) {
      //
      yield "رفع ملفات السؤال رقم (${i + 1}/$length)";
      //
      var q = newTest.questions[i];

      // video
      if (q.video != null) {
        var res = await locator<UploadFileUC>().call(
          bucket: "tests",
          material: newTest.information.material,
          id: newTest.id.toString(),
          path: q.video!,
        );
        res.fold(
          (l) => null,
          (r) {
            q = q.copyWith(video: r);
          },
        );
      }
      // Explain image
      if (q.explainImage != null) {
        var res = await locator<UploadFileUC>().call(
          bucket: "tests",
          material: newTest.information.material,
          id: newTest.id.toString(),
          path: q.explainImage!,
        );
        res.fold(
          (l) => null,
          (r) {
            q = q.copyWith(explainImage: r);
          },
        );
      }
      // image
      if (q.image != null) {
        var res = await locator<UploadFileUC>().call(
          bucket: "tests",
          material: newTest.information.material,
          id: newTest.id.toString(),
          path: q.image!,
        );
        res.fold(
          (l) => null,
          (r) {
            q = q.copyWith(image: r);
          },
        );
      }

      // answers
      for (int j = 0; j < q.answers.length; j++) {
        //
        var a = q.answers[j];
        //
        // image
        if (a.image != null) {
          var res = await locator<UploadFileUC>().call(
            bucket: "tests",
            material: newTest.information.material,
            id: newTest.id.toString(),
            path: a.image!,
          );
          res.fold(
            (l) => null,
            (r) {
              a = a.copyWith(image: r);
            },
          );
        }
        q.answers[j] = a;
      }
      newTest.questions[i] = QuestionModel.fromClass(q);
    }
    //
    ErrorsCopier().addErrorLogs("finish uploading test files");
    //
    yield newTest;
  }

  @override
  Future<List<Test>> getMyTests({required String? material}) async {
    //
    final client = Supabase.instance.client;
    //
    List<Test> tests = [];
    //
    final PostgrestList res;
    if (material != null) {
      res = await client.from("tests").select().eq("information->>material", material);
    } else {
      res = await client.from("tests").select();
    }
    //
    tests = res.map((e) => TestModel.fromJson(e)).toList();
    //
    return tests;
  }

  @override
  Future<Test?> getTestById({required int testId, required bool update}) async {
    //
    final client = Supabase.instance.client;
    //
    final res = await client.from("tests").select().eq("id", testId);
    //
    if (res.isNotEmpty) {
      final test = TestModel.fromJson(res.first);
      return test;
    }
    //
    throw Exception("لم يتم العثور على بيانات الاختبار");
  }

  @override
  Future<Unit> deleteTest({required int testId}) async {
    //
    final client = Supabase.instance.client;
    //
    await client.from("tests").delete().eq("id", testId);
    //
    return unit;
  }

  @override
  Stream<String> updateTest({
    required Test test,
  }) async* {
    //
    //
    final client = Supabase.instance.client;
    //
    yield "جلب بيانات البنك القديم";
    //
    var oldTest = await getTestById(testId: test.id, update: true);
    //
    if (oldTest != null) {
      //
      yield "حذف ملفات الاختبار القديم";
      // delete old test files
      locator<DeleteTestFilesUC>().call(oldTest: oldTest, newTest: test);
    }
    //
    late Map model;
    //
    await for (var newTest in uploadTestFile(test: test)) {
      if (newTest is String) {
        yield newTest;
      }
      if (newTest is Test) {
        model = TestModel.fromClass(newTest).toJson();
      }
    }
    //
    await client.from("tests").update(model).eq("id", test.id);
    //
    yield "تم الرفع";
  }

  @override
  Future<List<Test>> getTestsByIds({
    required List<int> ids,
    required bool update,
  }) async {
    //
    final client = Supabase.instance.client;
    //
    final res = await client.from("tests").select().inFilter("id", ids);
    //
    if (res.isNotEmpty) {
      final test = res.map((e) => TestModel.fromJson(e)).toList();
      return test;
    }
    //
    return [];
  }

  @override
  Future<List<Test>> searchTest({required String keyword}) async {
    //
    final client = Supabase.instance.client;
    //
    final res = await client.from("tests").select().like("information->>title", "%$keyword%");
    //
    if (res.isNotEmpty) {
      //
      final tests = res.map((e) => TestModel.fromJson(e)).toList();
      //
      return tests;
    }
    //
    return [];
  }

  @override
  Future<int> addVideo({
    required Video video,
  }) async {
    //
    final client = Supabase.instance.client;
    //
    int id = -1;
    //
    Map videoJson = VideoModel.fromClass(video).toJson();
    //
    await client.from("videos").insert(videoJson);
    //
    var res = await client.from("videos").select().eq("url", video.url).limit(1);
    //
    id = VideoModel.fromJson(res.first).id;
    //
    return id;
  }
}
