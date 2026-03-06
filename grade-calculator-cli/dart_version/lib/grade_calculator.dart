/// Grade Calculator Library
/// Provides functionality to calculate grades and GPA based on marks

class GradeResult {
  final String name;
  final int marks;
  final String grade;
  final double gpa;

  GradeResult({
    required this.name,
    required this.marks,
    required this.grade,
    required this.gpa,
  });

  @override
  String toString() {
    return 'GradeResult(name: $name, marks: $marks, grade: $grade, gpa: $gpa)';
  }
}

class GradeCalculator {
  /// Calculate grade letter based on marks
  static String calculateGrade(int marks) {
    if (marks >= 80 && marks <= 100) return 'A';
    if (marks >= 70 && marks < 80) return 'B+';
    if (marks >= 60 && marks < 70) return 'B';
    if (marks >= 55 && marks < 60) return 'C+';
    if (marks >= 50 && marks < 55) return 'C';
    if (marks >= 45 && marks < 50) return 'D+';
    if (marks >= 40 && marks < 45) return 'D';
    return 'F';
  }

  /// Calculate GPA based on marks
  static double calculateGPA(int marks) {
    if (marks >= 80 && marks <= 100) return 4.0;
    if (marks >= 70 && marks < 80) return 3.5;
    if (marks >= 60 && marks < 70) return 3.0;
    if (marks >= 55 && marks < 60) return 2.5;
    if (marks >= 50 && marks < 55) return 2.0;
    if (marks >= 45 && marks < 50) return 1.5;
    if (marks >= 40 && marks < 45) return 1.0;
    return 0.0;
  }

  /// Process a student record and return GradeResult
  static GradeResult processStudent(String name, int marks) {
    return GradeResult(
      name: name,
      marks: marks,
      grade: calculateGrade(marks),
      gpa: calculateGPA(marks),
    );
  }
}

