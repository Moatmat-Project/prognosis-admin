import 'package:flutter/material.dart';
import 'package:moatmat_admin/Core/resources/spacing_resources.dart';
import 'package:moatmat_admin/Core/validators/not_empty_v.dart';
import 'package:moatmat_admin/Core/widgets/fields/text_input_field.dart';

addGroupDialog({
  required BuildContext context,
  required Function(String) onSave,
}) {
  final formKey = GlobalKey<FormState>();
  String name = "";
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("مجموعة جديدة"),
      content: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            MyTextFormFieldWidget(
              width: SpacingResources.mainHalfWidth(context),
              hintText: "اسم المجموعة",
              onSaved: (p0) {
                name = p0 ?? "";
              },
              validator: (text) {
                return notEmptyValidator(text: text);
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            if (formKey.currentState?.validate() ?? false) {
              formKey.currentState?.save();
              onSave(name);
              Navigator.of(context).pop();
            }
          },
          child: const Text("إضافة"),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text("إلغاء"),
        ),
      ],
    ),
  );
}
