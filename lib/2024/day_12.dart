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
}

void main() {
  // Read the input.
  final lines = File('assets/2024/day_12_input') //
      .readAsLinesSync();

  // Make a map of the garden.
  final List<List<String>> map = [];

  for (int i = 0; i < lines.length; i++) {
    final row = lines[i].split('');

    map.add(row);
  }

  // Calculate the area and perimeter of the plants in the garden.
  final Set<Position> visited = {};
  int partOne = 0;

  for (int i = 0; i < map.length; i++) {
    for (int j = 0; j < map[i].length; j++) {
      final position = Position(i, j);

      // Retrieve the plant.
      final plant = get(map, position);
      if (plant == null) {
        continue;
      }

      // Skip if the plant is already part of another area.
      if (visited.contains(position)) {
        continue;
      }

      // Retrieve all plants that are part of the same area.
      final (plants, perimeter) = search(map, position, plant, {}, 0);
      visited.addAll(plants);

      // Calculate the fencing costs.
      partOne += plants.length * perimeter;
    }
  }

  print('Part one: $partOne');
}

/// Starting from the given [position], search in each direction for plants of
/// the same type, and return the list of positions and the perimeter of the
/// plants.
(Set<Position>, int) search(
  List<List<String>> map,
  Position position,
  String plant,
  Set<Position> visited,
  int perimeter,
) {
  visited.add(position);

  // Look in each direction, for plants of the same type.
  for (final direction in Direction.values) {
    final position_ = position.translate(direction);
    final plant_ = get(map, position_);

    // When the plant is not of the same type, we've reached an edge of this area.
    if (plant_ != plant) {
      perimeter++;
      continue;
    }

    // When the plant is of the same type, and we haven't visited it yet, search further.
    if (!visited.contains(position_)) {
      final (visited_, perimeter_) = search(map, position_, plant, visited, 0);

      visited.addAll(visited_);
      perimeter += perimeter_;
    }
  }

  return (visited, perimeter);
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
