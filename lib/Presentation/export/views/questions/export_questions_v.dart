import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:moatmat_admin/Core/validators/not_empty_v.dart';
import 'package:moatmat_admin/Core/widgets/fields/text_input_field.dart';
import 'package:open_file/open_file.dart';

import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../Core/resources/colors_r.dart';
import '../../../../Core/resources/sizes_resources.dart';
import '../../../../Core/services/export_repository_s.dart';
import '../../../../Core/widgets/fields/drop_down_w.dart';
import '../../../../Core/widgets/fields/elevated_button_widget.dart';
import '../../../../Core/widgets/toucheable_tile_widget.dart';
import '../../../../Features/tests/domain/entities/question/question.dart';
import '../../../questions/widgets/answer_body_w.dart';
import '../../../questions/widgets/question_body_w.dart';

class ExportQuestionsView extends StatefulWidget {
  const ExportQuestionsView({
    super.key,
    required this.questions,
    required this.title,
    required this.teacher,
    this.period,
  });
  final String title;
  final String teacher;
  final int? period;
  final List<Question> questions;
  @override
  State<ExportQuestionsView> createState() => _ExportQuestionsViewState();
}

class _ExportQuestionsViewState extends State<ExportQuestionsView> {
  //
  late GlobalKey<FormState> _formKey;
  //
  int length = 1;
  //
  List<String> files = [];
  //
  List<Widget> questionsWidgets = [];
  //
  List<ScreenshotController> controllers = [];
  //
  List<QuestionImgInformation> imagesFiles = [];
  //
  //
  String? text;
  //
  bool exported = false;
  //
  late String teacher;
  late String period;
  //
  @override
  void initState() {
    //
    _formKey = GlobalKey<FormState>();
    //
    teacher = widget.teacher;
    if (widget.period != null) {
      period = "${(widget.period! ~/ 60)} دقيقة";
    } else {
      period = "";
    }

    //
    WidgetsBinding.instance.addPostFrameCallback((t) {
      try {
        getQuestionsWidgets();
      } on Exception catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("$e"),
          ),
        );
      }
    });
    //
    super.initState();
  }

  exportAll() async {
    files = [];
    setState(() {
      text = "جاري تجهيز الاسئلة للطباعة";
    });
    for (int i = 0; i < length; i++) {
      files.add(await export(numberToLetter(i + 1)));
      setState(() {});
    }
    setState(() {
      text = "تم تصدير الملفات";
      exported = true;
    });
  }

  Future<String> export(String form) async {
    //

    imagesFiles = [];
    // make images
    for (int i = 0; i < controllers.length; i++) {
      var img = await ExportRepositoryService().widgetToImageInformation(
        controller: controllers[i],
        rect: getRect(),
      );
      imagesFiles.add(img);
    }
    var path = await ExportRepositoryService().toPdf(
      imagesFiles,
      title: widget.title,
      form: form,
      teacher: teacher,
      period: period,
    );

    return path;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: exported
                ? () async {
                    await Share.shareXFiles(
                      files.map((e) => XFile(e)).toList(),
                    );
                  }
                : null,
            child: const Text("مشاركة الملفات"),
          ),
        ],
      ),
      body: Stack(
        children: [
          Opacity(
              opacity: 1,
              child: SingleChildScrollView(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Stack(
                    children: questionsWidgets,
                  ),
                ),
              )),
          Container(
            color: ColorsResources.background,
          ),
          Form(
            key: _formKey,
            child: Column(
              children: [
                if (text == null) ...[
                  DropDownWidget(
                    items: const ["1", "2", "3", "4", "5", "6"],
                    hintText: "عدد النماذج",
                    selectedItem: length.toString(),
                    onChanged: (p0) {
                      if (text != null) {
                        return;
                      }
                      switch (p0) {
                        case "1":
                          setState(() {
                            length = 1;
                          });
                          break;
                        case "2":
                          setState(() {
                            length = 2;
                          });
                          break;
                        case "3":
                          setState(() {
                            length = 3;
                          });
                          break;
                        case "4":
                          setState(() {
                            length = 4;
                          });
                          break;
                        case "5":
                          setState(() {
                            length = 5;
                          });
                          break;
                        case "6":
                          setState(() {
                            length = 6;
                          });
                          break;
                      }
                    },
                    onSaved: (p0) {},
                  ),
                  const SizedBox(height: SizesResources.s2),
                  MyTextFormFieldWidget(
                    hintText: "اسم المعلم",
                    maxLines: 1,
                    initialValue: teacher,
                    validator: (t) {
                      return notEmptyValidator(text: t);
                    },
                    onSaved: (value) {
                      setState(() {
                        teacher = value!;
                      });
                    },
                  ),
                  const SizedBox(height: SizesResources.s2),
                  MyTextFormFieldWidget(
                    hintText: "وقت الاختبار",
                    maxLines: 1,
                    initialValue: period,
                    validator: (t) {
                      return notEmptyValidator(text: t);
                    },
                    onSaved: (value) {
                      setState(() {
                        period = value!;
                      });
                    },
                  ),
                ],
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      vertical: SizesResources.s2,
                    ),
                    itemCount: files.length,
                    itemBuilder: (context, index) {
                      return TouchableTileWidget(
                        title: "النموذج  ${numberToLetter(index + 1)}",
                        onTap: kDebugMode
                            ? () {
                                OpenFile.open(files[index]);
                              }
                            : null,
                      );
                    },
                  ),
                ),
                ElevatedButtonWidget(
                  text: text != null ? text! : "تصدير",
                  onPressed: text != null
                      ? null
                      : () {
                          if (_formKey.currentState?.validate() ?? false) {
                            _formKey.currentState?.save();
                            try {
                              exportAll();
                            } on Exception catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("$e"),
                                ),
                              );
                            }
                          }
                        },
                ),
                const SizedBox(height: SizesResources.s10),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future getQuestionsWidgets() async {
    //
    setState(() {
      text = "جاري معالجة الصور";
    });
    //
    await ExportRepositoryService().preCashImages(
      questions: widget.questions,
      context: context,
    );
    //
    await Future.delayed(const Duration(seconds: 3));
    //
    questionsWidgets = [];
    //
    for (int i = 0; i < widget.questions.length; i++) {
      //
      controllers.add(ScreenshotController());
      //
      questionsWidgets.add(
        QuestionPdfImgWidget(
          id: i + 1,
          question: widget.questions[i],
          controller: controllers[i],
        ),
      );
    }
    //
    questionsWidgets.add(Container(color: ColorsResources.background));
    //
    setState(() {
      text = null;
    });
    //
  }

  Rect getRect() {
    return Rect.fromCenter(
      center: Offset(
        MediaQuery.of(context).size.width / 2,
        MediaQuery.of(context).size.height / 2,
      ),
      width: MediaQuery.of(context).size.width / 2,
      height: MediaQuery.of(context).size.height / 2,
    );
  }
}

class QuestionPdfImgWidget extends StatelessWidget {
  const QuestionPdfImgWidget({
    super.key,
    required this.id,
    required this.question,
    required this.controller,
  });
  final int id;
  final Question question;
  final ScreenshotController controller;
  @override
  Widget build(BuildContext context) {
    return Screenshot(
        controller: controller,
        child: Container(
          width: 500,
          color: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: SizesResources.s4),
              if (question.upperImageText != null && question.upperImageText != "") ...[
                QuestionTextBuilderWidget(
                  text: question.upperImageText!,
                  equations: question.equations,
                  width: 500,
                  fontWeight: FontWeight.w800,
                  wrapAlignment: WrapAlignment.start,
                  fontSize: 18,
                  colors: const [],
                  disableNewLines: true,
                ),
                const SizedBox(height: SizesResources.s6),
              ],
              //
              if (question.image != null && question.image != "") ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    QuestionImageBuilderWidget(
                      image: question.image!,
                      width: 350,
                      radius: BorderRadius.circular(0),
                    ),
                  ],
                ),
                const SizedBox(height: SizesResources.s6),
              ],

              //
              if (question.lowerImageText != null && question.lowerImageText != "") ...[
                QuestionTextBuilderWidget(
                  text: question.lowerImageText!,
                  equations: question.equations,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  width: 500,
                  wrapAlignment: WrapAlignment.start,
                  colors: question.colors,
                  disableNewLines: true,
                ),
                const SizedBox(height: SizesResources.s3),
              ],
              //
              Padding(
                padding: const EdgeInsets.only(right: 5),
                child: Column(
                  children: List.generate(
                    question.answers.length,
                    (i) {
                      //
                      final answer = question.answers[i];
                      //
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          //
                          if (answer.text != null && answer.text != "") ...[
                            const SizedBox(height: SizesResources.s2),
                            QuestionTextBuilderWidget(
                              text: "${numberToLetter(i + 1)}- ${answer.text!}",
                              equations: answer.equations ?? [],
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              wrapAlignment: WrapAlignment.start,
                              colors: const [],
                            ),
                          ],
                          //
                          if (answer.image != null && answer.image != "") ...[
                            const SizedBox(height: SizesResources.s2),
                            AnswerImageBuilderWidget(
                              image: answer.image!,
                              width: 200,
                              fit: BoxFit.fitWidth,
                              radius: BorderRadius.circular(0),
                            ),
                            const SizedBox(height: SizesResources.s2),
                          ],
                          //
                        ],
                      );
                    },
                  ),
                ),
              ), //
              const SizedBox(height: SizesResources.s4),
              //
            ],
          ),
        ));
  }

  getSecondNumber(Question q) {
    if (q.upperImageText != null) {
      if (q.upperImageText!.isNotEmpty) {
        return "";
      }
    }
    return id;
  }
}

String numberToLetter(int number) {
  if (number < 1 || number > 26) {
    throw RangeError('Number must be between 1 and 26');
  }

  return String.fromCharCode(64 + number);
}
