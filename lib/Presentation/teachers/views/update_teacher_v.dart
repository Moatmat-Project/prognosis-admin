import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moatmat_admin/Core/functions/show_alert.dart';
import 'package:moatmat_admin/Core/resources/colors_r.dart';
import 'package:moatmat_admin/Core/resources/shadows_r.dart';
import 'package:moatmat_admin/Core/resources/sizes_resources.dart';
import 'package:moatmat_admin/Core/resources/spacing_resources.dart';
import 'package:moatmat_admin/Core/validators/not_empty_v.dart';
import 'package:moatmat_admin/Core/widgets/fields/checking_w.dart';
import 'package:moatmat_admin/Core/widgets/fields/text_input_field.dart';
import 'package:moatmat_admin/Core/widgets/toucheable_tile_widget.dart';
import 'package:moatmat_admin/Features/auth/domain/entites/teacher_data.dart';
import 'package:moatmat_admin/Presentation/teachers/state/teachers_manager/teachers_manager_cubit.dart';
import 'package:moatmat_admin/Presentation/teachers/views/manage_teacher_purchases_view.dart';

import '../../../Core/widgets/fields/attachment_w.dart';

class UpdateTeacherView extends StatefulWidget {
  const UpdateTeacherView({super.key, required this.teacherData});
  final TeacherData teacherData;
  @override
  State<UpdateTeacherView> createState() => _UpdateTeacherViewState();
}

class _UpdateTeacherViewState extends State<UpdateTeacherView> {
  //
  final _formKey = GlobalKey<FormState>();
  //
  late TeacherData teacherData;

  @override
  void initState() {
    teacherData = widget.teacherData;
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

  onDelete() {
    context.read<TeachersManagerCubit>().delete(widget.teacherData.email);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: [
        TextButton(
          onPressed: () {
            showAlert(
              context: context,
              title: "حذف الاستاذ",
              body: "هل انت متاكد من انك تريد حذف الاستاذ؟",
              agreeBtn: "حذف",
              onAgree: onDelete,
            );
          },
          child: const Text(
            "حذف",
            style: TextStyle(
              color: ColorsResources.red,
            ),
          ),
        ),
        TextButton(
          onPressed: onUpdate,
          child: const Text("تحديث"),
        ),
      ]),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              //
              Container(
                width: SpacingResources.mainWidth(context),
                padding: const EdgeInsets.symmetric(
                  vertical: SizesResources.s3,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: ColorsResources.onPrimary,
                  boxShadow: ShadowsResources.mainBoxShadow,
                ),
                child: Text(
                  teacherData.email,
                  textAlign: TextAlign.center,
                ),
              ),
              //
              const SizedBox(height: SizesResources.s4),
              //
              TouchableTileWidget(
                title: "ادارة عمليات الاشتراك",
                icon: const Icon(
                  Icons.arrow_forward_ios,
                  size: 14,
                ),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ManageTeacherPurchasesView(teacherData: teacherData),
                    ),
                  );
                },
              ),
              //

              //
              const SizedBox(height: SizesResources.s4),
              MyTextFormFieldWidget(
                hintText: "الاسم",
                initialValue: teacherData.name,
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
                initialValue: teacherData.description,
                onSaved: (p0) {
                  teacherData = teacherData.copyWith(
                    description: p0,
                  );
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
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
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
              const SizedBox(height: SizesResources.s4),
              //
              //
              AttachmentWidget(
                title: "صورة الاستاذ",
                file: teacherData.image,
                fileType: FileType.image,
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
