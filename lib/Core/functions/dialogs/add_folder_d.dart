import 'package:flutter/material.dart';
import 'package:moatmat_admin/Features/tests/domain/entities/test/test.dart';

import '../../resources/sizes_resources.dart';
import '../../resources/spacing_resources.dart';
import '../../services/folders_s.dart';
import '../../widgets/fields/elevated_button_widget.dart';
import '../../widgets/fields/text_input_field.dart';

addFolderFunction({
  required BuildContext context,
  required Function(Folder) onAdd,
}) {
  Folder folder = Folder(
    id: 0,
    name: "",
    tests: [],
    banks: [],
    subFolders: [],
  );
  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: SizesResources.s4),
            const Text("مجلد جديد"),
            const SizedBox(height: SizesResources.s4),
            MyTextFormFieldWidget(
              hintText: "اسم المجلد",
              width: SpacingResources.mainHalfWidth(context),
              onChanged: (p0) {
                folder = folder.copyWith(name: p0);
              },
            ),
            const SizedBox(height: SizesResources.s4),
            ElevatedButtonWidget(
              text: "إضافة",
              width: SpacingResources.mainHalfWidth(context),
              onPressed: () {
                onAdd(folder);
                Navigator.of(context).pop();
              },
            ),
            const SizedBox(height: SizesResources.s4),
          ],
        ),
      );
    },
  );
}
