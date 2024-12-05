import 'dart:io';

enum Direction {
  up,
  upRight,
  right,
  downRight,
  down,
  downLeft,
  left,
  upLeft;

  (int, int) translate(
    (int, int) position,
  ) {
    final (y, x) = position;

    switch (this) {
      case Direction.up:
        return (y - 1, x);
      case Direction.upRight:
        return (y - 1, x + 1);
      case Direction.right:
        return (y, x + 1);
      case Direction.downRight:
        return (y + 1, x + 1);
      case Direction.down:
        return (y + 1, x);
      case Direction.downLeft:
        return (y + 1, x - 1);
      case Direction.left:
        return (y, x - 1);
      case Direction.upLeft:
        return (y - 1, x - 1);
    }
  }
}

void main() {
  // 1. Read the input file.
  final lines = File('assets/2024/day_04_input') //
      .readAsLinesSync();

  // 2. Build a 2-dimensional array of characters.
  final List<List<String>> grid = [];

  for (int i = 0; i < lines.length; i++) {
    final chars = lines[i].split('');

    grid.add(chars);
  }

  // 3. Count the number of occurences of the word `XMAS`.
  int partOne = 0;

  for (int i = 0; i < grid.length; i++) {
    for (int j = 0; j < grid[i].length; j++) {
      // Search in every direction.
      for (final direction in Direction.values) {
        // Check if the word `XMAS` is found.
        final found = findWord(grid, (i, j), direction, ['X', 'M', 'A', 'S']);

        if (found) {
          partOne++;
        }
      }
    }
  }

  print('Part one: $partOne');

  // 4. Count the number of occurences of the shape `X` with `MAS` as letters.
  int partTwo = 0;

  for (int i = 0; i < grid.length; i++) {
    for (int j = 0; j < grid[i].length; j++) {
      // Check if this is the middle of the `X` shape.
      final found = findX(grid, (i, j));

      if (found) {
        partTwo++;
      }
    }
  }

  print('Part two: $partTwo');
}

String? get(
  List<List<String>> grid,
  (int, int) position,
) {
  final (y, x) = position;

  try {
    return grid[y][x];
  } //
  on RangeError {
    return null;
  }
}

bool findWord(
  List<List<String>> grid,
  (int, int) position,
  Direction direction,
  List<String> word,
) {
  // Make sure the first character matches.
  final char = get(grid, position);
  if (char != word.first) {
    return false;
  }

  // If this isn't the last character, continue searching.
  if (word.length != 1) {
    final position_ = direction.translate(position);
    final word_ = word.sublist(1);

    return findWord(grid, position_, direction, word_);
  }

  // We've found the entire word.
  return true;
}

bool findX(
  List<List<String>> grid,
  (int, int) position,
) {
  final char = get(grid, position);

  // Make sure this is an `A` character.
  if (char != 'A') {
    return false;
  }

  // Collect the four characters around this position.
  final directions = [
    Direction.upRight,
    Direction.downRight,
    Direction.downLeft,
    Direction.upLeft
  ];

  // Retrieve the characters in the four directions.
  final characters = directions //
      .map((dir) => dir.translate(position))
      .map((pos) => get(grid, pos))
      .join();

  // When the pattern has two consecutive characters, we've found the `X` shape.
  final allowed = ['MSSM', 'SSMM', 'SMMS', 'MMSS'];

  return allowed.contains(characters);
}
