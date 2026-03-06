import 'package:flutter/material.dart';
import 'dart:io';
import 'package:excel/excel.dart' hide Border;
import 'package:file_picker/file_picker.dart';
import 'grade_calculator.dart';

void main() {
  runApp(const GradeCalculatorApp());
}

class GradeCalculatorApp extends StatelessWidget {
  const GradeCalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Grade Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const GradeCalculatorHome(),
    );
  }
}

class GradeCalculatorHome extends StatefulWidget {
  const GradeCalculatorHome({super.key});

  @override
  State<GradeCalculatorHome> createState() => _GradeCalculatorHomeState();
}

class _GradeCalculatorHomeState extends State<GradeCalculatorHome> {
  String? _inputFilePath;
  List<GradeResult> _results = [];
  bool _isProcessing = false;
  String _statusMessage = 'No file selected';

  // HIGHER-ORDER FUNCTION: Accepts a callback function as parameter
  // This function wraps file picking logic and executes a callback on success
  Future<void> _performFileOperation(
    String operationType,
    Function(String filePath) onFileSelected,
  ) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xlsx'],
        dialogTitle: operationType,
      );

      if (result != null && result.files.single.path != null) {
        // LAMBDA: Anonymous function passed as callback
        onFileSelected(result.files.single.path!);
      }
    } catch (e) {
      _showErrorDialog('Error selecting file: $e');
    }
  }

  // LAMBDA & HIGHER-ORDER FUNCTION: Uses lambda for file processing
  void _pickInputFile() {
    // Passing a lambda function to the higher-order function
    _performFileOperation('Select Input Excel File', (filePath) {
      setState(() {
        _inputFilePath = filePath;
        _statusMessage = 'Input file selected: ${_getFileName(filePath)}';
        _results = []; // Clear previous results
      });
    });
  }

  // HIGHER-ORDER FUNCTION: Processes Excel data with transformation function
  List<GradeResult> _processExcelWithTransform(
    Excel excel,
    GradeResult Function(String name, int marks) transformer,
  ) {
    final results = <GradeResult>[];
    final sheetName = excel.tables.keys.first;
    final sheet = excel.tables[sheetName];

    if (sheet == null) return results;

    bool isFirstRow = true;
    for (var row in sheet.rows) {
      if (isFirstRow) {
        isFirstRow = false;
        continue;
      }

      if (row.length >= 2) {
        final nameCell = row[0];
        final marksCell = row[1];

        if (nameCell?.value != null && marksCell?.value != null) {
          final name = nameCell!.value.toString();
          final marksValue = marksCell!.value;

          int marks = _extractMarks(marksValue);
          // LAMBDA: Using the transformer function (passed as parameter)
          results.add(transformer(name, marks));
        }
      }
    }
    return results;
  }

  int _extractMarks(dynamic marksValue) {
    if (marksValue is IntCellValue) {
      return marksValue.value;
    } else if (marksValue is DoubleCellValue) {
      return marksValue.value.round();
    } else if (marksValue is TextCellValue) {
      return int.tryParse(marksValue.value.toString()) ?? 0;
    } else {
      return int.tryParse(marksValue.toString()) ?? 0;
    }
  }

  Future<void> _processFile() async {
    if (_inputFilePath == null) {
      _showErrorDialog('Please select an input file first');
      return;
    }

    setState(() {
      _isProcessing = true;
      _statusMessage = 'Processing file...';
    });

    try {
      final bytes = await File(_inputFilePath!).readAsBytes();
      final excel = Excel.decodeBytes(bytes);

      // LAMBDA & HIGHER-ORDER FUNCTION: Passing GradeCalculator.processStudent as lambda
      final processedResults = _processExcelWithTransform(
        excel,
        (name, marks) => GradeCalculator.processStudent(name, marks),
      );

      setState(() {
        _results = processedResults;
        _isProcessing = false;
        _statusMessage = 'Successfully processed ${_results.length} student(s)';
      });
    } catch (e) {
      setState(() {
        _isProcessing = false;
        _statusMessage = 'Error processing file';
      });
      _showErrorDialog('Error processing Excel file: $e');
    }
  }

  // LAMBDA: Save file operation with callback
  Future<void> _saveOutputFile() async {
    if (_results.isEmpty) {
      _showErrorDialog('No data to save. Please process a file first.');
      return;
    }

    try {
      String? outputPath = await FilePicker.platform.saveFile(
        dialogTitle: 'Save Output Excel File',
        fileName: 'output.xlsx',
        type: FileType.custom,
        allowedExtensions: ['xlsx'],
      );

      if (outputPath != null) {
        // Ensure .xlsx extension
        if (!outputPath.endsWith('.xlsx')) {
          outputPath = '$outputPath.xlsx';
        }

        await _generateAndSaveExcel(outputPath);

        if (mounted) {
          _showSuccessDialog('File saved successfully to: $outputPath');
        }
      }
    } catch (e) {
      _showErrorDialog('Error saving file: $e');
    }
  }

  Future<void> _generateAndSaveExcel(String outputPath) async {
    final outputExcel = Excel.createExcel();
    final outputSheet = outputExcel['Sheet1'];

    // Write header
    outputSheet.appendRow([
      TextCellValue('Name'),
      TextCellValue('Marks'),
      TextCellValue('Grade'),
      TextCellValue('GPA'),
    ]);

    // HIGHER-ORDER FUNCTION: forEach with lambda
    _results.forEach((result) {
      outputSheet.appendRow([
        TextCellValue(result.name),
        IntCellValue(result.marks),
        TextCellValue(result.grade),
        DoubleCellValue(result.gpa),
      ]);
    });

    final outputBytes = outputExcel.encode();
    if (outputBytes != null) {
      await File(outputPath).writeAsBytes(outputBytes);
    }
  }

  String _getFileName(String path) {
    return path.split(Platform.pathSeparator).last;
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            // LAMBDA: Anonymous function as event handler
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Success'),
        content: Text(message),
        actions: [
          TextButton(
            // LAMBDA: Anonymous function as event handler
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  // HIGHER-ORDER FUNCTION: Filters results based on a predicate
  List<GradeResult> _filterResults(bool Function(GradeResult) predicate) {
    return _results.where(predicate).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Grade Calculator'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // File Selection Card
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'File Operations',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      // LAMBDA: Button callback
                      onPressed: _pickInputFile,
                      icon: const Icon(Icons.file_open),
                      label: const Text('Select Input Excel File'),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _statusMessage,
                      style: TextStyle(
                        color: _results.isNotEmpty ? Colors.green : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    // LAMBDA: Button callback
                    onPressed: _isProcessing ? null : _processFile,
                    icon: _isProcessing
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.calculate),
                    label: Text(_isProcessing ? 'Processing...' : 'Process File'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(16),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    // LAMBDA: Button callback
                    onPressed: _results.isEmpty ? null : _saveOutputFile,
                    icon: const Icon(Icons.save),
                    label: const Text('Save Output File'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(16),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Statistics Card
            if (_results.isNotEmpty) ...[
              Card(
                elevation: 4,
                color: Colors.blue.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Statistics',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      // LAMBDA & HIGHER-ORDER FUNCTION: Using where with predicate
                      Text('Total Students: ${_results.length}'),
                      Text('Passed (>=40): ${_filterResults((r) => r.marks >= 40).length}'),
                      Text('Failed (<40): ${_filterResults((r) => r.marks < 40).length}'),
                      Text(
                        'Average Marks: ${(_results.fold<double>(0, (sum, r) => sum + r.marks) / _results.length).toStringAsFixed(2)}',
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Results Table
            Expanded(
              child: Card(
                elevation: 4,
                child: _results.isEmpty
                    ? const Center(
                        child: Text(
                          'No results to display.\nSelect and process a file to see results.',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      )
                    : Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            color: Colors.blue.shade100,
                            child: const Row(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    'Name',
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    'Marks',
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    'Grade',
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    'GPA',
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: ListView.builder(
                              // LAMBDA: Builder function for list items
                              itemCount: _results.length,
                              itemBuilder: (context, index) {
                                final result = _results[index];
                                return Container(
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(color: Colors.grey.shade300),
                                    ),
                                    // LAMBDA: Conditional color based on grade
                                    color: index % 2 == 0 ? Colors.white : Colors.grey.shade50,
                                  ),
                                  padding: const EdgeInsets.all(12),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 3,
                                        child: Text(result.name),
                                      ),
                                      Expanded(
                                        child: Text('${result.marks}'),
                                      ),
                                      Expanded(
                                        child: Text(
                                          result.grade,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            // LAMBDA: Color based on grade
                                            color: result.grade == 'F' ? Colors.red : Colors.green,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Text('${result.gpa}'),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

