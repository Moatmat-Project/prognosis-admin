import 'package:excel/excel.dart';

class GetMyStudentsStatisticsResponse {
  final List<StudentRowDetails> rows;
  final List<(int, String)> tests;

  GetMyStudentsStatisticsResponse({
    required this.rows,
    required this.tests,
  });
}

class StudentRowDetails {
  final String name;
  final String userId;
  final List<StudentTestMarkDetails> marks;

  StudentRowDetails({
    required this.name,
    required this.userId,
    required this.marks,
  });

  List<CellValue?> toExcelRow({
    required int id,
    required List<int> testsIds,
    required Function({
      required int cIndex,
      required int rIndex,
      required CellStyle style,
    }) onChangeStyle,
    required void Function({
      required double average,
    }) onGetAverage,
  }) {
    ///
    String studentId;
    String studentName;
    double studentAverage = 0.0;
    String studentRate = '        A        ';
    int studentAbsents = 0;
    List<double?> studentMarks = List.filled(testsIds.length, null);

    ///
    studentId = userId.toString().padLeft(6, "0");
    studentName = name;

    ///
    for (int i = 0; i < testsIds.length; i++) {
      if (!marks.any((e) {
        bool value = e.testId == testsIds[i];
        if (value) {
          studentMarks[i] = (e.mark);
        }
        return value;
      })) {
        studentAbsents++;
      }
    }

    if (studentAbsents > 0) {
      onChangeStyle(
        cIndex: 2,
        rIndex: id + 1,
        style: CellStyle(
          backgroundColorHex: ExcelColor.yellow100,
        ),
      );
    }

    ///
    final marksSum = studentMarks.where((e) => e != null).fold(0, (sum, element) => sum + element!.toInt());
    if (marksSum > 0) {
      studentAverage = marksSum / (testsIds.length - studentAbsents);
      studentAverage = double.parse(studentAverage.toStringAsPrecision(2));
    } else {
      studentAverage = 0.0;
    }
    onGetAverage(average: studentAverage);

    ///
    return [
      TextCellValue(studentId),
      TextCellValue(studentName),
      DoubleCellValue(studentAverage),
      TextCellValue(studentRate),
      IntCellValue(studentAbsents),
      ...List.generate(studentMarks.length, (i) {
        final mark = studentMarks[i];
        onChangeStyle(
          cIndex: 5 + i,
          rIndex: id + 1,
          style: CellStyle(
            numberFormat: NumFormat.standard_2,
            fontColorHex: mark == null ? ExcelColor.red : ExcelColor.black,
          ),
        );
        if (mark == null) {
          return TextCellValue(" غياب ");
        } else {
          return DoubleCellValue(mark);
        }
      })
    ];
  }
}

class StudentTestMarkDetails {
  final int testId;
  final double mark;
  final DateTime date;

  StudentTestMarkDetails({
    required this.testId,
    required this.mark,
    required this.date,
  });
}
