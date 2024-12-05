import 'dart:io';

final $do = RegExp(r"do\(\)");
final $dont = RegExp(r"don't\(\)");
final $mul = RegExp(r"mul\((\d+),(\d+)\)");

void main() {
  final program = File('assets/day_03_input') //
      .readAsStringSync();

  int partOne = 0;
  int partTwo = 0;

  // When starting, the `mul` instructions are enabled.
  bool enabled = true;

  for (int i = 0; i < program.length; i++) {
    // See if there is a `do()` match starting at index: i.
    final doMatch = $do.matchAsPrefix(program, i);
    if (doMatch != null) {
      enabled = true;
    }

    // See if there is a `don't()` match starting at index: i.
    final dontMatch = $dont.matchAsPrefix(program, i);
    if (dontMatch != null) {
      enabled = false;
    }

    // See if there is a `mul()` match starting at index: i.
    final mulMatch = $mul.matchAsPrefix(program, i);
    if (mulMatch != null) {
      // When enabled is `true`, we multiple for part two.
      if (enabled) {
        final [a, b] = mulMatch.groups([1, 2]);
        partTwo += int.parse(a!) * int.parse(b!);
      }

      // We always multiple for part one, regardless of the `enabled` state.
      final [a, b] = mulMatch.groups([1, 2]);
      partOne += int.parse(a!) * int.parse(b!);
    }
  }

  print('Part one: $partOne');
  print('Part two: $partTwo');
}
