import 'dart:io';

enum Direction {
  up,
  right,
  down,
  left;

  (int, int) translate(
    (int, int) position,
  ) {
    final (y, x) = position;

    switch (this) {
      case up:
        return (y - 1, x);
      case right:
        return (y, x + 1);
      case down:
        return (y + 1, x);
      case left:
        return (y, x - 1);
    }
  }

  Direction turnRight() {
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

void main() {
  // 1. Read the input.
  final lines = File('assets/2024/day_06_input') //
      .readAsLinesSync();

  // 2. Make a map.
  final List<String> map = [];
  (int, int) position = (0, 0);

  for (int i = 0; i < lines.length; i++) {
    final line = lines[i];

    map.add(line);

    // 3. Find the '^' character, which is the starting position.
    final index = line.indexOf('^');
    if (index != -1) {
      position = (i, index);
    }
  }

  // 3. Trace the path of the guard, and count the number of distinct positions.
  final visited = walk(map, position, Direction.up, {});

  print('Part one: ${visited.length}');
}

Set<(int, int)> walk(
  List<String> map,
  (int, int) current,
  Direction facing,
  Set<(int, int)> visited,
) {
  visited.add(current);

  final next = facing.translate(current);

  if (get(map, next) == null) {
    // We've reached the end of the map, we're done.
    return visited;
  }

  if (get(map, next) == '#') {
    // We've reached an obstacle, turn right, and continue walking.
    final facing_ = facing.turnRight();
    final next_ = facing_.translate(current);

    return walk(map, next_, facing_, visited);
  }

  // Continue walking in the same direction.
  return walk(map, next, facing, visited);
}

String? get(
  List<String> map,
  (int, int) position,
) {
  try {
    final (y, x) = position;

    return map[y][x];
  } //
  on RangeError {
    return null;
  }
}
