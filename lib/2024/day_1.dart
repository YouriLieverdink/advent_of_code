import 'dart:io';

Future<void> main() async {
  // 1. Read the input.
  final lines = File('assets/2024/day_01_input') //
      .readAsLinesSync();

  // 2. Create two lists, store the values in them.
  final (left, right) = (<int>[], <int>[]);

  for (final line in lines) {
    final [x, y] = line //
        .split('   ')
        .map(int.parse)
        .toList();

    left.add(x);
    right.add(y);
  }

  // 3. Sort the lists, because we need to match the lowest with the lowest.
  left.sort();
  right.sort();

  // 4. Loop through the lists, and sum the differences.
  int partOne = 0;

  for (int i = 0; i < left.length; i++) {
    partOne += (left[i] - right[i]).abs();
  }

  // 5. Print the result of part 1.
  print('Part one: $partOne');

  // 6. Loop through the lists, and determine the similarity.
  int partTwo = 0;

  for (int i = 0; i < left.length; i++) {
    final current = left[i];
    final count = right.where((a) => a == current).length;

    partTwo += current * count;
  }

  // 7. Print the result of part 2.
  print('Part two: $partTwo');
}
