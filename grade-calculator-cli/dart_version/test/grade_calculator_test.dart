import 'package:test/test.dart';
import '../lib/grade_calculator.dart';

void main() {
  group('GradeCalculator Tests', () {
    test('Calculate grade A for marks 80-100', () {
      expect(GradeCalculator.calculateGrade(80), equals('A'));
      expect(GradeCalculator.calculateGrade(90), equals('A'));
      expect(GradeCalculator.calculateGrade(100), equals('A'));
    });

    test('Calculate grade B+ for marks 70-79', () {
      expect(GradeCalculator.calculateGrade(70), equals('B+'));
      expect(GradeCalculator.calculateGrade(75), equals('B+'));
      expect(GradeCalculator.calculateGrade(79), equals('B+'));
    });

    test('Calculate grade B for marks 60-69', () {
      expect(GradeCalculator.calculateGrade(60), equals('B'));
      expect(GradeCalculator.calculateGrade(65), equals('B'));
      expect(GradeCalculator.calculateGrade(69), equals('B'));
    });

    test('Calculate grade C+ for marks 55-59', () {
      expect(GradeCalculator.calculateGrade(55), equals('C+'));
      expect(GradeCalculator.calculateGrade(57), equals('C+'));
      expect(GradeCalculator.calculateGrade(59), equals('C+'));
    });

    test('Calculate grade C for marks 50-54', () {
      expect(GradeCalculator.calculateGrade(50), equals('C'));
      expect(GradeCalculator.calculateGrade(52), equals('C'));
      expect(GradeCalculator.calculateGrade(54), equals('C'));
    });

    test('Calculate grade D+ for marks 45-49', () {
      expect(GradeCalculator.calculateGrade(45), equals('D+'));
      expect(GradeCalculator.calculateGrade(47), equals('D+'));
      expect(GradeCalculator.calculateGrade(49), equals('D+'));
    });

    test('Calculate grade D for marks 40-44', () {
      expect(GradeCalculator.calculateGrade(40), equals('D'));
      expect(GradeCalculator.calculateGrade(42), equals('D'));
      expect(GradeCalculator.calculateGrade(44), equals('D'));
    });

    test('Calculate grade F for marks 0-39', () {
      expect(GradeCalculator.calculateGrade(0), equals('F'));
      expect(GradeCalculator.calculateGrade(20), equals('F'));
      expect(GradeCalculator.calculateGrade(39), equals('F'));
    });

    test('Calculate GPA correctly', () {
      expect(GradeCalculator.calculateGPA(85), equals(4.0));
      expect(GradeCalculator.calculateGPA(75), equals(3.5));
      expect(GradeCalculator.calculateGPA(65), equals(3.0));
      expect(GradeCalculator.calculateGPA(57), equals(2.5));
      expect(GradeCalculator.calculateGPA(52), equals(2.0));
      expect(GradeCalculator.calculateGPA(47), equals(1.5));
      expect(GradeCalculator.calculateGPA(42), equals(1.0));
      expect(GradeCalculator.calculateGPA(30), equals(0.0));
    });

    test('Process student correctly', () {
      final result = GradeCalculator.processStudent('John Doe', 85);
      expect(result.name, equals('John Doe'));
      expect(result.marks, equals(85));
      expect(result.grade, equals('A'));
      expect(result.gpa, equals(4.0));
    });
  });
}

