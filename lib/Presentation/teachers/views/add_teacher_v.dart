import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moatmat_admin/Core/resources/sizes_resources.dart';
import 'package:moatmat_admin/Core/validators/not_empty_v.dart';
import 'package:moatmat_admin/Core/widgets/fields/attachment_w.dart';
import 'package:moatmat_admin/Core/widgets/fields/checking_w.dart';
import 'package:moatmat_admin/Core/widgets/fields/text_input_field.dart';
import 'package:moatmat_admin/Features/auth/domain/entites/teacher_data.dart';
import 'package:moatmat_admin/Features/auth/domain/entites/teacher_options.dart';
import 'package:moatmat_admin/Presentation/teachers/state/teachers_manager/teachers_manager_cubit.dart';

class AddTeacherView extends StatefulWidget {
  const AddTeacherView({super.key});
  @override
  State<AddTeacherView> createState() => _AddTeacherViewState();
}

class _AddTeacherViewState extends State<AddTeacherView> {
  //
  final _formKey = GlobalKey<FormState>();
  //
  late TeacherData teacherData;
  late TeacherOptions options;

  @override
  void initState() {
    //
    options = TeacherOptions(
      allowInsert: false,
      allowUpdate: false,
      allowDelete: false,
      allowScanning: false,
      isAdmin: false,
      isTeacher: false,
      isUploader: false,
    );
    //
    teacherData = TeacherData(
      name: "",
      email: "",
      options: options,
      purchaseDescription: "",
      description: null,
      image: null,
      price: 0,
      banksFolders: {},
      testsFolders: {},
      groups: [],
    );
    super.initState();
  }

  onUpdate() {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      context.read<TeachersManagerCubit>().update(teacherData);
      Navigator.of(context).pop();
    }
    //
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: [
        TextButton(
          onPressed: onUpdate,
          child: const Text("إضافة"),
        ),
      ]),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              //
              const SizedBox(height: SizesResources.s4),
              MyTextFormFieldWidget(
                hintText: "الاسم",
                onSaved: (p0) {
                  teacherData = teacherData.copyWith(
                    name: p0,
                  );
                },
                validator: (t) {
                  return notEmptyValidator(text: t);
                },
              ),
              const SizedBox(height: SizesResources.s4),
              MyTextFormFieldWidget(
                hintText: "الوصف",
                onSaved: (p0) {
                  teacherData = teacherData.copyWith(
                    description: p0,
                  );
                },
                validator: (t) {
                  return notEmptyValidator(text: t);
                },
              ),
              const SizedBox(height: SizesResources.s4),
              MyTextFormFieldWidget(
                hintText: "البريد الالكتروني",
                onSaved: (p0) {
                  teacherData = teacherData.copyWith(
                    email: p0!.toLowerCase(),
                  );
                },
                validator: (t) {
                  return notEmptyValidator(text: t);
                },
              ),
              const SizedBox(height: SizesResources.s4),
              MyTextFormFieldWidget(
                hintText: "سعر شراء محتوى الاستاذ",
                initialValue: teacherData.price.toString(),
                onSaved: (p0) {
                  teacherData = teacherData.copyWith(
                    price: int.parse(p0!),
                  );
                },
                validator: (p0) {
                  return notEmptyValidator(text: p0);
                },
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
              //
              const SizedBox(height: SizesResources.s4),
              MyTextFormFieldWidget(
                hintText: "تفاصيل الاشتراك",
                initialValue: teacherData.purchaseDescription,
                onSaved: (p0) {
                  teacherData = teacherData.copyWith(
                    purchaseDescription: p0,
                  );
                },
                validator: (t) {
                  return notEmptyValidator(text: t);
                },
              ),
              //
              const SizedBox(height: SizesResources.s4),
              //
              AttachmentWidget(
                title: "صورة الاستاذ",
                afterPick: (p0) {
                  teacherData = teacherData.copyWith(
                    image: p0,
                  );
                },
                onDelete: () {
                  teacherData = teacherData.copyWith(
                    image: null,
                  );
                },
              ),
              //
              const SizedBox(height: SizesResources.s4),
              //
              CheckingWidget(
                title: "السماح بانشاء اختبارات/بنوك",
                value: teacherData.options.allowInsert,
                onChanged: (value) {
                  teacherData = teacherData.copyWith(
                    options: teacherData.options.copyWith(
                      allowInsert: value,
                    ),
                  );
                  setState(() {});
                },
              ),

              //
              CheckingWidget(
                title: "السماح بتحديث اختبارات/بنوك",
                value: teacherData.options.allowUpdate,
                onChanged: (value) {
                  teacherData = teacherData.copyWith(
                    options: teacherData.options.copyWith(
                      allowUpdate: value,
                    ),
                  );
                  setState(() {});
                },
              ),
              //
              CheckingWidget(
                title: "السماح بحذف اختبارات/بنوك",
                value: teacherData.options.allowDelete,
                onChanged: (value) {
                  teacherData = teacherData.copyWith(
                    options: teacherData.options.copyWith(
                      allowDelete: value,
                    ),
                  );
                  setState(() {});
                },
              ),
              //
              CheckingWidget(
                title: "السماح باستخدام السكانر",
                value: teacherData.options.allowScanning,
                onChanged: (value) {
                  teacherData = teacherData.copyWith(
                    options: teacherData.options.copyWith(
                      allowScanning: value,
                    ),
                  );
                  setState(() {});
                },
              ),
              //
              const SizedBox(height: SizesResources.s4),
              //
              CheckingWidget(
                title: "تمكين الدخول لتطبيق الادمن",
                value: teacherData.options.isAdmin,
                onChanged: (value) {
                  teacherData = teacherData.copyWith(
                    options: teacherData.options.copyWith(
                      isAdmin: value,
                    ),
                  );
                  setState(() {});
                },
              ),
              //
              CheckingWidget(
                title: "تمكين الدخول لتطبيق المعلم",
                value: teacherData.options.isTeacher,
                onChanged: (value) {
                  teacherData = teacherData.copyWith(
                    options: teacherData.options.copyWith(
                      isTeacher: value,
                    ),
                  );
                  setState(() {});
                },
              ),
              //
              CheckingWidget(
                title: "تمكين الدخول لتطبيق الرفع",
                value: teacherData.options.isUploader,
                onChanged: (value) {
                  teacherData = teacherData.copyWith(
                    options: teacherData.options.copyWith(
                      isUploader: value,
                    ),
                  );
                  setState(() {});
                },
              ),
              //
              const SizedBox(height: SizesResources.s10),
            ],
          ),
        ),
      ),
    );
  }
}
