# Grade Calculator CLI

A command-line application for calculating student grades and GPA from Excel files, implemented in Dart.

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
- `excel: ^4.0.3` - For Excel file manipulation
- `args: ^2.4.2` - For command-line argument parsing
- `test: ^1.24.0` - For unit testing

### Kotlin Version
- `Apache POI 5.2.5` - For Excel file manipulation
  - `poi` - Core POI library
  - `poi-ooxml` - Support for .xlsx format
- `Kotlin Standard Library` - Kotlin runtime

## License

This project is provided as-is for educational purposes.

## Author

Created as a demonstration of cross-platform CLI application development with Dart and Kotlin.
