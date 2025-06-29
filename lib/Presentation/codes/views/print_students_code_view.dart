import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moatmat_admin/Core/resources/sizes_resources.dart';
import 'package:moatmat_admin/Core/widgets/fields/checking_w.dart';
import 'package:moatmat_admin/Core/widgets/fields/elevated_button_widget.dart';
import 'package:moatmat_admin/Core/widgets/fields/text_input_field.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../Core/resources/colors_r.dart';
import '../../../Core/resources/images_r.dart';
import '../state/print_students_codes/print_students_codes_bloc.dart';

class PrintStudentsCodeView extends StatefulWidget {
  const PrintStudentsCodeView({super.key});

  @override
  State<PrintStudentsCodeView> createState() => _PrintStudentsCodeViewState();
}

class _PrintStudentsCodeViewState extends State<PrintStudentsCodeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("طباعة أكواد الطلاب"),
      ),
      body: BlocProvider(
        create: (context) => PrintStudentsCodesBloc(),
        child: BlocBuilder<PrintStudentsCodesBloc, PrintStudentsCodesState>(
          builder: (context, state) {
            if (state is PrintStudentsCodesSuccess) {
              return PrintStudentsCodesSuccessView(state: state);
            } else if (state is PrintStudentsCodesInitial) {
              return PrintStudentsCodesInitialView(state: state);
            } else if (state is PrintStudentsCodesExploreStudents) {
              return PrintStudentsCodesExploreStudentsView(state: state);
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}

class PrintStudentsCodesExploreStudentsView extends StatelessWidget {
  const PrintStudentsCodesExploreStudentsView({super.key, required this.state});
  final PrintStudentsCodesExploreStudents state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: state.users.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  color: state.users[index].$2?.name == null ? ColorsResources.red : Colors.transparent,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              title: Text(state.users[index].$2?.name ?? "الطالب غير موجود"),
              subtitle: Text("الرقم : ${state.users[index].$1}"),
            ),
          );
        },
      ),
      bottomNavigationBar: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButtonWidget(
              text: "طباعة",
              onPressed: () {
                context.read<PrintStudentsCodesBloc>().add(PrintCodesEvent(users: state.users.map((e) => e.$2).toList()));
              },
            ),
          ],
        ),
      ),
    );
  }
}

class PrintStudentsCodesInitialView extends StatefulWidget {
  const PrintStudentsCodesInitialView({super.key, required this.state});
  final PrintStudentsCodesInitial state;

  @override
  State<PrintStudentsCodesInitialView> createState() => _PrintStudentsCodesInitialViewState();
}

class _PrintStudentsCodesInitialViewState extends State<PrintStudentsCodesInitialView> {
  final TextEditingController _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _onePerPage = false;
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: SizesResources.s3),
            Form(
              key: _formKey,
              child: MyTextFormFieldWidget(
                controller: _controller,
                hintText: "اكواد الطلاب (000001 000002 000003)",
                minLines: 1,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "ادخل اكواد الطلاب";
                  }
                  // Normalize spaces and newlines
                  final cleaned = value.replaceAll(RegExp(r'\s+'), ' ').trim();
                  final ids = cleaned.split(' ');

                  for (var id in ids) {
                    if (!RegExp(r'^\d{6}$').hasMatch(id)) {
                      return "كل كود يجب أن يحتوي على 6 أرقام فقط";
                    }
                  }

                  return null;
                },
              ),
            ),
            SizedBox(height: SizesResources.s3),
            Directionality(
              textDirection: TextDirection.rtl,
              child: CheckingWidget(
                title: "كود واحد في الصفحة",
                value: _onePerPage,
                onChanged: (value) {
                  setState(() {
                    _onePerPage = value ?? false;
                  });
                },
              ),
            ),
            SizedBox(height: SizesResources.s3),
            ElevatedButtonWidget(
              text: "طباعة",
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  context.read<PrintStudentsCodesBloc>().add(PrintStudentsSubmitTextCodesEvent(text: _controller.text, onPerPage: _onePerPage));
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class PrintStudentsCodesSuccessView extends StatelessWidget {
  const PrintStudentsCodesSuccessView({super.key, required this.state});
  final PrintStudentsCodesSuccess state;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.close),
        ),
      ),
      body: Center(
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Spacer(),
              Image.asset(
                ImagesResources.sheetIcon,
                width: 100,
              ),
              SizedBox(height: SizesResources.s6),
              Text(
                "تم تصدير الحضور بنجاح ",
                style: TextStyle(
                  fontSize: 24,
                  color: ColorsResources.primary,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Spacer(),
              ElevatedButton.icon(
                onPressed: () {
                  open(state.bytes);
                },
                label: Padding(
                  padding: const EdgeInsets.only(top: 3.0),
                  child: Text(
                    "عرض",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 19,
                    ),
                  ),
                ),
                icon: Icon(Icons.remove_red_eye),
              ),
              SizedBox(height: SizesResources.s2),
              ElevatedButton.icon(
                onPressed: () {
                  share(state.bytes);
                },
                label: Padding(
                  padding: const EdgeInsets.only(top: 3.0),
                  child: Text(
                    "مشاركة",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 19,
                    ),
                  ),
                ),
                icon: Icon(Icons.share),
              ),
              SizedBox(height: SizesResources.s2),
            ],
          ),
        ),
      ),
    );
  }

  Future<String> save(Uint8List bytes) async {
    var directory = await getApplicationDocumentsDirectory();
    String filePath = '${directory.path}/students_qr_codes${DateTime.now().toString().replaceAll(" ", "_").replaceAll("-", "_")}.pdf';
    final file = File(filePath);
    file.createSync(recursive: true);
    await file.writeAsBytes(bytes);
    return filePath;
  }

  Future<void> share(Uint8List bytes) async {
    var filePath = await save(bytes);
    await Share.shareXFiles([XFile(filePath)]);
  }

  Future<void> open(Uint8List bytes) async {
    var filePath = await save(bytes);
    await OpenFile.open(filePath);
  }
}
