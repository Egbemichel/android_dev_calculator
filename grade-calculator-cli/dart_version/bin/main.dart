import 'dart:io';
import 'package:excel/excel.dart';
import '../lib/grade_calculator.dart';

void main(List<String> arguments) async {
  // Check arguments
  if (arguments.length != 2) {
    print('Usage: dart run bin/main.dart <input.xlsx> <output.xlsx>');
    print('Example: dart run bin/main.dart input.xlsx output.xlsx');
    exit(1);
  }

  final inputFile = arguments[0];
  final outputFile = arguments[1];

  // Check if input file exists
  if (!File(inputFile).existsSync()) {
    print('Error: Input file "$inputFile" not found');
    exit(1);
  }

  try {
    print('Reading input file: $inputFile');

    // Read input Excel file
    final bytes = File(inputFile).readAsBytesSync();
    final excel = Excel.decodeBytes(bytes);

    // Get the first sheet
    final sheetName = excel.tables.keys.first;
    final sheet = excel.tables[sheetName];

    if (sheet == null) {
      print('Error: No sheet found in Excel file');
      exit(1);
    }

    // Process student data
    final results = <GradeResult>[];
    bool isFirstRow = true;

    for (var row in sheet.rows) {
      // Skip header row
      if (isFirstRow) {
        isFirstRow = false;
        continue;
      }

      // Read name and marks
      if (row.length >= 2) {
        final nameCell = row[0];
        final marksCell = row[1];

        if (nameCell?.value != null && marksCell?.value != null) {
          final name = nameCell!.value.toString();
          final marksValue = marksCell!.value;

          int marks;
          if (marksValue is IntCellValue) {
            marks = marksValue.value;
          } else if (marksValue is DoubleCellValue) {
            marks = marksValue.value.round();
          } else if (marksValue is TextCellValue) {
            marks = int.tryParse(marksValue.value.toString()) ?? 0;
          } else {
            marks = int.tryParse(marksValue.toString()) ?? 0;
          }

          final result = GradeCalculator.processStudent(name, marks);
          results.add(result);
          print('Processed: ${result.name} - ${result.marks} marks -> ${result.grade} (GPA: ${result.gpa})');
        }
      }
    }

    print('\nGenerating output file: $outputFile');

    // Create output Excel file
    final outputExcel = Excel.createExcel();
    final outputSheet = outputExcel['Sheet1'];

    // Write header
    outputSheet.appendRow([
      TextCellValue('Name'),
      TextCellValue('Marks'),
      TextCellValue('Grade'),
      TextCellValue('GPA'),
    ]);

    // Write results
    for (var result in results) {
      outputSheet.appendRow([
        TextCellValue(result.name),
        IntCellValue(result.marks),
        TextCellValue(result.grade),
        DoubleCellValue(result.gpa),
      ]);
    }

    // Save output file
    final outputBytes = outputExcel.encode();
    if (outputBytes != null) {
      File(outputFile)
        ..createSync(recursive: true)
        ..writeAsBytesSync(outputBytes);

      print('Successfully processed ${results.length} student(s)');
      print('Output saved to: $outputFile');
    } else {
      print('Error: Failed to encode output Excel file');
      exit(1);
    }

  } catch (e) {
    print('Error processing Excel file: $e');
    exit(1);
  }
}

