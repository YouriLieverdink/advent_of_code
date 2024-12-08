import 'dart:io';

class Antenna {
  final int i;
  final int j;
  final String frequency;

  const Antenna(
    this.i,
    this.j,
    this.frequency,
  );

  @override
  String toString() {
    return 'Antenna(i: $i, j: $j, $frequency)';
  }
}

void main() {
  // Read the input.
  final lines = File('assets/2024/day_8_input') //
      .readAsLinesSync();

  // Make a map, and capture the antennas.
  final List<List<String>> map = [];
  final List<Antenna> antennas = [];

  for (int i = 0; i < lines.length; i++) {
    final line = lines[i];

    // Add the line to the map.
    map.add(line.split(''));

    // Retrieve all the positions of the antennas.
    for (int j = 0; j < line.length; j++) {
      final char = line[j];

      if (char != '.') {
        // We've found an antenna!
        antennas.add(Antenna(i, j, char));
      }
    }
  }

  // Loop through the combinations of antennas, and calculate the antinodes.
  final List<(int, int)> antinodes = [];

  for (int i = 0; i < antennas.length; i++) {
    for (int j = i + 1; j < antennas.length; j++) {
      final a = antennas[i];
      final b = antennas[j];

      // If the frequencies are different, we can't form an antinode.
      if (a.frequency != b.frequency) {
        continue;
      }

      // Determine the translation between the two antennas.
      final t = getTranslation(a, b);
      final rT = reverse(t);

      // Calculate the antinodes.
      antinodes.addAll([
        add((b.i, b.j), t),
        add((a.i, a.j), rT),
      ]);
    }
  }

  final partOne = antinodes //
      .where((antinode) => get(map, antinode) != null)
      .toSet()
      .length;

  print('Part one: $partOne');

  final List<(int, int)> resonant = [];

  for (int i = 0; i < antennas.length; i++) {
    for (int j = i + 1; j < antennas.length; j++) {
      final a = antennas[i];
      final b = antennas[j];

      // If the frequencies are different, we can't form an antinode.
      if (a.frequency != b.frequency) {
        continue;
      }

      // Add positions of the antennas.
      resonant.addAll([
        (a.i, a.j),
        (b.i, b.j),
      ]);

      // Determine the translation between the two antennas.
      final t = getTranslation(a, b);
      final rT = reverse(t);

      // Translate in both directions, until we go out of bounds.
      var kPosition = add((b.i, b.j), t);
      for (int k = 0; k < 100; k++) {
        if (get(map, kPosition) == null) {
          // We've gone out of bounds.
          break;
        }

        // Add the antinode!
        resonant.add(kPosition);

        // Update the position.
        kPosition = add(kPosition, t);
      }

      var lPosition = add((a.i, a.j), rT);
      for (int l = 0; l < 100; l++) {
        if (get(map, lPosition) == null) {
          // We've gone out of bounds.
          break;
        }

        // Add the antinode!
        resonant.add(lPosition);

        // Update the position.
        lPosition = add(lPosition, rT);
      }
    }
  }

  //
  final partTwo = resonant //
      .toSet()
      .length;

  print('Part two: $partTwo');
}

/// Returns the translation of antenna [a] to antenna [b].
(int, int) getTranslation(
  Antenna a,
  Antenna b,
) {
  return (b.i - a.i, b.j - a.j);
}

/// Returns the reverse translation of a [t].
(int, int) reverse(
  (int, int) t,
) {
  return (-t.$1, -t.$2);
}

/// Adds two positions together.
(int, int) add(
  (int, int) a,
  (int, int) b,
) {
  return (a.$1 + b.$1, a.$2 + b.$2);
}

/// Retrieves a character from the [map] at the given [position].
String? get(
  List<List<String>> map,
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
