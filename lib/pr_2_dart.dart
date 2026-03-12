String makeGroupReport() {
  // РАБОДАЙ ЧАД ЖБД НАД ТАБЛИЧКАМИ ДАННЫЕ
  final students = <String>[
    'Алина Петрова',
    'Игорь Смирнов',
    'Надя Ким',
    'Олег Иванов',
    'Лена Орлова',
  ];

  final subjects = <String>['Математика', 'Физика', 'История', 'Информатика'];

  final gradeBook = <String, Map<String, int>>{
    'Алина Петрова': {
      'Математика': 5,
      'Физика': 5,
      'История': 4,
      'Информатика': 5,
    },
    'Игорь Смирнов': {
      'Математика': 4,
      'Физика': 3,
      'История': 4,
      'Информатика': 4,
    },
    'Надя Ким': {'Математика': 5, 'Физика': 4, 'История': 5, 'Информатика': 5},
    'Олег Иванов': {
      'Математика': 2,
      'Физика': 4,
      'История': 3,
      'Информатика': 4,
    },
    'Лена Орлова': {
      'Математика': 4,
      'Физика': 2,
      'История': 5,
      'Информатика': 4,
    },
  };

  final report = StringBuffer();
  const searchValue = 'Ким';

  report.writeln('1 - сводная таблица');
  report.writeln(buildTable(students, subjects, gradeBook));
  report.writeln('');

  report.writeln('2 - поиск по имени или фамилии');
  report.writeln(findStudent(students, subjects, gradeBook, searchValue));
  report.writeln('');

  report.writeln('3 - уникальные оценки');
  report.writeln(collectUniqueGrades(gradeBook));
  report.writeln('');

  report.writeln('4 - минимумы и максимумы по предметам');
  report.writeln(showMinMaxBySubjects(students, subjects, gradeBook));

  report.writeln('5 - у кого ровно одна двойка');
  report.writeln(studentsWithOneTwo(students, subjects, gradeBook));
  report.writeln('');

  report.writeln('6 - предметы выше общего среднего');
  report.writeln(subjectsAboveAverage(students, subjects, gradeBook));
  report.writeln('');

  report.writeln('7 - сколько студентов в каждой категории');
  report.writeln(countCategories(students, gradeBook));

  return report.toString();
}

String buildTable(
  List<String> students,
  List<String> subjects,
  Map<String, Map<String, int>> gradeBook,
) {
  final table = StringBuffer();
  const nameWidth = 21;
  const columnWidth = 14;

  String header = padText('студент', nameWidth);
  for (final subject in subjects) {
    header += padText(subject, columnWidth);
  }
  header += padText('средний', 10);
  table.writeln(header);

  for (final student in students) {
    String row = padText(student, nameWidth);

    for (final subject in subjects) {
      final grade = gradeBook[student]?[subject] ?? 0;
      row += padText('$grade', columnWidth);
    }

    final average = studentAverage(student, subjects, gradeBook);
    row += padText(average.toStringAsFixed(2), 10);
    table.writeln(row);
  }

  String lastRow = padText('средний по предмету', nameWidth);
  for (final subject in subjects) {
    final average = subjectAverage(students, subject, gradeBook);
    lastRow += padText(average.toStringAsFixed(2), columnWidth);
  }
  lastRow += padText('-', 10);
  table.write(lastRow);

  return table.toString();
}

String findStudent(
  List<String> students,
  List<String> subjects,
  Map<String, Map<String, int>> gradeBook,
  String searchText,
) {
  final result = StringBuffer();
  final searchValue = searchText.toLowerCase();

  String? foundStudent;

  for (final student in students) {
    if (student.toLowerCase().contains(searchValue)) {
      foundStudent = student;
      break;
    }
  }

  if (foundStudent == null) {
    return 'по запросу "$searchText" ниче не нашлось';
  }

  result.writeln('запрос: $searchText');
  result.writeln('нашёлся студент: $foundStudent');

  for (final subject in subjects) {
    final grade = gradeBook[foundStudent]?[subject] ?? 0;
    result.writeln('- $subject: $grade');
  }

  final average = studentAverage(foundStudent, subjects, gradeBook);
  final category = studentCategory(foundStudent, gradeBook);
  result.writeln('средний балл: ${average.toStringAsFixed(2)}');
  result.write('категория: $category');

  return result.toString();
}

String collectUniqueGrades(Map<String, Map<String, int>> gradeBook) {
  final uniqueGrades = <int>{};

  for (final studentGrades in gradeBook.values) {
    for (final grade in studentGrades.values) {
      uniqueGrades.add(grade);
    }
  }

  final sortedGrades = uniqueGrades.toList();
  sortedGrades.sort();

  return sortedGrades.join(', ');
}

String showMinMaxBySubjects(
  List<String> students,
  List<String> subjects,
  Map<String, Map<String, int>> gradeBook,
) {
  final result = StringBuffer();

  for (final subject in subjects) {
    int minGrade = 5;
    int maxGrade = 2;
    final studentsWithMin = <String>[];
    final studentsWithMax = <String>[];

    for (final student in students) {
      final grade = gradeBook[student]?[subject] ?? 0;

      if (grade < minGrade) {
        minGrade = grade;
      }

      if (grade > maxGrade) {
        maxGrade = grade;
      }
    }

    for (final student in students) {
      final grade = gradeBook[student]?[subject] ?? 0;

      if (grade == minGrade) {
        studentsWithMin.add(student);
      }

      if (grade == maxGrade) {
        studentsWithMax.add(student);
      }
    }

    result.writeln('$subject:');
    result.writeln('- максимум $maxGrade > ${studentsWithMax.join(', ')}');
    result.writeln('- минимум $minGrade > ${studentsWithMin.join(', ')}');
  }

  return result.toString();
}

String studentsWithOneTwo(
  List<String> students,
  List<String> subjects,
  Map<String, Map<String, int>> gradeBook,
) {
  final lines = <String>[];

  for (final student in students) {
    int twoCount = 0;
    String badSubject = '';

    for (final subject in subjects) {
      final grade = gradeBook[student]?[subject] ?? 0;
      if (grade == 2) {
        twoCount++;
        badSubject = subject;
      }
    }

    if (twoCount == 1) {
      lines.add('$student - $badSubject');
    }
  }

  if (lines.isEmpty) {
    return 'таких студентов нет';
  }

  return lines.join('\n');
}

String subjectsAboveAverage(
  List<String> students,
  List<String> subjects,
  Map<String, Map<String, int>> gradeBook,
) {
  final groupAverageValue = groupAverage(gradeBook);
  final lines = <String>[
    'общий средний по группе: ${groupAverageValue.toStringAsFixed(2)}',
  ];

  for (final subject in subjects) {
    final average = subjectAverage(students, subject, gradeBook);
    if (average > groupAverageValue) {
      lines.add('$subject - ${average.toStringAsFixed(2)}');
    }
  }

  return lines.join('\n');
}

String countCategories(
  List<String> students,
  Map<String, Map<String, int>> gradeBook,
) {
  int excellentCount = 0;
  int goodCount = 0;
  int otherCount = 0;

  for (final student in students) {
    final category = studentCategory(student, gradeBook);

    if (category == 'отличник') {
      excellentCount++;
    } else if (category == 'хорошист') {
      goodCount++;
    } else {
      otherCount++;
    }
  }

  return 'отличники: $excellentCount\nхорошисты: $goodCount\nостальные: $otherCount';
}

double studentAverage(
  String student,
  List<String> subjects,
  Map<String, Map<String, int>> gradeBook,
) {
  int sum = 0;

  for (final subject in subjects) {
    sum += gradeBook[student]?[subject] ?? 0;
  }

  return sum / subjects.length;
}

double subjectAverage(
  List<String> students,
  String subject,
  Map<String, Map<String, int>> gradeBook,
) {
  int sum = 0;

  for (final student in students) {
    sum += gradeBook[student]?[subject] ?? 0;
  }

  return sum / students.length;
}

double groupAverage(Map<String, Map<String, int>> gradeBook) {
  int sum = 0;
  int count = 0;

  for (final studentGrades in gradeBook.values) {
    for (final grade in studentGrades.values) {
      sum += grade;
      count++;
    }
  }

  return sum / count;
}

String studentCategory(
  String student,
  Map<String, Map<String, int>> gradeBook,
) {
  final grades = gradeBook[student]?.values.toList() ?? [];

  bool onlyFives = true;
  bool withoutBadGrades = true;

  for (final grade in grades) {
    if (grade != 5) {
      onlyFives = false;
    }

    if (grade < 4) {
      withoutBadGrades = false;
    }
  }

  if (onlyFives) {
    return 'отличник';
  }

  if (withoutBadGrades) {
    return 'хорошист';
  }

  return 'остальные';
}

String padText(String text, int width) {
  if (text.length >= width) {
    return '${text.substring(0, width - 1)} ';
  }

  return text.padRight(width);
}
