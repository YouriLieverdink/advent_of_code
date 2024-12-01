import 'dart:io';

Future<void> main() async {
  // 1. Read the input.
  final file = File('assets/day_01_input');
  final lines = await file.readAsLines();

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
  int totalDistance = 0;

  for (int i = 0; i < left.length; i++) {
    totalDistance += (left[i] - right[i]).abs();
  }

  // 5. Print the result of part 1.
  print('Total distance: $totalDistance');

  // 6. Loop through the lists, and determine the similarity.
  int similarity = 0;

  for (int i = 0; i < left.length; i++) {
    final current = left[i];
    final count = right.where((a) => a == current).length;

    similarity += current * count;
  }

  // 7. Print the result of part 2.
  print('Similarity: $similarity');
}
