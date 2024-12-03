import 'package:adventofcode_2024/utilities.dart';

bool isSafe(
  List<int> report,
) {
  int lastDistance = 0;

  for (int i = 0; i < report.length - 1; i++) {
    final distance = report[i + 1] - report[i];

    if (distance == 0 || distance.abs() > 3) {
      return false;
    }

    if (lastDistance * distance < 0) {
      return false;
    }

    lastDistance = distance;
  }

  return true;
}

void main() {
  // 1. Read the input.
  final lines = readFileAsLinesSync('assets/day_02_input');

  // 2. Parse the input.
  final reports = <List<int>>[];
  for (final line in lines) {
    final report = line //
        .split(' ')
        .map(int.parse)
        .toList();

    reports.add(report);
  }

  // 3. Loop through, and see which reports are safe.
  int safe = 0;

  for (int i = 0; i < reports.length; i++) {
    final report = reports[i];

    if (isSafe(reports[i])) {
      safe++;
      continue;
    }

    // Check if the report is safe when we remove one element.
    for (int j = 0; j < report.length; j++) {
      final report_ = [...report] //
        ..removeAt(j);

      if (isSafe(report_)) {
        safe++;
        break;
      }
    }
  }

  print('n: $safe');
}
