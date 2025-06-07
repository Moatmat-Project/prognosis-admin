import 'dart:math';

import 'package:flutter/services.dart';
import 'package:moatmat_admin/Features/students/domain/entities/user_data.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

Future<Uint8List> exportCodesPdf({required List<UserData> codes, required bool onPerPage}) async {
  final pdf = pw.Document();
  //
  var reqFont = pw.Font.ttf(
    await rootBundle.load("assets/fonts/Tajawal/Tajawal-Regular.ttf"),
  );
  var boldFont = pw.Font.ttf(
    await rootBundle.load("assets/fonts/Tajawal/Tajawal-Bold.ttf"),
  );
  if (onPerPage) {
    for (var c in codes) {
      pdf.addPage(getCodeWPage(user: c, reqFont: reqFont, boldFont: boldFont));
    }
  } else {
    // create pdf
    pdf.addPage(
      pw.MultiPage(
        pageTheme: pw.PageTheme(
          margin: pw.EdgeInsets.zero,
          pageFormat: PdfPageFormat.a4,
          textDirection: pw.TextDirection.rtl,
          theme: pw.ThemeData.withFont(
            base: reqFont,
            bold: boldFont,
          ),
          buildBackground: (context) => pw.FullPage(
            ignoreMargins: true,
            child: pw.Container(
              color: PdfColor.fromHex("#482476"), // your desired background color
            ),
          ),
        ),
        build: (context) {
          return [
            pw.Wrap(
              spacing: 0,
              runSpacing: 0,
              children: codes.map((e) => getCodeWidget(e)).toList(),
            ),
          ];
        }, // 012578 004305 001484 011852 010250 010915 012377 011500 010639 012327 012741 012722 012998
      ),
    );
  }

  return await pdf.save();
}

//  color: PdfColor.fromHex("#482476"),
pw.Widget getCodeWidget(UserData user) {
  final double cellWidth = PdfPageFormat.a4.width / 3;
  final double cellHeight = PdfPageFormat.a4.height / 3;

  return pw.Container(
    width: cellWidth,
    height: cellHeight,
    padding: const pw.EdgeInsets.all(40),
    child: pw.Column(
      mainAxisAlignment: pw.MainAxisAlignment.center,
      crossAxisAlignment: pw.CrossAxisAlignment.center,
      mainAxisSize: pw.MainAxisSize.min,
      children: [
        pw.Expanded(
          child: pw.FittedBox(
            child: pw.Container(
              padding: const pw.EdgeInsets.all(8),
              decoration: pw.BoxDecoration(color: PdfColors.white, borderRadius: pw.BorderRadius.circular(10)),
              child: pw.BarcodeWidget(
                barcode: pw.Barcode.qrCode(),
                data: user.toQrValue(),
                color: PdfColors.black,
                width: 80,
                height: 80,
              ),
            ),
          ),
        ),
        pw.SizedBox(height: 5),
        pw.Text(
          user.name,
          maxLines: 1,
          textAlign: pw.TextAlign.center,
          style: pw.TextStyle(
            fontSize: 10,
            color: PdfColors.white,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.SizedBox(height: 8),
        pw.Text(
          user.id.toString().padLeft(6, '0'),
          textAlign: pw.TextAlign.center,
          style: pw.TextStyle(
            fontSize: 9,
            letterSpacing: 1.2,
            color: PdfColors.white,
          ),
        ),
        pw.SizedBox(height: 10),
      ],
    ),
  );
}

pw.Page getCodeWPage({required UserData user, required pw.Font reqFont, required pw.Font boldFont}) {
  final double cellWidth = PdfPageFormat.a4.width;
  final double cellHeight = PdfPageFormat.a4.height;

  return pw.Page(
    pageTheme: pw.PageTheme(
      margin: pw.EdgeInsets.zero,
      pageFormat: PdfPageFormat.a4,
      textDirection: pw.TextDirection.rtl,
      theme: pw.ThemeData.withFont(
        base: reqFont,
        bold: boldFont,
      ),
      buildBackground: (context) => pw.FullPage(
        ignoreMargins: true,
        child: pw.Container(
          color: PdfColor.fromHex("#482476"), // your desired background color
        ),
      ),
    ),
    build: (context) {
      return pw.Container(
        width: cellWidth,
        height: cellHeight,
        padding: const pw.EdgeInsets.all(80),
        child: pw.Column(
          mainAxisAlignment: pw.MainAxisAlignment.center,
          crossAxisAlignment: pw.CrossAxisAlignment.center,
          mainAxisSize: pw.MainAxisSize.min,
          children: [
            pw.Expanded(
              child: pw.FittedBox(
                child: pw.Container(
                  padding: const pw.EdgeInsets.all(8),
                  decoration: pw.BoxDecoration(color: PdfColors.white, borderRadius: pw.BorderRadius.circular(10)),
                  child: pw.BarcodeWidget(
                    barcode: pw.Barcode.qrCode(),
                    data: user.toQrValue(),
                    color: PdfColors.black,
                    width: 80,
                    height: 80,
                  ),
                ),
              ),
            ),
            pw.SizedBox(height: 5),
            pw.Text(
              "الاسم : ${user.name}",
              maxLines: 1,
              textAlign: pw.TextAlign.center,
              style: pw.TextStyle(
                fontSize: 28,
                color: PdfColors.white,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.SizedBox(height: 20),
            pw.Text(
              "رقم الطالب : ${user.id.toString().padLeft(6, '0')}",
              textAlign: pw.TextAlign.center,
              style: pw.TextStyle(
                fontSize: 26,
                letterSpacing: 1.2,
                color: PdfColors.white,
              ),
            ),
            pw.SizedBox(height: 10),
          ],
        ),
      );
    },
  );
}
