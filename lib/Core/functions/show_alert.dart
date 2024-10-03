import 'package:flutter/material.dart';

import '../resources/sizes_resources.dart';

showAlert({
  required BuildContext context,
  required String title,
  required String body,
  required VoidCallback onAgree,
  String? agreeBtn,
  String? disagreeBtn,
}) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(body),
      actions: [
        TextButton(
          onPressed: () {
            onAgree();
            Navigator.of(context).pop();
          },
          child: Text(agreeBtn ?? "حسنا"),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(disagreeBtn ?? "الغاء"),
        ),
      ],
    ),
  );
}
