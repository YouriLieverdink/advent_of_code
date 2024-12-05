import 'dart:io';

void main() {
  // 1. Read the input file.
  final file = File('assets/day_05_input');
  final lines = file.readAsLinesSync();

  // 2. Make a list of rules and manuals.
  final List<(int, int)> rules = [];
  final List<List<int>> manuals = [];

  for (int i = 0; i < lines.length; i++) {
    final line = lines[i];

    if (line.isEmpty) continue;

    // Handle rules.
    if (line.contains('|')) {
      final [a, b] = line //
          .split('|')
          .map(int.parse)
          .toList();

      rules.add((a, b));
    }

    // Handle manuals.
    if (line.contains(',')) {
      final manual = line //
          .split(',')
          .map(int.parse)
          .toList();

      manuals.add(manual);
    }
  }

  // 3. Sum the center values of the correct manuals.
  int partOne = 0;

  for (int i = 0; i < manuals.length; i++) {
    final manual = manuals[i];

    // Check if `all` the rules are satisfied.
    if (!satisfiesAll(manual, rules)) {
      continue;
    }

    final center = manual[manual.length ~/ 2];
    partOne += center;
  }

  // 4. Print the sum.
  print('Sum: $partOne');

  // 5. Sum the center values of all manuals, make them correct if not already.
  int partTwo = 0;

  for (int i = 0; i < manuals.length; i++) {
    var manual = manuals[i];

    // Check if `all` the rules are satisfied.
    if (!satisfiesAll(manual, rules)) {
      // Make the manual correct.
      manual = correct(manual, rules);

      final center = manual[manual.length ~/ 2];
      partTwo += center;
    }
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

  return manual.contains(a) && manual.contains(b);
}

List<int> correct(
  List<int> manual,
  List<(int, int)> rules,
) {
  if (satisfiesAll(manual, rules)) {
    return manual;
  }

  final manual_ = [...manual];

  for (int i = 0; i < rules.length; i++) {
    final rule = rules[i];

    if (!satisfies(manual_, rule)) {
      // Switch the positions of the two pages.
      final (a, b) = rule;

      final idxA = manual_.indexOf(a);
      final idxB = manual_.indexOf(b);

      manual_[idxA] = b;
      manual_[idxB] = a;
    }
  }

  return correct(manual_, rules);
}
