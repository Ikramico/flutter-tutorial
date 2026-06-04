// void main() {
//   print("------------start------------");
//
//   List<String> students = ["Sadik", "Rahim", "Karim", "Mustakim", "Adib", "Kawser"];
//
//   // print("------------for loop------------");
//   // for (int i = 0; i < students.length; i++) {
//   //   print(students[i]);
//   // }
//   //
//   // print("------------for in loop------------");
//   // for (String s in students) {
//   //   print(s);
//   // }
//   //
//   // print("------------while loop------------");
//   // int i = 0;
//   // while (i < students.length) {
//   //   print(students[i]);
//   //   i++;
//   // }
//   //
//   // print("------------while loop------------");
//   // int j = 0;
//   // do {
//   //   print(students[j]);
//   //   j++;
//   // } while (j < students.length);
//   // print(students.length); //6
//   // students.add("Nasim");
//   // print(students.length); //7
//   // students.remove("Sabbir");
//   // print(students.length); //7
//   // students.removeAt(3);
//   // print(students.length); //6
//   // students.removeAt(5);
//   // print(students.length); //5
//   // students[3] = "Murad";
//   // print(students);
//   //
//
//   // Map<String, dynamic> studentDataA = {"id": 101, "name": "Sadik", "department": "CSE"};
//   //
//   // Map<String, dynamic> studentDataB = {"id": 102, "name": "Adib", "department": "EEE"};
//   //
//   // // List<Map<String, dynamic>> students = [studentDataA, studentDataB];
//   //
//   // List<Map<String, dynamic>> students = [
//   //   {"id": 102, "name": "Adib", "department": "EEE"},
//   //   {"id": 102, "name": "Adib", "department": "EEE"},
//   // ];
//   //
//   // print(studentDataA["id"].toString().replaceAll("10", ""));
//   // print(studentDataA["name"].toString().toUpperCase().length);
//   // print(studentDataB["name"].toString().toLowerCase());
//
//   students.addAll(["Sadik", "Ahmed"]);
//
//   Set<String> uniqueStudents = {"Sadik", "Rahim", "Karim", "Mustakim", "Adib", "Kawser"};
// }

import 'dart:io';

void main() {
  List<Student> students = [];
  bool running = true;
  while (running) {
    print("\n========== Student List Manager ==========");
    print("1. Add Student");
    print("2. Remove Student");
    print("3. Search Student");
    print("4. Show All Students");
    print("5. Sort Students");
    print("6. Show Uppercase Names");
    print("7. Unique Departments");
    print("8. Exit");

    stdout.write("Enter your choice:");
    String? choice = stdin.readLineSync();

    switch (choice) {
      case '1':
        addStudent(students);
        break;
      case '2':
        removeStudent(students);
        break;
      case '3':
        searchStudent(students);
        break;
      case '4':
        showStudents(students);
        break;
      case '5':
        sortStudents(students);
        break;
      case '6':
        showUppercaseNames(students);
        break;
      case '7':
        showUniqueDepartments(students);
        break;
      case '8':
        running = false;
        print("\nProgram Closed.");
        break;
      default:
        print("\nInvalid Option!");
    }
  }
}

void showUniqueDepartments(List<Student> students) {
  Set<String> departments = students
      .map((student) => student.department)
      .toSet();
  print(departments);
}

void showUppercaseNames(List<Student> students) {
  // Create a new list with uppercase names — original list is untouched
  List<Student> uppercased = students.map((student) {
    return Student(
      id: student.id,
      name: student.name.toUpperCase(),
      department: student.department,
      grade: student.grade,
    );
  }).toList();

  showStudents(uppercased);
}

void sortStudents(List<Student> students) {
  List<Student> sorted = List.from(
    students,
  ); // copy so original order is preserved
  sorted.sort((a, b) => a.name.compareTo(b.name));
  showStudents(sorted);
}

void showStudents(List<Student> students) {
  if (students.isEmpty) {
    print("No students found.");
    return;
  }
  for (Student student in students) {
    print(
      "ID: ${student.id}, Name: ${student.name}, "
      "Dept.: ${student.department}, Grade: ${student.grade.toStringAsFixed(1)}",
    );
  }
}

void searchStudent(List<Student> students) {
  stdout.write("Student name to search: ");
  String query = stdin.readLineSync() ?? "";

  List<Student> result = students.where((Student student) {
    return student.name.toLowerCase().trim().contains(query.toLowerCase());
  }).toList();

  result.isEmpty ? print("No Data") : showStudents(result);
}

void removeStudent(List<Student> students) {
  stdout.write("Student ID to remove: ");
  String id = stdin.readLineSync() ?? "";
  students.removeWhere((Student student) {
    return student.id == int.parse(id);
  });
}

void addStudent(List<Student> students) {
  stdout.write("Student ID: ");
  String id = stdin.readLineSync() ?? "";

  stdout.write("Student Name: ");
  String name = stdin.readLineSync() ?? "";

  stdout.write("Student Dept: ");
  String department = stdin.readLineSync() ?? "";

  stdout.write("Student Grade (0–100): ");
  String gradeInput = stdin.readLineSync() ?? "0";

  Student newStudent = Student(
    id: int.parse(id),
    name: name.trim(),
    department: department.trim(),
    grade: double.parse(gradeInput),
  );
  students.add(newStudent);
}

// Returns a single Student by ID, or null if not found
Student? searchStudentByID(List<Student> students, int id) {
  try {
    return students.firstWhere((student) => student.id == id);
  } catch (_) {
    return null;
  }
}

// Returns a list of maps containing only Name and Grade for each student
List<Map<String, dynamic>> showResultAsGradeOfAllStudents(
  List<Student> students,
) {
  List<Map<String, dynamic>> result = students.map((student) {
    return {'name': student.name, 'grade': student.grade};
  }).toList();

  for (var entry in result) {
    print(
      "Name: ${entry['name']}, Grade: ${(entry['grade'] as double).toStringAsFixed(1)}",
    );
  }
  return result;
}

// Prints and returns students who passed (grade >= 33)
List<Student> showHowManyPassed(List<Student> students) {
  List<Student> passed = students.where((s) => s.grade >= 33).toList();
  print("Passed (${passed.length}):");
  showStudents(passed);
  return passed;
}

// Prints and returns students who failed (grade < 33)
List<Student> showHowManyFailed(List<Student> students) {
  List<Student> failed = students.where((s) => s.grade < 33).toList();
  print("Failed (${failed.length}):");
  showStudents(failed);
  return failed;
}

class Student {
  int id;
  String name;
  String department;
  double grade; // NEW: 0.0 – 100.0

  Student({
    required this.id,
    required this.name,
    required this.department,
    this.grade = 0.0, // default so old call sites don't break
  });
}
