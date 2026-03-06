# Grade Calculator CLI

A command-line application for calculating student grades and GPA from Excel files, implemented in both Dart and Kotlin.

## Overview

This project provides two implementations of a grade calculator:
- **Dart Version**: Uses the `excel` package for Excel file handling
- **Kotlin Version**: Uses Apache POI for Excel file handling

Both versions read student data from an Excel file (Name and Marks), calculate the grade and GPA according to a predefined grading system, and output the results to a new Excel file.

## Grading System

| Grade | Marks Range | GPA  |
|-------|-------------|------|
| A     | 80-100      | 4.0  |
| B+    | 70-79       | 3.5  |
| B     | 60-69       | 3.0  |
| C+    | 55-59       | 2.5  |
| C     | 50-54       | 2.0  |
| D+    | 45-49       | 1.5  |
| D     | 40-44       | 1.0  |
| F     | 0-39        | 0.0  |

## Prerequisites

### For Dart Version
- Dart SDK 3.0 or higher
- Download from: https://dart.dev/get-dart

### For Kotlin Version
- Java Development Kit (JDK) 11 or higher
- Kotlin (managed by Gradle)
- Download JDK from: https://adoptium.net/

## Project Structure

```
grade-calculator-cli/
├── dart_version/
│   ├── bin/
│   │   └── main.dart              # Entry point for Dart CLI
│   ├── lib/
│   │   └── grade_calculator.dart  # Grade calculation logic
│   ├── test/
│   │   └── grade_calculator_test.dart  # Unit tests
│   └── pubspec.yaml               # Dart dependencies
├── kotlin_version/
│   ├── src/main/kotlin/
│   │   ├── Main.kt                # Entry point for Kotlin CLI
│   │   └── GradeCalculator.kt     # Grade calculation logic
│   ├── build.gradle.kts           # Kotlin/Gradle build configuration
│   └── settings.gradle.kts        # Gradle settings
├── sample_input/
│   └── students.xlsx              # Sample input file with 5 students
├── README.md                      # This file
└── .gitignore                     # Git ignore rules
```

## Input Excel Format

The input Excel file should have the following structure:

| Name          | Marks |
|---------------|-------|
| Student Name1 | 85    |
| Student Name2 | 72    |
| Student Name3 | 55    |

- **Column 1 (Name)**: Student's name (text)
- **Column 2 (Marks)**: Student's marks (number between 0-100)

## Output Excel Format

The output Excel file will contain:

| Name          | Marks | Grade | GPA |
|---------------|-------|-------|-----|
| Student Name1 | 85    | A     | 4.0 |
| Student Name2 | 72    | B+    | 3.5 |
| Student Name3 | 55    | C+    | 2.5 |

- **Column 1 (Name)**: Student's name
- **Column 2 (Marks)**: Student's marks
- **Column 3 (Grade)**: Calculated grade letter
- **Column 4 (GPA)**: Calculated GPA

## How to Run

### Dart Version

1. Navigate to the Dart version directory:
   ```bash
   cd dart_version
   ```

2. Install dependencies:
   ```bash
   dart pub get
   ```

3. Run the application:
   ```bash
   dart run bin/main.dart <input.xlsx> <output.xlsx>
   ```

   **Example:**
   ```bash
   dart run bin/main.dart ../sample_input/students.xlsx output_dart.xlsx
   ```

4. Run tests:
   ```bash
   dart test
   ```

### Kotlin Version

1. Navigate to the Kotlin version directory:
   ```bash
   cd kotlin_version
   ```

2. Build the project:
   ```bash
   ./gradlew build
   ```
   
   On Windows:
   ```bash
   gradlew.bat build
   ```

3. Run the application:
   ```bash
   ./gradlew run --args="<input.xlsx> <output.xlsx>"
   ```
   
   On Windows:
   ```bash
   gradlew.bat run --args="<input.xlsx> <output.xlsx>"
   ```

   **Example:**
   ```bash
   ./gradlew run --args="../sample_input/students.xlsx output_kotlin.xlsx"
   ```
   
   On Windows:
   ```bash
   gradlew.bat run --args="../sample_input/students.xlsx output_kotlin.xlsx"
   ```

## Features

- ✅ Read student data from Excel files (.xlsx format)
- ✅ Calculate grades based on predefined grading system
- ✅ Calculate GPA values
- ✅ Generate formatted output Excel files
- ✅ Command-line interface for both implementations
- ✅ Comprehensive error handling
- ✅ Unit tests for grade calculation logic (Dart)

## Dependencies

### Dart Version
- `flutter: sdk` - Flutter framework for GUI
- `excel: ^4.0.3` - For Excel file manipulation
- `file_picker: ^8.0.0+1` - For native file selection dialogs
- `path: ^1.8.3` - For file path manipulation
- `args: ^2.4.2` - For command-line argument parsing (CLI mode)
- `test: ^1.21.0` - For unit testing
- `flutter_lints: ^3.0.0` - Linting rules

### Kotlin Version
- `Apache POI 5.2.5` - For Excel file manipulation
  - `poi` - Core POI library
  - `poi-ooxml` - Support for .xlsx format
- `Kotlin Standard Library` - Kotlin runtime

## Functional Programming Concepts in Dart GUI

The GUI implementation extensively uses functional programming concepts:

### 1. **Higher-Order Functions**
Functions that accept other functions as parameters or return functions.

**Example in `lib/main.dart`:**
```dart
// _performFileOperation accepts a callback function
Future<void> _performFileOperation(
  String operationType,
  Function(String filePath) onFileSelected,
) async {
  // ... file picking logic
  onFileSelected(result.files.single.path!);  // Calls the callback
}

// _processExcelWithTransform accepts a transformer function
List<GradeResult> _processExcelWithTransform(
  Excel excel,
  GradeResult Function(String name, int marks) transformer,
) {
  // Uses transformer to process each student
  results.add(transformer(name, marks));
}
```

### 2. **Lambda Expressions**
Anonymous functions passed as arguments or assigned to variables.

**Examples in `lib/main.dart`:**
```dart
// Lambda passed to higher-order function
_performFileOperation('Select Input Excel File', (filePath) {
  setState(() {
    _inputFilePath = filePath;
  });
});

// Lambda in event handlers
onPressed: () => Navigator.pop(context),

// Lambda in filtering
_filterResults((r) => r.marks >= 40)
_filterResults((r) => r.marks < 40)
```

### 3. **Collection Operations with Lambdas**
Using `where`, `fold`, `forEach`, and `map` with lambda functions.

**Examples in `lib/main.dart`:**
```dart
// Using forEach with lambda
_results.forEach((result) {
  outputSheet.appendRow([...]);
});

// Using fold to calculate sum
_results.fold<double>(0, (sum, r) => sum + r.marks)

// Using where (filter) with predicate lambda
_results.where(predicate).toList()
```

### 4. **Function Composition**
Combining functions to create new functionality.

**Example:**
The `_filterResults` function accepts a predicate and returns filtered data, which can be composed with other operations.

### Where to Find These Concepts
All functional programming implementations are **commented in the code** with markers like:
- `// LAMBDA:` - Marks lambda expression usage
- `// HIGHER-ORDER FUNCTION:` - Marks higher-order function definitions
- Check `dart_version/lib/main.dart` for detailed comments

📚 **Additional Documentation:**
- **`dart_version/GUI_SETUP_GUIDE.md`** - Complete setup and usage instructions for the GUI
- **`dart_version/FUNCTIONAL_PROGRAMMING_REFERENCE.md`** - Comprehensive guide to all lambda and higher-order function usages with examples

## Setting Up the GUI Application

Before running the GUI version for the first time, you need to set up the Windows platform support:

1. **Navigate to the dart_version directory:**
   ```bash
   cd dart_version
   ```

2. **Create Windows platform files:**
   ```bash
   flutter create --org com.gradecalc --platforms windows .
   ```
   This will create a `windows/` directory with all necessary files.

3. **Install dependencies:**
   ```bash
   flutter pub get
   ```

4. **Verify setup:**
   ```bash
   flutter doctor
   flutter devices
   ```
   You should see "Windows (desktop)" in the devices list.

## Testing the Application

### GUI Testing Steps

1. **Install dependencies:**
   ```bash
   cd dart_version
   flutter pub get
   ```

2. **Run the application:**
   ```bash
   flutter run -d windows
   ```
   (Replace `windows` with `macos` or `linux` as needed)

3. **Test the workflow:**
   - **Step 1**: Click "Select Input Excel File"
   - **Step 2**: Navigate to and select `../sample_input/students.xlsx`
   - **Step 3**: Verify the status message shows the selected file
   - **Step 4**: Click "Process File" button
   - **Step 5**: Observe the results table populate with student data
   - **Step 6**: Check the statistics card showing:
     - Total students
     - Passed/Failed counts
     - Average marks
   - **Step 7**: Click "Save Output File"
   - **Step 8**: Choose a location and filename for the output
   - **Step 9**: Verify the success message appears
   - **Step 10**: Open the saved Excel file to verify the output

4. **Test error handling:**
   - Try processing without selecting a file (should show error)
   - Try saving without processing (should show error)
   - Try selecting a non-Excel file (file picker should prevent this)

5. **Build standalone executable (optional):**
   ```bash
   flutter build windows --release
   ```
   The executable will be created in `build/windows/runner/Release/grade_calculator.exe`

### CLI Testing

```bash
cd dart_version
dart run bin/main.dart ../sample_input/students.xlsx test_output.xlsx
```

Expected output:
```
Reading input file: ../sample_input/students.xlsx
Processed: [Student Name] - [Marks] marks -> [Grade] (GPA: [GPA])
...
Successfully processed X student(s)
Output saved to: test_output.xlsx
```

## License

This project is provided as-is for educational purposes.

## Author

Created as a demonstration of cross-platform CLI application development with Dart and Kotlin.

