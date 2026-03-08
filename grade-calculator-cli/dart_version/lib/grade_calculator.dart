/// Grade Calculator Library
/// Demonstrates OOP principles: Inheritance, Polymorphism, Abstract Classes, and Data Classes

// ============================================================================
// ABSTRACT CLASS - Defines common behavior for all students
// ============================================================================
abstract class Student {
  final String name;
  final int marks;

  Student({required this.name, required this.marks});

  // Abstract methods that must be implemented by subclasses
  String calculateGrade();
  double calculateGPA();
  String getStudentType();

  // Common method available to all students
  bool hasPassed() => marks >= 40;

  // Template method pattern - uses abstract methods
  GradeResult evaluatePerformance() {
    return GradeResult(
      name: name,
      marks: marks,
      grade: calculateGrade(),
      gpa: calculateGPA(),
      studentType: getStudentType(),
      passed: hasPassed(),
    );
  }

  @override
  String toString() {
    return '$name (${getStudentType()}): $marks marks - ${calculateGrade()} (GPA: ${calculateGPA()})';
  }
}

// ============================================================================
// CONCRETE CLASSES - Implementing the abstract Student class
// ============================================================================

/// Regular Student - Standard grading system
class RegularStudent extends Student {
  RegularStudent({required super.name, required super.marks});

  @override
  String calculateGrade() {
    if (marks >= 80 && marks <= 100) return 'A';
    if (marks >= 70 && marks < 80) return 'B+';
    if (marks >= 60 && marks < 70) return 'B';
    if (marks >= 55 && marks < 60) return 'C+';
    if (marks >= 50 && marks < 55) return 'C';
    if (marks >= 45 && marks < 50) return 'D+';
    if (marks >= 40 && marks < 45) return 'D';
    return 'F';
  }

  @override
  double calculateGPA() {
    if (marks >= 80 && marks <= 100) return 4.0;
    if (marks >= 70 && marks < 80) return 3.5;
    if (marks >= 60 && marks < 70) return 3.0;
    if (marks >= 55 && marks < 60) return 2.5;
    if (marks >= 50 && marks < 55) return 2.0;
    if (marks >= 45 && marks < 50) return 1.5;
    if (marks >= 40 && marks < 45) return 1.0;
    return 0.0;
  }

  @override
  String getStudentType() => 'Regular';
}

/// Honors Student - More stringent grading (requires higher marks for same grade)
class HonorsStudent extends Student {
  final String honorsProgram;

  HonorsStudent({
    required super.name,
    required super.marks,
    required this.honorsProgram,
  });

  @override
  String calculateGrade() {
    // Honors students need 5% more for each grade
    if (marks >= 85 && marks <= 100) return 'A';
    if (marks >= 75 && marks < 85) return 'B+';
    if (marks >= 65 && marks < 75) return 'B';
    if (marks >= 60 && marks < 65) return 'C+';
    if (marks >= 55 && marks < 60) return 'C';
    if (marks >= 50 && marks < 55) return 'D+';
    if (marks >= 45 && marks < 50) return 'D';
    return 'F';
  }

  @override
  double calculateGPA() {
    // Honors GPA is boosted by 0.5 for excellence
    final baseGPA = _calculateBaseGPA();
    return (baseGPA + 0.5).clamp(0.0, 4.5); // Max GPA can go to 4.5 for honors
  }

  double _calculateBaseGPA() {
    if (marks >= 85 && marks <= 100) return 4.0;
    if (marks >= 75 && marks < 85) return 3.5;
    if (marks >= 65 && marks < 75) return 3.0;
    if (marks >= 60 && marks < 65) return 2.5;
    if (marks >= 55 && marks < 60) return 2.0;
    if (marks >= 50 && marks < 55) return 1.5;
    if (marks >= 45 && marks < 50) return 1.0;
    return 0.0;
  }

  @override
  String getStudentType() => 'Honors ($honorsProgram)';

  @override
  String toString() {
    return '${super.toString()} [Program: $honorsProgram]';
  }
}

/// Transfer Student - Different grading scale for credits transfer
class TransferStudent extends Student {
  final String previousInstitution;
  final bool creditTransfer;

  TransferStudent({
    required super.name,
    required super.marks,
    required this.previousInstitution,
    this.creditTransfer = true,
  });

  @override
  String calculateGrade() {
    // Transfer students use pass/fail for some courses
    if (!creditTransfer) {
      return marks >= 50 ? 'P' : 'F'; // Pass/Fail
    }

    // Standard grading for credit transfer
    if (marks >= 80 && marks <= 100) return 'A';
    if (marks >= 70 && marks < 80) return 'B+';
    if (marks >= 60 && marks < 70) return 'B';
    if (marks >= 50 && marks < 60) return 'C';
    return 'F';
  }

  @override
  double calculateGPA() {
    if (!creditTransfer) {
      return marks >= 50 ? 2.0 : 0.0; // Pass = 2.0, Fail = 0.0
    }

    if (marks >= 80 && marks <= 100) return 4.0;
    if (marks >= 70 && marks < 80) return 3.5;
    if (marks >= 60 && marks < 70) return 3.0;
    if (marks >= 50 && marks < 60) return 2.0;
    return 0.0;
  }

  @override
  String getStudentType() => 'Transfer';

  @override
  bool hasPassed() => creditTransfer ? marks >= 40 : marks >= 50;

  @override
  String toString() {
    final transferInfo = creditTransfer ? 'Credit Transfer' : 'Pass/Fail';
    return '${super.toString()} [From: $previousInstitution, Type: $transferInfo]';
  }
}

// ============================================================================
// DATA CLASS - Immutable data structure with all evaluation results
// ============================================================================
class GradeResult {
  final String name;
  final int marks;
  final String grade;
  final double gpa;
  final String studentType;
  final bool passed;

  GradeResult({
    required this.name,
    required this.marks,
    required this.grade,
    required this.gpa,
    required this.studentType,
    required this.passed,
  });

  // Copy constructor for immutability
  GradeResult copyWith({
    String? name,
    int? marks,
    String? grade,
    double? gpa,
    String? studentType,
    bool? passed,
  }) {
    return GradeResult(
      name: name ?? this.name,
      marks: marks ?? this.marks,
      grade: grade ?? this.grade,
      gpa: gpa ?? this.gpa,
      studentType: studentType ?? this.studentType,
      passed: passed ?? this.passed,
    );
  }

  @override
  String toString() {
    final status = passed ? '✓ PASSED' : '✗ FAILED';
    return 'GradeResult(name: $name, type: $studentType, marks: $marks, grade: $grade, gpa: $gpa, status: $status)';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GradeResult &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          marks == other.marks &&
          grade == other.grade &&
          gpa == other.gpa &&
          studentType == other.studentType &&
          passed == other.passed;

  @override
  int get hashCode =>
      name.hashCode ^
      marks.hashCode ^
      grade.hashCode ^
      gpa.hashCode ^
      studentType.hashCode ^
      passed.hashCode;
}

// ============================================================================
// STATIC UTILITY CLASS - For backward compatibility and factory methods
// ============================================================================
class GradeCalculator {
  // Private constructor to prevent instantiation
  GradeCalculator._();

  /// Factory method to create a regular student (default)
  static Student createStudent({
    required String name,
    required int marks,
    String? studentType,
    String? honorsProgram,
    String? previousInstitution,
    bool? creditTransfer,
  }) {
    switch (studentType?.toLowerCase()) {
      case 'honors':
        return HonorsStudent(
          name: name,
          marks: marks,
          honorsProgram: honorsProgram ?? 'General Honors',
        );
      case 'transfer':
        return TransferStudent(
          name: name,
          marks: marks,
          previousInstitution: previousInstitution ?? 'Unknown',
          creditTransfer: creditTransfer ?? true,
        );
      default:
        return RegularStudent(name: name, marks: marks);
    }
  }

  /// Process a student record and return GradeResult (backward compatible)
  static GradeResult processStudent(String name, int marks) {
    final student = RegularStudent(name: name, marks: marks);
    return student.evaluatePerformance();
  }

  /// Static methods for backward compatibility
  static String calculateGrade(int marks) {
    final student = RegularStudent(name: '', marks: marks);
    return student.calculateGrade();
  }

  static double calculateGPA(int marks) {
    final student = RegularStudent(name: '', marks: marks);
    return student.calculateGPA();
  }

  // ========================================================================
  // POLYMORPHISM DEMONSTRATION
  // ========================================================================

  /// Demonstrates polymorphism by processing different student types
  static void demonstratePolymorphism() {
    print('\n' + '=' * 70);
    print('POLYMORPHISM DEMONSTRATION - OOP Principles Showcase');
    print('=' * 70 + '\n');

    // Collection of different student types (polymorphism)
    final List<Student> students = [
      RegularStudent(name: 'Alice Johnson', marks: 85),
      HonorsStudent(name: 'Bob Smith', marks: 82, honorsProgram: 'Computer Science Honors'),
      TransferStudent(name: 'Carol White', marks: 75, previousInstitution: 'State University'),
      RegularStudent(name: 'David Brown', marks: 55),
      HonorsStudent(name: 'Eve Davis', marks: 90, honorsProgram: 'Mathematics Honors'),
      TransferStudent(name: 'Frank Miller', marks: 60, previousInstitution: 'Community College', creditTransfer: false),
    ];

    print('📚 Processing ${students.length} students of different types:\n');

    // Polymorphic behavior - calling overridden methods
    for (var student in students) {
      print('→ ${student.toString()}');
      final result = student.evaluatePerformance();
      print('  Result: ${result.toString()}\n');
    }

    // Statistics using polymorphism
    print('─' * 70);
    print('📊 STATISTICS:\n');

    final passedStudents = students.where((s) => s.hasPassed()).toList();
    final failedStudents = students.where((s) => !s.hasPassed()).toList();

    print('Total Students: ${students.length}');
    print('Passed: ${passedStudents.length}');
    print('Failed: ${failedStudents.length}');

    // Group by type
    final regularCount = students.whereType<RegularStudent>().length;
    final honorsCount = students.whereType<HonorsStudent>().length;
    final transferCount = students.whereType<TransferStudent>().length;

    print('\nStudent Types:');
    print('  - Regular: $regularCount');
    print('  - Honors: $honorsCount');
    print('  - Transfer: $transferCount');

    // Average GPA (polymorphic calculation)
    final avgGPA = students.map((s) => s.calculateGPA()).reduce((a, b) => a + b) / students.length;
    print('\nAverage GPA: ${avgGPA.toStringAsFixed(2)}');

    print('\n' + '=' * 70 + '\n');
  }
}
