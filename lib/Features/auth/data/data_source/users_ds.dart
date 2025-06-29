import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:moatmat_admin/Features/students/data/models/user_data_m.dart';
import 'package:moatmat_admin/Features/students/domain/entities/user_data.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../../Core/errors/exceptions.dart';
import '../../domain/entites/teacher_data.dart';
import '../models/teacher_data_m.dart';

abstract class TeachersDataSource {
  // signIn
  Future<TeacherData> signIn({
    required String email,
    required String password,
  });
  // signUp
  Future<TeacherData> signUp({
    required TeacherData teacherData,
    required String password,
  });
  //
  // update User Data
  Future<Unit> updateTeacherData({
    required TeacherData teacherData,
  });
  //
  // get teacher Data
  Future<TeacherData> getTeacherData({String? email});
  // get User Data
  Future<UserData> getUserDataData({required String id,bool isUuid = true});
  //
  Future<List<UserData>> getUsersDataByIds({required List<String> ids, bool isUuid = true});
  //
  Future<Unit> resetPassword({
    required String email,
    required String password,
    required String token,
  });
  //
  Future<List<TeacherData>> getALlTeachers();
}

class TeachersDataSourceImpl implements TeachersDataSource {
  final SupabaseClient client;

  TeachersDataSourceImpl({required this.client});
  @override
  Future<TeacherData> getTeacherData({String? email}) async {
    //
    var query = client.from("teachers_data").select().eq("email", email ?? client.auth.currentUser!.email!.toLowerCase());
    //
    List res = await query;
    if (res.isNotEmpty) {
      final teacherData = TeacherDataModel.fromJson(res.first);
      return teacherData;
    } else {
      throw Exception();
    }
  }

  @override
  Future<TeacherData> signIn({
    required String email,
    required String password,
  }) async {
    email = email.toLowerCase().trim();
    await client.auth.signInWithPassword(
      email: email,
      password: password,
    );
    String? uuid = client.auth.currentUser?.id;
    if (uuid != null) {
      return await getTeacherData();
    } else {
      throw AnonException();
    }
  }

  @override
  Future<TeacherData> signUp({
    required TeacherData teacherData,
    required String password,
  }) async {
    //
    teacherData = teacherData.copyWith(email: teacherData.email.toLowerCase());
    //
    teacherData = teacherData.copyWith(
      email: teacherData.email.toLowerCase().trim(),
    );
    //
    await client.auth.signUp(
      email: teacherData.email,
      password: password,
    );
    //
    String? uuid = client.auth.currentUser?.id;
    if (uuid != null) {
      await updateTeacherData(teacherData: teacherData);
      return teacherData;
    } else {
      throw AnonException();
    }
  }

  @override
  Future<Unit> updateTeacherData({
    required TeacherData teacherData,
  }) async {
    //
    Map json = TeacherDataModel.fromClass(teacherData).toJson();
    //
    var query1 = await client.from("teachers_data").select().eq("email", teacherData.email);
    //
    if (teacherData.image != null) {
      //
      var res = await uploadTeacherImage(
        path: teacherData.image!,
        teacher: teacherData.email,
      );
      //
      json["image"] = res;
    }
    //
    if (query1.isEmpty) {
      //
      //
      await client.from("teachers_data").insert(json);
      //
      //
      return unit;
      //
    } else {
      //
      await client.from("teachers_data").update(json).eq("email", teacherData.email);
      //
      return unit;
    }
  }

  Future<String> uploadTeacherImage({
    required String path,
    required String teacher,
  }) async {
    try {
      if (path.contains("supabase")) {
        return path;
      }
      //
      final client = Supabase.instance.client;
      //
      final storage = client.storage.from("teachers");
      //
      String filePath = await setUpFilePath(
        path: path,
        teacher: teacher,
      );
      //
      await storage.upload(filePath, File(path));
      //

      //
      return storage.getPublicUrl(Uri.decodeFull(filePath));
    } on Exception catch (e) {
      return path;
    }
  }

  Future<String> setUpFilePath({
    required String path,
    required String teacher,
  }) async {
    //
    String folder1 = teacher;
    //
    //
    String type = path.split("/").last;
    //
    type = type.split(".").last;
    //
    String date = DateTime.now().toString();
    date = date.substring(0, 19);
    //
    return "$folder1/avatar-$date.$type";
  }

  @override
  Future<Unit> resetPassword({
    required String email,
    required String password,
    required String token,
  }) async {
    var client = Supabase.instance.client;
    await client.auth.verifyOTP(
      email: email,
      token: token,
      type: OtpType.recovery,
    );
    await client.auth.updateUser(
      UserAttributes(password: password),
    );
    return unit;
  }

  @override
  Future<UserData> getUserDataData({required String id, bool isUuid = true}) async {
    //
    var query = isUuid ? client.from("users_data").select().eq("uuid", id) : client.from("users_data").select().eq("id", id);
    //
    List res = await query;
    if (res.isNotEmpty) {
      final userData = UserDataModel.fromJson(res.first);
      return userData;
    } else {
      throw NotFoundException();
    }
  }

  @override
  Future<List<TeacherData>> getALlTeachers() async {
    //
    final client = Supabase.instance.client;
    //
    var res = await client.from("teachers_data").select();
    //
    if (res.isEmpty) return [];
    //
    List<TeacherData> teachers = [];
    //
    teachers = res.map((e) => TeacherDataModel.fromJson(e)).toList();
    //
    return teachers;
  }

  @override
  Future<List<UserData>> getUsersDataByIds({required List<String> ids, bool isUuid = true}) async {
    //
    PostgrestList query;
    if (isUuid) {
      query = await client.from("users_data").select().inFilter("uuid", ids);
    } else {
      query = await client.from("users_data").select().inFilter("id", ids);
    }
    //
    List res = query;
    if (res.isNotEmpty) {
      final usersData = res.map((e) {
        return UserDataModel.fromJson(e);
      }).toList();
      return usersData;
    } else {
      throw Exception("empty");
    }
  }
}
