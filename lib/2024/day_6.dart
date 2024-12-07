import 'dart:io';

class Position {
  final int x;
  final int y;

  const Position(this.y, this.x);

  Position translate(
    Direction direction,
  ) {
    switch (direction) {
      case Direction.up:
        return Position(y - 1, x);
      case Direction.right:
        return Position(y, x + 1);
      case Direction.down:
        return Position(y + 1, x);
      case Direction.left:
        return Position(y, x - 1);
    }
  }

  @override
  String toString() {
    return '(i: $y, j: $x)';
  }

  @override
  bool operator ==(Object other) {
    return other is Position && other.x == x && other.y == y;
  }

  @override
  int get hashCode => x.hashCode ^ y.hashCode;
}

enum Direction {
  up,
  right,
  down,
  left;

  Direction turn() {
    switch (this) {
      case up:
        return right;
      case right:
        return down;
      case down:
        return left;
      case left:
        return up;
    }
  }
}

const depth = 8192;

void main() {
  // Read the input.
  final lines = File('assets/2024/day_6_input') //
      .readAsLinesSync();

  // Make a map.
  final List<List<String>> map = [];
  var start = Position(0, 0);

  for (int i = 0; i < lines.length; i++) {
    final line = lines[i];

    map.add(line.split(''));

    // Find the starting position.
    for (int j = 0; j < line.length; j++) {
      if (line[j] == '^') {
        start = Position(i, j);
      }
    }
  }

  final (visited, _) = trace(map, start, Direction.up, [], depth);
  final unique = visited.toSet();

  print('Part one: ${unique.length}');

  int partTwo = 0;

  for (int i = 1; i < unique.length; i++) {
    final position = unique.elementAt(i);

    // Place an obstacle at this position, and see if it results in a loop.
    map[position.y][position.x] = '#';

    final (_, done) = trace(map, start, Direction.up, [], depth);
    if (!done) {
      partTwo++;
    }

    // Remove the obstacle.
    map[position.y][position.x] = '.';
  }

  print('Part two: $partTwo');
}

(List<Position>, bool) trace(
  List<List<String>> map,
  Position current,
  Direction direction,
  List<Position> $visited,
  int depth,
) {
  $visited.add(current);

  final next = current.translate(direction);

  if (depth <= 0) {
    return ($visited, false);
  }

  if (get(map, next) == null) {
    // We're out of bounds.
    return ($visited, true);
  }

  if (get(map, next) == '#') {
    // We've hit an obstacle, turn, and continue.
    return trace(map, current, direction.turn(), $visited, depth - 1);
  }

  return trace(map, next, direction, $visited, depth - 1);
}

/// Retrieve a character from the [map] at the given [position].
String? get(
  List<List<String>> map,
  Position position,
) {
  try {
    return map[position.y][position.x];
  } //
  on RangeError {
    return null;
  }
}
