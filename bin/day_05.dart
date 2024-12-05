import 'dart:io';

void main() {
  // 1. Read the input file.
  final lines = File('assets/day_05_input') //
      .readAsLinesSync();

  // 2. Make a list of rules and manuals.
  final List<(int, int)> rules = [];
  final List<List<int>> manuals = [];

  for (int i = 0; i < lines.length; i++) {
    final line = lines[i];

    if (line.isEmpty) continue;

    // Handle the lines with rules.
    if (line.contains('|')) {
      final [a, b] = line //
          .split('|')
          .map(int.parse)
          .toList();

      rules.add((a, b));
    }

    // Handle the lines with manuals.
    if (line.contains(',')) {
      final manual = line //
          .split(',')
          .map(int.parse)
          .toList();

      manuals.add(manual);
    }
  }

  // 3. Sum the center element, only of the correct manuals.
  int partOne = 0;

  for (int i = 0; i < manuals.length; i++) {
    final manual = manuals[i];

    if (satisfiesAll(manual, rules)) {
      final center = manual[manual.length ~/ 2];
      partOne += center;
    }
  }

  print('Sum: $partOne');

  // 4. Sum the center element, only of the manuals that were corrected.
  int partTwo = 0;

  for (int i = 0; i < manuals.length; i++) {
    var manual = manuals[i];

    if (satisfiesAll(manual, rules)) {
      continue;
    }

    // Make the manual correct, and then sum the center element.
    manual = correct(manual, rules);

    final center = manual[manual.length ~/ 2];
    partTwo += center;
  }

  print('Sum: $partTwo');
}

bool satisfiesAll(
  List<int> manual,
  List<(int, int)> rules,
) {
  for (int i = 0; i < rules.length; i++) {
    final rule = rules[i];

    if (!satisfies(manual, rule)) {
      return false;
    }
  }

  return true;
}

bool satisfies(
  List<int> manual,
  (int, int) rule,
) {
  // When the rule does not apply, it is satisfied.
  if (!applies(manual, rule)) {
    return true;
  }

  // See if the first page comes before the second page.
  final (a, b) = rule;

  final idxA = manual.indexOf(a);
  final idxB = manual.indexOf(b);

  return idxA < idxB;
}

bool applies(
  List<int> manual,
  (int, int) rule,
) {
  final (a, b) = rule;

  // A rule is only enforced if both pages are in the manual.
  return manual.contains(a) && manual.contains(b);
}

List<int> correct(
  List<int> manual,
  List<(int, int)> rules,
) {
  // Base case: the manual is correct.
  if (satisfiesAll(manual, rules)) {
    return manual;
  }

  final manual_ = [...manual];

  for (int i = 0; i < rules.length; i++) {
    final rule = rules[i];

    // If the rule is already satisfied, skip it.
    if (satisfies(manual_, rule)) {
      continue;
    }

    // Swap the pages.
    final (a, b) = rule;

    final idxA = manual_.indexOf(a);
    final idxB = manual_.indexOf(b);

    manual_[idxA] = b;
    manual_[idxB] = a;
  }

  // Recurse until the manual is correct.
  return correct(manual_, rules);
}
