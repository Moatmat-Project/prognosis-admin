// ignore_for_file: use_build_context_synchronously
import 'dart:core';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'dart:async';

import 'dart:ui' as ui;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:pdf/widgets.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

import '../../Features/tests/domain/entities/question/question.dart';

const double maxColumnHeight = 730; //831
const double maxItemWidth = 275; //831
const int itemWidth = 240; //831

class ExportRepositoryService {
  //
  Future toPdf(
    List<QuestionImgInformation> images, {
    required String title,
    required String form,
    required String period,
    required String teacher,
  }) async {
    //
    if (!kDebugMode) {
      images.shuffle();
    }
    //
    //
    final pdf = pw.Document();
    //
    //
    var reqFont = pw.Font.ttf(
      await rootBundle.load("assets/fonts/Tajawal/Tajawal-Regular.ttf"),
    );
    var boldFont = pw.Font.ttf(
      await rootBundle.load("assets/fonts/Tajawal/Tajawal-Bold.ttf"),
    );

    var res = imageInformationToPages(
      qInformation: images,
      reqFont: reqFont,
      boldFont: boldFont,
      title: title,
      form: form,
      period: period,
      teacher: teacher,
    );
    for (var r in res) {
      pdf.addPage(r);
    }

    // Save the PDF file to local storage
    var directory = await getApplicationDocumentsDirectory();
    String filePath = '${directory.path}/results_of_${title}_$form.pdf';
    final file = File(filePath);
    var pdfFile = await file.writeAsBytes(await pdf.save());

    return pdfFile.path;
  }

  //
  List<pw.Page> imageInformationToPages({
    required List<QuestionImgInformation> qInformation,
    required Font reqFont,
    required Font boldFont,
    required String title,
    required String form,
    required String? period,
    required String teacher,
  }) {
    //
    int curentIndex = 0;
    //
    //
    List<(List<QuestionImgInformation>, List<QuestionImgInformation>)> list = [];
    //
    //
    for (var q in qInformation) {
      //
      //
      // check if list is empty.
      if (!(curentIndex < list.length)) {
        list.add(([], []));
      }
      //
      if (canAdd(list: list[curentIndex].$1, item: q)) {
        list[curentIndex].$1.add(q);
      } else if (canAdd(list: list[curentIndex].$2, item: q)) {
        list[curentIndex].$2.add(q);
      } else {
        curentIndex++;
        list.add(([], []));
        list[curentIndex].$1.add(q);
      }
    }

    List<pw.Page> result = [];

    //
    int counter = 0;
    //
    for (int i = 0; i < list.length; i++) {
      result.add(
        pw.MultiPage(
          mainAxisAlignment: pw.MainAxisAlignment.center,
          footer: (context) {
            return pw.Footer(
              title: pw.Directionality(
                textDirection: pw.TextDirection.rtl,
                child: pw.SizedBox(
                  height: 34,
                  child: pw.Column(
                    mainAxisAlignment: pw.MainAxisAlignment.center,
                    children: [
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.center,
                        children: [
                          if (list.length - 1 == i)
                            pw.Text(
                              "مؤتمت... معك في كل اختيار",
                              textAlign: pw.TextAlign.center,
                              style: const pw.TextStyle(
                                fontSize: 7,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              margin: const pw.EdgeInsets.all(0),
              padding: const pw.EdgeInsets.all(0),
            );
          },
          header: (context) {
            return pw.Directionality(
              textDirection: pw.TextDirection.rtl,
              child: pw.SizedBox(
                height: 65,
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Column(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.SizedBox(),
                        pw.Text(
                          "اسم الاختبار  $title",
                          style: pw.TextStyle(
                            fontSize: 11,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                        pw.Text(
                          "اسم الاستاذ :  $teacher",
                          style: pw.TextStyle(
                            fontSize: 11,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                        pw.Text(
                          "النموذج :  $form",
                          style: pw.TextStyle(
                            fontSize: 11,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                        period != null
                            ? pw.Text(
                                "المدة :  $period",
                                style: pw.TextStyle(
                                  fontSize: 11,
                                  fontWeight: pw.FontWeight.bold,
                                ),
                              )
                            : pw.SizedBox(),
                      ],
                    ),
                    pw.Column(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        pw.SizedBox(),
                        pw.Text(
                          "رقم الصفحة : ${i + 1}",
                          style: pw.TextStyle(
                            fontSize: 11,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                        pw.SizedBox(),
                        pw.SizedBox(),
                      ],
                    )
                  ],
                ),
              ),
            );
          },
          pageTheme: pw.PageTheme(
            theme: pw.ThemeData.withFont(
              base: reqFont,
              bold: boldFont,
            ),
            pageFormat: PdfPageFormat.a4,
            margin: const pw.EdgeInsets.symmetric(
              horizontal: 25,
            ),
          ),
          build: (context) {
            return [
              pw.Directionality(
                textDirection: pw.TextDirection.rtl,
                child: pw.SizedBox(
                  width: maxItemWidth * 2,
                  height: maxColumnHeight,
                  child: pw.Column(
                    mainAxisSize: pw.MainAxisSize.min,
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.end,
                        children: [
                          pw.Container(
                            decoration: pw.BoxDecoration(
                              border: pw.Border.all(
                                width: 1,
                              ),
                            ),
                            width: maxItemWidth,
                            height: maxColumnHeight,
                            child: pw.Column(
                              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                              children: List.generate(list[i].$1.length, (i2) {
                                //
                                counter++;
                                //

                                final e = list[i].$1[i2];
                                //
                                if (i == list.length - 1 || list[i].$2.length == 1) {
                                  return pw.Expanded(
                                    flex: newHeight(
                                      e.height.toDouble(),
                                      list[i].$2.fold(
                                            0,
                                            (previousValue, element) => previousValue + element.height,
                                          ),
                                    ).toInt(),
                                    child: pw.Container(
                                      width: maxItemWidth - 2,
                                      alignment: pw.Alignment.topLeft,
                                      decoration: const pw.BoxDecoration(
                                        border: pw.Border(
                                          bottom: pw.BorderSide(
                                            width: 1,
                                          ),
                                        ),
                                      ),
                                      child: pw.Padding(
                                        padding: const pw.EdgeInsets.all(5),
                                        child: pw.Row(
                                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                                          children: [
                                            pw.Padding(
                                              child: pw.Text(
                                                "- $counter",
                                                style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold),
                                              ),
                                              padding: const pw.EdgeInsets.only(
                                                top: 10,
                                              ),
                                            ),
                                            pw.Image(
                                              pw.MemoryImage(e.bytes),
                                              width: e.width * 0.93,
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }
                                //
                                return pw.Expanded(
                                  flex: newHeight(
                                    e.height.toDouble(),
                                    list[i].$2.fold(
                                          0,
                                          (previousValue, element) => previousValue + element.height,
                                        ),
                                  ).toInt(),
                                  child: pw.Container(
                                    width: maxItemWidth - 2,
                                    alignment: pw.Alignment.topLeft,
                                    decoration: const pw.BoxDecoration(
                                      border: pw.Border(
                                        bottom: pw.BorderSide(
                                          width: 1,
                                        ),
                                      ),
                                    ),
                                    child: pw.Padding(
                                      padding: const pw.EdgeInsets.all(5),
                                      child: pw.Row(
                                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                                        children: [
                                          pw.Padding(
                                            child: pw.Text(
                                              "- $counter",
                                              style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold),
                                            ),
                                            padding: const pw.EdgeInsets.only(
                                              top: 10,
                                            ),
                                          ),
                                          pw.Image(
                                            pw.MemoryImage(e.bytes),
                                            width: e.width * 0.93,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ),

                          ///////////
                          ///////////
                          ///////////
                          ///////////
                          ///////////
                          ///////////
                          pw.Container(
                            decoration: pw.BoxDecoration(
                              border: pw.Border.all(
                                width: 1,
                              ),
                            ),
                            width: maxItemWidth,
                            height: maxColumnHeight,
                            child: pw.Column(
                              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                              children: List.generate(list[i].$2.length, (i2) {
                                //
                                counter++;
                                //
                                final e = list[i].$2[i2];
                                //
                                if (i == list.length - 1 || list[i].$2.length == 1) {
                                  return pw.Expanded(
                                    flex: newHeight(
                                      e.height.toDouble(),
                                      list[i].$2.fold(
                                            0,
                                            (previousValue, element) => previousValue + element.height,
                                          ),
                                    ).toInt(),
                                    child: pw.Container(
                                      width: maxItemWidth - 2,
                                      alignment: pw.Alignment.topLeft,
                                      decoration: const pw.BoxDecoration(
                                        border: pw.Border(
                                          bottom: pw.BorderSide(
                                            width: 1,
                                          ),
                                        ),
                                      ),
                                      child: pw.Padding(
                                        padding: const pw.EdgeInsets.all(5),
                                        child: pw.Row(
                                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                                          children: [
                                            pw.Padding(
                                              child: pw.Text(
                                                "- $counter",
                                                style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold),
                                              ),
                                              padding: const pw.EdgeInsets.only(
                                                top: 10,
                                              ),
                                            ),
                                            pw.Image(
                                              pw.MemoryImage(e.bytes),
                                              width: e.width * 0.93,
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }
                                //
                                return pw.Expanded(
                                  flex: newHeight(
                                    e.height.toDouble(),
                                    list[i].$2.fold(
                                          0,
                                          (previousValue, element) => previousValue + element.height,
                                        ),
                                  ).toInt(),
                                  child: pw.Container(
                                    width: maxItemWidth - 2,
                                    alignment: pw.Alignment.topLeft,
                                    decoration: const pw.BoxDecoration(
                                      border: pw.Border(
                                        bottom: pw.BorderSide(
                                          width: 1,
                                        ),
                                      ),
                                    ),
                                    child: pw.Padding(
                                      padding: const pw.EdgeInsets.all(5),
                                      child: pw.Row(
                                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                                        children: [
                                          pw.Padding(
                                            child: pw.Text(
                                              "- $counter",
                                              style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold),
                                            ),
                                            padding: const pw.EdgeInsets.only(
                                              top: 10,
                                            ),
                                          ),
                                          pw.Image(
                                            pw.MemoryImage(e.bytes),
                                            width: e.width * 0.93,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ];
          },
        ),
      );
    }
    //
    //
    return result;
  }

  double newHeight(double height, double itemsHeight) {
    if (itemsHeight == 0 || maxColumnHeight == 0) {
      return 0;
    }

    double r = height / itemsHeight;

    if (r.isNaN || r.isInfinite) {
      return 0;
    }

    return r * ((maxColumnHeight - 50) * 0.80);
  }

  bool canAdd({
    required List<QuestionImgInformation> list,
    required QuestionImgInformation item,
  }) {
    //
    int sum = list.fold(0, (prev, element) => prev + element.height);
    //
    return (sum + item.height) < (maxColumnHeight - 50);
  }

  //
  Future<QuestionImgInformation> widgetToImageInformation({
    required ScreenshotController controller,
    required Rect rect,
  }) async {
    var value = await controller.capture(pixelRatio: 3);
    //
    if (value == null) {
      debugPrint("Screenshot capture failed.");
      throw Exception();
    }
    //
    final filePath = await getFilePath();
    //
    await XFile.fromData(value).saveTo(filePath);
    //
    ui.Image? image = await decodeImageFromList(value);
    // Extract the width and height of the image
    final width = image.width;
    final height = image.height;
    //
    return QuestionImgInformation(
      bytes: value,
      originalHeight: height,
      originalWidth: width,
    );
  }

  Future<String> getFilePath() async {
    //
    Directory? externalDir;
    //
    if (Platform.isIOS) {
      externalDir = await getApplicationDocumentsDirectory();
    } else if (Platform.isAndroid) {
      externalDir = await getExternalStorageDirectory();
    } else {
      externalDir = await getApplicationSupportDirectory();
    }
    //
    final ts = DateTime.now().toIso8601String();
    //
    final filePath = "${externalDir!.path}/$ts.png";
    //
    return filePath;
  }

  //
  Future<void> preCashImages({
    required List<Question> questions,
    required BuildContext context,
  }) async {
    //
    for (var q in questions) {
      //
      if (q.image != null) {
        print("cached");
        await cacheImage(imageUrl: q.image!, context: context);
      }
      //
      for (var a in q.answers) {
        if (a.image != null) {
          await cacheImage(imageUrl: a.image!, context: context);
        }
      }
      //
    }
    //
  }

  //
  Future<void> cacheImage({
    required String imageUrl,
    required BuildContext context,
  }) async {
    //
    Completer<void> completer = Completer<void>();
    //
    final imageProvider = CachedNetworkImageProvider(imageUrl);
    //
    final config = createLocalImageConfiguration(context);
    //
    final imageStream = imageProvider.resolve(config);
    //
    ImageStreamListener? listener;
    //
    listener = ImageStreamListener(
      (img, syn) {
        completer.complete();
        imageStream.removeListener(listener!);
      },
      //
      onError: (exception, stackTrace) {
        completer.completeError(exception, stackTrace);
        imageStream.removeListener(listener!);
      },
    );
    //
    imageStream.addListener(listener);
    //
    return completer.future;
  }
}

class QuestionImgInformation {
  final Uint8List bytes;
  final int height;
  final int width;

  QuestionImgInformation._({
    required this.bytes,
    required this.height,
    required this.width,
  });

  factory QuestionImgInformation({
    required Uint8List bytes,
    required int originalHeight,
    required int originalWidth,
  }) {
    int calculatedWidth = itemWidth;
    final int calculatedHeight = (calculatedWidth * originalHeight) ~/ originalWidth;

    return QuestionImgInformation._(
      bytes: bytes,
      height: calculatedHeight,
      width: calculatedWidth,
    );
  }
}
