import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:moatmat_admin/Features/code/domain/entites/code_data.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

Future<Uint8List> exportQRCodesPdf({required List<CodeData> codes, required bool onPerPage}) async {
  final pdf = pw.Document();
  //
  var reqFont = pw.Font.ttf(
    await rootBundle.load("assets/fonts/Tajawal/Tajawal-Regular.ttf"),
  );
  var boldFont = pw.Font.ttf(
    await rootBundle.load("assets/fonts/Tajawal/Tajawal-Bold.ttf"),
  );
  final ByteData framePng = await rootBundle.load("assets/other/code_frame.png");
  final ByteData logoSvg = await rootBundle.load("assets/other/app-icon.svg");
  //
  final pw.ImageProvider frame = pw.MemoryImage(framePng.buffer.asUint8List());
//
  final ByteData logoSvgBytes = await rootBundle.load("assets/other/app-icon.svg");
  final String svgString = String.fromCharCodes(logoSvgBytes.buffer.asUint8List());

  final pw.SvgImage logo = pw.SvgImage(svg: svgString);

  if (onPerPage) {
    for (var c in codes) {
      pdf.addPage(getCodeWPage(
        code: c,
        reqFont: reqFont,
        boldFont: boldFont,
        frame: frame,
        logo: logo,
      ));
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
              color: PdfColor.fromHex("#482476"),
            ),
          ),
        ),
        build: (context) {
          return [
            pw.Wrap(
              spacing: 0,
              runSpacing: 0,
              children: codes
                  .map((e) => getCodeWidget(
                        code: e,
                        frame: frame,
                        logo: logo,
                      ))
                  .toList(),
            ),
          ];
        }, // 012578 004305 001484 011852 010250 010915 012377 011500 010639 012327 012741 012722 012998
      ),
    );
  }

  return await pdf.save();
}

//  color: PdfColor.fromHex("#482476"),
pw.Widget getCodeWidget({
  required CodeData code,
  required pw.ImageProvider frame,
  required pw.SvgImage logo,
}) {
  final double cellWidth = PdfPageFormat.a4.width / 3;
  final double cellHeight = PdfPageFormat.a4.height / 3;
  final double imageSize = 100;

  return pw.Container(
    width: cellWidth,
    height: cellHeight,
    padding: const pw.EdgeInsets.symmetric(vertical: 40),
    child: pw.Column(
      mainAxisAlignment: pw.MainAxisAlignment.center,
      crossAxisAlignment: pw.CrossAxisAlignment.center,
      mainAxisSize: pw.MainAxisSize.min,
      children: [
        pw.SizedBox(
          width: 40,
          height: 40,
          child: logo,
        ),
        pw.SizedBox(height: 9),
        pw.Stack(
          alignment: pw.Alignment.center,
          children: [
            pw.SizedBox(
              width: imageSize,
              height: imageSize,
              child: pw.BarcodeWidget(
                barcode: pw.Barcode.qrCode(),
                data: code.id,
                color: PdfColors.black,
                backgroundColor: PdfColors.white,
                padding: pw.EdgeInsets.all(6),
                margin: pw.EdgeInsets.all(2),
              ),
            ),
            pw.SizedBox(
              width: imageSize,
              height: imageSize,
              child: pw.Image(frame, fit: pw.BoxFit.cover),
            ),
          ],
        ),
        pw.SizedBox(height: 18),
        pw.Text(
          "قيمة الكود : ${code.amount}",
          maxLines: 1,
          textAlign: pw.TextAlign.center,
          style: pw.TextStyle(
            fontSize: 12,
            color: PdfColors.white,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.SizedBox(height: 12),
        pw.Container(
          padding: const pw.EdgeInsets.symmetric(
            horizontal: 4,
            vertical: 2,
          ),
          decoration: pw.BoxDecoration(
            border: pw.Border.all(
              color: PdfColors.green,
              width: 1,
            ),
            borderRadius: pw.BorderRadius.circular(6),
          ),
          child: pw.Padding(
            padding: pw.EdgeInsets.only(top: 3),
            child: pw.Text(
              code.id.toUpperCase(),
              textAlign: pw.TextAlign.center,
              style: pw.TextStyle(
                fontSize: 7,
                color: PdfColors.white,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ),
        ),
        pw.SizedBox(height: 10),
      ],
    ),
  );
}

pw.Page getCodeWPage({
  required CodeData code,
  required pw.Font reqFont,
  required pw.Font boldFont,
  required pw.ImageProvider frame,
  required pw.SvgImage logo,
}) {
  const double imageSize = 300; // QR with frame size
  const double logoSize = 160;
  const double textFontSize = 32;
  const double idFontSize = 24;

  return pw.Page(
    pageTheme: pw.PageTheme(
      margin: pw.EdgeInsets.zero,
      pageFormat: PdfPageFormat.a4,
      textDirection: pw.TextDirection.rtl,
      theme: pw.ThemeData.withFont(base: reqFont, bold: boldFont),
      buildBackground: (_) => pw.FullPage(
        ignoreMargins: true,
        child: pw.Container(color: PdfColor.fromHex("#482476")),
      ),
    ),
    build: (context) {
      return pw.Center(
        child: pw.Column(
          mainAxisAlignment: pw.MainAxisAlignment.center,
          children: [
            pw.SizedBox(
              width: logoSize,
              height: logoSize,
              child: logo,
            ),
            pw.SizedBox(height: 60),
            pw.Stack(
              alignment: pw.Alignment.center,
              children: [
                pw.SizedBox(
                  width: imageSize,
                  height: imageSize,
                  child: pw.BarcodeWidget(
                    barcode: pw.Barcode.qrCode(),
                    data: code.id,
                    color: PdfColors.black,
                    backgroundColor: PdfColors.white,
                    padding: pw.EdgeInsets.all(12),
                    margin: pw.EdgeInsets.all(6),
                  ),
                ),
                pw.SizedBox(
                  width: imageSize,
                  height: imageSize,
                  child: pw.Image(frame, fit: pw.BoxFit.cover),
                ),
              ],
            ),
            pw.SizedBox(height: 40),
            pw.Text(
              "قيمة الكود : ${code.amount}",
              textAlign: pw.TextAlign.center,
              style: pw.TextStyle(
                fontSize: textFontSize,
                color: PdfColors.white,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.SizedBox(height: 40),
            pw.Container(
              padding: const pw.EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: pw.BoxDecoration(
                border: pw.Border.all(color: PdfColors.green, width: 2),
                borderRadius: pw.BorderRadius.circular(10),
              ),
              child: pw.Padding(
                padding: pw.EdgeInsets.only(top: 6),
                child: pw.Text(
                  code.id.toUpperCase(),
                  textAlign: pw.TextAlign.center,
                  style: pw.TextStyle(
                    fontSize: idFontSize,
                    color: PdfColors.white,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}
